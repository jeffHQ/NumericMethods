function par = parametros_base()
    % Caso base del reporte (Tabla 1). Todos los demas scripts parten de aqui.
    par.L      = 1.0;     % Longitud de la linea de corriente (m)
    par.N      = 51;      % Numero de nodos
    par.v      = 0.5;     % Velocidad constante del fluido (m/s)
    par.alpha0 = 0.01;    % Difusividad termica de referencia (m^2/s)
    par.beta   = 0.2;     % Coeficiente de variacion de la difusividad (1/C)
    par.T0     = 0.0;     % Temperatura de referencia (C)
    par.T1     = 100.0;   % Temperatura de la corriente caliente, x = 0 (C)
    par.TN     = 0.0;     % Temperatura de la pared del tubo, x = L (C)
    par.tf     = 2.0;     % Tiempo final (s); L/v = 2 s es el tiempo de transito advectivo
    par.h      = 0.01;    % Paso de tiempo (s)
    par.tol_nr = 1e-6;    % Tolerancia de Newton-Raphson
    par.max_nr = 20;      % Maximo de iteraciones de Newton-Raphson
    par.tol_gs = 1e-8;    % Tolerancia de Gauss-Seidel
    par.max_gs = 500;     % Maximo de iteraciones de Gauss-Seidel
    par.solver = 'gs';    % 'gs' (Gauss-Seidel) o 'directo' (solo para soluciones de referencia)
    par = completar_parametros(par);
end
