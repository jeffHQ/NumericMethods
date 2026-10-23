function ref = solucion_referencia(par, N_ref, h_ref)
    % Solucion de referencia: mismo esquema (SDIRK4 + Newton-Raphson) con malla y paso de tiempo
    % mucho mas finos; el sistema lineal se resuelve de forma directa porque Gauss-Seidel converge
    % muy lento en mallas finas. Devuelve T(x, tf) en la malla de referencia.
    p = par;
    p.N = N_ref; p.h = h_ref; p.solver = 'directo';
    p = completar_parametros(p);
    o = simular_sdirk(p, p.tf);
    ref = o.T;
end
