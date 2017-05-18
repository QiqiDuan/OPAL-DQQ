function y = benchmark_fun(x, fun_ind)
% *********************************************************************** %
% Benchmark Functions for Population-based Stochastic Optimization Algorithms,
%   Especially Evolutionary Computation.
%
% || INPUT  || <---
%   x       <--- matrix (pop_size, fun_dim)
%   fun_ind <--- integer, starting with 1
% || OUTPUT || --->
%   y ---> vector (1, pop_size)
%
% -----------------------------
% List for Benchmark Functions:
% -----------------------------
%   Unimodal Functions:
%       01. sphere:
%       02. step:
%       03. schwefel_p221:
%       04. schwefel_p222:
%   Multimodal Functions:
%       05. schwefel_p226 (ie, schwefel): deep local optima
%       06. rosenbrock:
%       07. ackley: shallow local optima
%       08. griewanks:
%       09. rastrigin:
%
% ----------
% Reference:
% ----------
%   * Liang J J, Qin A K, Suganthan P N, et al. Comprehensive learning 
%       particle swarm optimizer for global optimization of multimodal functions[J]. 
%       IEEE Transactions on Evolutionary Computation, 2006, 10(3): 281-295.
%   * Shi Y. An optimization algorithm based on brainstorming process[J]. 
%       International Journal of Swarm Intelligence Research, 2011, 2(4): 35-62.
% *********************************************************************** %
    switch fun_ind
        case 1
            y = sphere(x);
        case 2
            y = step(x);
        case 3
            y = schwefel_p221(x);
        case 4
            y = schwefel_p222(x);
        case 5
            y = schwefel_p226(x);
        case 6
            y = rosenbrock(x);
        case 7
            y = ackley(x);
        case 8
            y = griewanks(x);
        case 9
            y = rastrigin(x);
        otherwise
            error(['ERROR ---> benchmark_fun.m -> provide an ' ...
                'invalid value (ie, %d) for input argument <fun_ind>.'], fun_ind);
    end
    
    y = y';
end

% *********************************************************************** %
function y = sphere(x)
    y = sum(x .^ 2, 2);
end

function y = step(x)
    y = sum((floor(x + 0.5)) .^ 2, 2);
end

function y = schwefel_p221(x)
    y = max(abs(x), [], 2);
end

function y = schwefel_p222(x)
    y = sum(abs(x), 2) + prod(abs(x), 2);
end

function y = schwefel_p226(x)
    [~, fun_dim] = size(x);
    y = 418.9829 * fun_dim - sum(x .* sin(sqrt(abs(x))), 2);
end

function y = rosenbrock(x)
    [~, fun_dim] = size(x);
    if fun_dim < 2
        error(['\n\n\nERROR ---> benchmark_fun.m -> rosenbrock(x) -> ' ...
            '<fun_dim> of input argument x = %d (should >= 2).\n\n\n'], fun_dim)
    end
    y = 100 * sum((x(:, 1 : (fun_dim - 1)) .^ 2 - x(:, 2 : fun_dim)) .^ 2, 2) ...
        + sum((x(:, 1 : (fun_dim - 1)) - 1) .^ 2, 2);
end

function y = ackley(x)
    [~, fun_dim] = size(x);
    y = -20 * exp(-0.2 * sqrt(sum(x .^ 2, 2) / fun_dim)) ...
        - exp(sum(cos(2 * pi * x), 2) / fun_dim) + 20 + exp(1);
end

function y = griewanks(x)
    [pop_size, fun_dim] = size(x);
    y = sum(x .^ 2, 2) / 4000 ...
        - prod(cos(x ./ sqrt(repmat(1 : fun_dim, pop_size, 1))), 2) + 1;
end

function y = rastrigin(x)
    y = sum(x .^ 2 - 10 * cos(2 * pi * x) + 10, 2);
end
