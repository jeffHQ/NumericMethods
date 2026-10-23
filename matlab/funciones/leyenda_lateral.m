function lg = leyenda_lateral(ax)
    % Leyenda debajo del recuadro de variables, fuera de las curvas.
    lg = legend(ax, 'Interpreter', 'tex', 'Location', 'none');
    lg.Units = 'normalized';
    lg.Position = [0.70 0.14 0.29 0.33];
end
