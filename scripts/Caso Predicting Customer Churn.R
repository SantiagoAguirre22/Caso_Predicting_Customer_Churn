# ---------------------------------------------------------
# Instalación de paquetes necesarios
# ---------------------------------------------------------

if (!require(readxl)) install.packages("readxl")
if (!require(dplyr)) install.packages("dplyr")
if (!require(ggplot2)) install.packages("ggplot2")
if (!require(broom)) install.packages("broom")
if (!require(gt)) install.packages("gt")
if (!require(htmlwidgets)) install.packages("htmlwidgets")
if (!require(scales)) install.packages("scales")
if (!require(pscl)) install.packages("pscl")
if (!require(pROC)) install.packages("pROC")
if (!require(tidyr)) install.packages("tidyr")

# ---------------------------------------------------------
# Librerías
# ---------------------------------------------------------

library(readxl)
library(dplyr)
library(ggplot2)
library(broom)
library(gt)
library(htmlwidgets)
library(scales)
library(pscl)
library(pROC)
library(tidyr)

# ---------------------------------------------------------
# Configuración inicial
# ---------------------------------------------------------

setwd("C:/Users/Usuario/Documents")
getwd()

options(scipen = 999)

formato_grafica <- theme_gray() +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
    axis.title = element_text(size = 11),
    axis.text = element_text(size = 10)
  )

# ---------------------------------------------------------
# Lectura y preparación de datos
# ---------------------------------------------------------

data <- read_excel("Predicting_Customer_Churn.xlsx", sheet = "Case Data")

names(data) <- trimws(names(data))

names(data)[names(data) == "ID"] <- "ID"
names(data)[names(data) == "Customer Age (in months)"] <- "Customer_Age"
names(data)[names(data) == "Churn (1 = Yes, 0 = No)"] <- "Churn"
names(data)[names(data) == "CHI Score Month 0"] <- "CHI_Score"
names(data)[names(data) == "CHI Score 0-1"] <- "CHI_Change"
names(data)[names(data) == "Support Cases Month 0"] <- "Support_Cases"
names(data)[names(data) == "Support Cases 0-1"] <- "Support_Cases_Change"
names(data)[names(data) == "SP Month 0"] <- "Support_Priority"
names(data)[names(data) == "SP 0-1"] <- "Support_Priority_Change"
names(data)[names(data) == "Logins 0-1"] <- "Logins"
names(data)[names(data) == "Blog Articles 0-1"] <- "Blog_Articles"
names(data)[names(data) == "Views 0-1"] <- "Views"
names(data)[names(data) == "Days Since Last Login 0-1"] <- "Days_Since_Last_Login"

str(data)
head(data)
names(data)

# ---------------------------------------------------------
# Limpieza de la variable Churn
# ---------------------------------------------------------

data <- data %>%
  mutate(
    Churn = as.numeric(Churn)
  )

table(data$Churn, useNA = "ifany")

# ---------------------------------------------------------
# Selección de variables para el modelo
# ---------------------------------------------------------

data_modelo <- data %>%
  select(
    Churn,
    Customer_Age,
    CHI_Score,
    CHI_Change,
    Support_Cases,
    Support_Cases_Change,
    Support_Priority,
    Support_Priority_Change,
    Logins,
    Blog_Articles,
    Views,
    Days_Since_Last_Login
  ) %>%
  na.omit()

str(data_modelo)
head(data_modelo)
names(data_modelo)
table(data_modelo$Churn, useNA = "ifany")

# ---------------------------------------------------------
# Tabla descriptiva de los datos
# ---------------------------------------------------------

tabla_descriptiva <- data_modelo %>%
  summarise(across(
    everything(),
    list(
      Minimo = ~min(.x, na.rm = TRUE),
      Promedio = ~mean(.x, na.rm = TRUE),
      Desviacion = ~sd(.x, na.rm = TRUE),
      Maximo = ~max(.x, na.rm = TRUE)
    )
  )) %>%
  pivot_longer(
    cols = everything(),
    names_to = c("Variable", ".value"),
    names_pattern = "(.+)_(Minimo|Promedio|Desviacion|Maximo)"
  )

tabla_descriptiva_gt <- tabla_descriptiva %>%
  gt() %>%
  tab_header(
    title = md("**Tabla Descriptiva de los Datos**")
  ) %>%
  fmt_number(
    columns = c(Minimo, Promedio, Desviacion, Maximo),
    decimals = 4
  ) %>%
  cols_align(
    align = "center",
    columns = everything()
  ) %>%
  tab_options(
    table.width = pct(95),
    heading.align = "center",
    table.font.size = px(12),
    data_row.padding = px(6)
  )

