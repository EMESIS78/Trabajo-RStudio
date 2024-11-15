# Configuración de la semilla para reproducibilidad
set.seed(123)

# Generación de datos aleatorios
n <- 10000  # Número de registros

# Edad del cliente
age <- sample(18:70, n, replace = TRUE)

# Ingreso mensual del cliente
income <- runif(n, min = 1000, max = 10000)

# Género del cliente (0 para femenino, 1 para masculino)
gender <- sample(c(0, 1), n, replace = TRUE)

# Número de visitas al sitio web en el último mes (asumimos un rango de 0 a 50)
web_visits <- sample(0:50, n, replace = TRUE)

# Variable objetivo: si el cliente compró (1) o no (0)
purchased <- sample(c(0, 1), n, replace = TRUE, prob = c(0.7, 0.3))

# Creación del data frame
data <- data.frame(age, income, gender, web_visits, purchased)

# Visualizar las primeras filas del dataset
head(data)

# Guardar el dataset en un archivo CSV si es necesario
write.csv(data, "cliente_prediccion_compra.csv", row.names = FALSE)
