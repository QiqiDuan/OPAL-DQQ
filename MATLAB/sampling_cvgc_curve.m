function [ind_samples, cvgc_curve] = ...
    sampling_cvgc_curve(seq_fun_eval, sampling_length)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% Sampling the Convergence Curve based on a Given Sampling Interval.
%
% || INPUT  || <---
%   seq_fun_eval    <--- matrix(TOTAL_NUM_TRIALS, MAX_FUN_EVAL),
%                        sequence of function evaluations (FEs)
%   sampling_length <--- integer, sampling length
% || OUTPUT || --->
%   ind_samples ---> matrix(1, sampling_length), index of samples
%   cvgc_curve  ---> matrix(1, sampling_length), convergence curve
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
    [num_row, num_col] = size(seq_fun_eval);
    for i = 1 : num_row
        for j = 1 : (num_col - 1)
            if seq_fun_eval(i, j + 1) > seq_fun_eval(i, j)
                seq_fun_eval(i, j + 1) = seq_fun_eval(i, j);
            end
        end
    end
    
    seq_fun_eval = median(seq_fun_eval, 1);
    ind_samples = ceil(linspace(1, num_col, sampling_length));
    cvgc_curve = seq_fun_eval(ind_samples);
end
