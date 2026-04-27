# Caso Predicting Customer Churn  

Este repositorio contiene el desarrollo y la resolución del caso **“Predicting Customer Churn”**, realizado en el marco del curso **Analítica de los Negocios**.  

Datos y archivos de réplica para el análisis del caso por:  

**David Santiago Aguirre Polanco**  
**María Juanita Rojas Chacón**  
**Andrés Felipe Romero Rodríguez**  

--------------------------------------------------  

# **Resumen**  

El caso *Predicting Customer Churn* analiza la deserción de clientes en la empresa QWE Inc. desde una perspectiva analítica, con el objetivo de identificar los factores que influyen en la probabilidad de abandono. En particular, se estudia cómo distintos elementos relacionados con el comportamiento del cliente, el uso del servicio y la experiencia con el soporte impactan la decisión de continuar o cancelar la suscripción.  

A partir de un conjunto de datos que incluye información de clientes activos, se realiza un análisis cuantitativo para evaluar variables clave y construir modelos predictivos de churn. Este análisis busca determinar qué características pueden aumentar o reducir la probabilidad de deserción y, por ende, apoyar la toma de decisiones estratégicas en retención de clientes.  

El análisis incluye el estudio de variables como:  

- Customer Age (Antigüedad del cliente)  
- CHI Score (Indicador de satisfacción del cliente)  
- Support Cases (Casos de soporte)  
- Support Priority (Prioridad de soporte)  
- Logins (Número de accesos)  
- Blog Articles (Artículos consultados)  
- Views (Interacciones o visualizaciones)  
- Days Since Last Login (Días desde el último acceso)  
- Cambios en comportamiento entre periodos  
- Churn (Deserción del cliente)  

A través de estadísticas descriptivas, modelos de probabilidad para variable binaria (MPL, logit y probit), análisis de errores y matriz de confusión, se busca comprender los determinantes de la deserción y evaluar la capacidad predictiva de los modelos.  

--------------------------------------------------  

# **Estructura del repositorio**  

El repositorio está organizado en las siguientes carpetas:  

--------------------------------------------------  

# **Carpeta Document**  

Esta carpeta contiene los documentos finales relacionados con el análisis del caso.  

**Archivos incluidos:**  

- **Caso Predicting Customer Churn.pdf**  

Documento principal donde se presenta el desarrollo completo del análisis del caso. Este documento incluye la exploración de los datos, el análisis estadístico realizado, la construcción de modelos de probabilidad, la evaluación del desempeño del modelo y las conclusiones sobre los factores que influyen en la deserción de clientes.  

- **Resumen Ejecutivo. Caso Predicting Customer Churn.pdf**  

Documento que presenta una síntesis de los hallazgos más relevantes del análisis. En este resumen se destacan las conclusiones clave relacionadas con los determinantes del churn y las implicaciones para la toma de decisiones en estrategias de retención de clientes.  

--------------------------------------------------  

# **Carpeta Scripts**  

Esta carpeta contiene el código utilizado para desarrollar el análisis de datos.  

El análisis fue realizado utilizando el software **R**.  

**Archivo incluido:**  

- **Caso Predicting Customer Churn.R**  

Este script incluye:  

- Preparación y limpieza de los datos  
- Cálculo de estadísticas descriptivas  
- Estimación de modelos de probabilidad (MPL, logit y probit)  
- Evaluación del modelo (R², matriz de confusión y errores)  
- Generación de gráficos y tablas  
- Análisis de relaciones entre variables  

--------------------------------------------------  

# **Carpeta Stores**  

Esta carpeta contiene las bases de datos utilizadas para el análisis.  

**Archivos incluidos:**  

- **Predicting_Customer_Churn.xls**  

Este archivo contiene la información utilizada en el caso, incluyendo datos sobre:  

- Antigüedad del cliente  
- Indicador de satisfacción (CHI)  
- Casos de soporte y prioridad  
- Uso del servicio (logins, artículos, vistas)  
- Actividad reciente del cliente  
- Cambios en comportamiento entre periodos  
- Variable de deserción (churn)  

Estos datos constituyen la base para el análisis estadístico y la construcción de los resultados obtenidos.  

--------------------------------------------------  

# **Carpeta Views**  

Esta carpeta contiene todas las **figuras, tablas y gráficos generados durante el análisis**.  

Entre las visualizaciones incluidas se encuentran:  

- Gráficos de distribución de variables clave  
- Diagramas de dispersión entre variables  
- Comparaciones entre clientes con churn y sin churn  
- Resultados visuales de modelos de probabilidad  
- Tablas de estadísticas descriptivas  
- Matriz de confusión y métricas de desempeño  

Estas ilustraciones permiten interpretar y comunicar de manera clara los resultados obtenidos en el análisis.  

--------------------------------------------------  

# **Notas**  

Para ejecutar correctamente el análisis se recomienda utilizar **R o RStudio**.  

Antes de ejecutar los scripts es recomendable:  

1. Configurar el directorio de trabajo en la carpeta **Scripts** del repositorio.  
2. Verificar que todos los paquetes necesarios estén previamente instalados.  
3. Ejecutar los scripts siguiendo el orden indicado en el código.  

La velocidad de ejecución puede variar dependiendo de las características del equipo en el que se ejecuten los scripts.
