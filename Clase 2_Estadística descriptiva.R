#===============================================================#
#            CLASE 2: ESTADÍSTICA DESCRIPTIVA CON R             #
#      Diplomado en Data Science para las Ciencias Sociales     #
#                  Exploración de Datos - UDP                   #
#===============================================================#

# OBJETIVO DE LA CLASE
# Resumir y describir un conjunto de datos usando:
#   1. Tipos de variable y su tratamiento
#   2. Tablas de frecuencia (variables cualitativas)
#   3. Medidas de tendencia central (media, mediana, moda)
#   4. Medidas de dispersión (rango, IQR, varianza, sd, CV)
#   5. Medidas de posición (cuartiles, quintiles, deciles, percentiles)
#   6. Forma de la distribución (sesgo y curtosis)
#   7. Descriptivos resumidos y bivariados (por grupos)

# METODOLOGÍA: cada bloque tiene un EJEMPLO (lo hacemos juntos)
# y un EJERCICIO (lo resuelves tú). Trabajamos en R base y librerías
# especializadas (NO usamos tidyverse: eso es materia del próximo curso).

#---------------------------------------------------------------#
# 0. PREPARACIÓN: LIBRERÍAS Y DATOS                             #
#---------------------------------------------------------------#

# Trabajaremos con pacman para gestionar las librerías. Su función
# p_load() hace dos cosas en un solo paso: INSTALA el paquete si aún
# no lo tienes y lo ACTIVA. Así evitamos alternar install.packages()
# con library() y el código queda más limpio y reproducible.
# (Recuerda: los paquetes se instalan una vez, pero se activan cada
#  vez que abres R.)

# Instalamos pacman solo si no está disponible:
if (!require("pacman")) install.packages("pacman")

# Cargamos (e instalamos si falta) todas las librerías de la clase:
pacman::p_load(
  rio,        # importar/exportar datos de cualquier formato
  psych,      # describe() y describeBy(): resúmenes completos
  skimr,      # skim(): vistazo rápido y ordenado
  epiDisplay, # tab1(): tablas de frecuencia univariadas prolijas
  moments     # skewness() y kurtosis(): sesgo y curtosis numéricos
)

# CARGAR DATOS
# Usamos una versión reducida de la encuesta CASEN.
# Asegúrate de tener abierto el proyecto (Exploración de datos.Rproj)
# para que la ruta relativa funcione.
data <- import("Datos/casen_red.sav")

# PRIMER VISTAZO
str(data)      # estructura: nombres, tipos y primeras observaciones
head(data)     # primeras 6 filas
skim(data)     # resumen ordenado de todas las variables

# Diccionario de la base:
#   nse    -> Nivel socioeconómico (cualitativa)
#   sexo   -> Sexo (cualitativa)
#   edad   -> Edad en años (cuantitativa)
#   region -> Región (cualitativa)
#   v17    -> ¿Cuánto paga de dividendo? (cuantitativa)
#   v18    -> ¿Cuánto paga de arriendo su hogar? (cuantitativa)

#---------------------------------------------------------------#
# 0.1 UN PARÉNTESIS: FUNCIONES EN R                            #
#---------------------------------------------------------------#

# Ya venimos usando funciones todo el tiempo: mean(), table(), hist()...
# Una función RECIBE argumentos (lo que va entre paréntesis), hace algo
# con ellos y DEVUELVE un resultado. Su forma general es:
#
#     nombre_funcion(argumento1, argumento2 = valor_por_defecto)
#
# Por ejemplo, en round(x, digits = 2): 'x' es el número a redondear y
# 'digits' cuántos decimales queremos. Los argumentos escritos con "="
# ya traen un valor por defecto, así que son OPCIONALES. Por eso
# mean(data$edad) funciona, pero si hay NA debemos activar na.rm = TRUE.

# También podemos CREAR nuestras propias funciones con function():
#
#     nombre <- function(entradas) { operaciones ; return(salida) }

# Ejemplo: una función que convierte una proporción a porcentaje.
a_porcentaje <- function(x) {
  resultado <- x * 100   # operación
  return(resultado)      # lo que la función entrega
}
a_porcentaje(0.25)   # devuelve 25

# ¿PARA QUÉ CREAR FUNCIONES? Para no repetir código. Si vas a hacer lo
# mismo muchas veces, encapsúlalo en una función y llámala cuando la
# necesites. En esta clase construiremos dos funciones propias:
#   - a_na(): para limpiar códigos de valores perdidos.
#   - cv():   para calcular el coeficiente de variación.

