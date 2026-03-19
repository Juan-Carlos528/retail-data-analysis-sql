# Retail Inventory Data Analysis

![SQL](https://img.shields.io/badge/SQL-Queries-blue?logo=postgresql&logoColor=white)
![Excel](https://img.shields.io/badge/Excel-Data%20Validation-green?logo=microsoft-excel&logoColor=white)
![Database](https://img.shields.io/badge/Database-Relational-orange?logo=databricks&logoColor=white)
![Project](https://img.shields.io/badge/Project-Portfolio-blueviolet?logo=github&logoColor=white)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen?logo=checkmarx&logoColor=white)

---

## 📊 Project Overview / Descripción del Proyecto

This project analyzes inventory inconsistencies between two retail systems and identifies data replication issues across item-location records.

Este proyecto analiza inconsistencias de inventario entre dos sistemas retail e identifica problemas de replicación de datos entre producto y ubicación.

The analysis classifies records into different operational scenarios based on data conditions.

El análisis clasifica los registros en diferentes escenarios operativos según su condición en los sistemas.

Initial data validation and exploratory review were performed using Excel before executing SQL analysis.

La validación inicial y el análisis exploratorio se realizaron en Excel antes de ejecutar los scripts SQL.

---

## 💼 Business Problem / Problema de Negocio

Retail systems rely on accurate data replication between platforms. When failures occur, they can cause:

Los sistemas retail dependen de la correcta replicación de datos. Cuando esto falla, puede provocar:

- Missing product availability  
- Incorrect inventory status  
- Data inconsistencies  
- Failed replication processes  

This project simulates a real-world data troubleshooting scenario.

Este proyecto simula un caso real de análisis y solución de problemas de datos.

---

## 📂 Project Structure

retail-inventory-data-analysis

│

├── README.md

│

└── sql_queries

│

├── 01_data_exploration.sql

├── 02_data_validation.sql

├── 03_inventory_analysis.sql

└── 04_query_optimization.sql

---

## ⚙️ SQL Scripts Description / Descripción de Scripts

### 1️⃣ Data Exploration
Explores records before analysis.  
Explora los datos antes del análisis.

---

### 2️⃣ Data Validation
Inserts test records to validate scenarios.  
Inserta datos para validar escenarios.

---

### 3️⃣ Inventory Scenario Classification (MAIN SCRIPT)

Main logic of the project.

Script principal del proyecto.

Classifies records into scenarios such as:

Clasifica registros en escenarios como:

- Correct replication configuration  
- Pending pipeline processing  
- Closed store locations  
- Missing staging data  
- Replication errors  
- Inactive records  
- Missing records in legacy system  

---

### 📊 Scenario Summary (NEW)

At the end of the analysis, a summary query provides a distribution of all classified scenarios.

Al final del análisis, se incluye un query que muestra la distribución de todos los escenarios detectados.

This allows quick identification of the most frequent issues in the system.

Esto permite identificar rápidamente los problemas más frecuentes.

---

### 4️⃣ Query Optimization / Data Recovery

Identifies failed records in the pipeline and resets them for reprocessing.

Identifica registros con error y los reinicia para reproceso.

---

## 📈 Key Insights / Hallazgos Clave

- Data replication issues can occur at multiple stages of the pipeline  
- Missing staging data is a common source of inconsistency  
- Store status impacts inventory visibility  
- Scenario classification helps prioritize data fixes  
- Aggregated results allow quick identification of major issues  

---

## 🛠 Technologies Used / Tecnologías

- SQL  
- Excel (Data Validation, Data Cleaning)  
- Relational Databases  
- Data Analysis  
- ETL Troubleshooting 

---

## 🔮 Future Improvements / Mejoras Futuras

- Build dashboard to visualize scenario distribution  
- Automate anomaly detection  
- Implement monitoring alerts  
- Integrate with BI tools  

---

## ⚠️ Disclaimer

This project is a simulated case study inspired by real-world data engineering challenges.

Este proyecto es un caso simulado basado en problemas reales de ingeniería de datos.

All structures and names have been anonymized.

---

## 👤 Author

Juan Carlos Cardona

Aspiring Data Scientist  

GitHub: https://github.com/Juan-Carlos528 
LinkedIn: https://linkedin.com/in/juan-carlos-cardona-alvarado
