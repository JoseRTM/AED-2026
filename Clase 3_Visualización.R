#===============================================================#
#              CLASE 3: VISUALIZACIÓN CON R BASE                #
#      Diplomado en Data Science para las Ciencias Sociales     #
#                  Exploración de Datos - UDP                   #
#===============================================================#

# OBJETIVO DE LA CLASE
# Construir e interpretar gráficos adecuados para distintos datos:
#   1. Barras para variables cualitativas
#   2. Líneas para series temporales
#   3. Boxplots para comparar distribuciones entre grupos
#   4. Dispersión para estudiar relaciones
#   5. Histogramas y densidades para variables cuantitativas
#   6. Paneles con múltiples gráficos

# METODOLOGÍA: cada bloque tiene un EJEMPLO (lo hacemos juntos)
# y un EJERCICIO (lo resuelves tú). Usaremos gráficos de R base.

#---------------------------------------------------------------#
# 0. PREPARACIÓN: LIBRERÍAS Y DATOS                             #
#---------------------------------------------------------------#

if (!require("pacman")) install.packages("pacman")

# ggplot2 se usa únicamente para acceder a la base economics.
pacman::p_load(
  ggplot2 # contiene la base economics
)

# mtcars viene incluida en R. Cada fila corresponde a un automóvil.
data <- mtcars
?mtcars
str(data)
head(data)

# Variables utilizadas:
#   mpg  -> rendimiento (millas por galón)
#   cyl  -> número de cilindros
#   wt   -> peso (miles de libras)
#   hp   -> potencia
#   qsec -> tiempo en recorrer un cuarto de milla
#   am   -> transmisión (0 = automática, 1 = manual)

data$am <- factor(data$am,
                  levels = c(0, 1),
                  labels = c("Automática", "Manual"))

#---------------------------------------------------------------#
# 0.1 ELEMENTOS DE UN GRÁFICO EN R BASE                         #
#---------------------------------------------------------------#

# Argumentos frecuentes:
#   main -> título              xlab, ylab -> nombres de los ejes
#   col  -> color               xlim, ylim -> límites de los ejes
#   pch  -> símbolo del punto   lty, lwd   -> tipo y grosor de línea
#
# QUÉ GRÁFICO USAR:
#   Cualitativa               -> barras
#   Cuantitativa              -> histograma, densidad o boxplot
#   Cuantitativa por grupos   -> boxplots comparados
#   Dos cuantitativas         -> dispersión
#   Cuantitativa en el tiempo -> líneas

#---------------------------------------------------------------#
# 1. GRÁFICOS DE BARRAS                                         #
#---------------------------------------------------------------#

# Representan frecuencias o porcentajes de una variable cualitativa.

# EJEMPLO: automóviles según número de cilindros ----------------#
frecuencia_cilindros <- table(data$cyl)
frecuencia_cilindros

barplot(frecuencia_cilindros,
        main = "Automóviles según número de cilindros",
        xlab = "Número de cilindros",
        ylab = "Frecuencia",
        col = c("steelblue1", "steelblue3", "steelblue4"),
        border = "white")

porcentaje_cilindros <- prop.table(frecuencia_cilindros) * 100
barplot(porcentaje_cilindros,
        main = "Automóviles según número de cilindros",
        xlab = "Número de cilindros",
        ylab = "Porcentaje",
        col = "steelblue3",
        border = "white")

# EJERCICIO 1 --------------------------------------------------#
# a) Construye un gráfico de barras para la transmisión (am).
# b) Expresa la frecuencia como porcentaje.
# c) Agrega título, nombres de ejes y colores apropiados.
#--------------------------------------------------------------#


#---------------------------------------------------------------#
# 2. BARRAS AGRUPADAS Y APILADAS                                #
#---------------------------------------------------------------#

# Una tabla de contingencia permite comparar dos cualitativas.
tabla_cilindros_transmision <- table(data$cyl, data$am)
tabla_cilindros_transmision

# beside = TRUE ubica las barras lado a lado.
barplot(tabla_cilindros_transmision,
        beside = TRUE,
        main = "Cilindros según tipo de transmisión",
        xlab = "Tipo de transmisión",
        ylab = "Frecuencia",
        col = c("steelblue1", "steelblue3", "steelblue4"),
        border = "white",
        legend.text = rownames(tabla_cilindros_transmision),
        args.legend = list(title = "Cilindros", x = "topright"))