#---------------------------------------------------------------#
# 1. TIPOS DE VARIABLE Y LIMPIEZA DE CÓDIGOS PERDIDOS           #
#---------------------------------------------------------------#

# ¿Por qué importa el tipo de variable?
# Porque determina QUÉ estadístico tiene sentido calcular:
#   - CUALITATIVAS (nominal/ordinal): tablas de frecuencia, moda.
#   - CUANTITATIVAS (discreta/continua): media, mediana, dispersión, etc.

# ATENCIÓN: en encuestas los valores perdidos suelen venir CODIFICADOS
# con números (por ej. -88 = "no sabe/no responde"). Si no los limpiamos,
# R los trata como números reales y CONTAMINA todos los cálculos.

# Veámoslo con v18 (arriendo):
summary(data$v18)            # fíjate en el mínimo: aparece un -88
sum(data$v18 == -88, na.rm = TRUE)  # ¿cuántos casos con -88?

# La media SIN limpiar está sesgada por esos códigos:
mean(data$v18, na.rm = TRUE)

# Reemplazamos el código perdido por NA (subsetting base de R):
data$v18[data$v18 == -88] <- NA

# La media ahora es correcta:
mean(data$v18, na.rm = TRUE)

# SUGERENCIA: cuando hay que limpiar varias variables con el mismo código,
# conviene una pequeña función. Así no repetimos código y evitamos errores.
a_na <- function(x, codigos) {
  x[x %in% codigos] <- NA
  return(x)
}
# Ejemplo de uso (v17 dividendo suele traer el mismo tipo de códigos):
data$v17 <- a_na(data$v17, c(-88, -66))

#---------------------------------------------------------------#
# 2. VARIABLES CUALITATIVAS: TABLAS DE FRECUENCIA               #
#---------------------------------------------------------------#

# EJEMPLO -------------------------------------------------------#
# Valores únicos de la variable
unique(data$sexo)

# FRECUENCIA ABSOLUTA con table()
table(data$sexo)
table(data$nse)

# FRECUENCIA RELATIVA (proporción) con prop.table()
prop.table(table(data$sexo))

# PORCENTAJE (multiplicamos por 100)
# OJO: para redondear correctamente encerramos todo en paréntesis,
# porque R evalúa e imprime antes de redondear si no lo hacemos.
round(prop.table(table(data$sexo)) * 100, 1)

# TABLA CON TOTALES: addmargins() agrega la fila/columna de totales
addmargins(table(data$nse))

# tab1() de epiDisplay entrega en un solo paso la frecuencia absoluta,
# relativa, acumulada y un gráfico de barras:
tab1(data$sexo)
tab1(data$nse)

# TABLA DE CONTINGENCIA (dos variables cualitativas)
tabla <- table(data$sexo, data$nse)
tabla

# Porcentaje POR FILA (margin = 1): cada fila suma 100%
round(prop.table(tabla, margin = 1) * 100, 1)

# Porcentaje POR COLUMNA (margin = 2): cada columna suma 100%
round(prop.table(tabla, margin = 2) * 100, 1)

# Tabla de contingencia con totales en los márgenes
addmargins(tabla)

# EJERCICIO 1 --------------------------------------------------#
# a) Construye la tabla de frecuencias absolutas de 'region'.
# b) Exprésala en porcentaje redondeado a 1 decimal.
# c) Haz una tabla de contingencia entre 'sexo' y 'region' con
#    porcentajes por columna. ¿En qué región hay proporcionalmente
#    más mujeres?
#--------------------------------------------------------------#


#---------------------------------------------------------------#
# 3. MEDIDAS DE TENDENCIA CENTRAL                               #
#---------------------------------------------------------------#

# EJEMPLO (variable v18 = arriendo, ya limpia) -----------------#

# MEDIA: el promedio aritmético. Sensible a valores extremos.
mean(data$v18, na.rm = TRUE)

# MEDIANA: el valor central (percentil 50). Robusta a extremos.
median(data$v18, na.rm = TRUE)

# ¿Por qué media y mediana difieren? Porque unos pocos arriendos
# muy altos "tiran" la media hacia arriba. La mediana no se deja arrastrar.
# Esta diferencia es la primera pista de que la distribución es asimétrica.

