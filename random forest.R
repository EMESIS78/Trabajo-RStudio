# Cargar las librerías necesarias
library(randomForest)
library(caret)

data$purchased <- as.factor(data$purchased)

# Dividir el dataset en conjunto de entrenamiento y pruebas
set.seed(123)
train_index <- createDataPartition(data$purchased, p = 0.8, list = FALSE)
train_data <- data[train_index, ]
test_data <- data[-train_index, ]

# Entrenar el modelo Random Forest
rf_model <- randomForest(purchased ~ age + income + gender + web_visits, data = train_data, ntree = 100)

# Realizar predicciones en el conjunto de pruebas
predictions <- predict(rf_model, test_data)

# Generar la matriz de confusión
conf_matrix <- confusionMatrix(predictions, as.factor(test_data$purchased))
print(conf_matrix)
