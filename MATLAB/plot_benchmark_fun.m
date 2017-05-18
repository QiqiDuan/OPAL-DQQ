% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% Plot 2-D Contour and/or 3-D Surface Figures for Benchmark Functions.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %

close all;
clc;

%% set experimental parameters

% IS_CONTOUR = true; % if true, plot 2-d contour figures; otherwise, plot 3-d surface figures
IS_CONTOUR = false;

% save all the figures into the special folder
SAVING_FOLDER = mfilename;
if ~exist(SAVING_FOLDER, 'dir')
    mkdir(SAVING_FOLDER);
end

FHD            = str2func('benchmark_fun');  % function handler for benchmark_fun.m
TOTAL_NUM_FUNS = 9;                          % total number of test functions

% for all the benchmark functions, each dimension has the same search bound, 
%   ranging from -100 to 100
SLB = -100; % search lower bounds
SUB = +100; % search upper bounds
sampling_interval = 0.25;
x = SLB : sampling_interval : SUB;
y = SLB : sampling_interval : SUB;

[X, Y] = meshgrid(x, y);
[num_row, num_col] = size(X);

%% plot benchmark functions
for fun_ind = 1 : TOTAL_NUM_FUNS
    figure(fun_ind);
    
    Z = Inf * ones(num_row, num_col);
    for i = 1 : num_row
        for j = 1 : num_col
             Z(i, j) = feval(FHD, [X(i, j) Y(i, j)], fun_ind);
        end
    end
    
    colormap(cool); % eg., bone || spring
    
    if IS_CONTOUR
        contour(X, Y, Z);
        saveas(gcf, sprintf('./%s/contour_FUN_IND_%02i.png', SAVING_FOLDER, fun_ind));
    else
        fig = surf(X, Y, Z, 'FaceAlpha', 0.85);
        fig.EdgeColor = 'none';
        saveas(fig, sprintf('./%s/surface_FUN_IND_%02i.png', SAVING_FOLDER, fun_ind));
    end
end