# MODA: el valor más frecuente. R base no tiene función de moda,
# así que la obtenemos desde la tabla de frecuencias.
frec <- table(data$v18)
moda <- as.numeric(names(frec)[frec == max(frec)])
moda

# Para ver los 5 valores más repetidos (útil para detectar redondeos):
sort(frec, decreasing = TRUE)[1:5]
# Nota: la gente tiende a declarar cifras "redondas" (200000, 300000...).

# EJERCICIO 3 --------------------------------------------------#
# a) Calcula media y mediana de 'edad'.
# b) ¿Son parecidas o muy distintas? ¿Qué te dice eso sobre la
#    simetría de la distribución de la edad?
#--------------------------------------------------------------#


#---------------------------------------------------------------#
# 4. MEDIDAS DE DISPERSIÓN                                      #
#---------------------------------------------------------------#

# EJEMPLO -------------------------------------------------------#

# RANGO: del mínimo al máximo
range(data$v18, na.rm = TRUE)
diff(range(data$v18, na.rm = TRUE))  # amplitud del rango

# RANGO INTERCUARTÍLICO (IQR): distancia entre el Q3 y el Q1.
# Contiene al 50% central de los datos y es robusto a extremos.
IQR(data$v18, na.rm = TRUE)
# Equivalente "a mano":
quantile(data$v18, 0.75, na.rm = TRUE) - quantile(data$v18, 0.25, na.rm = TRUE)

# VARIANZA: promedio de las distancias al cuadrado respecto a la media.
var(data$v18, na.rm = TRUE)

# DESVIACIÓN ESTÁNDAR: raíz de la varianza (vuelve a las unidades originales).
sd(data$v18, na.rm = TRUE)

# COEFICIENTE DE VARIACIÓN (CV): dispersión RELATIVA, en %.
# Sirve para comparar la variabilidad de variables con distinta escala o unidad.
cv <- function(x) sd(x, na.rm = TRUE) / mean(x, na.rm = TRUE) * 100
cv(data$v18)

# ¿POR QUÉ EL CV? Comparemos la dispersión de la EDAD y el ARRIENDO.
# La desviación estándar no es comparable (años vs. pesos):
sd(data$edad, na.rm = TRUE)   # en años
sd(data$v18, na.rm = TRUE)    # en pesos
# Pero el CV sí es comparable (ambos en %):
cv(data$edad)
cv(data$v18)
# Conclusión: el arriendo es MUCHO más disperso en términos relativos
# que la edad, aunque su desviación estándar "en bruto" sea enorme.

# EJERCICIO 4 --------------------------------------------------#
# a) Calcula sd y CV de 'v17' (dividendo).
# b) Compara el CV de 'v17' con el de 'v18'. ¿Qué gasto de vivienda
#    presenta mayor dispersión relativa entre los hogares?
#--------------------------------------------------------------#


#---------------------------------------------------------------#
# 5. MEDIDAS DE POSICIÓN                                        #
#---------------------------------------------------------------#

# La función clave es quantile(). El argumento 'probs' define los cortes.
# Recuerda que la distribución completa va de 0 a 1.

# EJEMPLO -------------------------------------------------------#

# CUARTILES: dividen la distribución en 4 partes (25% cada una)
quantile(data$v18, probs = c(0.25, 0.50, 0.75), na.rm = TRUE)

# QUINTILES: en 5 partes (20% cada una). Muy usados en política social
# (por ej. "quintil de ingreso").
quantile(data$v18, probs = seq(0.2, 0.8, by = 0.2), na.rm = TRUE)

# DECILES: en 10 partes (10% cada una)
quantile(data$v18, probs = seq(0.1, 0.9, by = 0.1), na.rm = TRUE)

# PERCENTIL puntual: por ejemplo, el arriendo del 95% más bajo
quantile(data$v18, probs = 0.95, na.rm = TRUE)
# INTERPRETACIÓN: el 95% de los hogares paga ese monto o menos.

# EJERCICIO 5 --------------------------------------------------#
# a) Obtén los deciles de 'edad'.
# b) ¿Qué edad separa al 10% más joven de la muestra (primer decil)?
#--------------------------------------------------------------#


#---------------------------------------------------------------#
# 6. INTRODUCCIÓN BREVE A LOS GRÁFICOS EN R BASE               #
#---------------------------------------------------------------#

# Antes de graficar la FORMA de la distribución, conozcamos los
# gráficos base y sus argumentos más usados. La visualización completa
# es materia de la Clase 3; aquí solo lo esencial para esta clase.

