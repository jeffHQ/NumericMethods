function out = simular_sdirk(par, t_snap)
    % Integra el modelo con SDIRK4 + Newton-Raphson + Gauss-Seidel.
    % t_snap: instantes (s) en los que se guarda el perfil T(x,t); 0 es la condicion inicial.
    if nargin < 2, t_snap = par.tf; end
    N = par.N; h = par.h;
    pasos_snap = round(t_snap / h);

    % Condicion inicial: tubo frio (TN) y corriente caliente (T1) solo en x = 0
    T = par.TN * ones(N, 1);
    T(1) = par.T1;

    snaps = nan(N, numel(t_snap));
    xf_snap = nan(1, numel(t_snap));
    k0 = find(pasos_snap == 0, 1);
    if ~isempty(k0), snaps(:, k0) = T; xf_snap(k0) = posicion_frente(par.x, T, par.T1, par.TN); end

    total_nr = 0; total_gs = 0; fallos_nr = 0; fallos_gs = 0;
    tic;
    for n = 1:par.num_pasos
        T_old = T;
        F = zeros(N, 5);             % f(T^(j)) de cada etapa
        T_etapa = T_old;

        for i = 1:5
            % Ecuacion (8): r_i = T^n + h * sum_{j<i} a_ij * f(T^(j))
            r_i = T_old + h * F(:, 1:i-1) * par.A_rk(i, 1:i-1)';
            [T_etapa, iter_nr, iter_gs] = newton_raphson_sdirk(T_etapa, r_i, par);

            total_nr = total_nr + iter_nr;
            total_gs = total_gs + iter_gs;
            if iter_nr >= par.max_nr, fallos_nr = fallos_nr + 1; end
            if iter_gs >= par.max_gs * iter_nr, fallos_gs = fallos_gs + 1; end

            F(:, i) = evaluar_f(T_etapa, par);
        end

        T = T_etapa;                 % T^{n+1} = T^(5)
        T(1) = par.T1; T(N) = par.TN;

        k = find(pasos_snap == n, 1);
        if ~isempty(k)
            snaps(:, k) = T;
            xf_snap(k) = posicion_frente(par.x, T, par.T1, par.TN);
        end
    end
    out.cpu = toc;
    out.x = par.x; out.T = T; out.snaps = snaps; out.t_snap = t_snap;
    out.nr = total_nr; out.gs = total_gs;
    out.fallos_nr = fallos_nr; out.fallos_gs = fallos_gs;
    out.xf = posicion_frente(par.x, T, par.T1, par.TN);
    out.xf_snap = xf_snap;
end