# beside = FALSE acumula los grupos.
barplot(tabla_cilindros_transmision,
        beside = FALSE,
        main = "Cilindros según tipo de transmisión",
        xlab = "Tipo de transmisión",
        ylab = "Frecuencia",
        col = c("steelblue1", "steelblue3", "steelblue4"),
        border = "white",
        legend.text = rownames(tabla_cilindros_transmision),
        args.legend = list(title = "Cilindros", x = "topright"))

# EJERCICIO 2 --------------------------------------------------#
# a) Invierte las variables en table(): transmisión por cilindros.
# b) Grafica la tabla con barras agrupadas y luego apiladas.
# c) ¿Qué versión facilita más la comparación entre grupos?
#--------------------------------------------------------------#


#---------------------------------------------------------------#
# 3. GRÁFICOS DE LÍNEAS                                         #
#---------------------------------------------------------------#

# Son apropiados para mostrar la evolución a través del tiempo.
economia <- as.data.frame(ggplot2::economics)
economia$date <- as.Date(economia$date)
str(economia)

# EJEMPLO: evolución de la población ---------------------------#
plot(economia$date, economia$pop,
     type = "l",
     main = "Evolución de la población en Estados Unidos",
     xlab = "Año",
     ylab = "Población (miles de personas)",
     col = "steelblue4",
     lwd = 2)

# Dos series con unidades distintas deben compararse en una escala común.
ahorro_z <- as.numeric(scale(economia$psavert))
desempleo_z <- as.numeric(scale(economia$uempmed))

plot(economia$date, ahorro_z,
     type = "l",
     main = "Ahorro personal y duración del desempleo",
     xlab = "Año",
     ylab = "Valor estandarizado",
     col = "firebrick3",
     lwd = 2,
     ylim = range(c(ahorro_z, desempleo_z), na.rm = TRUE))
lines(economia$date, desempleo_z,
      col = "steelblue4", lwd = 2, lty = 2)
abline(h = 0, col = "grey60", lty = 3)
legend("topright",
       legend = c("Ahorro personal", "Duración del desempleo"),
       col = c("firebrick3", "steelblue4"),
       lty = c(1, 2), lwd = 2, cex = 0.8, bty = "n")

# EJERCICIO 3 --------------------------------------------------#
# a) Grafica la evolución de la tasa de desempleo (unemploy).
# b) Agrega una línea horizontal en su promedio.
# c) Identifica períodos por encima del promedio.
#--------------------------------------------------------------#


#---------------------------------------------------------------#
# 4. BOXPLOTS: DISTRIBUCIONES ENTRE GRUPOS                       #
#---------------------------------------------------------------#

# Resume mediana, cuartiles, dispersión y posibles valores atípicos.
boxplot(mpg ~ factor(cyl),
        data = data,
        main = "Rendimiento según número de cilindros",
        xlab = "Número de cilindros",
        ylab = "Rendimiento (millas por galón)",
        col = c("steelblue1", "steelblue3", "steelblue4"),
        border = "grey30")

# EJERCICIO 4 --------------------------------------------------#
# a) Compara mpg según transmisión (am).
# b) ¿Qué grupo tiene una mediana más alta?
# c) ¿Cuál presenta mayor dispersión?
#--------------------------------------------------------------#


#---------------------------------------------------------------#
# 5. GRÁFICOS DE DISPERSIÓN                                     #
#---------------------------------------------------------------#

# Cada punto representa una observación de dos cuantitativas.
plot(data$wt, data$mpg,
     main = "Peso y rendimiento de combustible",
     xlab = "Peso (miles de libras)",
     ylab = "Rendimiento (millas por galón)",
     col = "steelblue4",
     pch = 19)

modelo_peso <- lm(mpg ~ wt, data = data)
abline(modelo_peso, col = "firebrick3", lwd = 2)
coef(modelo_peso)
cor(data$wt, data$mpg)

# EJERCICIO 5 --------------------------------------------------#
# a) Grafica la relación entre potencia (hp) y rendimiento (mpg).
# b) Agrega su recta de regresión.
# c) Describe la dirección y la intensidad de la relación.
#--------------------------------------------------------------#


#---------------------------------------------------------------#
# 6. DISPERSIÓN MULTIVARIADA                                    #
#---------------------------------------------------------------#

# pairs() explora varias relaciones cuantitativas en un solo paso.
pairs(data[c("mpg", "wt", "hp", "qsec")],
      main = "Relaciones entre características de los automóviles",
      col = "steelblue4",
      pch = 19)

# EJERCICIO 6 --------------------------------------------------#
# a) Construye una matriz con mpg, disp, drat y wt.
# b) Identifica el par con la relación lineal más clara.
# c) Comprueba tu apreciación mediante cor().
#--------------------------------------------------------------#


