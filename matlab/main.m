%% MODELADO NUMERICO TRANSITORIO DEL TRANSPORTE DE CALOR 1D
% dT/dt + v dT/dx = d/dx( alpha(T) dT/dx ),  alpha(T) = alpha0 [1 + beta (T - T0)]
% SDIRK4 (5 etapas) + Newton-Raphson + Gauss-Seidel
% Las funciones estan en la carpeta "funciones", junto a este archivo. Las figuras se guardan en
% informe/figuras y las tablas (CSV) en resultados/.
clear; clc; close all;
base = fileparts(mfilename('fullpath'));
addpath(fullfile(base, 'funciones'));
raiz = fileparts(base);
dir_fig = fullfile(raiz, 'informe', 'figuras');
dir_res = fullfile(raiz, 'resultados');
if ~isfolder(dir_fig), mkdir(dir_fig); end
if ~isfolder(dir_res), mkdir(dir_res); end

%% 1. CASO BASE (Tabla 1 del reporte)
par = parametros_base();
t_snap = [0 0.25 0.5 1.0 1.5 2.0];       % instantes a graficar (0 = condicion inicial)
base_sim = simular_sdirk(par, t_snap);

T_media = (par.T1 + par.TN) / 2;
fprintf('=======================================================\n');
fprintf(' CASO BASE: SDIRK4 + Newton-Raphson + Gauss-Seidel\n');
fprintf('=======================================================\n');
fprintf('Tiempo fisico simulado: %.3f s (%d pasos, h = %.4f s)\n', par.tf, par.num_pasos, par.h);
fprintf('Tiempo de procesamiento CPU: %.4f s\n', base_sim.cpu);
fprintf('Iteraciones de Newton totales: %d\n', base_sim.nr);
fprintf('Iteraciones de Gauss-Seidel totales: %d\n', base_sim.gs);
fprintf('Etapas sin convergencia (Newton / Gauss-Seidel): %d / %d\n', base_sim.fallos_nr, base_sim.fallos_gs);
fprintf('Posicion del frente (T = %.1f C) en t = %.1f s: x = %.4f m\n', T_media, par.tf, base_sim.xf);
tab_frente = table(t_snap', base_sim.xf_snap', 'VariableNames', {'t_s', 'x_frente_m'});
disp(tab_frente); writetable(tab_frente, fullfile(dir_res, 'frente_vs_tiempo.csv'));

%% 2. FIGURA 1: evolucion del perfil en el tiempo (incluye condicion inicial y t = tf)
ax = nueva_figura('Evolucion', par);
colores = parula(numel(t_snap) + 1);
for k = 1:numel(t_snap)
    plot(ax, base_sim.x, base_sim.snaps(:, k), 'Color', colores(k, :), 'LineWidth', 1.8, ...
        'DisplayName', sprintf('t = %.2f s', t_snap(k)));
end
yline(ax, T_media, 'k--', 'DisplayName', sprintf('Temperatura media (%g °C)', T_media));
xlabel(ax, 'Posición x (m)', 'Interpreter', 'tex'); ylabel(ax, 'Temperatura T (°C)', 'Interpreter', 'tex');
title(ax, 'Evolución del perfil de temperatura (caso base)', 'Interpreter', 'tex');
leyenda_lateral(ax); ylim(ax, [-5 105]);
exportgraphics(ancestor(ax, 'figure'), fullfile(dir_fig, 'fig_evolucion.png'), 'Resolution', 200);

%% 3. FIGURA 2: terminos advectivo y difusivo de dT/dt en t = 1 s
k1 = find(t_snap == 1.0, 1);
[f_tot, ~, f_dif, f_adv] = evaluar_f(base_sim.snaps(:, k1), par);
ax = nueva_figura('Terminos', par);
plot(ax, base_sim.x, f_adv, 'r-', 'LineWidth', 1.8, 'DisplayName', 'Advectivo: -v ∂T/∂x');
plot(ax, base_sim.x, f_dif, 'b-', 'LineWidth', 1.8, 'DisplayName', 'Difusivo: ∂/∂x(α ∂T/∂x)');
plot(ax, base_sim.x, f_tot, 'k--', 'LineWidth', 1.8, 'DisplayName', 'Suma: ∂T/∂t');
xlabel(ax, 'Posición x (m)', 'Interpreter', 'tex'); ylabel(ax, 'Contribución a ∂T/∂t (°C/s)', 'Interpreter', 'tex');
title(ax, 'Términos advectivo y difusivo en t = 1 s (caso base)', 'Interpreter', 'tex');
leyenda_lateral(ax);
exportgraphics(ancestor(ax, 'figure'), fullfile(dir_fig, 'fig_terminos.png'), 'Resolution', 200);
fprintf('t = 1 s: max dT/dt = %.1f en x = %.2f; en x = 0.5: adv = %.1f, dif = %.1f\n', ...
    max(f_tot), base_sim.x(f_tot == max(f_tot)), f_adv(26), f_dif(26));

