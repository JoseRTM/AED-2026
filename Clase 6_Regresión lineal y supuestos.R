#===============================================================#
#          CLASE 6: REGRESIÓN LINEAL Y SUPUESTOS               #
#===============================================================#

# OBJETIVOS
# 1. Ajustar modelos de regresión lineal simple y múltiple.
# 2. Interpretar intercepto, pendientes, R2 e intervalos de confianza.
# 3. Obtener predicciones para valores definidos de las variables.
# 4. Examinar linealidad, varianza constante, normalidad e influencia.
# 5. Reconocer que los diagnósticos informan decisiones, no reglas mecánicas.

#---------------------------------------------------------------#
# 0. PREPARACIÓN                                                #
#---------------------------------------------------------------#

if (!require("pacman")) install.packages("pacman")

pacman::p_load(
  rio,
  skimr,
  car,
  lmtest,
  texreg
)

data <- rio::import(
  "https://github.com/JoseRTM/AED_UDP/raw/refs/heads/main/welfare.dta"
)

skimr::skim(data)

# En esta clase modelaremos el índice de Gini a partir del gasto público
# en educación y el PIB. Antes de ajustar un modelo, revisamos las variables.
summary(data[c("gini_slc", "educ_expend", "gdp")])

plot(data$educ_expend, data$gini_slc,
     xlab = "Gasto en educación (% del PIB)",
     ylab = "Índice de Gini",
     main = "Gasto en educación y desigualdad",
     pch = 19, col = adjustcolor("steelblue4", alpha.f = 0.6))

#---------------------------------------------------------------#
# 1. REGRESIÓN LINEAL SIMPLE                                    #
#---------------------------------------------------------------#

# Modelo: Y_i = beta_0 + beta_1 X_i + error_i
#
# beta_0: valor esperado de Y cuando X = 0.
# beta_1: cambio esperado en Y asociado a una unidad adicional de X.

modelo_simple <- lm(gini_slc ~ educ_expend, data = data)
summary(modelo_simple)
confint(modelo_simple)

abline(modelo_simple, col = "firebrick3", lwd = 2)

# Valores observados, ajustados y residuos
head(data.frame(
  observado = data$gini_slc,
  ajustado = fitted(modelo_simple),
  residuo = residuals(modelo_simple)
))

# R2 expresa la proporción de variación observada en Y que el modelo explica
# dentro de la muestra. Un R2 alto no prueba causalidad ni buen ajuste causal.
summary(modelo_simple)$r.squared

#---------------------------------------------------------------#
# 2. REGRESIÓN LINEAL MÚLTIPLE                                  #
#---------------------------------------------------------------#

# Agregamos PIB. Cada pendiente se interpreta manteniendo constantes las
# demás variables incluidas en el modelo.

modelo_multiple <- lm(gini_slc ~ educ_expend + gdp, data = data)
summary(modelo_multiple)
confint(modelo_multiple)

texreg::screenreg(
  list(modelo_simple, modelo_multiple),
  custom.model.names = c("Simple", "Múltiple"),
  custom.coef.names = c("Constante", "Gasto en educación", "PIB"),
  include.ci = TRUE
)

# Comparación formal entre modelos anidados
anova(modelo_simple, modelo_multiple)

#---------------------------------------------------------------#
# 3. PREDICCIONES                                               #
#---------------------------------------------------------------#

nuevos_casos <- data.frame(
  educ_expend = c(3, 5, 7),
  gdp = median(data$gdp, na.rm = TRUE)
)

predict(modelo_multiple,
        newdata = nuevos_casos,
        interval = "confidence",
        level = 0.95)

# interval = "confidence" estima la media esperada para casos con esos X.
# interval = "prediction" incorpora además la variabilidad individual.
predict(modelo_multiple,
        newdata = nuevos_casos,
        interval = "prediction",
        level = 0.95)

#---------------------------------------------------------------#
# 4. SUPUESTOS Y DIAGNÓSTICOS                                   #
#---------------------------------------------------------------#

# A. LINEALIDAD Y FORMA FUNCIONAL
plot(fitted(modelo_multiple), residuals(modelo_multiple),
     xlab = "Valores ajustados", ylab = "Residuos",
     main = "Residuos y valores ajustados",
     pch = 19, col = adjustcolor("steelblue4", alpha.f = 0.6))
abline(h = 0, col = "firebrick3", lwd = 2)

# B. VARIANZA CONSTANTE
# H0 del test de Breusch-Pagan: homocedasticidad.
lmtest::bptest(modelo_multiple)

# C. NORMALIDAD APROXIMADA DE LOS RESIDUOS
# Importa principalmente para inferencia en muestras pequeñas.
qqnorm(residuals(modelo_multiple), main = "Q-Q de residuos")
qqline(residuals(modelo_multiple), col = "firebrick3", lwd = 2)

# D. MULTICOLINEALIDAD
car::vif(modelo_multiple)

# E. OBSERVACIONES INFLUYENTES
plot(cooks.distance(modelo_multiple), type = "h",
     xlab = "Observación", ylab = "Distancia de Cook",
     main = "Influencia de las observaciones")
abline(h = 4 / nobs(modelo_multiple), col = "firebrick3", lty = 2)

# Panel estándar de diagnóstico
configuracion_original <- par(no.readonly = TRUE)
par(mfrow = c(2, 2))
plot(modelo_multiple)
par(configuracion_original)

# Los diagnósticos deben interpretarse junto con el diseño, el tamaño de la
# muestra y el objetivo. La clase 7 abordará interacciones, transformaciones
# y errores estándar robustos frente a heterocedasticidad.

#---------------------------------------------------------------#
# 5. EJERCICIO                                                  #
#---------------------------------------------------------------#

# 1. Ajusta un modelo para gini_slc usando educ_expend, gdp y unemployment.
# 2. Interpreta la pendiente de educ_expend y su IC95%.
# 3. Compara R2 y R2 ajustado con el modelo_multiple.
# 4. Examina residuos, Q-Q, VIF y distancia de Cook.
# 5. Escribe dos conclusiones: una estadística y otra sustantiva.

