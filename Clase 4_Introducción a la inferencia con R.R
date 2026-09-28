#===============================================================#
#          CLASE 4: INTRODUCCIÓN A LA INFERENCIA CON R          #
#      Diplomado en Data Science para las Ciencias Sociales     #
#                  Exploración de Datos - UDP                   #
#===============================================================#

# OBJETIVO DE LA CLASE
# Comprender, mediante simulaciones, las ideas que permiten usar una
# muestra para aprender sobre una población:
#   1. Ley de los Grandes Números (LGN)
#   2. Teorema del Límite Central (TLC)
#   3. Error estándar e intervalos de confianza
#   4. Estimaciones con factores de expansión

# METODOLOGÍA: cada bloque incluye una explicación, una simulación
# reproducible y un ejercicio. Trabajaremos principalmente con R base.

#---------------------------------------------------------------#
# 0. PREPARACIÓN                                                #
#---------------------------------------------------------------#

if (!require("pacman")) install.packages("pacman")

pacman::p_load(
  rio,    # importar datos
  survey  # analizar encuestas complejas y ponderadas
)

# set.seed() permite obtener los mismos resultados aleatorios cada vez.
# Esto hace que una simulación sea reproducible.

#---------------------------------------------------------------#
# 1. POBLACIÓN, MUESTRA, PARÁMETRO Y ESTADÍSTICO                #
#---------------------------------------------------------------#

# POBLACIÓN: conjunto completo que queremos estudiar.
# MUESTRA: subconjunto observado de esa población.
# PARÁMETRO: característica numérica de la población, generalmente
#            desconocida (por ejemplo, la media poblacional mu).
# ESTADÍSTICO: característica calculada con una muestra y utilizada
#              para estimar el parámetro (por ejemplo, la media muestral).

# La inferencia estadística estudia cuánto puede variar el estadístico
# entre muestras y qué tan precisa es nuestra estimación del parámetro.

#---------------------------------------------------------------#
# 2. LEY DE LOS GRANDES NÚMEROS                                 #
#---------------------------------------------------------------#

# La LGN indica que, cuando repetimos muchas veces un experimento
# independiente, el promedio observado tiende a acercarse al valor
# esperado. No asegura una coincidencia exacta ni elimina el azar.

# EJEMPLO: lanzamientos de una moneda justa --------------------#
set.seed(123)
n_lanzamientos <- 10000

# Cara = 1, sello = 0. El valor esperado de cada lanzamiento es 0.5.
lanzamientos <- rbinom(n = n_lanzamientos, size = 1, prob = 0.5)
proporcion_acumulada <- cumsum(lanzamientos) / seq_len(n_lanzamientos)

plot(proporcion_acumulada,
     type = "l",
     main = "Proporción acumulada de caras",
     xlab = "Número de lanzamientos",
     ylab = "Proporción acumulada",
     col = "steelblue4",
     lwd = 2,
     ylim = c(0.35, 0.65))
abline(h = 0.5, col = "firebrick3", lwd = 2, lty = 2)
legend("topright",
       legend = c("Proporción observada", "Valor esperado: 0.5"),
       col = c("steelblue4", "firebrick3"),
       lty = c(1, 2), lwd = 2, bty = "n", cex = 0.8)

# Comparamos la proporción acumulada en distintos momentos.
momentos <- c(10, 100, 1000, 10000)
round(proporcion_acumulada[momentos], 3)

# FALACIA DEL APOSTADOR
# Después de varias caras consecutivas, la probabilidad de sello en el
# siguiente lanzamiento sigue siendo 0.5 si los lanzamientos son
# independientes. La LGN describe una tendencia de largo plazo, pero no
# afirma que el azar deba "compensarse" inmediatamente.

# EJERCICIO 1 --------------------------------------------------#
# a) Cambia la semilla y repite la simulación con 100 lanzamientos.
# b) Repite con 1000 y 100000 lanzamientos.
# c) ¿Qué cambia en la estabilidad de la proporción acumulada?
# d) Simula una moneda con probabilidad de cara igual a 0.7.
#--------------------------------------------------------------#


#---------------------------------------------------------------#
# 3. TEOREMA DEL LÍMITE CENTRAL                                 #
#---------------------------------------------------------------#

