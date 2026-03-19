# Retail Inventory Data Analysis

![SQL](https://img.shields.io/badge/SQL-Data%20Analysis-blue)
![Database](https://img.shields.io/badge/Database-Relational-orange)
![Project](https://img.shields.io/badge/Project-Portfolio-green)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen)

## Project Overview / Descripción del Proyecto

This project analyzes inventory inconsistencies between two retail inventory systems and identifies data replication issues across item-location records.

Este proyecto analiza inconsistencias de inventario entre dos sistemas de inventario retail e identifica problemas de replicación de datos entre registros de producto y ubicación.

The analysis classifies records into different scenarios such as:

El análisis clasifica los registros en diferentes escenarios como:

- Correctly replicated inventory records
- Pending data pipeline processing
- Missing staging records
- Replication errors
- Store closure scenarios
- Status inconsistencies between systems

---

# Business Problem / Problema de Negocio

Retail inventory systems often synchronize product availability across multiple locations. When data replication pipelines fail or become inconsistent, this can lead to:

Los sistemas de inventario retail sincronizan productos entre múltiples ubicaciones. Cuando fallan los pipelines de replicación de datos pueden ocurrir problemas como:

- Missing product availability
- Incorrect inventory status
- Data inconsistencies between systems
- Failed data replication processes

This project simulates a real-world investigation of such issues using SQL queries and scenario classification logic.

Este proyecto simula una investigación real de estos problemas utilizando consultas SQL y lógica de clasificación de escenarios.

---

# Project Structure / Estructura del Proyecto


---

# SQL Scripts Description / Descripción de Scripts

## 1️⃣ Data Exploration

Purpose:

Explores the dataset before running the analysis.

Propósito:

Explorar los datos antes de ejecutar el análisis de escenarios.

Main tasks:

- Identify records pending analysis
- Analyze process status distribution
- Review existing error comments
- Analyze item-location relationships

---

## 2️⃣ Data Validation

Purpose:

Allows inserting sample records to test different scenarios.

Propósito:

Permite insertar registros de prueba para validar distintos escenarios de análisis.

---

## 3️⃣ Inventory Scenario Classification

This is the main script of the project.

Este es el script principal del proyecto.

The script classifies records into different operational scenarios including:

El script clasifica los registros en distintos escenarios operativos como:

- Correct replication configuration
- Pending pipeline processing
- Closed store locations
- Missing staging records
- Data replication errors
- Status inconsistencies between inventory systems

The script uses:

El script utiliza:

- Complex JOINs
- Conditional classification logic
- Update operations for scenario labeling
- Performance hints

---

## 4️⃣ Query Optimization / Data Pipeline Recovery

Purpose:

Identify and reset records that failed during the replication pipeline.

Propósito:

Identificar registros con error en el pipeline y reiniciarlos para reprocesamiento.

---

# Skills Demonstrated / Habilidades Demostradas

SQL skills demonstrated in this project:

Habilidades SQL demostradas en este proyecto:

- Data exploration
- Data validation
- Complex SQL joins
- Data pipeline troubleshooting
- Scenario-based data classification
- Query optimization
- Data quality analysis
- ETL pipeline debugging

---

# Technologies Used / Tecnologías Utilizadas

- SQL
- Relational Databases
- Data Analysis
- Data Pipeline Monitoring
- ETL Troubleshooting

---

# Key Insights / Hallazgos Clave

During the analysis several possible data issues were identified:

Durante el análisis se identificaron posibles problemas de datos:

- Replication delays between inventory systems
- Missing staging records in the data pipeline
- Closed store locations still referenced in inventory tables
- Replication errors causing inconsistent item availability
- Status mismatches between legacy and current inventory systems

This type of analysis helps data teams identify operational issues and maintain inventory accuracy.

# Key Insights / Hallazgos Clave

During the analysis several possible data issues were identified:

Durante el análisis se identificaron posibles problemas de datos:

- Replication delays between inventory systems
- Missing staging records in the data pipeline
- Closed store locations still referenced in inventory tables
- Replication errors causing inconsistent item availability
- Status mismatches between legacy and current inventory systems

This type of analysis helps data teams identify operational issues and maintain inventory accuracy.

# Disclaimer / Aviso

This project is a **simulated case study inspired by real-world data engineering and retail inventory challenges**.

Este proyecto es un **caso de estudio simulado inspirado en problemas reales de ingeniería de datos e inventarios retail**.

All table names, schemas, and structures have been anonymized for educational and portfolio purposes.

Todos los nombres de tablas, esquemas y estructuras han sido anonimizados para fines educativos y de portafolio.

---

# Author

Juan Carlos Cardona  

Aspiring Data Scientist  

GitHub: https://github.com/Juan-Carlos528

LinkedIn: https://linkedin.com/in/juan-carlos-cardona-alvarado
