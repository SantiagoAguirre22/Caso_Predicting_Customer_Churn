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
