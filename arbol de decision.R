install.packages("smotefamily")
install.packages("ROSE")

library(rpart)
library(caret)
library(smotefamily)
library(ROSE)

data$purchased <- as.factor(data$purchased)

# Dividir el dataset en conjunto de entrenamiento y pruebas
set.seed(123)
train_index <- createDataPartition(data$purchased, p = 0.8, list = FALSE)
train_data <- data[train_index, ]
test_data <- data[-train_index, ]

# Asegurarse de que todas las variables categóricas estén bien configuradas
train_data$purchased <- as.factor(train_data$purchased)
test_data$purchased <- as.factor(test_data$purchased)
train_data$gender <- as.factor(train_data$gender)
test_data$gender <- as.factor(test_data$gender)

# ---------------------------------------------------------------------------------------------------
# 1. Ajuste de parámetros del Árbol de Decisión (rpart)
tree_model_adjusted <- rpart(purchased ~ age + income + gender + web_visits, 
                             data = train_data, 
                             method = "class", 
                             control = rpart.control(cp = 0.01, minsplit = 20))

# Realizar predicciones en el conjunto de pruebas
tree_predictions_adjusted <- predict(tree_model_adjusted, test_data, type = "class")

# Generar la matriz de confusión
tree_conf_matrix_adjusted <- confusionMatrix(tree_predictions_adjusted, test_data$purchased)
print("Matriz de Confusión (Ajuste de parámetros):")
print(tree_conf_matrix_adjusted)

# ---------------------------------------------------------------------------------------------------
# 2. Balanceo de clases con SMOTE (Sobremuestreo de la clase minoritaria)
# Usando la función SMOTE del paquete smotefamily
train_data_balanced <- SMOTE(purchased ~ age + income + gender + web_visits, 
                             data = train_data, 
                             perc.over = 100, perc.under = 200)

# Entrenar el modelo de Árbol de Decisión con datos balanceados
tree_model_balanced <- rpart(purchased ~ age + income + gender + web_visits, 
                             data = train_data_balanced, 
                             method = "class")

# Realizar predicciones en el conjunto de pruebas
tree_predictions_balanced <- predict(tree_model_balanced, test_data, type = "class")

# Generar la matriz de confusión
tree_conf_matrix_balanced <- confusionMatrix(tree_predictions_balanced, test_data$purchased)
print("Matriz de Confusión (SMOTE - Sobremuestreo):")
print(tree_conf_matrix_balanced)

# ---------------------------------------------------------------------------------------------------
# 3. Submuestreo de la clase mayoritaria
train_data_under <- ovun.sample(purchased ~ age + income + gender + web_visits, 
                                data = train_data, 
                                method = "under", 
                                p = 0.5, 
                                seed = 123)$data

# Entrenar el modelo con datos submuestreados
tree_model_under <- rpart(purchased ~ age + income + gender + web_visits, 
                          data = train_data_under, 
                          method = "class")

# Realizar predicciones en el conjunto de pruebas
tree_predictions_under <- predict(tree_model_under, test_data, type = "class")

# Generar la matriz de confusión
tree_conf_matrix_under <- confusionMatrix(tree_predictions_under, test_data$purchased)
print("Matriz de Confusión (Submuestreo de la clase mayoritaria):")
print(tree_conf_matrix_under)
