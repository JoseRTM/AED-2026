#===============================================================#
#    GUÍA DE EJERCICIOS - ESTADÍSTICA DESCRIPTIVA (RESUELTA)    #
#      Diplomado en Data Science para las Ciencias Sociales     #
#                  Exploración de Datos - UDP                   #
#===============================================================#

# 1) CARGAR LIBRERÍAS (con pacman, como en clase)
if (!require("pacman")) install.packages("pacman")
pacman::p_load(rio, psych, moments, epiDisplay)

# 2) IMPORTAR LA BASE DE DATOS mineduc_paes
data <- rio::import("https://github.com/JoseRTM/AED_UDP/raw/refs/heads/main/mineduc_paes.rds")

# 3) LIMPIAR LOS CÓDIGOS PERDIDOS
# Reutilizamos la función de la clase para no repetir código.
a_na <- function(x, codigos) { x[x %in% codigos] <- NA; x }

puntajes <- c("PTJE_NEM", "PTJE_RANKING", "CLEC_REG_ACTUAL",
              "MATE1_REG_ACTUAL", "MATE2_REG_ACTUAL",
              "HCSOC_REG_ACTUAL", "CIEN_REG_ACTUAL")
# En los puntajes, el 0 = "no rindió" -> NA
for (v in puntajes) data[[v]] <- a_na(data[[v]], 0)
# En el decil de ingreso, el 99 = "sin información" -> NA
data$INGRESO_PERCAPITA_GRUPO_FA <- a_na(data$INGRESO_PERCAPITA_GRUPO_FA, 99)

#---------------------------------------------------------------#
# 1) La distribución de puntajes del NEM es simétrica.  --> ~VERDADERO
describe(data$PTJE_NEM)
skewness(data$PTJE_NEM, na.rm = TRUE)   # ≈ -0.19 (muy leve, casi 0)
mean(data$PTJE_NEM, na.rm = TRUE)       # ≈ 698.8
median(data$PTJE_NEM, na.rm = TRUE)     # ≈ 700
hist(data$PTJE_NEM, main = "Distribución NEM", xlab = "Puntaje NEM")
# JUSTIFICACIÓN: el sesgo es casi nulo (-0.19) y la media ≈ mediana,
# por lo que la distribución es aproximadamente simétrica (con una
# levísima cola hacia la izquierda).

#---------------------------------------------------------------#
# 2) Matemática 1 > Competencia Lectora (en promedio).  --> VERDADERO (leve)
mean(data$MATE1_REG_ACTUAL, na.rm = TRUE)   # ≈ 603.5
mean(data$CLEC_REG_ACTUAL,  na.rm = TRUE)   # ≈ 598.9
# JUSTIFICACIÓN: la media de Matemática 1 supera a la de Comprensión
# Lectora, aunque la diferencia es pequeña (~5 puntos).

#---------------------------------------------------------------#
# 3) El décimo decil supera a los inferiores en TODAS las pruebas.
#    --> VERDADERO respecto al máximo, pero el aumento NO es monótono.
tapply(data$CLEC_REG_ACTUAL,  data$INGRESO_PERCAPITA_GRUPO_FA, mean, na.rm = TRUE)
tapply(data$MATE1_REG_ACTUAL, data$INGRESO_PERCAPITA_GRUPO_FA, mean, na.rm = TRUE)
tapply(data$MATE2_REG_ACTUAL, data$INGRESO_PERCAPITA_GRUPO_FA, mean, na.rm = TRUE)
tapply(data$HCSOC_REG_ACTUAL, data$INGRESO_PERCAPITA_GRUPO_FA, mean, na.rm = TRUE)
tapply(data$CIEN_REG_ACTUAL,  data$INGRESO_PERCAPITA_GRUPO_FA, mean, na.rm = TRUE)
# JUSTIFICACIÓN: en todas las pruebas el decil 10 tiene el promedio más
# alto, así que la afirmación es verdadera. Pero atención: el ascenso no
# es perfectamente monótono (hay una leve caída en los deciles medios),
# lo que muestra que la relación ingreso-puntaje no es estrictamente lineal.

#---------------------------------------------------------------#
# 4) Los puntajes de matemáticas están sesgados a la derecha. --> VERDADERO
skewness(data$MATE1_REG_ACTUAL, na.rm = TRUE)   # ≈ 0.92 (positivo)
skewness(data$MATE2_REG_ACTUAL, na.rm = TRUE)   # ≈ 1.58 (positivo)
hist(data$MATE2_REG_ACTUAL, main = "Distribución Matemática 2",
     xlab = "Puntaje MATE2")
# JUSTIFICACIÓN: ambos sesgos son positivos (cola hacia la derecha).
# MATE2 es aún más asimétrica que MATE1.

#---------------------------------------------------------------#
# 5) El NEM tiene mayor dispersión relativa que las PAES. --> FALSO
cv <- function(x) sd(x, na.rm = TRUE) / mean(x, na.rm = TRUE) * 100
cvs <- c(NEM   = cv(data$PTJE_NEM),
         CLEC  = cv(data$CLEC_REG_ACTUAL),
         MATE1 = cv(data$MATE1_REG_ACTUAL),
         MATE2 = cv(data$MATE2_REG_ACTUAL),
         HSOC  = cv(data$HCSOC_REG_ACTUAL),
         CIEN  = cv(data$CIEN_REG_ACTUAL))
round(cvs, 2)
# JUSTIFICACIÓN: el CV del NEM (~21.7%) es de los MÁS BAJOS. La prueba
# con mayor dispersión relativa es Matemática 2 (~27.5%). Por lo tanto,
# es falso que el NEM sea el de mayor dispersión relativa.

#---------------------------------------------------------------#
# 6) Tabla de frecuencias del decil de ingreso (en %)
round(prop.table(table(data$INGRESO_PERCAPITA_GRUPO_FA)) * 100, 1)
tab1(data$INGRESO_PERCAPITA_GRUPO_FA)
# El primer decil (1) concentra la mayor cantidad de estudiantes.

#---------------------------------------------------------------#
# 7) Deciles de Competencia Lectora
quantile(data$CLEC_REG_ACTUAL, probs = seq(0.1, 0.9, by = 0.1), na.rm = TRUE)
# El noveno decil (percentil 90) separa al 10% de mejor rendimiento
# del resto: los estudiantes por sobre ese puntaje están en el 10% superior.

#===============================================================#
