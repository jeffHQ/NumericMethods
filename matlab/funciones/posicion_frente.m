function xf = posicion_frente(x, T, T1, TN)
    % Posicion del frente: punto donde T alcanza la temperatura media (T1+TN)/2.
    % Se busca el primer nodo con T <= T_media y se interpola linealmente.
    T_media = (T1 + TN) / 2;
    idx = find(T <= T_media, 1);
    if isempty(idx) || idx == 1
        xf = NaN;
    else
        xf = x(idx-1) + (T_media - T(idx-1)) * (x(idx) - x(idx-1)) / (T(idx) - T(idx-1));
    end
end
