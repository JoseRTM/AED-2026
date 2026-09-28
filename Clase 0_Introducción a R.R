#===============================================================#
#            CLASE 0: INTRODUCCIÓN A R                          #
#      Diplomado en Data Science para las Ciencias Sociales     #
#                  Exploración de Datos - UDP                   #
#===============================================================#

# Bienvenid@s a R, pueden escribir sus apuntes utilizando el "gato"(shift+3) 
# R es un software gratuito de codigo abierto
# Recomendaciones generales para el desarrollo del script
# No usar caracteres especiales como tildes o eñes.
# R es case sensitive, eso significa que es importante respetar las mayusculas y minusculas de las funciones
# R se puede usar como calculadora, probemos.

# Suma
5 + 5 

# Resta
5 - 5 

# Multiplicación
3 * 5

# División
(5 + 5) / 2 

# Exponencial
exp(5+5)

# Potencia
2^5 

# Logaritmo natural
log(10)

# Logaritmo base 10
log10(10)

########################
##### EJERCICIO 1 ######
########################

# Ahora ustedes deben calcular lo siguiente:
# 1) La diferencia entre 20 y 10, divido por 5.
# 2) La diferencia entre 5 y 2 elevado a 4.
# 3) El producto entre 9 y la exponencial de la diferencia entre 10 y 4.


# Los resultados se pueden almacenar en el Environment (Esquina superior derecha), tienen que usar una flecha "<-",
# De esta forma podemos crear objetos.

x <- 24

# El objeto x tiene solamente una observación, que es 24. Cuando la guardamos, 
# no nos da el resultado inmediatamente, tenemos que "llamar" al objeto.
x
# Es equivalente usar
print(x)

# Se pueden hacer operaciones matemáticas con los objetos guardados
manzanas <- 5

peras <- 6

frutas <- manzanas + peras

print(frutas)

#####################
#### EJERCICIO 2 ####
#####################

# 1.a) Crear un objeto llamado a, que sea igual a 100
# 1.b) Calcular el logartimo natural de a, guardarlo como log_a
# 2) Calcular la exponencial de log_a, no guardar el resultado

# En R existen diferentes tipos de variables: Numeric o numéricas, Character o 
# categóricas y Logical o lógicas
numerica <- 42

categorica <- "perro"

logica <- TRUE

# Podemos ver el tipo de variable utilizando el comando class
class(numerica)

###############
# EJERCICIO 3 #
###############
# Revisar la clase del objeto categorica y logica usando la funcion class()


# Hasta ahora, solo hemos trabajado con una sola "observacion". Para crear un vector, 
# debemos utilizar el comando c() que significa concatenar.
vector_numerico <- c(20,21,15,26)
vector_numerico
class(vector_numerico)

###############
# EJERCICIO 4 #
###############
# 1.a) Crear un vector llamado vector_categorico que sea de clase character
# este vector debe contener los elementos: perro,gato,canario,caballo
# 1.b) Inspeccionar la clase del vector_categorico



# 2.a) Crear un vector llamado vector_logico que sea de clase logical
# este vector debe contener los elementos: verdadero,falso,falso,verdadero
# 2.b) Inspeccionar la clase del vector_logico




# OPERACIONES CON VECTORES
vector_a <- c(1,2,3)
vector_b <- c(4,5,6)
vector_total <- vector_a + vector_b
vector_total

# Notemos que R suma el elemento 1 del vector 1 con el elemento 1 del vector 2
# y asi sucesivamente.


###################
### EJERCICIO 5 ###
###################
# Fueron al casino durante una semana (de lunes a viernes). Jugaron poker y ruleta. 
# A continuación se encuentra el balance por día del poker:
# Lunes: Ganaron 100
# Martes: Perdieron 200
# Miércoles: Ganaron 20
# Jueves: Perdieron 150
# Viernes: Ganaron 200

# Ahora el balance de la ruleta
# Lunes: Ganaron 40
# Martes: Perdieron 30
# Miércoles: Ganaron 100
# Jueves: Perdieron 140
# Viernes: Ganaron 60

# Construir dos vectores que reflejen el balance de cada juego, durante los 5 días.
# El primer vector debe llamarse poker, el segundo debe llamarse ruleta.








# NOMBRAR LOS VECTORES
# podemos utilizar la funcion names() para darle nombre a los elementos de un vector
print(vector_a)
names(vector_a) <- c("uno","dos","tres")
vector_a

print(vector_b)
names(vector_b)<- c("cuatro","cinco","seis")
vector_b

#################
## EJERCICIO 6 ##
#################
# crear un vector que se llame dias, debe contener los dias de la semana desde el lunes hasta el viernes
# nombrar los vectores poker y ruleta utilizando el vector dias




