-- =====================================================
-- DATA VALIDATION / VALIDACIÓN DE DATOS
-- =====================================================
-- Este script permite insertar registros manualmente
-- para validar escenarios específicos del análisis.
--
-- This script allows inserting records manually
-- to validate specific analysis scenarios.
-- =====================================================


INSERT ALL

INTO retail_analysis.item_location_analysis
    (ITEM_ID, LOCATION_ID, LOCATION_TYPE, PROCESS_STATUS)

VALUES
    ('7501073831964',16768,'S','D')

SELECT * FROM DUAL;
