function [delta, iter_gs] = gauss_seidel_solver(A, b, par)
    % Resuelve A * delta = b con Gauss-Seidel (Ecuacion 3 del reporte).
    % Los nodos 1 y N son Dirichlet (delta = 0).
    N = par.N;
    delta = zeros(N, 1);
    iter_gs = 0;

    for iter = 1:par.max_gs
        iter_gs = iter;
        delta_old = delta;
        for i = 2:N-1
            % A es tridiagonal: solo los vecinos i-1 (ya actualizado) e i+1 (iteracion anterior)
            % tienen coeficiente distinto de cero, igual que en la Ecuacion 3 del reporte.
            delta(i) = (b(i) - A(i, i-1) * delta(i-1) - A(i, i+1) * delta_old(i+1)) / A(i, i);
        end

        if norm(delta - delta_old, inf) < par.tol_gs
            break;
        end
    end
end
