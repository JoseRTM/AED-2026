#===============================================================#
#                CLASE 5: TEST DE HIPÓTESIS CON R               #
#      Diplomado en Data Science para las Ciencias Sociales     #
#                  Exploración de Datos - UDP                   #
#===============================================================#

# OBJETIVO DE LA CLASE
# Utilizar test de hipótesis para evaluar evidencia muestral:
#   1. Formular hipótesis nula y alternativa
#   2. Interpretar el valor p y el nivel de significancia
#   3. Reconocer errores tipo I y tipo II
#   4. Comparar una o dos proporciones
#   5. Comparar una, dos o más medias
#   6. Evaluar la correlación entre dos variables cuantitativas

# METODOLOGÍA: cada bloque incluye una explicación, un ejemplo y un
# ejercicio. La interpretación sustantiva es tan importante como el código.

#---------------------------------------------------------------#
# 0. PREPARACIÓN                                                #
#---------------------------------------------------------------#

if (!require("pacman")) install.packages("pacman")

pacman::p_load(
  rio,   # importar datos
  psych  # descriptivos y matriz gráfica de correlaciones
)

#---------------------------------------------------------------#
# 1. LÓGICA DE UN TEST DE HIPÓTESIS                             #
#---------------------------------------------------------------#

# Un test contrasta dos afirmaciones:
#
# H0: HIPÓTESIS NULA
#     Representa ausencia de diferencia, cambio o asociación.
#
# H1: HIPÓTESIS ALTERNATIVA
#     Representa el patrón que queremos evaluar.
#
# El test pregunta: si H0 fuera cierta, ¿qué tan probable sería observar
# un resultado tan extremo como el de nuestra muestra?

# NIVEL DE SIGNIFICANCIA (alfa)
alfa <- 0.05

# Regla de decisión habitual:
#   valor p < alfa  -> rechazamos H0
#   valor p >= alfa -> no rechazamos H0
#
# ATENCIÓN: "no rechazar H0" no significa demostrar que H0 es verdadera.
# Significa que la muestra no aporta evidencia suficiente para rechazarla.

# VALOR P
# Es la probabilidad de observar un resultado tan extremo o más que el
# obtenido, suponiendo que H0 es cierta. No es la probabilidad de que H0
# sea verdadera y tampoco mide el tamaño o la importancia de un efecto.
# SURPRISE VALUE O VALOR S
# El valor S expresa la evidencia en bits de sorpresa bajo H0:
#
#                  S = -log2(valor p)
#
# Un S mayor indica que los datos resultan más sorprendentes bajo H0.
# El valor S no es la probabilidad de que H0 sea falsa ni mide el efecto.

# ERRORES POSIBLES
# Error tipo I: rechazamos H0 cuando en realidad es verdadera.
# Error tipo II: no rechazamos H0 cuando en realidad es falsa.

# EJEMPLO INICIAL: ¿LA MONEDA ESTÁ CARGADA? --------------------#
# Una persona afirma que su moneda es equilibrada. La lanzamos 10 veces y
# obtenemos 8 caras. ¿Es un resultado suficientemente raro como para dudar?
#
# H0: p_cara = 0.50  (moneda equilibrada)
# H1: p_cara > 0.50  (moneda cargada hacia cara)

moneda <- binom.test(x = 8,
                     n = 10,
                     p = 0.50,
                     alternative = "greater")
moneda
moneda$p.value  # P(X >= 8 | H0) = 0.0546875
S_moneda <- -log2(moneda$p.value)
S_moneda         # aproximadamente 4.19 bits de sorpresa bajo H0

# Con alfa = 0.05, el resultado queda apenas por encima del umbral.
# No rechazamos H0, pero tampoco demostramos que la moneda sea equilibrada:
# con solo 10 lanzamientos, la evidencia todavía es insuficiente.

#---------------------------------------------------------------#
# 2. UNA PROPORCIÓN                                             #
#---------------------------------------------------------------#

# PREGUNTA
# Un estudio de mercado anterior estimó que al 30% de la población adulta
# le gustaba el helado Centella. Tras una nueva campaña, la empresa encuesta
# una muestra aleatoria simple de 50 personas adultas: 22 lo prefieren.
# La proporción observada es 22/50 = 0.44, es decir, 14 puntos porcentuales
# sobre el valor histórico. ¿Es evidencia de un aumento o variación muestral?

# H0: p = 0.30
# H1: p > 0.30

centella_una_cola <- prop.test(x = 22,
                               n = 50,
                               p = 0.30,
                               alternative = "greater",
                               correct = TRUE)
centella_una_cola