invisible(tabla_descriptiva_gt)

# ---------------------------------------------------------
# Distribución de la variable Churn
# ---------------------------------------------------------

tabla_churn <- data_modelo %>%
  count(Churn) %>%
  mutate(
    Grupo = ifelse(Churn == 1, "Cliente con churn", "Cliente sin churn"),
    Porcentaje = n / sum(n)
  ) %>%
  select(Grupo, Frecuencia = n, Porcentaje)

tabla_churn_gt <- tabla_churn %>%
  gt() %>%
  tab_header(
    title = md("**Distribución de la Variable Churn**")
  ) %>%
  fmt_percent(
    columns = Porcentaje,
    decimals = 2
  ) %>%
  cols_align(
    align = "center",
    columns = everything()
  ) %>%
  tab_options(
    table.width = pct(75),
    heading.align = "center",
    table.font.size = px(13),
    data_row.padding = px(6)
  )

invisible(tabla_churn_gt)

grafico_churn <- ggplot(
  data_modelo,
  aes(x = factor(Churn, levels = c(0, 1), labels = c("Sin churn", "Con churn")))
) +
  geom_bar(fill = "steelblue") +
  labs(
    title = "Distribución de Clientes según Churn",
    x = "Grupo",
    y = "Número de clientes"
  ) +
  formato_grafica

print(grafico_churn)

# ---------------------------------------------------------
# Gráficos exploratorios de variables relevantes
# ---------------------------------------------------------

grafico_chi <- ggplot(
  data_modelo,
  aes(
    x = factor(Churn, levels = c(0, 1), labels = c("Sin churn", "Con churn")),
    y = CHI_Score
  )
) +
  geom_boxplot(fill = "steelblue") +
  labs(
    title = "CHI Score según Churn",
    x = "Grupo",
    y = "CHI Score"
  ) +
  formato_grafica

print(grafico_chi)

grafico_soporte <- ggplot(
  data_modelo,
  aes(
    x = factor(Churn, levels = c(0, 1), labels = c("Sin churn", "Con churn")),
    y = Support_Cases
  )
) +
  geom_boxplot(fill = "steelblue") +
  labs(
    title = "Casos de Soporte según Churn",
    x = "Grupo",
    y = "Casos de soporte"
  ) +
  formato_grafica

print(grafico_soporte)

grafico_login <- ggplot(
  data_modelo,
  aes(
    x = factor(Churn, levels = c(0, 1), labels = c("Sin churn", "Con churn")),
    y = Days_Since_Last_Login
  )
) +
  geom_boxplot(fill = "steelblue") +
  labs(
    title = "Días desde el Último Login según Churn",
    x = "Grupo",
    y = "Días desde el último login"
  ) +
  formato_grafica

print(grafico_login)

grafico_logins <- ggplot(
  data_modelo,
  aes(
    x = factor(Churn, levels = c(0, 1), labels = c("Sin churn", "Con churn")),
    y = Logins
  )
) +
  geom_boxplot(fill = "steelblue") +
  labs(
    title = "Número de Logins según Churn",
    x = "Grupo",
    y = "Logins"
  ) +
  formato_grafica

print(grafico_logins)

# ---------------------------------------------------------
# Especificación de modelos de probabilidad
# ---------------------------------------------------------

formula_modelo <- Churn ~ Customer_Age +
  CHI_Score +
  CHI_Change +
  Support_Cases +
  Support_Cases_Change +
  Support_Priority +
  Support_Priority_Change +
  Logins +
  Blog_Articles +
  Views +
  Days_Since_Last_Login

# ---------------------------------------------------------
# Modelo de Probabilidad Lineal
# ---------------------------------------------------------

modelo_mpl <- lm(formula_modelo, data = data_modelo)

summary(modelo_mpl)

tabla_mpl <- tidy(modelo_mpl) %>%
  rename(
    Variable = term,
    Coeficiente = estimate,
    `Error estándar` = std.error,
    `Valor p` = p.value
  )

tabla_mpl_gt <- tabla_mpl %>%
  gt() %>%
  tab_header(
    title = md("**Modelo de Probabilidad Lineal para Churn**")
  ) %>%
  fmt_number(
    columns = c(Coeficiente, `Error estándar`, `Valor p`),
    decimals = 6
  ) %>%
  cols_align(
    align = "center",
    columns = everything()
  ) %>%
  tab_options(
    table.width = pct(95),
    heading.align = "center",
    table.font.size = px(12),
    data_row.padding = px(6)
  )

