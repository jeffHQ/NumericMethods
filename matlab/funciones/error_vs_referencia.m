function e = error_vs_referencia(T, ref)
    % Error maximo |T - T_ref| en los nodos que la malla de T comparte con la de referencia.
    paso = (numel(ref) - 1) / (numel(T) - 1);
    assert(abs(paso - round(paso)) < 1e-12, 'Las mallas no comparten nodos');
    e = max(abs(T - ref(1:round(paso):end)));
end
