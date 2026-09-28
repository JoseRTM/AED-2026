#==================================================================#
#            CLASE 1: LIBRERÍAS E IMPORTACIÓN DE DATOS             #
#      Diplomado en Data Science para las Ciencias Sociales        #
#                  Exploración de Datos - UDP                      #
#==================================================================#

# Para importar datos es muy relevante reconocer la extensión del archivo
# .xlsx = Excel
# .csv = Archivo delimitado
# .sav = SPSS
# .dta = STATA
# .txt = texto delimitado
# .rds = base de datos de R
# .RData = environment de R

# y Hay muchos formatos más como json
# Ejemplo 1: Importar un archivo Excel con readxl

# En R las librerías y paquetes son muy importantes, nos "desbloquean" funciones
# que antes no teníamos. Para importar datos esto es fundamental. 
# En general, trabajaremos con tres librerías: rio, readxl y haven

# Instalar y cargar la librería readxl
install.packages("readxl")
# Instalar no basta para usar las funciones
# Tenemos que activar la librería
# NOTA: LOS PAQUETES SE INSTALAN UNA VEZ, 
# PERO SE TIENEN QUE ACTIVAR SIEMPRE QUE INICIAS R (SI QUEREMOS UTILIZARLO)
library(readxl)

data_xlsx <- read_excel("bbdd_prueba1.xlsx")
View(data_xlsx)

# Ejemplo: Importar una hoja específica de un archivo Excel
# La librería readxl nos permite usar la función read_excel
# Es importante especificar la ruta del archivo y su extensión
data_xlsx <- read_excel("bbdd_prueba1.xlsx", sheet = 1)

# Ejemplo: Importar un archivo SPSS
# Cuando intentamos usar la función read_spss
data_spss <- read_spss("bbdd_prueba1.sav")

# DICE
# Error in read_spss("bbdd_prueba1.sav") : 
#  no se pudo encontrar la función "read_spss"

# Esto es producto de que la librería no está activa o el paquete no está instalado.
# el paquete que necesitamos para importar archivos .sav se llama haven

# Instalar y cargar la librería haven
install.packages("haven")
library(haven)

# Ahora si funciona
data_spss <- read_spss("bbdd_prueba1.sav")

# Ejemplo: Importar un archivo en múltiples formatos con rio

# el paquete rio es una excelente librería porque nos permite importar y exportar datos 
# de diferentes fuentes en un mismo paquete. 
# Instalar y cargar la librería rio
install.packages("rio")
library(rio)

# Ejemplo: Importar un archivo dta utilizando rio

data_dta <- import("bbdd_prueba1.dta")

# notemos que hay 74 observaciones, si inspeccionamos nos daremos cuenta de que
# hay 4 filas vacías
View(data_dta)
# podemos sacarlas utilizando corchetes
data_dta <- data_dta[1:70,]
# a la izquierda de la coma van las filas
# a la derecha van las columnas
# si cualquier de ambos lados está vacío, significa que lo quiero seleccionar todo
# en este caso, estamos seleccionando desde la fila 1 hasta la 70, y todas las columnas.

# para importar csv recomiendo utilizar la interfaz
# en la ventana del environment hay un botón que dice import dataset
# se debe seleccionar la extensión del archivo
# los csv se importan con text (readr)
# browse
# seleccionar la ruta del archivo
# especificar el nombre, separador, etc
# copiar y pegar el código en el script
library(readr)
data_csv <- read_delim("bbdd_prueba1.csv", 
                       delim = ";", escape_double = FALSE, trim_ws = TRUE)
View(data_csv)

# Ejemplo: Exportar archivos
# El formato .rds (base de datos de R) en general es mucho más liviana que los otros formatos
# para eso necesitamos la librería readr
install.packages("readr")
library(readr)

write_rds(data_xlsx, "bbdd_prueba1.rds")

# también podemos exportar en otros formatos
# por ejemplo un .csv
write_csv(data_xlsx, "data_xlsx.csv") 
# a partir de la data proveniente de excel, la transformamos en csv
data_csv <- import("data_xlsx.csv")

# para guardar todo el environment y crear un archivo .RData
save.image("bbdd_ejercicios.RData")

# podemos borrar todo el environment
rm(list = ls())
#liberamos el espacio de la ram
gc()

# podemos usar ambas funciones en una línea
rm(list = ls());gc()

# y volver a cargar el RData
load("bbdd_ejercicios.RData")

# Inspeccionar los datos
str(data_xlsx) # nos da la estructura de la base de datos
summary(data_xlsx) # nos da el resumen de las variables numéricas

# Paquete skimr
install.packages("skimr")
# nos da la función skim
skim(data_xlsx)

#==================#
# TRABAJO EN GRUPO #
#==================#
