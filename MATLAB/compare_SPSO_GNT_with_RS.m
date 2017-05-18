% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% Compare SPSO_GNT with RS Based on the Following Performance Criteria:
%   1. median run time,
%   2. median optimization performance (via the Wilcoxon rank-sum test),
%   3. median convergence curve.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %

close all;
clc;

%% set experimental parameters
%   two comparable optimization algorithms, the first is the baseline
ALGOS            = {'RS'; 'SPSO_GNT'};
TOTAL_NUM_FUNS   = 9;                        % the total number of benchmark functions
TOTAL_NUM_TRIALS = 50;                       % the total number of trials
FUN_DIM          = 100;                      % function dimension
OPT_FUN_VALS     = zeros(1, TOTAL_NUM_FUNS); % actual optimal minima
X_AXIS           = 1 : TOTAL_NUM_FUNS;       % x-axis for figures comparing run time and optimization performance
FIG_LEGENDS      = {'RS'; 'SPSO\_GNT'};     % figure legends
FIG_COLORS       = {'m'; 'b'};               % figure colors for different legends

% save all the analysis results into the special folder
SAVING_FOLDER = mfilename;
if ~exist(SAVING_FOLDER, 'dir')
    mkdir(SAVING_FOLDER);
end

%% median run time
ind_fig = 100;
figure(ind_fig);

run_time_summary = zeros(TOTAL_NUM_TRIALS, TOTAL_NUM_FUNS, length(ALGOS));
for algo_ind = 1 : length(ALGOS)
    for fun_ind = 1 : TOTAL_NUM_FUNS
        load(sprintf('./%s/rts_Algo%s_Fun%02d_Dim%02d.mat', ...
            ALGOS{algo_ind}, ALGOS{algo_ind}, fun_ind, FUN_DIM), 'run_time');
        run_time_summary(:, fun_ind, algo_ind) = run_time / 3600; % second -> hour
    end
    fprintf(sprintf('Total run time (hour) for %s :: %5.2f\n', ...
        ALGOS{algo_ind}, sum(sum(run_time_summary(:, :, algo_ind)))));
    scatter(X_AXIS, median(run_time_summary(:, :, algo_ind), 1), ...
        FIG_COLORS{algo_ind}, 'filled');
    hold on;
end

fig_title = sprintf('Median Run Time on %02d-Dim Benchmark Functions for %02d Trials', ...
    FUN_DIM, TOTAL_NUM_TRIALS);
title(fig_title);
legend(FIG_LEGENDS{1}, FIG_LEGENDS{2});
xlabel('Function Index');
ylabel('Run Time (hour)');
set(gca, 'XTick', X_AXIS);
hold off;

saveas(ind_fig, ['./' SAVING_FOLDER '/' fig_title '.png']);

%% median optimization performance (via the Wilcoxon rank-sum test)
ind_fig = 200;
figure(ind_fig);

opt_val_summary = zeros(TOTAL_NUM_TRIALS, TOTAL_NUM_FUNS, length(ALGOS));
for algo_ind = 1 : length(ALGOS)
    for fun_ind = 1 : TOTAL_NUM_FUNS
       load(sprintf('./%s/opt_Algo%s_Fun%02d_Dim%02d.mat', ...
           ALGOS{algo_ind}, ALGOS{algo_ind}, fun_ind, FUN_DIM), 'opt_val');
       opt_val_summary(:, fun_ind, algo_ind) = opt_val;
    end
    scatter(X_AXIS, log(median(opt_val_summary(:, :, algo_ind), 1)), ...
        FIG_COLORS{algo_ind}, 'filled');
    hold on;
end

plot(X_AXIS, log(OPT_FUN_VALS), 'k');
fig_title = sprintf('Median Final Values on %02d-Dim Benchmark Functions for %02d Trials', ...
    FUN_DIM, TOTAL_NUM_TRIALS);
title(fig_title);
xlabel('Function Index');
ylabel('Optimal Value (log)');
set(gca, 'XTick', X_AXIS);
legend(FIG_LEGENDS{1}, FIG_LEGENDS{2}, 'Opt*');
hold off;

saveas(ind_fig, ['./' SAVING_FOLDER '/' fig_title '.png']);

ind_better = median(opt_val_summary(:, :, 2), 1) < ...
    median(opt_val_summary(:, :, 1), 1);
fprintf(sprintf('Total num of *better* results for %s :: %02d\n', ...
    ALGOS{2}, sum(ind_better)));

% conduct the significantly statistical test to compare
ind_sigf_better = Inf * ones(TOTAL_NUM_FUNS, 1);
ind_sigf_equal  = Inf * ones(TOTAL_NUM_FUNS, 1);
ind_sgnf_worse  = Inf * ones(TOTAL_NUM_FUNS, 1);

for fun_ind = 1 : TOTAL_NUM_FUNS
    % perform a rightsided test to assess the decrease in median
    [~, ind_sigf_better(fun_ind, 1)] = ranksum(opt_val_summary(:, fun_ind, 1), ...
        opt_val_summary(:, fun_ind, 2), 'tail', 'right');
    % perform a leftsided test to assess the increase in median
    [~, ind_sgnf_worse(fun_ind, 1)] = ranksum(opt_val_summary(:, fun_ind, 1), ...
        opt_val_summary(:, fun_ind, 2), 'tail', 'left');
    [~, ind_sigf_equal(fun_ind, 1)] = ranksum(opt_val_summary(:, fun_ind, 1), ...
        opt_val_summary(:, fun_ind, 2));
end

fprintf(sprintf('Total num of significantly *better* results for %s :: %02d\n', ...
    ALGOS{2}, sum(ind_sigf_better)));
fprintf(sprintf('Total num of significantly *equal * results for %s :: %02d\n', ...
    ALGOS{2}, sum(ind_sigf_equal == 0)));
fprintf(sprintf('Total num of significantly *worse * results for %s :: %02d\n', ...
    ALGOS{2}, sum(ind_sgnf_worse)));

%% median convergence curve
sampling_length = 100;
for fun_ind = 1 : TOTAL_NUM_FUNS
    figure(fun_ind);
    for algo_ind = 1 : length(ALGOS)
        load(sprintf('./%s/sfe_Algo%s_Fun%02d_Dim%02d.mat', ...
            ALGOS{algo_ind}, ALGOS{algo_ind}, fun_ind, FUN_DIM), 'seq_fun_eval');
        [ind_samples, convergence_samples] = ...
            sampling_cvgc_curve(seq_fun_eval, sampling_length);
        plot(ind_samples, log(convergence_samples), FIG_COLORS{algo_ind});
        hold on;
    end
    
    plot(ind_samples, repmat(log(OPT_FUN_VALS(fun_ind)), 1, length(ind_samples)), 'k');
    fig_title = sprintf(...
        'Median Convergence Curve on %02d-Dim Benchmark Function %02d for %02d Trials', ...
        FUN_DIM, fun_ind, TOTAL_NUM_TRIALS);
    title(fig_title);
    xlabel('Index of Function Evaluations');
    ylabel('Optimal Value (log)');
    legend(FIG_LEGENDS{1}, FIG_LEGENDS{2}, 'Opt*');
    
    saveas(fun_ind, ['./' SAVING_FOLDER '/' fig_title '.png']);
end
