function [f, J_f, f_dif, f_adv] = evaluar_f(T, par)
    % Operador espacial f(T) = dT/dt y su Jacobiano J_f (Ecuaciones 6 y 7 del reporte).
    % f = f_dif + f_adv, con
    %   f_dif : termino difusivo   d/dx( alpha(T) dT/dx )
    %   f_adv : termino advectivo  -v dT/dx
    N = par.N; dx = par.dx; v = par.v; alpha0 = par.alpha0; beta = par.beta; T0 = par.T0;

    f_dif = zeros(N, 1);
    f_adv = zeros(N, 1);
    J_f = zeros(N, N);

    % Difusividad termica dependiente de la temperatura (Ecuacion 2)
    alpha = alpha0 * (1 + beta * (T - T0));

    % Nodos internos (2 a N-1)
    for i = 2:N-1
        % Difusividad en puntos medios
        alpha_der = 0.5 * (alpha(i) + alpha(i+1));
        alpha_izq = 0.5 * (alpha(i) + alpha(i-1));

        % Terminos de f_i (Ecuacion 6)
        f_dif(i) = (alpha_der * (T(i+1) - T(i)) - alpha_izq * (T(i) - T(i-1))) / dx^2;
        f_adv(i) = -v * (T(i+1) - T(i-1)) / (2 * dx);

        % Matriz Jacobiana J_f (Ecuacion 7)
        J_f(i, i-1) = (alpha_izq - 0.5*alpha0*beta*(T(i) - T(i-1))) / dx^2 + v/(2*dx);
        J_f(i, i)   = (-alpha_der - alpha_izq + 0.5*alpha0*beta*(T(i+1) - 2*T(i) + T(i-1))) / dx^2;
        J_f(i, i+1) = (alpha_der + 0.5*alpha0*beta*(T(i+1) - T(i))) / dx^2 - v/(2*dx);
    end

    f = f_dif + f_adv;   % en los extremos (Dirichlet) f = 0 y J_f = 0
end