# QUÉ FUNCIÓN USAR SEGÚN EL TIPO DE VARIABLE:
#   barplot(table(x)) -> barras (variables CUALITATIVAS)
#   hist(x)           -> histograma (variables CUANTITATIVAS)
#   boxplot(x)        -> caja y bigotes (dispersión y valores atípicos)
#   plot(x, y)        -> dispersión/línea (relación entre dos variables)
#   plot(density(x))  -> curva de densidad (un histograma "suavizado")

# ARGUMENTOS COMUNES (sirven en casi todos los gráficos):
#   main   -> título del gráfico
#   xlab   -> etiqueta del eje X
#   ylab   -> etiqueta del eje Y
#   col    -> color del relleno, líneas o puntos
#   border -> color del borde de las barras
#   xlim, ylim -> límites de los ejes, por ej. ylim = c(0, 100)
#   breaks -> número de intervalos del histograma
#   probability = TRUE -> el eje Y muestra densidad en vez de frecuencia

# EJEMPLO: el mismo histograma, primero por defecto y luego "vestido".
hist(data$edad)   # versión mínima
hist(data$edad,
     main   = "Distribución de la edad",
     xlab   = "Edad (años)",
     ylab   = "Frecuencia",
     col    = "grey85",   # color de las barras
     border = "white")    # color del borde

# ARGUMENTOS PROPIOS DE LÍNEAS Y PUNTOS:
#   lwd -> grosor de la línea (1 por defecto; 2 o 3 = más gruesa)
#   lty -> tipo de línea: 1 sólida, 2 discontinua, 3 punteada
#   pch -> tipo de punto en dispersión (por ej. 19 = punto relleno)

# FUNCIONES QUE SE AGREGAN SOBRE UN GRÁFICO YA EXISTENTE:
#   abline(v = ...) -> línea vertical   | abline(h = ...) -> horizontal
#   lines(...)      -> agrega una curva o línea
#   legend(...)     -> agrega una leyenda

# EJEMPLO: histograma + línea vertical roja en la media.
hist(data$edad, main = "Edad con su media",
     xlab = "Edad (años)", col = "grey85")
abline(v = mean(data$edad, na.rm = TRUE), col = "red", lwd = 2, lty = 2)

# VARIOS GRÁFICOS EN UNA VENTANA: par(mfrow = c(filas, columnas)).
# Acuérdate de volver a par(mfrow = c(1, 1)) al terminar.

#---------------------------------------------------------------#
# 7. FORMA DE LA DISTRIBUCIÓN: SESGO Y CURTOSIS                 #
#---------------------------------------------------------------#

# --- 6.1 SESGO (asimetría) ---

# El SESGO mide la asimetría de la distribución.
#   - Sesgo = 0  -> simétrica (media ≈ mediana)
#   - Sesgo > 0  -> asimetría positiva, cola hacia la DERECHA (media > mediana)
#   - Sesgo < 0  -> asimetría negativa, cola hacia la IZQUIERDA (media < mediana)

# EJEMPLO: distribución simétrica simulada
set.seed(123)  # fija la semilla para que el resultado sea reproducible
simetrica <- rnorm(10000, mean = 100, sd = 5)
hist(simetrica, main = "Distribución simétrica",
     xlab = "Valores", ylab = "Frecuencia", col = "grey85")
abline(v = mean(simetrica),   col = "red",  lwd = 2, lty = 2)  # media
abline(v = median(simetrica), col = "blue", lwd = 2, lty = 2)  # mediana
# Cuando es simétrica, media y mediana casi coinciden (las líneas se pisan).
skewness(simetrica)   # cercano a 0

# EJEMPLO: nuestra variable real v18 (arriendo)
hist(data$v18, main = "Costo del arriendo (CASEN)",
     xlab = "Arriendo ($)", ylab = "Frecuencia", col = "grey85")
abline(v = mean(data$v18, na.rm = TRUE),   col = "red",  lwd = 2, lty = 2)
abline(v = median(data$v18, na.rm = TRUE), col = "blue", lwd = 2, lty = 2)
# La media (roja) queda a la DERECHA de la mediana (azul): sesgo positivo.
skewness(data$v18, na.rm = TRUE)   # valor positivo -> cola a la derecha

# --- 6.2 CURTOSIS (peso de las colas) ---