# OPERACIONES DENTRO DE UN VECTOR
# podemos usar el comando sum() para sumar los elementos de un vector
sum(vector_a)
sum(vector_b)


#################
## EJERCICIO 7 ##
#################


# Calcular el balance total por dia


# calcular el balance total de la semana

# ¡INTERPRETE!

# OPERACIONES LOGICAS CON VECTORES
# podemos preguntarle a R ciertas cosas, por ejemplo, si la suma del vector a es mayor al vector b
sum(vector_a)>sum(vector_b)

###################################
###### Comparaciones lógicas ######
###################################

# < menor que
# > mayor que
# <= menor o igual que
# >= mayor o igual que
# == igual a
# != distinto a

#################
## EJERCICIO 8 ##
#################

# PREGUNTARLE A R SI ESTAMOS GANANDO MAS EN EL POKER O EN LA RULETA




# SELECCIONAR ELEMENTOS DE UN VECTOR
# podemos seleccionar elementos de un vector utilizando corchetes []
vector_a[1] # seleccionar el elemento 1 del vector_a
vector_b[3] # seleccionar el elemento 3 del vector_b
vector_a[4] # ¿Que ocurre aqui?

# podemos seleccionar varios elementos a la vez, utilizando concatenar c()
vector_a[c(1,2)] # elemento 1 y 2 del vector_a
vector_b[c(3,1)] # elemento 3 y 1 del vector_b

#################
## EJERCICIO 9 ##
#################

# Seleccionar en los vectores poker y ruleta los días martes,miercoles y jueves
# llamar al objeto poker_midweek y ruleta_midweek 
# ¿Cuánto gané o perdí en total durante esos días? Llamar a la variable total_midweek
# ¿Gané más en poker o en la ruleta?



# Cuando son elementos colindantes, se puede utilizar : entre los dos elementos.
vector_c <- rnorm(100,20,3)
vector_c
vector_c[1:50] # seleccionar los elementos de vector_c desde el 1 hasta el 50.


##################
## EJERCICIO 10 ##
##################
# Si el vector tiene nombres asignados, también podemos utilizarlo. Compruebe esto
# crear un vector que contenga 5 elementos, desde el 1 hasta el 5.
# llamarlo vector_d
# crear un vector de nombres que contenga "R","Python","SQL","SPSS"y "STATA"
# llamarlo softwares
# asignar los nombres al vector_d utilizando el comando names()
# seleccionar "R" y "STATA" del vector_d usando []
# No olvide usar "" para seleccionar los objetos.


######################
###### Matrices ######
######################

# Trabajaremos con matrices bidimensionales, que es una combinación de filas y columnas
# En R podemos crear matrices desde 0, utilizando el comando matrix.

# Para cualquier función, R les ayuda a utilizarlo. Pueden usar ? a la izquierda de la función o 
# apretar donde dice "Help", en la ventana inferior derecha. 
?matrix

# si byrow está activado, los datos se van a posicionar por fila
matrix(1:9, byrow = TRUE, nrow = 3) # creamos una matriz que contenga los valores desde el 1 hasta el 9 (1:9) ordenadas por fila

# Si está desactivado, se van a posicionar por columna
matrix(1:9, byrow = FALSE, nrow = 3)# creamos una matriz que contenga los valores desde el 1 hasta el 9 (1:9) ordenadas por columna

# Podemos tomar varios vectores y transformarlos en una matriz
matrix_a <- matrix(c(vector_a,vector_b), byrow = FALSE, nrow = 3) # matriz con tres filas, sin ordenar por fila.
matrix_b <- matrix(c(vector_a,vector_b), byrow = TRUE, nrow = 3) # matriz con tres filas, ordenada por fila.

# OJO AQUI
matrix(c(vector_a,vector_b), byrow = FALSE, nrow = 4) # cuando el numero de filas no es multiplo del tamaño del vector, da error.

##################
## EJERCICIO 11 ##
##################

# crear la matriz casino1 que contenga los vectores poker y ruleta creados en ejercicios anteriores.
# Debe tener 5 filas y debe estar ordenada por columna.
# crear la matriz casino2 que contenga los vectores poker y ruleta creados en ejercicios anteriores.
# debe tener 2 filas y estar ordenadas por fila.










# Para ordenarnos mejor, podemos asignar nombres
colnames(matrix_a)<- c("vector_a","vector_b")
rownames(matrix_a) <- c("Elemento 1","Elemento 2","Elemento 3")
matrix_a


##################
## EJERCICIO 12 ##
##################

# Asignar nombres a casino1 y casino2.
# Un vector de nombres debe contener los dias de la semana
# el otro vector debe contener poker y ruleta
# asignar con colnames y rownames segun corresponda.