%% 4. BARRIDO DE LA VELOCIDAD v (efecto del termino advectivo)
vs = [0 0.25 0.5 1.0];
tab_v = table();
par_v = par; par_v.v = NaN;               % en el recuadro se indica que v varia
ax = nueva_figura('Barrido de v', par_v);
colores = lines(numel(vs));
for k = 1:numel(vs)
    p = par; p.v = vs(k);
    o = simular_sdirk(p, par.tf);
    tab_v(k, :) = {vs(k), o.xf, o.nr, o.gs, o.cpu, o.fallos_nr + o.fallos_gs};
    plot(ax, o.x, o.T, 'Color', colores(k, :), 'LineWidth', 1.8, 'DisplayName', sprintf('v = %.2f m/s', vs(k)));
end
tab_v.Properties.VariableNames = {'v', 'x_frente', 'iter_Newton', 'iter_GS', 'cpu_s', 'fallos'};
disp(tab_v); writetable(tab_v, fullfile(dir_res, 'barrido_v.csv'));
yline(ax, T_media, 'k--', 'DisplayName', sprintf('Temperatura media (%g °C)', T_media));
xlabel(ax, 'Posición x (m)', 'Interpreter', 'tex'); ylabel(ax, 'Temperatura T (°C)', 'Interpreter', 'tex');
title(ax, sprintf('Efecto de la velocidad v sobre T(x, t = %.1f s)', par.tf), 'Interpreter', 'tex');
leyenda_lateral(ax); ylim(ax, [-5 105]);
exportgraphics(ancestor(ax, 'figure'), fullfile(dir_fig, 'fig_barrido_v.png'), 'Resolution', 200);

%% 5. BARRIDO DE beta (no linealidad)
betas = [0 0.1 0.2 0.4];
tab_b = table();
for k = 1:numel(betas)
    p = par; p.beta = betas(k);
    o = simular_sdirk(p, par.tf);
    tab_b(k, :) = {betas(k), o.xf, o.nr, o.gs, o.cpu, o.fallos_nr + o.fallos_gs};
end
tab_b.Properties.VariableNames = {'beta', 'x_frente', 'iter_Newton', 'iter_GS', 'cpu_s', 'fallos'};
disp(tab_b); writetable(tab_b, fullfile(dir_res, 'barrido_beta.csv'));

%% 6. ERROR FRENTE A UNA SOLUCION DE REFERENCIA
% Referencia espacial: N = 401 (dx = 0.0025 m) y h = 0.00125 s.
% Referencia temporal: misma malla del caso base (N = 51) y h = 0.00125 s.
N_ref = 401; h_ref = 0.00125;
ref_esp = solucion_referencia(par, N_ref, h_ref);
ref_tmp = solucion_referencia(par, par.N, h_ref);

% 6.1 Error del caso base
e_base = error_vs_referencia(base_sim.T, ref_esp);
fprintf('Error maximo del caso base (N = %d, h = %g s): %.4e C\n', par.N, par.h, e_base);

% 6.2 Barrido del paso espacial (h = base)
Ns = [26 51 101 201];
tab_dx = table();
for k = 1:numel(Ns)
    p = par; p.N = Ns(k); p = completar_parametros(p);
    o = simular_sdirk(p, p.tf);
    e = error_vs_referencia(o.T, ref_esp);
    tab_dx(k, :) = {p.dx, Ns(k), e, o.nr, o.gs, o.cpu, o.fallos_nr + o.fallos_gs};
end
tab_dx.Properties.VariableNames = {'dx', 'N', 'error_max', 'iter_Newton', 'iter_GS', 'cpu_s', 'fallos'};
tab_dx.orden = [NaN; log2(tab_dx.error_max(1:end-1) ./ tab_dx.error_max(2:end))];
disp(tab_dx); writetable(tab_dx, fullfile(dir_res, 'barrido_dx.csv'));

% 6.3 Barrido del paso de tiempo (malla = base)
hs = [0.04 0.02 0.01 0.005];
tab_h = table();
for k = 1:numel(hs)
    p = par; p.h = hs(k); p = completar_parametros(p);
    o = simular_sdirk(p, p.tf);
    e = error_vs_referencia(o.T, ref_tmp);
    tab_h(k, :) = {hs(k), e, o.nr, o.gs, o.cpu, o.fallos_nr + o.fallos_gs};
end
tab_h.Properties.VariableNames = {'h', 'error_max', 'iter_Newton', 'iter_GS', 'cpu_s', 'fallos'};
tab_h.orden = [NaN; log2(tab_h.error_max(1:end-1) ./ tab_h.error_max(2:end))];
disp(tab_h); writetable(tab_h, fullfile(dir_res, 'barrido_h.csv'));