invisible(tabla_mpl_gt)

# ---------------------------------------------------------
# Modelo Logit
# ---------------------------------------------------------

modelo_logit <- glm(
  formula_modelo,
  data = data_modelo,
  family = binomial(link = "logit")
)

summary(modelo_logit)

tabla_logit <- tidy(modelo_logit) %>%
  rename(
    Variable = term,
    Coeficiente = estimate,
    `Error estándar` = std.error,
    `Valor p` = p.value
  )

tabla_logit_gt <- tabla_logit %>%
  gt() %>%
  tab_header(
    title = md("**Modelo Logit para Churn**")
  ) %>%
  fmt_number(
    columns = c(Coeficiente, `Error estándar`, `Valor p`),
    decimals = 6
  ) %>%
  cols_align(
    align = "center",
    columns = everything()
  ) %>%
  tab_options(
    table.width = pct(95),
    heading.align = "center",
    table.font.size = px(12),
    data_row.padding = px(6)
  )

invisible(tabla_logit_gt)

# ---------------------------------------------------------
# Modelo Probit
# ---------------------------------------------------------

modelo_probit <- glm(
  formula_modelo,
  data = data_modelo,
  family = binomial(link = "probit")
)

summary(modelo_probit)

tabla_probit <- tidy(modelo_probit) %>%
  rename(
    Variable = term,
    Coeficiente = estimate,
    `Error estándar` = std.error,
    `Valor p` = p.value
  )

tabla_probit_gt <- tabla_probit %>%
  gt() %>%
  tab_header(
    title = md("**Modelo Probit para Churn**")
  ) %>%
  fmt_number(
    columns = c(Coeficiente, `Error estándar`, `Valor p`),
    decimals = 6
  ) %>%
  cols_align(
    align = "center",
    columns = everything()
  ) %>%
  tab_options(
    table.width = pct(95),
    heading.align = "center",
    table.font.size = px(12),
    data_row.padding = px(6)
  )

invisible(tabla_probit_gt)

# ---------------------------------------------------------
# Comparación general de modelos
# ---------------------------------------------------------

pseudo_logit <- pscl::pR2(modelo_logit)["McFadden"]
pseudo_probit <- pscl::pR2(modelo_probit)["McFadden"]

tabla_comparacion_modelos <- data.frame(
  Modelo = c("MPL", "Logit", "Probit"),
  R2 = c(
    summary(modelo_mpl)$r.squared,
    as.numeric(pseudo_logit),
    as.numeric(pseudo_probit)
  ),
  AIC = c(
    AIC(modelo_mpl),
    AIC(modelo_logit),
    AIC(modelo_probit)
  )
)

tabla_comparacion_modelos_gt <- tabla_comparacion_modelos %>%
  gt() %>%
  tab_header(
    title = md("**Comparación General de Modelos**")
  ) %>%
  fmt_number(
    columns = c(R2, AIC),
    decimals = 6
  ) %>%
  cols_align(
    align = "center",
    columns = everything()
  ) %>%
  tab_options(
    table.width = pct(80),
    heading.align = "center",
    table.font.size = px(13),
    data_row.padding = px(6)
  )

invisible(tabla_comparacion_modelos_gt)

# ---------------------------------------------------------
# Selección del modelo final
# ---------------------------------------------------------

modelo_final <- modelo_logit

data_resultados <- data_modelo %>%
  mutate(
    Probabilidad_Churn = predict(modelo_final, type = "response"),
    Prediccion_Churn = ifelse(Probabilidad_Churn >= 0.10, 1, 0),
    Error = Churn - Probabilidad_Churn,
    Error_Absoluto = abs(Error)
  )

# ---------------------------------------------------------
# Tabla del modelo final
# ---------------------------------------------------------

tabla_modelo_final <- tidy(modelo_final) %>%
  mutate(
    Odds_Ratio = exp(estimate)
  ) %>%
  rename(
    Variable = term,
    Coeficiente = estimate,
    `Error estándar` = std.error,
    `Valor p` = p.value
  )

tabla_modelo_final_gt <- tabla_modelo_final %>%
  gt() %>%
  tab_header(
    title = md("**Modelo Final Seleccionado: Logit**")
  ) %>%
  fmt_number(
    columns = c(Coeficiente, `Error estándar`, `Valor p`, Odds_Ratio),
    decimals = 6
  ) %>%
  cols_align(
    align = "center",
    columns = everything()
  ) %>%
  tab_options(
    table.width = pct(95),
    heading.align = "center",
    table.font.size = px(12),
    data_row.padding = px(6)
  )