proporcion_centella <- 22 / 50
diferencia_centella <- proporcion_centella - 0.30
proporcion_centella  # 0.44
diferencia_centella  # aumento observado de 0.14

# Elementos principales del resultado:
centella_una_cola$estimate    # proporción observada: 22/50
centella_una_cola$p.value     # evidencia contra H0
centella_una_cola$conf.int    # intervalo unilateral

# Decisión automática para alfa = 0.05
if (centella_una_cola$p.value < alfa) {
  print("Rechazamos H0")
} else {
  print("No rechazamos H0")
}

# Si la pregunta fuera solamente si la proporción CAMBIÓ, sin anticipar
# la dirección, corresponde una prueba bilateral:
# H0: p = 0.30
# H1: p != 0.30
centella_dos_colas <- prop.test(x = 22,
                                n = 50,
                                p = 0.30,
                                alternative = "two.sided",
                                correct = TRUE)
centella_dos_colas

# PRUEBA EXACTA BINOMIAL
# Para muestras pequeñas o recuentos extremos, binom.test() evita la
# aproximación asintótica utilizada por prop.test().
binom.test(x = 22, n = 50, p = 0.30, alternative = "greater")

# La prueba exacta entrega p aproximadamente 0.025. Bajo H0, la probabilidad
# de observar 22 o más preferencias en una muestra de 50 es cercana al 2.5%.
# Con alfa = 0.05 rechazamos H0. Esto apoya un aumento respecto de 30%, pero
# no demuestra que la campaña lo haya causado: eso depende del diseño.

centella_exacto <- binom.test(x = 22,
                              n = 50,
                              p = 0.30,
                              alternative = "greater")
S_centella <- -log2(centella_exacto$p.value)
S_centella  # aproximadamente 5.32 bits de sorpresa bajo H0

# Regla intuitiva: aumentar S en 1 bit equivale a reducir el valor p a la
# mitad. Por ejemplo, p = 0.05 corresponde a S = 4.32 bits.

# EJERCICIO 1 --------------------------------------------------#
# En una encuesta, 37 de 80 personas apoyan una política. El apoyo
# histórico es 35%.
# a) Formula H0 y H1 para evaluar si el apoyo aumentó.
# b) Realiza el test unilateral con prop.test().
# c) Compara el resultado con binom.test().
# d) Redacta una conclusión para alfa = 0.05.
#--------------------------------------------------------------#


#---------------------------------------------------------------#
# 3. DOS PROPORCIONES                                           #
#---------------------------------------------------------------#

# Un estudio asignó 200 pacientes al grupo control y 200 al grupo
# experimental. Presentaron náuseas 88 personas del control y 80 del
# grupo experimental. ¿El tratamiento reduce la proporción de náuseas?

# p_control = proporción con náuseas en el grupo control
# p_experimental = proporción con náuseas en el grupo experimental
# H0: p_control = p_experimental
# H1: p_control > p_experimental

nauseas <- prop.test(x = c(control = 88, experimental = 80),
                     n = c(control = 200, experimental = 200),
                     alternative = "greater",
                     correct = TRUE)
nauseas

nauseas$estimate  # proporciones de cada grupo
nauseas$p.value
nauseas$conf.int  # intervalo para p_control - p_experimental

# Para una pregunta no direccional usamos alternative = "two.sided".
prop.test(x = c(88, 80),
          n = c(200, 200),
          alternative = "two.sided",
          correct = TRUE)

# EJERCICIO 2 --------------------------------------------------#
# En dos escuelas, aprobaron 72 de 100 estudiantes en la escuela A y
# 61 de 100 en la escuela B.
# a) Evalúa si las proporciones difieren.
# b) Evalúa si A tiene una proporción mayor que B.
# c) Compara los valores p e interpreta la diferencia.
#--------------------------------------------------------------#


#---------------------------------------------------------------#
# 4. DATOS PAES: IMPORTACIÓN Y LIMPIEZA                         #
#---------------------------------------------------------------#

data <- rio::import(
  "https://github.com/JoseRTM/AED_UDP/raw/refs/heads/main/mineduc_paes.rds"
)

str(data)

# En los puntajes, 0 significa "no rindió" y debe tratarse como NA.
puntajes <- c("PTJE_NEM", "PTJE_RANKING", "CLEC_REG_ACTUAL",
              "MATE1_REG_ACTUAL", "MATE2_REG_ACTUAL",
              "HCSOC_REG_ACTUAL", "CIEN_REG_ACTUAL")

for (variable in puntajes) {
  data[[variable]][data[[variable]] == 0] <- NA
}

