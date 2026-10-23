function [T_etapa, iter_nr, iter_gs] = newton_raphson_sdirk(T_guess, r_i, par)
    % Resuelve la ecuacion de etapa de SDIRK4 G(T^(i)) = 0 con Newton-Raphson
    % (Ecuaciones 9 y 10 del reporte); el sistema lineal se resuelve con Gauss-Seidel.
    N = par.N;
    T_etapa = T_guess;
    iter_gs = 0;
    iter_nr = 0;

    for k = 1:par.max_nr
        iter_nr = k;
        [f_val, J_f] = evaluar_f(T_etapa, par);

        % Residual G (Ecuacion 9)
        G = T_etapa - par.h * par.gamma * f_val - r_i;
        G(1) = 0; G(N) = 0; % Preservar Dirichlet

        % Matriz A = I - h*gamma*J_f (Ecuacion 10)
        A = eye(N) - par.h * par.gamma * J_f;
        A(1,1) = 1; A(N,N) = 1;

        % Solver lineal: Gauss-Seidel (metodo del estudio)
        if strcmp(par.solver, 'directo')
            delta = A \ (-G);          % solo para las soluciones de referencia
            gs_k = 0;
        else
            [delta, gs_k] = gauss_seidel_solver(A, -G, par);
        end
        iter_gs = iter_gs + gs_k;

        T_etapa = T_etapa + delta;

        if norm(delta, inf) < par.tol_nr
            break;
        end
    end
end
