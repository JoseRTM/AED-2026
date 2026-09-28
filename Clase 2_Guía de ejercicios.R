#===============================================================#
#         GUÍA DE EJERCICIOS - ESTADÍSTICA DESCRIPTIVA          #
#      Diplomado en Data Science para las Ciencias Sociales     #
#                  Exploración de Datos - UDP                   #
#===============================================================#

# INSTRUCCIONES
# Trabaja en R base y las librerías vistas en clase (NO uses tidyverse).
# Responde cada afirmación con VERDADERO o FALSO y JUSTIFICA tu elección
# con evidencia empírica (los estadísticos o gráficos que la respaldan).

# Base de datos: MINEDUC-PAES (puntajes de la Prueba de Acceso a la
# Educación Superior). Diccionario de variables relevantes:
#   PTJE_NEM                   -> puntaje NEM (notas de enseñanza media)
#   PTJE_RANKING               -> puntaje ranking
#   CLEC_REG_ACTUAL            -> Competencia Lectora
#   MATE1_REG_ACTUAL           -> Matemática 1
#   MATE2_REG_ACTUAL           -> Matemática 2
#   HCSOC_REG_ACTUAL           -> Historia y Cs. Sociales
#   CIEN_REG_ACTUAL            -> Ciencias
#   INGRESO_PERCAPITA_GRUPO_FA -> decil de ingreso per cápita del hogar (1 a 10)

# -------------------------------------------------------------- #
# 1) CARGAR LIBRERÍAS (usa pacman, como en clase)
#    if (!require("pacman")) install.packages("pacman")
#    pacman::p_load(rio, psych, moments, epiDisplay)


# 2) IMPORTAR LA BASE DE DATOS mineduc_paes
#    (se descarga directamente desde el repositorio del curso)
# data <- rio::import("https://github.com/JoseRTM/AED_UDP/raw/refs/heads/main/mineduc_paes.rds")


# 3) LIMPIAR LOS CÓDIGOS PERDIDOS
#    En los puntajes, el valor 0 indica "no rindió" (no es una nota real).
#    En INGRESO_PERCAPITA_GRUPO_FA, el valor 99 indica "sin información".
#    Reemplázalos por NA antes de calcular cualquier estadístico.
#    (Sugerencia: reutiliza la función a_na() de la clase.)


# -------------------------------------------------------------- #
# RESPONDE VERDADERO O FALSO, JUSTIFICANDO CON EVIDENCIA:

# 1) La distribución de puntajes del NEM es simétrica.


# 2) Los puntajes de la prueba de matemáticas 1 son, en promedio,
#    mayores que los de competencia lectora.


# 3) Los estudiantes del décimo decil de ingreso tienen mayores
#    puntajes que los deciles inferiores en TODAS las pruebas PAES.
#    (¿El aumento es además monótono a medida que sube el decil?)


# 4) La distribución de los puntajes de matemáticas está sesgada
#    a la derecha (sesgo positivo).


# 5) El puntaje del NEM tiene mayor dispersión relativa que los
#    puntajes de las pruebas PAES.


# -------------------------------------------------------------- #
# EJERCICIOS ADICIONALES

# 6) Construye la tabla de frecuencias (en porcentaje) de la variable
#    INGRESO_PERCAPITA_GRUPO_FA. ¿Qué decil concentra más estudiantes?


# 7) Obtén los deciles del puntaje de Competencia Lectora (CLEC).
#    ¿Qué puntaje separa al 10% de mejor rendimiento del resto?

#===============================================================#