# El comando matrix permite asignar nombres dentro de la funcion
columna <- c("vector_a","vector_b")
fila <- c("Elemento 1","Elemento 2","Elemento 3")
matrix_b <-matrix(c(vector_a,vector_b),
       byrow = FALSE,
       nrow = 3,
       dimnames = list(fila,columna)) # noten que primero va el nombre de la fila, despues columna
# Para sumar los valores por fila, se puede utilizar el comando rowSums: Recuerde que R es case sensitive y es una S MAYUSCULA.
matrix_b
rowSums(matrix_b)
# Para sumar los valores por columna, se puede utilizar colSums
colSums(matrix_b)
# Supongamos que ahora quiero agregar dos filas Para eso debo utilizar el comando rbind(),
# que significa row bind.
a <- c(4,5)
b <- c(7,8)
matrix_c <- matrix(c(a,b),
                   nrow = 2,
                   byrow = FALSE,
                   dimnames = list(c("Elemento 4","Elemento 5"),c("vector_a","vector_b")))
matrix_c
matrix_d <- rbind(matrix_b,matrix_c)
matrix_d
# Para completar la base, me interesa crear una columna que sea la suma de la fila 
# para esto, debo utilizar cbind() que significa column bind
total_fila <- rowSums(matrix_d)
total_fila
cbind(matrix_d,total_fila)

##################
## EJERCICIO 13 ##
##################

# Agregar el sábado y domingo al vector casino1.
# poker: sabado ganaron 100
# poker: domingo ganaron 70
# ruleta: sabado perdieron 20
# ruleta: domingo ganaron 10
# Las filas deben contener los dias de la semana desde el lunes hasta el domingo
# Las columnas deben ser poker y ruleta.
# Encontrar el total de ambos juegos por los 7 dias a la semana. 
# Asignar el resultado a total_casino
# Pista 1: Deben crear una variable que sume poker y ruleta por dia, utilizando rowSums. Llamenla total_dia
# Pista 2: Deben sumar la variable total_dia, y despues usar colSums()

# DATA FRAMES
# LOS DATA FRAMES SON ESTRUCTURAS ESENCIALES EN R, SON NUESTRAS "BASES DE DATOS"
# Es una tabla de datos en R.

# Cada columna es un vector del mismo largo (puede ser numérico, texto, lógico o factor).

# Cada fila representa una observación o registro.

df <- data.frame(cbind(matrix_d,total_fila))

# Ejemplo sencillo
df <- data.frame(
  nombre = c("Ana", "Bruno", "Carla"),
  edad   = c(23, 31, 29),
  aprobado = c(TRUE, FALSE, TRUE)
)
df

# ACCEDER A UNA COLUMA
df$edad # usar el operador $

# ACCEDER A CELDAS
df[2,2]
# los corchetes se usan igual que en una matriz

# SUBCONJUNTO DE FILAS
df[df$edad > 25, ]

# AGREGAR UNA COLUMA
df$ciudad <- c("Quito", "Lima", "Bogotá")

# ELIMINAR UNA COLUMNA
df$aprobado <- NULL

################
# EJERCICIO 14 #
################
# Transforme la matriz del ejercicio anterior a un data frame
# revise el resultado con la función View()

# LISTAS
# Las listas son como un contenedor flexible que puede guardar objetos de distinto tipo y tamaño.

# A diferencia de un vector (que debe ser homogéneo), una lista puede contener:
  
# Vectores numéricos, de texto o lógicos.
# Data frames.
# Otras listas.
# Resultados de funciones.

mi_lista <- list(
  nombre = "Ana",
  edad = 25,
  notas = c(8, 9, 10),
  aprobado = TRUE
)

mi_lista[["edad"]]   # Devuelve 25
mi_lista[[2]]        # También devuelve 25

mi_lista$notas       # Devuelve el vector (8, 9, 10)

mi_lista["edad"]     # Devuelve una lista con un solo elemento

# [[]] → devuelve el contenido.

# [] → devuelve otra lista.

# LISTAS ANIDADAS
# Las listas pueden contener otras listas
anidada <- list(
  persona = list(
    nombre = "Bruno",
    edad = 30
  ),
  calificaciones = list(
    matematicas = c(7, 8, 9),
    historia = c(6, 7, 8)
  )
)

anidada$persona$edad          # 30
anidada$calificaciones$historia[2]  # 7

# LAS LISTAS ESTÁN PRESENTES EN MUCHAS FUNCIONES
modelo <- lm(mpg ~ hp, data = mtcars)
class(modelo)   # "lm"
names(modelo)   # La lista de componentes (coeficientes, residuos, etc.)
modelo$coefficients

# RECUERDA: Un data frame es en realidad una lista de vectores de igual longitud.