invisible(tabla_modelo_final_gt)

# ---------------------------------------------------------
# Interpretación de coeficientes relevantes
# ---------------------------------------------------------

variables_interpretacion <- c("CHI_Score", "Support_Cases", "Days_Since_Last_Login", "Customer_Age")
variables_interpretacion <- variables_interpretacion[variables_interpretacion %in% tabla_modelo_final$Variable]

tabla_interpretacion <- tabla_modelo_final %>%
  filter(Variable %in% variables_interpretacion) %>%
  mutate(
    Interpretacion = case_when(
      Coeficiente < 0 ~ "Un aumento en esta variable se asocia con una menor probabilidad de churn.",
      Coeficiente > 0 ~ "Un aumento en esta variable se asocia con una mayor probabilidad de churn.",
      TRUE ~ "La variable no presenta un efecto direccional claro."
    )
  ) %>%
  select(Variable, Coeficiente, Odds_Ratio, `Valor p`, Interpretacion)

tabla_interpretacion_gt <- tabla_interpretacion %>%
  gt() %>%
  tab_header(
    title = md("**Interpretación de Coeficientes Relevantes**")
  ) %>%
  fmt_number(
    columns = c(Coeficiente, Odds_Ratio, `Valor p`),
    decimals = 6
  ) %>%
  cols_align(
    align = "center",
    columns = c(Variable, Coeficiente, Odds_Ratio, `Valor p`)
  ) %>%
  tab_options(
    table.width = pct(100),
    heading.align = "center",
    table.font.size = px(12),
    data_row.padding = px(6)
  )

invisible(tabla_interpretacion_gt)

# ---------------------------------------------------------
# Evaluación del desempeño del modelo
# ---------------------------------------------------------

matriz_confusion <- table(
  Real = data_resultados$Churn,
  Predicho = data_resultados$Prediccion_Churn
)

matriz_confusion

VP <- ifelse("1" %in% rownames(matriz_confusion) & "1" %in% colnames(matriz_confusion), matriz_confusion["1", "1"], 0)
VN <- ifelse("0" %in% rownames(matriz_confusion) & "0" %in% colnames(matriz_confusion), matriz_confusion["0", "0"], 0)
FP <- ifelse("0" %in% rownames(matriz_confusion) & "1" %in% colnames(matriz_confusion), matriz_confusion["0", "1"], 0)
FN <- ifelse("1" %in% rownames(matriz_confusion) & "0" %in% colnames(matriz_confusion), matriz_confusion["1", "0"], 0)

accuracy <- (VP + VN) / (VP + VN + FP + FN)
precision <- ifelse((VP + FP) == 0, NA, VP / (VP + FP))
recall <- ifelse((VP + FN) == 0, NA, VP / (VP + FN))
specificity <- ifelse((VN + FP) == 0, NA, VN / (VN + FP))

tabla_metricas <- data.frame(
  Metrica = c("Accuracy", "Precision", "Recall", "Specificity"),
  Valor = c(accuracy, precision, recall, specificity)
)

tabla_metricas_gt <- tabla_metricas %>%
  gt() %>%
  tab_header(
    title = md("**Métricas de Desempeño del Modelo Final**")
  ) %>%
  fmt_number(
    columns = Valor,
    decimals = 4
  ) %>%
  cols_align(
    align = "center",
    columns = everything()
  ) %>%
  tab_options(
    table.width = pct(75),
    heading.align = "center",
    table.font.size = px(13),
    data_row.padding = px(6)
  )

invisible(tabla_metricas_gt)

tabla_matriz_confusion <- as.data.frame.matrix(matriz_confusion)

tabla_matriz_confusion_gt <- tabla_matriz_confusion %>%
  gt(rownames_to_stub = TRUE) %>%
  tab_header(
    title = md("**Matriz de Confusión: Valores Reales vs Predichos**")
  ) %>%
  cols_align(
    align = "center",
    columns = everything()
  ) %>%
  tab_options(
    table.width = pct(70),
    heading.align = "center",
    table.font.size = px(13),
    data_row.padding = px(6)
  )

invisible(tabla_matriz_confusion_gt)

# ---------------------------------------------------------
# Gráfico de errores
# ---------------------------------------------------------

