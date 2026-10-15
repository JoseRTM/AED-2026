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
  "Datos/welfare.dta"
)

# Centramos las variables para que el intercepto y los efectos principales
# tengan una referencia interpretable. Expresamos PIB en miles de unidades.
data$educ_s <- as.numeric(scale(data$educ_expend))
data$gdp_s <- as.numeric(scale(data$gdp))


#---------------------------------------------------------------#
# 1. INTERACCIONES                                              #
#---------------------------------------------------------------#

# Una interacción permite que la pendiente de X cambie según Z.
# Y = beta_0 + beta_1 X + beta_2 Z + beta_3 XZ + error

modelo_aditivo <- lm(gini_slc ~ educ_s + gdp_s, data = data)
modelo_interaccion <- lm(gini_slc ~ educ_s * gdp_s, data = data)

summary(modelo_interaccion)
anova(modelo_aditivo, modelo_interaccion)

# beta_1 representa el efecto de educ_s cuando gdp_s = a su media, es decir, en el
# PIB promedio. beta_3 indica cuánto cambia esa pendiente por cada unidad
# adicional de gdp_s.

# Es decir, la interacción negativa y estadísticamente significativa entre educación y PIB (β = −1.70; p = 0.002) 
# indica que la relación entre gasto educativo y desigualdad depende del nivel de desarrollo económico.
# En países con un PIB relativamente bajo (una desviación estándar bajo la media), 
# un mayor gasto educativo se asocia con una mayor desigualdad de ingresos. 
# Concretamente, un incremento de una desviación estándar en educación se relaciona 
# con un aumento estimado de 3.32 puntos en el índice de Gini.
# En cambio, en países con un PIB relativamente alto (una desviación estándar sobre la media), 
# esta asociación prácticamente desaparece, alcanzando una pendiente estimada de −0.09 puntos.


#En un modelo de regresión con interacción, el efecto de una variable independiente 
# depende del valor de la otra. Como las variables fueron estandarizadas mediante scale(), 
# el valor 0 representa la media, −1 una desviación estándar bajo la media y +1 
# una desviación estándar sobre ella. Para interpretar la interacción, calculamos 
# la pendiente de educación como β₁ + β₃ × PIB. Por ejemplo, cuando el PIB es −1, 
# la pendiente de educación es 1.6154 − 1.7013 × (−1) = 3.32. 
# Esto significa que, en países con un PIB una desviación estándar bajo la media, 
# un aumento de una desviación estándar en educación se asocia con un incremento 
# estimado de 3.32 puntos en el índice de Gini.

# Predicciones para tres niveles de PIB
niveles_gdp <- quantile(data$gdp_s, c(0.25, 0.50, 0.75), na.rm = TRUE)

rejilla <- expand.grid(
  educ_s = seq(min(data$educ_s, na.rm = TRUE),
               max(data$educ_s, na.rm = TRUE), length.out = 60),
  gdp_s = as.numeric(niveles_gdp)
)

pred <- predict(modelo_interaccion, newdata = rejilla,
                interval = "confidence")
rejilla <- cbind(rejilla, pred)

colores <- c("#2867E8", "#D94DBB", "#16A078")
plot(range(rejilla$educ_s), range(rejilla$lwr, rejilla$upr),
     type = "n", xlab = "Gasto en educación centrado",
     ylab = "Gini predicho", main = "Interacción entre gasto y PIB")

for (i in seq_along(niveles_gdp)) {
  bloque <- rejilla$gdp_s == niveles_gdp[i]
  lines(rejilla$educ_s[bloque], rejilla$fit[bloque],
        col = colores[i], lwd = 2)
}

legend("topleft", legend = c("PIB bajo", "PIB medio", "PIB alto"),
       col = colores, lwd = 2, bty = "n", cex = 0.7)

#---------------------------------------------------------------#
# 2. TRANSFORMACIONES                                           #
#---------------------------------------------------------------#

# A. TÉRMINO CUADRÁTICO: la pendiente cambia a lo largo de X.
modelo_cuadratico <- lm(gini_slc ~ educ_s + I(educ_s^2) + gdp_s,
                        data = data)
summary(modelo_cuadratico)

# El modelo cuadrático permite evaluar si la asociación entre gasto educativo y 
# desigualdad de ingresos presenta un comportamiento no lineal. 
# Se puede ver un coeficiente lineal positivo (β = 2.02; p < 0.001) 
# y un coeficiente cuadrático negativo (β = −0.75; p = 0.010). 
# Esto significa que existe una relación de U invertida. 
# En palabras sencillas, un mayor gasto educativo se asocia con un aumento de la desigualdad, 
# pero esta asociación disminuye progresivamente conforme aumenta el gasto. 


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