# La CURTOSIS mide cuán concentrados están los datos en las colas.
#   - Mesocúrtica  -> como la normal
#   - Leptocúrtica -> colas pesadas, pico alto (más valores extremos)
#   - Platicúrtica -> colas livianas, aplanada

# EJEMPLO comparativo con tres distribuciones simuladas:
set.seed(123)
meso  <- rnorm(1000, 0, 1)                      # normal
lepto <- rt(1000, df = 3)                        # t de Student: colas pesadas
plati <- runif(1000, -sqrt(3), sqrt(3))          # uniforme: colas livianas

par(mfrow = c(3, 1))  # 3 gráficos en una columna
hist(meso,  breaks = 30, probability = TRUE, main = "Mesocúrtica (Normal)")
lines(density(meso), lwd = 2)
hist(lepto, breaks = 30, probability = TRUE, main = "Leptocúrtica (t, df=3)")
lines(density(lepto), lwd = 2)
hist(plati, breaks = 30, probability = TRUE, main = "Platicúrtica (Uniforme)")
lines(density(plati), lwd = 2)
par(mfrow = c(1, 1))  # volvemos a un solo gráfico

# Curtosis numérica con moments::kurtosis()
kurtosis(meso)   # ~3
kurtosis(lepto)  # claramente > 3
kurtosis(plati)  # < 3

# ¡OJO CON LA ESCALA DE LA CURTOSIS! Hay dos convenciones:
#   - moments::kurtosis(): la normal vale ~3 (curtosis "clásica").
#   - psych::describe():   reporta el EXCESO de curtosis (resta 3),
#                          por lo que la normal vale ~0.
# No es un error: es la misma información en distinta escala.
# Regla práctica:  moments ~3  ==  psych ~0  ==  distribución mesocúrtica.

# EJERCICIO 6 --------------------------------------------------#
# a) Calcula el sesgo de 'edad' con skewness(). ¿Positivo o negativo?
# b) Dibuja su histograma con las líneas de media y mediana y comprueba
#    visualmente el signo del sesgo.
#--------------------------------------------------------------#


#---------------------------------------------------------------#
# 8. RESÚMENES Y ESTADÍSTICA BIVARIADA (POR GRUPOS)            #
#---------------------------------------------------------------#

# EJEMPLO -------------------------------------------------------#

# Resumen rápido de una variable con R base
summary(data$v18)

# describe() de psych entrega en una sola tabla: n, media, sd, mediana,
# min, max, rango, sesgo (skew) y curtosis (kurtosis, en EXCESO).
describe(data$v18)

# ¿EN QUÉ REGIÓN SE PAGA MÁS ARRIENDO?
# Preparamos una submuestra de 3 regiones y etiquetamos la variable region.
arriendo <- data[!is.na(data$v18) &
                   data$region %in% c(2, 5, 13), ]
arriendo$region <- factor(arriendo$region,
                          levels = c(2, 5, 13),
                          labels = c("Antofagasta", "Valparaíso", "RM"))

# tapply() aplica una función a una variable cuantitativa SEGÚN los
# niveles de una cualitativa: tapply(cuantitativa, cualitativa, función)
tapply(arriendo$v18, arriendo$region, mean, na.rm = TRUE)

# describeBy() de psych: el resumen completo, pero por grupo
describeBy(arriendo$v18, arriendo$region)

# EJERCICIO 7 (SÍNTESIS) ---------------------------------------#
# a) Compara el arriendo promedio entre hombres y mujeres con tapply().
# b) Usa describeBy() para ver también la mediana y el sesgo por sexo.
# c) Redacta en una línea la conclusión sustantiva de lo que observas.
#--------------------------------------------------------------#


#===============================================================#
# RESUMEN: ¿QUÉ MEDIDA USAR SEGÚN EL TIPO DE VARIABLE?          #
#---------------------------------------------------------------#
# CUALITATIVA (nominal/ordinal):
#   - Frecuencias: table(), prop.table(), addmargins(), tab1()
#   - Tendencia central: moda
#
# CUANTITATIVA:
#   - Tendencia central: mean(), median(), (moda)
#   - Dispersión: range(), IQR(), var(), sd(), CV
#   - Posición: quantile()
#   - Forma: skewness(), kurtosis(), histograma + densidad
#   - Todo junto: summary(), describe(), skim()
#
# BIVARIADO:
#   - Cualitativa x cualitativa: table() + prop.table(margin=)
#   - Cuantitativa por grupos:   tapply(), describeBy()
#===============================================================#
