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