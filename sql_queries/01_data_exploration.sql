-- =====================================================
-- DATA EXPLORATION / EXPLORACIÓN DE DATOS
-- Proyecto: Retail Inventory Data Analysis
-- Objetivo / Objective:
-- Explorar registros antes de ejecutar el análisis de escenarios.
-- Explore records before running the scenario classification.
-- =====================================================


-- =========================================
-- Registros pendientes de análisis
-- Records pending analysis
-- =========================================

SELECT *
FROM retail_analysis.item_location_analysis
WHERE PROCESS_STATUS = 'D';



-- =========================================
-- Conteo de registros por estado
-- Record count by process status
-- =========================================

SELECT
    PROCESS_STATUS,
    COUNT(*) AS total_records
FROM retail_analysis.item_location_analysis
GROUP BY PROCESS_STATUS
ORDER BY total_records DESC;



-- =========================================
-- Cantidad de locations por item
-- Number of locations per item
-- =========================================

SELECT
    ITEM_ID,
    COUNT(LOCATION_ID) AS total_locations
FROM retail_analysis.item_location_analysis
GROUP BY ITEM_ID
ORDER BY total_locations DESC;



-- =========================================
-- Revisión de comentarios generados
-- Review generated comments
-- =========================================

SELECT
    COMMENTS,
    COUNT(*) AS occurrences
FROM retail_analysis.item_location_analysis
WHERE COMMENTS IS NOT NULL
GROUP BY COMMENTS
ORDER BY occurrences DESC;
