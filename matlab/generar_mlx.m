%% Genera las versiones .mlx (Live Scripts) para la entrega a partir de las fuentes .m
% Las fuentes .m (matlab/main.m y matlab/funciones/*.m) son la version de trabajo;
% el resultado queda en entrega_mlx/ con la misma estructura de carpetas.
base = fileparts(mfilename('fullpath'));
raiz = fileparts(base);
destino = fullfile(raiz, 'entrega_mlx');
if ~isfolder(fullfile(destino, 'funciones')), mkdir(fullfile(destino, 'funciones')); end

lista = dir(fullfile(base, 'funciones', '*.m'));
archivos = [{fullfile(base, 'main.m')}, fullfile(base, 'funciones', {lista.name})];
for k = 1:numel(archivos)
    [~, nombre] = fileparts(archivos{k});
    if strcmp(nombre, 'main')
        salida = fullfile(destino, 'main.mlx');
    else
        salida = fullfile(destino, 'funciones', [nombre '.mlx']);
    end
    matlab.internal.liveeditor.openAndSave(archivos{k}, salida);
    fprintf('%s -> %s\n', archivos{k}, salida);
end