# En el grupo de ingreso, 99 significa "sin información".
data$INGRESO_PERCAPITA_GRUPO_FA[
  data$INGRESO_PERCAPITA_GRUPO_FA == 99
] <- NA

#---------------------------------------------------------------#
# 5. PRUEBA T PARA UNA MEDIA                                    #
#---------------------------------------------------------------#

# PREGUNTA
# ¿El promedio del puntaje NEM difiere de 700 puntos?
# H0: mu = 700
# H1: mu != 700

nem_una_muestra <- t.test(data$PTJE_NEM,
                          mu = 700,
                          alternative = "two.sided",
                          conf.level = 0.95)
nem_una_muestra

nem_una_muestra$estimate
nem_una_muestra$conf.int
nem_una_muestra$p.value

# La prueba t supone observaciones independientes. Con muestras grandes,
# la inferencia sobre la media suele ser robusta frente a desviaciones
# moderadas de normalidad, gracias al Teorema del Límite Central.

# EJERCICIO 3 --------------------------------------------------#
# a) Evalúa si el promedio de MATE1_REG_ACTUAL difiere de 600.
# b) Reporta media, intervalo de confianza y valor p.
# c) Explica si la diferencia es estadística y sustantivamente relevante.
#--------------------------------------------------------------#


#---------------------------------------------------------------#
# 6. PRUEBA T PARA DOS GRUPOS                                   #
#---------------------------------------------------------------#

# Comparamos el puntaje NEM del décimo decil con los demás deciles.
data$grupo_decil <- ifelse(
  data$INGRESO_PERCAPITA_GRUPO_FA == 10,
  "Decil 10",
  "Deciles 1 a 9"
)
data$grupo_decil[is.na(data$INGRESO_PERCAPITA_GRUPO_FA)] <- NA
data$grupo_decil <- factor(data$grupo_decil,
                           levels = c("Deciles 1 a 9", "Decil 10"))

# Descriptivos antes del test
tapply(data$PTJE_NEM, data$grupo_decil, mean, na.rm = TRUE)
tapply(data$PTJE_NEM, data$grupo_decil, sd, na.rm = TRUE)

# H0: mu_deciles_1_9 = mu_decil_10
# H1: mu_deciles_1_9 != mu_decil_10
# Por defecto, t.test() utiliza la prueba de Welch, que no exige varianzas
# iguales entre los grupos.
nem_dos_grupos <- t.test(PTJE_NEM ~ grupo_decil,
                         data = data,
                         alternative = "two.sided",
                         conf.level = 0.95)
nem_dos_grupos

# Inspección gráfica complementaria
boxplot(PTJE_NEM ~ grupo_decil,
        data = data,
        main = "Puntaje NEM según grupo de ingreso",
        xlab = "Grupo",
        ylab = "Puntaje NEM",
        col = c("grey80", "steelblue2"))

# EJERCICIO 4 --------------------------------------------------#
# a) Compara MATE1_REG_ACTUAL entre los mismos grupos.
# b) Revisa descriptivos, boxplot, intervalo y valor p.
# c) Redacta una conclusión sin confundir asociación con causalidad.
#--------------------------------------------------------------#


#---------------------------------------------------------------#
# 7. ANOVA: TRES O MÁS MEDIAS                                   #
#---------------------------------------------------------------#

# ANOVA contrasta simultáneamente las medias de varios grupos.
# H0: todas las medias son iguales.
# H1: al menos una media difiere.

data$decil_factor <- factor(data$INGRESO_PERCAPITA_GRUPO_FA)

modelo_anova <- aov(PTJE_NEM ~ decil_factor, data = data)
summary(modelo_anova)

# Si rechazamos H0, ANOVA no indica por sí solo qué pares difieren.
# Tukey controla el error familiar al realizar comparaciones múltiples.
comparaciones_tukey <- TukeyHSD(modelo_anova)
comparaciones_tukey
plot(comparaciones_tukey, las = 1)

# Descriptivos por decil para interpretar las diferencias
tapply(data$PTJE_NEM, data$decil_factor, mean, na.rm = TRUE)

# DIAGNÓSTICOS BÁSICOS DEL MODELO
configuracion_original <- par(no.readonly = TRUE)
par(mfrow = c(1, 2))
plot(modelo_anova, which = 1) # residuos frente a valores ajustados
plot(modelo_anova, which = 2) # gráfico Q-Q de residuos
par(configuracion_original)