# El TLC estudia la distribución de un estadístico entre muchas muestras.
# Bajo condiciones generales, la distribución de las medias muestrales
# se aproxima a una normal cuando aumenta el tamaño de muestra, incluso
# si la población original no tiene forma normal.

# Creamos una población uniforme: todos los valores entre 70 y 100
# tienen la misma probabilidad. Su forma no es normal.
set.seed(1234)
poblacion <- runif(n = 100000, min = 70, max = 100)
media_poblacional <- mean(poblacion)
sd_poblacional <- sd(poblacion)

summary(poblacion)
media_poblacional
sd_poblacional

hist(poblacion,
     breaks = 30,
     main = "Distribución de la población",
     xlab = "Valor",
     ylab = "Frecuencia",
     col = "grey80",
     border = "white")
abline(v = media_poblacional, col = "firebrick3", lwd = 2)

# Tomamos 1000 muestras para cada tamaño y guardamos sus medias.
set.seed(4321)
n_repeticiones <- 1000

medias_10 <- replicate(
  n_repeticiones,
  mean(sample(poblacion, size = 10, replace = TRUE))
)
medias_50 <- replicate(
  n_repeticiones,
  mean(sample(poblacion, size = 50, replace = TRUE))
)
medias_100 <- replicate(
  n_repeticiones,
  mean(sample(poblacion, size = 100, replace = TRUE))
)

# Las tres distribuciones se concentran alrededor de la misma media.
round(c(poblacion = media_poblacional,
        n_10 = mean(medias_10),
        n_50 = mean(medias_50),
        n_100 = mean(medias_100)), 2)

# Comparamos sus formas usando los mismos límites del eje X.
limites_x <- range(c(medias_10, medias_50, medias_100))
configuracion_original <- par(no.readonly = TRUE)
par(mfrow = c(1, 3))

hist(medias_10, breaks = 25, xlim = limites_x,
     col = "orange", border = "white",
     main = "n = 10", xlab = "Media muestral")
abline(v = media_poblacional, col = "firebrick3", lwd = 2)

hist(medias_50, breaks = 25, xlim = limites_x,
     col = "lightblue", border = "white",
     main = "n = 50", xlab = "Media muestral")
abline(v = media_poblacional, col = "firebrick3", lwd = 2)

hist(medias_100, breaks = 25, xlim = limites_x,
     col = "lightgreen", border = "white",
     main = "n = 100", xlab = "Media muestral")
abline(v = media_poblacional, col = "firebrick3", lwd = 2)

par(configuracion_original)

# Al crecer n, la variabilidad de las medias disminuye.
sd_medias <- c(n_10 = sd(medias_10),
               n_50 = sd(medias_50),
               n_100 = sd(medias_100))
round(sd_medias, 3)

# El error estándar teórico de la media es sigma / raíz(n).
error_teorico <- sd_poblacional / sqrt(c(10, 50, 100))
round(error_teorico, 3)

# EJERCICIO 2 --------------------------------------------------#
# a) Repite la simulación con una población exponencial: rexp(100000).
# b) Compara las medias muestrales para n = 5, 30 y 100.
# c) ¿Cómo cambian la forma y la dispersión cuando aumenta n?
# d) Compara cada desviación observada con sigma / sqrt(n).
#--------------------------------------------------------------#


#---------------------------------------------------------------#
# 4. INTERVALOS DE CONFIANZA PARA UNA PROPORCIÓN                #
#---------------------------------------------------------------#

# Simulamos una población donde el 60% apoya una opción.
set.seed(123)
poblacion_apoyo <- rbinom(n = 12000, size = 1, prob = 0.6)
parametro <- mean(poblacion_apoyo)
parametro

# En una variable 0/1, la media es igual a la proporción de valores 1.
set.seed(175)
muestra <- sample(poblacion_apoyo, size = 75, replace = FALSE)
estimacion <- mean(muestra)
estimacion

# Intervalo aproximado del 95% para una proporción.
n <- length(muestra)
p <- mean(muestra)
q <- 1 - p
z <- qnorm(1 - 0.05 / 2)
error_estandar <- sqrt(p * q / n)
margen_error <- z * error_estandar
intervalo_95 <- c(inferior = p - margen_error,
                  superior = p + margen_error)
round(intervalo_95, 3)

