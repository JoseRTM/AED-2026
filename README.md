# Exploración de Datos con R

Material del curso **Exploración de Datos** del Diplomado en Data Science para las Ciencias Sociales de la Universidad Diego Portales.

El repositorio reúne presentaciones, scripts, ejercicios y bases de datos para avanzar desde los fundamentos de R hasta la inferencia y la regresión lineal. Los materiales están preparados para estudiantes que comienzan a trabajar con datos: cada script combina explicaciones, ejemplos desarrollados, interpretación y ejercicios.

## Objetivos del curso

Al finalizar el módulo podrás:

- reconocer los principales objetos y tipos de datos de R;
- importar archivos de distintos formatos;
- inspeccionar, limpiar y transformar bases de datos;
- calcular e interpretar estadísticos descriptivos;
- construir tablas y visualizaciones apropiadas;
- comprender la variabilidad muestral y la lógica de la inferencia;
- interpretar intervalos de confianza y pruebas de hipótesis;
- ajustar e interpretar modelos de regresión lineal; y
- revisar supuestos, interacciones, transformaciones y errores estándar robustos.

## Antes de comenzar

Instala los siguientes programas:

1. [R](https://cran.r-project.org/), el lenguaje que utilizaremos.
2. [RStudio Desktop](https://posit.co/download/rstudio-desktop/), la interfaz recomendada para trabajar con los scripts.

No necesitas instalar manualmente todos los paquetes antes del curso. Los scripts más recientes utilizan `pacman` para instalar y cargar los paquetes necesarios.

## Cómo obtener el material

### Alternativa 1: descargar desde GitHub

1. Presiona el botón verde **Code**.
2. Selecciona **Download ZIP**.
3. Descomprime el archivo en una carpeta fácil de encontrar.
4. Abre esa carpeta desde RStudio.

### Alternativa 2: clonar con Git

```bash
git clone https://github.com/JoseRTM/AED_UDP.git
```

## Abrir la carpeta como proyecto de RStudio

La carpeta puede utilizarse sin ser inicialmente un proyecto. Sin embargo, convertirla en proyecto ayuda a mantener una carpeta de trabajo estable.

1. Abre RStudio.
2. Selecciona **File > New Project**.
3. Elige **Existing Directory**.
4. Selecciona la carpeta que contiene este README.
5. Presiona **Create Project**.

RStudio creará un archivo `.Rproj`. Este archivo organiza la sesión, pero no modifica los scripts ni las bases de datos.

## Cómo trabajar con los scripts

Abre el archivo correspondiente a la clase y ejecuta el código por secciones:

- Windows y Linux: `Ctrl + Enter`.
- macOS: `Cmd + Enter`.

Durante el primer recorrido no se recomienda ejecutar el archivo completo de una sola vez. Algunos bloques están diseñados para observar los resultados, discutirlos y escribir una interpretación antes de continuar.

Los comentarios comienzan con `#` y no se ejecutan. Puedes utilizarlos para agregar tus propios apuntes.

## Orden recomendado de las clases

| Clase | Material principal | Contenidos |
|---:|---|---|
| 0 | `Clase 0_Introducción a R.R` | RStudio, operaciones, objetos, vectores, tipos de datos, matrices, listas y data frames. |
| 1 | `Clase 1. Exploración de datos.pptx` | Introducción al análisis exploratorio y conceptos centrales del curso. |
| 1.1 | `Clase 1.1_Librerías e importación de datos.R` | Paquetes e importación de Excel, CSV, SPSS, Stata, RDS y RData. |
| 2 | `Clase 2_Estadística descriptiva.R` | Tipos de variables, limpieza, frecuencias, tendencia central, dispersión, posición, sesgo y curtosis. |
| 2 | `Clase 2_Guía de ejercicios.R` | Aplicación individual de estadística descriptiva con datos PAES. |
| 2 | `Clase 2_Guía de ejercicios_RESUELTA.R` | Soluciones comentadas para revisar después de intentar la guía. |
| 3 | `Clase 3_Visualización.R` | Barras, líneas, boxplots, dispersión, histogramas, densidades y paneles con R base. |
| 4 | `Clase 4_Ley de los Grandes Números y TLC.pptx` | Población, muestra, estimadores, Ley de los Grandes Números, Teorema del Límite Central e intervalos de confianza. |
| 4 | `Clase 4_Introducción a la inferencia con R.R` | Simulación, distribuciones muestrales e intervalos de confianza con R. |
| 5 | `Clase 5_Introducción a los test de hipótesis_conceptest-final.pptx` | Hipótesis, valor p, valor S, errores estadísticos y ConcepTest. |
| 5 | `Clase 5_Test_de_hipótesis.R` | Pruebas para proporciones y medias, ANOVA, correlación e interpretación. |
| 6 | `Clase 6_Regresión lineal y supuestos_final.pptx` | Regresión simple y múltiple, coeficientes, incertidumbre y supuestos. |
| 6 | `Clase 6_Regresión lineal y supuestos.R` | Ajuste, predicciones y diagnósticos de modelos lineales con R. |
| 7 | `Clase 7_Interacciones transformaciones y varianza robusta_final.pptx` | Interacciones, transformaciones y heterocedasticidad. |
| 7 | `Clase 7_Interacciones transformaciones y varianza robusta.R` | Predicciones de interacciones, términos cuadráticos, logaritmos y errores estándar HC3. |

El archivo `Programa exploración de datos.docx` contiene la descripción general y planificación del módulo.

## Estructura del repositorio

```text
.
├── Datos/
│   ├── bbdd_ejercicios.RData
│   ├── bbdd_prueba1.csv
│   ├── bbdd_prueba1.dta
│   ├── bbdd_prueba1.rds
│   ├── bbdd_prueba1.sav
│   ├── bbdd_prueba1.xlsx
│   └── casen_red.sav
├── Clase 0_Introducción a R.R
├── Clase 1. Exploración de datos.pptx
├── Clase 1.1_Librerías e importación de datos.R
├── Clase 2_Estadística descriptiva.R
├── Clase 2_Guía de ejercicios.R
├── Clase 2_Guía de ejercicios_RESUELTA.R
├── Clase 3_Visualización.R
├── Clase 4_Ley de los Grandes Números y TLC.pptx
├── Clase 4_Introducción a la inferencia con R.R
├── Clase 5_Introducción a los test de hipótesis_conceptest-final.pptx
├── Clase 5_Test_de_hipótesis.R
├── Clase 6_Regresión lineal y supuestos_final.pptx
├── Clase 6_Regresión lineal y supuestos.R
├── Clase 7_Interacciones transformaciones y varianza robusta_final.pptx
├── Clase 7_Interacciones transformaciones y varianza robusta.R
├── Programa exploración de datos.docx
└── README.md
```

## Dinámica de los materiales

Cada clase sigue una secuencia similar:

1. **Introducción conceptual:** la presentación introduce la pregunta y las ideas centrales.
2. **Ejemplo desarrollado:** el script muestra cómo realizar el análisis con R.
3. **Interpretación:** los comentarios conectan la salida estadística con una conclusión sustantiva.
4. **Ejercicio:** cada sección propone una aplicación para practicar.

Las clases 4 a 7 combinan presentaciones breves con scripts. Se recomienda revisar primero la presentación y después trabajar el código en RStudio.

## Bases de datos

La carpeta `Datos/` contiene archivos en distintos formatos para practicar importación y análisis:

- `bbdd_prueba1.*`: una misma base guardada en formatos de Excel, CSV, SPSS, Stata y R;
- `bbdd_ejercicios.RData`: entorno de R utilizado en ejercicios de importación; y
- `casen_red.sav`: versión reducida de CASEN utilizada en estadística descriptiva.

Algunas clases utilizan bases disponibles en el repositorio remoto del curso. Para ejecutar esos bloques necesitas conexión a internet.

## Paquetes utilizados

- `rio`, `readxl`, `haven` y `readr` para importar datos;
- `psych`, `skimr`, `epiDisplay` y `moments` para explorar y resumir información;
- `car` y `lmtest` para diagnósticos de regresión;
- `sandwich` para estimación robusta de la varianza;
- `texreg` para presentar resultados de modelos; y
- funciones de R base para tablas, gráficos, pruebas y regresiones.

Si R solicita seleccionar un servidor de descarga, elige uno cercano a tu ubicación o la opción **0-Cloud**.

## Recomendaciones para estudiar

- Ejecuta el código línea por línea y observa los paneles **Environment**, **Console**, **Plots** y **Files**.
- Antes de mirar una solución, intenta resolver el ejercicio y redacta una interpretación.
- Distingue siempre entre significancia estadística y relevancia sustantiva.
- Revisa los gráficos y supuestos antes de informar un modelo.
- No interpretes una asociación como causal sin considerar el diseño del estudio.
- Conserva tus respuestas en un script separado.

## Problemas frecuentes

### R no encuentra un archivo

Comprueba la carpeta de trabajo:

```r
getwd()
```

La ruta debería apuntar a la carpeta que contiene este README. Verifica también que la carpeta `Datos/` conserve su nombre y ubicación.

### R no encuentra una función

La función probablemente pertenece a un paquete que aún no está cargado. Ejecuta primero el bloque de preparación de la clase correspondiente.

### Un paquete no se instala

Comprueba tu conexión, reinicia RStudio e intenta nuevamente. La instalación se realiza una sola vez, pero el paquete debe cargarse en cada sesión.

### No aparece la pestaña Terminal

En RStudio selecciona **Tools > Terminal > New Terminal**. La terminal funciona aunque la carpeta todavía no sea un proyecto de RStudio.

## Publicar esta carpeta en GitHub

La carpeta puede convertirse en repositorio sin mover sus archivos. Abre una terminal ubicada en esta carpeta y ejecuta:

```bash
git init
git add .
git commit -m "Primera versión del curso"
```

Después de crear un repositorio vacío en GitHub, conecta la carpeta utilizando la dirección que GitHub te entregue:

```bash
git branch -M main
git remote add origin https://github.com/TU-USUARIO/NOMBRE-DEL-REPOSITORIO.git
git push -u origin main
```

Reemplaza `TU-USUARIO` y `NOMBRE-DEL-REPOSITORIO` por los valores correspondientes.

## Uso del material

Este repositorio tiene fines docentes. Puedes descargar y adaptar los materiales para estudiar. Si reutilizas contenidos fuera del curso, indica su procedencia.

---

**Diplomado en Data Science para las Ciencias Sociales**  
**Universidad Diego Portales**