#---------------------------------------------------------------#
# 7. HISTOGRAMAS                                                #
#---------------------------------------------------------------#

# Las barras representan intervalos de una variable cuantitativa.
hist(data$mpg,
     breaks = 8,
     main = "Distribución del rendimiento de combustible",
     xlab = "Rendimiento (millas por galón)",
     ylab = "Frecuencia",
     col = "steelblue2",
     border = "white")
abline(v = mean(data$mpg), col = "firebrick3", lty = 2, lwd = 2)
abline(v = median(data$mpg), col = "darkgreen", lty = 3, lwd = 2)
legend("topright",
       legend = c("Media", "Mediana"),
       col = c("firebrick3", "darkgreen"),
       lty = c(2, 3), lwd = 2, bty = "n")

# EJERCICIO 7 --------------------------------------------------#
# a) Construye histogramas de wt con 5, 10 y 15 intervalos.
# b) Agrega líneas de media y mediana.
# c) ¿Cambia tu interpretación al modificar breaks?
#--------------------------------------------------------------#


#---------------------------------------------------------------#
# 8. CURVAS DE DENSIDAD                                         #
#---------------------------------------------------------------#

# Una densidad representa de forma suavizada la distribución.
densidad_mpg <- density(data$mpg)
plot(densidad_mpg,
     main = "Densidad del rendimiento de combustible",
     xlab = "Rendimiento (millas por galón)",
     ylab = "Densidad",
     col = "purple4",
     lwd = 2)
polygon(densidad_mpg,
        col = adjustcolor("mediumpurple2", alpha.f = 0.4),
        border = "purple4")

# Para superponerla a un histograma, usamos probability = TRUE.
hist(data$mpg,
     breaks = 8,
     probability = TRUE,
     main = "Histograma y densidad del rendimiento",
     xlab = "Rendimiento (millas por galón)",
     ylab = "Densidad",
     col = "grey85",
     border = "white")
lines(density(data$mpg), col = "purple4", lwd = 2)

# EJERCICIO 8 --------------------------------------------------#
# a) Grafica la densidad de la potencia (hp).
# b) Superponla a un histograma con probability = TRUE.
# c) Describe la forma: simétrica o asimétrica.
#--------------------------------------------------------------#


#---------------------------------------------------------------#
# 9. MÚLTIPLES GRÁFICOS CON par(mfrow)                          #
#---------------------------------------------------------------#

# Guardamos la configuración para restaurarla al final.
configuracion_original <- par(no.readonly = TRUE)
par(mfrow = c(1, 2))

plot(data$wt, data$mpg,
     main = "Peso y rendimiento",
     xlab = "Peso", ylab = "Rendimiento",
     col = "steelblue4", pch = 19)
hist(data$mpg,
     main = "Distribución del rendimiento",
     xlab = "Rendimiento",
     col = "steelblue2", border = "white")

par(configuracion_original)

# EJERCICIO 9 --------------------------------------------------#
# a) Crea un panel de 2 filas y 2 columnas.
# b) Incluye barras, boxplot, dispersión e histograma.
# c) Restaura la configuración gráfica al terminar.
#--------------------------------------------------------------#


#---------------------------------------------------------------#
# 10. EJERCICIO DE CIERRE: DATOS PAES                           #
#---------------------------------------------------------------#

# a) Importa la base:
#      paes <- rio::import("Datos/mineduc_paes.rds")
# b) Reemplaza por NA el valor 0 de las variables de puntaje.
# c) Selecciona PTJE_NEM, PTJE_RANKING, CLEC_REG_ACTUAL,
#    MATE1_REG_ACTUAL, MATE2_REG_ACTUAL, HCSOC_REG_ACTUAL y
#    CIEN_REG_ACTUAL.
# d) Construye una matriz de dispersión con pairs().
# e) Elige dos puntajes, grafica su relación y agrega una regresión.
# f) Describe la dirección, forma e intensidad de la relación.


#===============================================================#
# RESUMEN: ¿QUÉ GRÁFICO USAR?                                  #
#---------------------------------------------------------------#
# CUALITATIVA:                    barplot(table(x))
# CUANTITATIVA:                   hist(), density(), boxplot()
# CUALITATIVA x CUALITATIVA:      barplot(table(x, grupo))
# CUANTITATIVA x CUALITATIVA:     boxplot(y ~ grupo)
# CUANTITATIVA x CUANTITATIVA:    plot(x, y)
# TIEMPO:                         plot(fecha, valor, type = "l")
# VARIAS CUANTITATIVAS:           pairs()
#===============================================================#