# La función permite cambiar la muestra y el nivel de confianza.
ic_proporcion <- function(x, confianza = 0.95) {
  n <- length(x)
  p <- mean(x)
  alfa <- 1 - confianza
  z <- qnorm(1 - alfa / 2)
  error_estandar <- sqrt(p * (1 - p) / n)
  c(inferior = p - z * error_estandar,
    superior = p + z * error_estandar)
}

ic_proporcion(muestra, confianza = 0.95)

# COBERTURA: repetimos el procedimiento 1000 veces.
set.seed(2026)
n_repeticiones <- 1000
intervalos <- replicate(n_repeticiones, {
  nueva_muestra <- sample(poblacion_apoyo, size = 75)
  ic_proporcion(nueva_muestra, confianza = 0.95)
})

# Cada columna contiene los límites de un intervalo.
cubre_parametro <- intervalos["inferior", ] <= parametro &
                   intervalos["superior", ] >= parametro
mean(cubre_parametro)

# La confianza del 95% describe el procedimiento: al repetirlo muchas
# veces, cerca del 95% de los intervalos construidos contiene el parámetro.
# No significa que un intervalo ya calculado tenga 95% de probabilidad
# de contenerlo bajo la interpretación frecuentista.

# EJERCICIO 3 --------------------------------------------------#
# a) Repite la simulación con confianza de 90% y 99%.
# b) Calcula la cobertura observada en cada caso.
# c) Compara la amplitud promedio de los intervalos.
# d) Explica el intercambio entre confianza y precisión.
#--------------------------------------------------------------#


#---------------------------------------------------------------#
# 5. FACTORES DE EXPANSIÓN Y ENCUESTAS COMPLEJAS                #
#---------------------------------------------------------------#

# En una encuesta, las observaciones pueden representar cantidades
# distintas de personas. El ponderador o factor de expansión indica
# cuánto aporta cada caso a una estimación poblacional.

data <- rio::import(
  "https://github.com/JoseRTM/AED_UDP/raw/refs/heads/main/jovenes.rds"
)

str(data[c("CONGLOMERADO", "ESTRATO", "PONDERADOR", "SEXO", "P82")])

# Declaramos el diseño de la encuesta:
#   ids     -> conglomerados de selección
#   strata  -> estratos del diseño
#   weights -> factores de expansión
diseno <- svydesign(ids = ~CONGLOMERADO,
                    strata = ~ESTRATO,
                    weights = ~PONDERADOR,
                    data = data,
                    nest = TRUE)

# MEDIA SIN Y CON PONDERACIÓN
mean(data$P82, na.rm = TRUE)
media_ponderada <- svymean(~P82, design = diseno, na.rm = TRUE)
media_ponderada
confint(media_ponderada)

# PROPORCIONES SIN Y CON PONDERACIÓN
prop.table(table(data$SEXO))
prop.table(svytable(~SEXO, design = diseno))

proporciones_ponderadas <- svymean(~factor(SEXO),
                                   design = diseno,
                                   na.rm = TRUE)
proporciones_ponderadas
confint(proporciones_ponderadas)

# EJERCICIO 4 --------------------------------------------------#
# a) Compara la distribución de SEXO sin ponderar y ponderada.
# b) Compara la media simple y ponderada de P82.
# c) Interpreta el intervalo de confianza de la media ponderada.
# d) Explica por qué ignorar el diseño puede cambiar la conclusión.
#--------------------------------------------------------------#


#===============================================================#
# RESUMEN DE LA CLASE                                           #
#---------------------------------------------------------------#
# LEY DE LOS GRANDES NÚMEROS:
#   El promedio observado se estabiliza cerca del valor esperado cuando
#   aumenta el número de observaciones independientes.
#
# TEOREMA DEL LÍMITE CENTRAL:
#   La distribución de las medias muestrales se aproxima a una normal
#   y su error estándar disminuye en proporción a 1 / sqrt(n).
#
# INTERVALO DE CONFIANZA:
#   Combina estimación y margen de error. Su nivel de confianza describe
#   la cobertura del procedimiento bajo muestreo repetido.
#
# FACTOR DE EXPANSIÓN:
#   Permite que cada caso contribuya según la cantidad de personas de la
#   población que representa dentro del diseño muestral.
#===============================================================#