# EJERCICIO 5 --------------------------------------------------#
# a) Compara MATE1_REG_ACTUAL entre los deciles de ingreso.
# b) Si el ANOVA es significativo, ejecuta TukeyHSD().
# c) Identifica dos pares de deciles que difieran significativamente.
# d) Revisa los gráficos de diagnóstico.
#--------------------------------------------------------------#


#---------------------------------------------------------------#
# 8. TEST DE CORRELACIÓN                                        #
#---------------------------------------------------------------#

# PREGUNTA
# ¿Existe una asociación lineal entre Matemática 1 y Matemática 2?
# H0: rho = 0
# H1: rho != 0

correlacion_matematica <- cor.test(
  data$MATE1_REG_ACTUAL,
  data$MATE2_REG_ACTUAL,
  alternative = "two.sided",
  method = "pearson"
)
correlacion_matematica

# El coeficiente r expresa dirección e intensidad. El valor p evalúa si
# la evidencia permite rechazar rho = 0. Una correlación significativa
# no demuestra causalidad.

plot(data$MATE1_REG_ACTUAL, data$MATE2_REG_ACTUAL,
     main = "Matemática 1 y Matemática 2",
     xlab = "Puntaje Matemática 1",
     ylab = "Puntaje Matemática 2",
     col = adjustcolor("steelblue4", alpha.f = 0.3),
     pch = 19)
abline(lm(MATE2_REG_ACTUAL ~ MATE1_REG_ACTUAL, data = data),
       col = "firebrick3", lwd = 2)

# Matriz exploratoria de los puntajes
psych::corPlot(data[puntajes])

# EJERCICIO 6 --------------------------------------------------#
# a) Evalúa la correlación entre CLEC_REG_ACTUAL y HCSOC_REG_ACTUAL.
# b) Construye el gráfico de dispersión y agrega una recta.
# c) Interpreta dirección, intensidad, intervalo y valor p.
#--------------------------------------------------------------#


#---------------------------------------------------------------#
# 9. CÓMO REPORTAR UN RESULTADO                                 #
#---------------------------------------------------------------#

# Una conclusión completa debería incluir:
#   1. La pregunta y las hipótesis.
#   2. El test utilizado.
#   3. El estadístico, grados de libertad cuando corresponda y valor p.
#   4. La estimación y su intervalo de confianza.
#   5. Una interpretación sustantiva limitada al diseño del estudio.

# PLANTILLA GENERAL
# "Se aplicó [nombre del test] para evaluar [pregunta]. La estimación fue
# [valor] y su IC95% fue [LI, LS]. El resultado [fue/no fue] significativo,
# [estadístico y gl], p = [valor]. Por lo tanto, [conclusión sustantiva]."

# Evita escribir solamente "hay diferencias significativas". Indica la
# dirección, magnitud e incertidumbre de la diferencia observada.

# CONCEPTEST FINAL ---------------------------------------------#
# Un experimento aleatorizado evalúa un programa de tutorías. La diferencia
# estimada en aprobación es de +3 puntos porcentuales, con IC95% [0.3, 5.7]
# puntos porcentuales y p = 0.03. ¿Qué se puede concluir?
#
# A) El programa produce una mejora grande y educativamente importante.
# B) Hay evidencia de un efecto promedio positivo, pero los datos también
#    son compatibles con una mejora pequeña.
# C) Existe 97% de probabilidad de que el programa funcione.
# D) El programa mejora la aprobación de cada estudiante.
#
# Secuencia: voto individual, discusión con alguien que eligió otra opción
# y segunda votación antes de revelar la respuesta.
#
# RESPUESTA: B
# El valor p aporta evidencia contra H0, mientras el intervalo informa qué
# magnitudes son compatibles con los datos. Ninguno decide por sí solo si
# tres puntos porcentuales constituyen una mejora educativamente importante.
# Para eso necesitamos un criterio sustantivo definido en el contexto.

#===============================================================#
# RESUMEN: ¿QUÉ TEST USAR?                                      #
#---------------------------------------------------------------#
# UNA PROPORCIÓN frente a un valor:       prop.test() / binom.test()
# DOS PROPORCIONES:                        prop.test()
# UNA MEDIA frente a un valor:            t.test(x, mu = ...)
# DOS MEDIAS independientes:              t.test(y ~ grupo)
# TRES O MÁS MEDIAS:                      aov() + TukeyHSD()
# DOS VARIABLES CUANTITATIVAS:            cor.test()
#
# En todos los casos:
#   - formula H0 y H1 antes de ejecutar el test;
#   - revisa supuestos, descriptivos y gráficos;
#   - informa estimación, incertidumbre y valor p;
#   - distingue significancia estadística de relevancia sustantiva.
#===============================================================#
