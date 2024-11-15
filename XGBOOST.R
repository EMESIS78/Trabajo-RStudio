install.packages("xgboost")

library(xgboost)
library(caret)

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

# Convertir las variables categóricas a variables dummy
train_data_dummies <- model.matrix(purchased ~ age + income + gender + web_visits, data = train_data)[,-1]
test_data_dummies <- model.matrix(purchased ~ age + income + gender + web_visits, data = test_data)[,-1]

# Convertir las variables objetivo a valores numéricos (0 o 1)
train_labels <- as.numeric(train_data$purchased) - 1  # 0 o 1
test_labels <- as.numeric(test_data$purchased) - 1

# Entrenar el modelo XGBoost
xgb_model <- xgboost(data = train_data_dummies, 
                     label = train_labels, 
                     nrounds = 100,  # Número de iteraciones (árboles)
                     objective = "binary:logistic",  # Para clasificación binaria
                     eval_metric = "logloss",  # Métrica de evaluación
                     max_depth = 6,  # Profundidad máxima de los árboles
                     eta = 0.3,  # Tasa de aprendizaje
                     subsample = 0.8,  # Submuestra de datos
                     colsample_bytree = 0.8)  # Submuestra de características

# Realizar predicciones en el conjunto de pruebas
xgb_predictions <- predict(xgb_model, test_data_dummies)

# Convertir las predicciones a clases (0 o 1)
xgb_predictions_class <- ifelse(xgb_predictions > 0.5, 1, 0)

# Generar la matriz de confusión
xgb_conf_matrix <- confusionMatrix(as.factor(xgb_predictions_class), as.factor(test_labels))
print("Matriz de Confusión (XGBoost):")
print(xgb_conf_matrix)
