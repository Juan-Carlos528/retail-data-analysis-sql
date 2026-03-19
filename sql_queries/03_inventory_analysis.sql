-- =====================================================
-- INVENTORY SCENARIO CLASSIFICATION
-- CLASIFICACIÓN DE ESCENARIOS DE INVENTARIO
-- =====================================================
--
-- Este script analiza inconsistencias entre dos sistemas
-- de inventario y clasifica los registros según
-- diferentes escenarios de replicación de datos.
--
-- This script analyzes inconsistencies between two
-- inventory systems and classifies records according
-- to different data replication scenarios.
-- =====================================================

DEFINE vprocess_ind = "'D'";


-- =========================================
-- Reset de comentarios previos
-- Reset previous analysis comments
-- =========================================

UPDATE retail_analysis.item_location_analysis
SET COMMENTS = NULL
WHERE PROCESS_STATUS = &vprocess_ind;

COMMIT;



-- =========================================
-- Escenario 1
-- RIL configurado correctamente
-- Scenario 1
-- RIL correctly configured
-- =========================================

UPDATE /*+ parallel(8) */ retail_analysis.item_location_analysis
SET COMMENTS = 'RIL configurado RMSv10'

WHERE (ITEM_ID, LOCATION_ID) IN (

SELECT
    ilm.ITEM_ID,
    ilm.LOCATION_ID

FROM retail_analysis.item_location_analysis ilm

INNER JOIN retail_master.item_location il16
ON ilm.ITEM_ID = il16.ITEM_ID
AND ilm.LOCATION_ID = il16.LOCATION_ID

INNER JOIN legacy_retail.item_location il10
ON ilm.ITEM_ID = il10.ITEM_ID
AND ilm.LOCATION_ID = il10.LOCATION_ID

INNER JOIN retail_master.item_location_replication ril16
ON ilm.ITEM_ID = ril16.ITEM_ID
AND ilm.LOCATION_ID = ril16.LOCATION_ID

INNER JOIN legacy_retail.item_location_replication ril10
ON ilm.ITEM_ID = ril10.ITEM_ID
AND ilm.LOCATION_ID = ril10.LOCATION_ID

WHERE ilm.PROCESS_STATUS = &vprocess_ind
AND ril16.DEACTIVATION_DATE IS NULL
AND ril10.DEACTIVATION_DATE IS NULL
AND il16.STATUS = 'A'
AND il10.STATUS = 'A'

)

AND PROCESS_STATUS = &vprocess_ind;

COMMIT;



-- =========================================
-- Escenario 2
-- Pendiente en pipeline
-- Scenario 2
-- Pending replication in pipeline
-- =========================================

UPDATE /*+ parallel(8) */ retail_analysis.item_location_analysis
SET COMMENTS = 'Pendiente Pipeline RMSv16'

WHERE (ITEM_ID, LOCATION_ID) IN (

SELECT DISTINCT
ilm.ITEM_ID,
ilm.LOCATION_ID

FROM retail_analysis.item_location_analysis ilm

INNER JOIN retail_master.item_location il16
ON ilm.ITEM_ID = il16.ITEM_ID
AND ilm.LOCATION_ID = il16.LOCATION_ID

INNER JOIN retail_pipeline.replication_stage_monitor xx
ON ilm.ITEM_ID = xx.ITEM_ID
AND ilm.LOCATION_ID = xx.LOCATION_ID

WHERE ilm.PROCESS_STATUS = &vprocess_ind
AND COMMENTS IS NULL
AND il16.STATUS = 'A'
AND (xx.ATTEMPTS < 300 OR xx.ATTEMPTS IS NULL)

)

AND PROCESS_STATUS = &vprocess_ind;

COMMIT;



-- =========================================
-- Escenario 3
-- Tienda cerrada
-- Scenario 3
-- Closed store location
-- =========================================

UPDATE retail_analysis.item_location_analysis
SET COMMENTS = 'Tienda Cerrada'

WHERE LOCATION_ID IN (

SELECT STORE_ID
FROM retail_master.store
WHERE STORE_CLOSE_DATE IS NOT NULL

)

AND PROCESS_STATUS = &vprocess_ind
AND COMMENTS IS NULL;

COMMIT;



-- =========================================
-- Escenario 4
-- Sin registro en STG
-- Scenario 4
-- Missing staging record
-- =========================================

UPDATE retail_analysis.item_location_analysis
SET COMMENTS = 'Sin STG RMSv16'

WHERE (ITEM_ID, LOCATION_ID) IN (

SELECT
ilm.ITEM_ID,
ilm.LOCATION_ID

FROM retail_analysis.item_location_analysis ilm

LEFT JOIN (

SELECT *
FROM retail_pipeline.stg_replication_data
WHERE MESSAGE_ID IN (
SELECT MAX(MESSAGE_ID)
FROM retail_pipeline.stg_replication_data
GROUP BY ITEM_ID, LOCATION_ID
)

) sra

ON sra.ITEM_ID = ilm.ITEM_ID
AND sra.LOCATION_ID = ilm.LOCATION_ID

WHERE ilm.PROCESS_STATUS = &vprocess_ind
AND COMMENTS IS NULL
AND sra.ITEM_ID IS NULL

)

AND PROCESS_STATUS = &vprocess_ind;

COMMIT;
