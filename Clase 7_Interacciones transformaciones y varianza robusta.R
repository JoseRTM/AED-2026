#===============================================================#
#  CLASE 7: INTERACCIONES, TRANSFORMACIONES Y VARIANZA ROBUSTA  #
#===============================================================#

# OBJETIVOS
# 1. Modelar relaciones cuyo efecto depende de otra variable.
# 2. Interpretar interacciones mediante predicciones y gráficos.
# 3. Usar transformaciones para representar relaciones no lineales.
# 4. Estimar errores estándar robustos frente a heterocedasticidad.
# 5. Distinguir cambios en la especificación de cambios en la inferencia.

#---------------------------------------------------------------#
# 0. PREPARACIÓN                                                #
#---------------------------------------------------------------#

if (!require("pacman")) install.packages("pacman")

pacman::p_load(
  rio,
  skimr,
  lmtest,
  sandwich,
  texreg
)

data <- rio::import(
  "https://github.com/JoseRTM/AED_UDP/raw/refs/heads/main/welfare.dta"
)

# Centramos las variables para que el intercepto y los efectos principales
# tengan una referencia interpretable. Expresamos PIB en miles de unidades.
data$educ_c <- data$educ_expend - mean(data$educ_expend, na.rm = TRUE)
data$gdp_miles <- data$gdp / 1000
data$gdp_c <- data$gdp_miles - mean(data$gdp_miles, na.rm = TRUE)

#---------------------------------------------------------------#
# 1. INTERACCIONES                                              #
#---------------------------------------------------------------#

# Una interacción permite que la pendiente de X cambie según Z.
# Y = beta_0 + beta_1 X + beta_2 Z + beta_3 XZ + error

modelo_aditivo <- lm(gini_slc ~ educ_c + gdp_c, data = data)
modelo_interaccion <- lm(gini_slc ~ educ_c * gdp_c, data = data)

summary(modelo_interaccion)
anova(modelo_aditivo, modelo_interaccion)

# beta_1 representa el efecto de educ_c cuando gdp_c = 0, es decir, en el
# PIB promedio. beta_3 indica cuánto cambia esa pendiente por cada unidad
# adicional de gdp_c.

# Predicciones para tres niveles de PIB
niveles_gdp <- quantile(data$gdp_c, c(0.25, 0.50, 0.75), na.rm = TRUE)

rejilla <- expand.grid(
  educ_c = seq(min(data$educ_c, na.rm = TRUE),
               max(data$educ_c, na.rm = TRUE), length.out = 60),
  gdp_c = as.numeric(niveles_gdp)
)

pred <- predict(modelo_interaccion, newdata = rejilla,
                interval = "confidence")
rejilla <- cbind(rejilla, pred)

colores <- c("#2867E8", "#D94DBB", "#16A078")
plot(range(rejilla$educ_c), range(rejilla$lwr, rejilla$upr),
     type = "n", xlab = "Gasto en educación centrado",
     ylab = "Gini predicho", main = "Interacción entre gasto y PIB")

for (i in seq_along(niveles_gdp)) {
  bloque <- rejilla$gdp_c == niveles_gdp[i]
  lines(rejilla$educ_c[bloque], rejilla$fit[bloque],
        col = colores[i], lwd = 2)
}

legend("topright", legend = c("PIB bajo", "PIB medio", "PIB alto"),
       col = colores, lwd = 2, bty = "n")

#---------------------------------------------------------------#
# 2. TRANSFORMACIONES                                           #
#---------------------------------------------------------------#

# A. TÉRMINO CUADRÁTICO: la pendiente cambia a lo largo de X.
modelo_cuadratico <- lm(gini_slc ~ educ_c + I(educ_c^2) + gdp_c,
                        data = data)
summary(modelo_cuadratico)

# B. LOGARITMO: útil para variables positivas con gran asimetría.
modelo_log_gdp <- lm(gini_slc ~ educ_expend + log(gdp), data = data)
summary(modelo_log_gdp)

# En un modelo nivel-log, beta_log(gdp) aproxima el cambio en Y asociado a
# un aumento de 1% en GDP dividido por 100. La interpretación siempre debe
# corresponder a la escala usada en el modelo.

texreg::screenreg(
  list(modelo_aditivo, modelo_interaccion,
       modelo_cuadratico, modelo_log_gdp),
  custom.model.names = c("Aditivo", "Interacción", "Cuadrático", "Log PIB")
)

# Comparación gráfica de forma lineal y cuadrática
plot(data$educ_c, data$gini_slc,
     xlab = "Gasto en educación centrado", ylab = "Índice de Gini",
     main = "Forma funcional", pch = 19,
     col = adjustcolor("grey30", alpha.f = 0.5))

orden <- order(data$educ_c)
lines(data$educ_c[orden], fitted(modelo_aditivo)[orden],
      col = "#2867E8", lwd = 2)
lines(data$educ_c[orden], fitted(modelo_cuadratico)[orden],
      col = "#D94DBB", lwd = 2)

#---------------------------------------------------------------#
# 3. ESTIMACIÓN ROBUSTA DE LA VARIANZA                          #
#---------------------------------------------------------------#

# La heterocedasticidad no cambia los coeficientes OLS, pero puede sesgar
# sus errores estándar convencionales. HC3 suele ser una opción prudente
# en muestras pequeñas o moderadas.

lmtest::bptest(modelo_interaccion)

vcov_hc3 <- sandwich::vcovHC(modelo_interaccion, type = "HC3")
resultado_hc3 <- lmtest::coeftest(modelo_interaccion, vcov. = vcov_hc3)
resultado_hc3

# Intervalos robustos
lmtest::coefci(modelo_interaccion, vcov. = vcov_hc3)

# Comparación: los coeficientes son iguales, cambian SE, pruebas e IC.
resultado_convencional <- lmtest::coeftest(modelo_interaccion)
cbind(
  beta = coef(modelo_interaccion),
  SE_convencional = resultado_convencional[, "Std. Error"],
  SE_HC3 = resultado_hc3[, "Std. Error"]
)

# Los errores robustos corrigen la inferencia frente a heterocedasticidad.
# No corrigen no linealidad, variables omitidas, dependencia entre casos,
# errores de medición ni una interpretación causal injustificada.

#---------------------------------------------------------------#
# 4. EJERCICIO                                                  #
#---------------------------------------------------------------#

# 1. Ajusta una interacción entre educ_expend y unemployment.
# 2. Centra ambas variables y explica los efectos principales.
# 3. Grafica predicciones para desempleo bajo, medio y alto.
# 4. Compara una especificación lineal con una cuadrática.
# 5. Reporta resultados con errores estándar convencionales y HC3.
# 6. Explica qué problema resuelve HC3 y qué problemas quedan pendientes.

