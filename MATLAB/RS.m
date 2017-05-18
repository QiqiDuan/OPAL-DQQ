function [opt_pos, opt_val, seq_fun_eval, run_time] = ...
    RS(fhd, fun_ind, fun_dim, slb, sub, pop_size, ...
        max_iter, ini_seed, is_output_seq_fun_eval)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% Random Search as a Comparative Baseline.
%
% || INPUT  || <---
%   fhd      <--- str2func, benchmark function handler
%   fun_ind  <--- integer, index for benchmark functions
%   fun_dim  <--- integer, benchmark function dimension
%   slb      <--- matrix(pop_size, fun_dim), search lower bound
%   sub      <--- matrix(pop_size, fun_dim), search upper bound
%   pop_size <--- integer, population size
%   max_iter <--- integer, maximum of iterations
%   ini_seed <--- integer, random seed for initializing the population
%   is_output_seq_fun_eval <- logical, whether ouput <seq_fun_eval> or not
%
% || OUTPUT || --->
%   opt_pos      ---> matrix(1, fun_dim), optimal function position (point/solution)
%   opt_val      ---> double, optimal function (cost/fitness) value
%   seq_fun_eval ---> matrix(1, pop_size * max_iter), sequence of function evaluations (FEs)
%   run_time     ---> double, run time of the program
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
    % initialize experimental parameters
    run_time_start = tic;
    RandStream.setGlobalStream(RandStream('mt19937ar', 'Seed', 'shuffle'));
    if is_output_seq_fun_eval
        seq_fun_eval = zeros(1, pop_size * max_iter);
    else
        seq_fun_eval = Inf;
    end
    
    % initialize algorithmic parameters
    ini_rand = rand(RandStream('mt19937ar', 'Seed', ini_seed), pop_size, fun_dim);
    x = slb + (sub - slb) .* ini_rand; % positions
    fun_val = feval(fhd, x, fun_ind); % function evaluations
    if is_output_seq_fun_eval
        seq_fun_eval(1 : pop_size) = fun_val;
    end
    
    opt_val = Inf;
    for ind_iter = 2 : max_iter
        x = slb + (sub - slb) .* rand(pop_size, fun_dim);
        fun_val = feval(fhd, x, fun_ind);
        if is_output_seq_fun_eval
            seq_fun_eval(((ind_iter - 1) * pop_size + 1) : (ind_iter * pop_size)) = fun_val;
        end
        if min(fun_val) < opt_val
            [opt_val, ind_min] = min(fun_val);
            opt_pos = x(ind_min, :);
        end
    end
    
    % output the final optimization results
    run_time = toc(run_time_start);
end