grafico_errores <- ggplot(data_resultados, aes(x = Probabilidad_Churn, y = Error)) +
  geom_point(alpha = 0.6, color = "steelblue") +
  geom_hline(yintercept = 0, linetype = "dashed") +
  labs(
    title = "Gráfico de Errores del Modelo Final",
    x = "Probabilidad estimada de churn",
    y = "Error"
  ) +
  formato_grafica

print(grafico_errores)

grafico_error_absoluto <- ggplot(data_resultados, aes(x = Probabilidad_Churn, y = Error_Absoluto)) +
  geom_point(alpha = 0.6, color = "steelblue") +
  labs(
    title = "Error Absoluto según Probabilidad Estimada",
    x = "Probabilidad estimada de churn",
    y = "Error absoluto"
  ) +
  formato_grafica

print(grafico_error_absoluto)

# ---------------------------------------------------------
# Curva ROC y AUC
# ---------------------------------------------------------

roc_modelo <- roc(data_resultados$Churn, data_resultados$Probabilidad_Churn)

auc_modelo <- auc(roc_modelo)

tabla_auc <- data.frame(
  Medida = "AUC",
  Valor = as.numeric(auc_modelo)
)

tabla_auc_gt <- tabla_auc %>%
  gt() %>%
  tab_header(
    title = md("**Área Bajo la Curva ROC**")
  ) %>%
  fmt_number(
    columns = Valor,
    decimals = 4
  ) %>%
  cols_align(
    align = "center",
    columns = everything()
  ) %>%
  tab_options(
    table.width = pct(60),
    heading.align = "center",
    table.font.size = px(13),
    data_row.padding = px(6)
  )

invisible(tabla_auc_gt)

plot(
  roc_modelo,
  main = "Curva ROC del Modelo Final",
  col = "steelblue",
  lwd = 2
)

# ---------------------------------------------------------
# Comparación entre valores reales y predichos
# ---------------------------------------------------------

grafico_predicho_real <- ggplot(
  data_resultados,
  aes(
    x = factor(Churn, levels = c(0, 1), labels = c("Sin churn real", "Con churn real")),
    y = Probabilidad_Churn
  )
) +
  geom_boxplot(fill = "steelblue") +
  labs(
    title = "Probabilidad Estimada según Churn Real",
    x = "Resultado real",
    y = "Probabilidad estimada de churn"
  ) +
  formato_grafica

print(grafico_predicho_real)

# ---------------------------------------------------------
# Clientes con mayor riesgo de churn
# ---------------------------------------------------------

ranking_clientes_riesgo <- data_resultados %>%
  mutate(ID_Cliente = row_number()) %>%
  arrange(desc(Probabilidad_Churn)) %>%
  select(ID_Cliente, Churn, Probabilidad_Churn, Prediccion_Churn, Error_Absoluto) %>%
  head(100)

tabla_ranking_clientes_gt <- ranking_clientes_riesgo %>%
  gt() %>%
  tab_header(
    title = md("**Clientes con Mayor Probabilidad Estimada de Churn**")
  ) %>%
  fmt_number(
    columns = c(Probabilidad_Churn, Error_Absoluto),
    decimals = 4
  ) %>%
  cols_align(
    align = "center",
    columns = everything()
  ) %>%
  tab_options(
    table.width = pct(90),
    heading.align = "center",
    table.font.size = px(12),
    data_row.padding = px(5)
  )

invisible(tabla_ranking_clientes_gt)

# ---------------------------------------------------------
# Principales determinantes del churn
# ---------------------------------------------------------

tabla_drivers <- tabla_modelo_final %>%
  filter(Variable != "(Intercept)") %>%
  mutate(
    Impacto = abs(Coeficiente),
    Direccion = ifelse(
      Coeficiente > 0,
      "Aumenta la probabilidad de churn",
      "Reduce la probabilidad de churn"
    )
  ) %>%
  arrange(desc(Impacto)) %>%
  select(Variable, Coeficiente, Odds_Ratio, `Valor p`, Direccion)

tabla_drivers_gt <- tabla_drivers %>%
  gt() %>%
  tab_header(
    title = md("**Principales Determinantes del Churn**")
  ) %>%
  fmt_number(
    columns = c(Coeficiente, Odds_Ratio, `Valor p`),
    decimals = 6
  ) %>%
  cols_align(
    align = "center",
    columns = c(Variable, Coeficiente, Odds_Ratio, `Valor p`)
  ) %>%
  tab_options(
    table.width = pct(100),
    heading.align = "center",
    table.font.size = px(12),
    data_row.padding = px(6)
  )

invisible(tabla_drivers_gt)
