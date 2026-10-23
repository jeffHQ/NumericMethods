function par = completar_parametros(par)
    % Calcula los parametros derivados y los coeficientes de SDIRK4 (5 etapas).
    par.dx = par.L / (par.N - 1);
    par.x  = linspace(0, par.L, par.N)';
    par.num_pasos = round(par.tf / par.h);
    par.gamma = 1/4;
    par.A_rk = [ 1/4         0           0         0       0;
                 1/2         1/4         0         0       0;
                 17/50      -1/25        1/4       0       0;
                 371/1360   -137/2720    15/544    1/4     0;
                 25/24      -49/48       125/16   -85/12   1/4 ];
    % La ultima fila coincide con los pesos b_i, por eso T^{n+1} = T^(5).
end
