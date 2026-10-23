# Métodos Numéricos (CC2104) — Transporte de calor 1D con difusividad variable

Modelamiento numérico transitorio del transporte de calor unidimensional (advección + difusión) en el flujo sobre un tubo cilíndrico, con difusividad térmica que depende de la temperatura.

$$\frac{\partial T}{\partial t} + v\,\frac{\partial T}{\partial x} = \frac{\partial}{\partial x}\!\left(\alpha(T)\,\frac{\partial T}{\partial x}\right), \qquad \alpha(T)=\alpha_0\,[1+\beta\,(T-T_0)]$$

**Integrantes:** Calapuja Quispe, Angela Lorena · Dongo Triveño, Daniel Mateo · Hilario Quintana, Jeffry Arturo · Zorrilla Pelaez, María José
**Curso:** Métodos Numéricos (CC2104), UTEC — Profesor: Ponce Cegovia, Roger Ivan

## Métodos

| Función | Método | Rol |
|---|---|---|
| `simular_sdirk` | Runge-Kutta diagonalmente implícito de 4.º orden (SDIRK4, 5 etapas) | Avance en el tiempo |
| `newton_raphson_sdirk` | Newton-Raphson | Resuelve la ecuación no lineal de cada etapa |
| `gauss_seidel_solver` | Gauss-Seidel | Resuelve el sistema lineal de cada iteración de Newton |
| `evaluar_f` | Diferencias finitas (forma conservativa, advección centrada) | Operador espacial `f(T)` y su Jacobiano |
| `solucion_referencia`, `error_vs_referencia` | Mismo esquema con malla y paso finos (sistema lineal directo) | Error máximo frente a una referencia |

## Estructura del repositorio

```
NumericMethods/
├── matlab/                     # Código fuente (texto plano, versionable)
│   ├── main.m                  # Caso base, figuras, barridos de v, beta, dx y h, y error
│   ├── generar_mlx.m           # Convierte main.m y funciones/*.m a Live Scripts (.mlx)
│   └── funciones/              # Funciones del modelo (.m)
├── entrega_mlx/                # Versión .mlx exigida en los lineamientos (generada)
│   ├── main.mlx
│   └── funciones/*.mlx
├── informe/                    # Paper en LaTeX
│   ├── reporte.tex             # Documento principal (elsarticle, 2 columnas, 11 pt)
│   ├── logo_utec.png           # Logo de la portada
│   ├── figuras/                # Figuras generadas por main
│   └── build/                  # PDF compilado (ignorado por git)
├── resultados/                 # Tablas CSV generadas por main
├── docs/
│   ├── Lineamientos de Proyecto.pdf
│   ├── plantilla_elsevier/     # Archivos de la plantilla elsarticle (referencia)
│   ├── versiones_previas/      # main_anterior.tex (versión previa del reporte)
│   └── figuras_previas/        # Resultado1/2.png de versiones anteriores (no usadas)
├── .vscode/                    # Visor de LaTeX (LaTeX Workshop) y extensiones recomendadas
├── CLAUDE.md, graphify-out/    # Integración con graphify (grafo de conocimiento)
├── README.md
└── LICENSE
```

## Cómo ejecutar

1. Abrir MATLAB (R2025a o superior) y ejecutar `matlab/main.m` (o `entrega_mlx/main.mlx`). No hace falta cambiar de carpeta ni agregar rutas.
2. Genera `informe/figuras/*.png` y `resultados/*.csv` (posición del frente en el tiempo, barridos de `v`, `beta`, `dx` y `h`).
3. Los parámetros del caso base se cambian en `matlab/funciones/parametros_base.m`. Todas las funciones usan una estructura `par` con la misma nomenclatura que el reporte (`T`, `T1`, `TN`, `v`, `alpha0`, `beta`, `T0`, `h`, `dx`…).
4. Si se modifica el código, regenerar los `.mlx` con `matlab/generar_mlx.m` (las fuentes `.m` son la versión de trabajo).

## Ver el reporte en LaTeX

El reporte se visualiza dentro de VS Code con la extensión **LaTeX Workshop** (recomendada en `.vscode/extensions.json`):

1. Compilador: **Tectonic** (`tectonic --version`) descarga solo los paquetes que necesita (la primera compilación requiere internet). Alternativa: MiKTeX o TeX Live con la receta `latexmk`.
2. Abrir VS Code en la raíz del repositorio y aceptar las extensiones recomendadas.
3. Abrir `informe/reporte.tex`; al guardar se compila y `Ctrl+Alt+V` abre el PDF en una pestaña. Manualmente: `cd informe && mkdir -p build && tectonic -X compile --outdir build reporte.tex`.

## Entrega

Según los lineamientos, el paper se entrega como `MN P2 Grupo #.pdf` por Canvas (máximo 10 páginas sin referencias ni anexos, 2 columnas, 11 pt) y el enlace del repositorio con los `.mlx` va en los Anexos. Antes de entregar: completar la fecha de la portada y confirmar que el repositorio en la nube es accesible.

## Grafo de conocimiento (graphify)

El proyecto tiene [graphify](https://pypi.org/project/graphifyy/) instalado para Claude Code (`graphify claude install`). Tras modificar código:

```bash
graphify update .      # reconstruye el grafo (solo AST, sin costo de API)
graphify query "¿dónde se usa evaluar_f?"
```

## Licencia

Ver [LICENSE](LICENSE).
