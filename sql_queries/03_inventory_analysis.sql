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
SET
    comments = NULL
WHERE
    process_status = &vprocess_ind;

COMMIT;


-- =========================================
-- Escenario 1
-- RIL configurado correctamente
-- Scenario 1
-- RIL correctly configured
-- =========================================

UPDATE /*+ parallel(8) */ retail_analysis.item_location_analysis
SET
    comments = 'RIL configurado RMSv10'
WHERE
    ( item_id, location_id ) IN (
        SELECT
            ilm.item_id, ilm.location_id
        FROM
                 retail_analysis.item_location_analysis ilm
            INNER JOIN retail_master.item_location             il16 ON ilm.item_id = il16.item_id
                                                           AND ilm.location_id = il16.location_id
            INNER JOIN legacy_retail.item_location             il10 ON ilm.item_id = il10.item_id
                                                           AND ilm.location_id = il10.location_id
            INNER JOIN retail_master.item_location_replication ril16 ON ilm.item_id = ril16.item_id
                                                                        AND ilm.location_id = ril16.location_id
            INNER JOIN legacy_retail.item_location_replication ril10 ON ilm.item_id = ril10.item_id
                                                                        AND ilm.location_id = ril10.location_id
        WHERE
                ilm.process_status = &vprocess_ind
            AND ril16.deactivation_date IS NULL
            AND ril10.deactivation_date IS NULL
            AND il16.status = 'A'
            AND il10.status = 'A'
    )
    AND process_status = &vprocess_ind;

COMMIT;


-- =========================================
-- Escenario 2
-- Pendiente en pipeline
-- Scenario 2
-- Pending replication in pipeline
-- =========================================

UPDATE /*+ parallel(8) */ retail_analysis.item_location_analysis
SET
    comments = 'Pendiente Pipeline RMSv16'
WHERE
    ( item_id, location_id ) IN (
        SELECT DISTINCT
            ilm.item_id, ilm.location_id
        FROM
                 retail_analysis.item_location_analysis ilm
            INNER JOIN retail_master.item_location               il16 ON ilm.item_id = il16.item_id
                                                           AND ilm.location_id = il16.location_id
            INNER JOIN retail_pipeline.replication_stage_monitor xx ON ilm.item_id = xx.item_id
                                                                       AND ilm.location_id = xx.location_id
        WHERE
                ilm.process_status = &vprocess_ind
            AND comments IS NULL
            AND il16.status = 'A'
            AND ( xx.attempts < 300
                  OR xx.attempts IS NULL )
    )
    AND process_status = &vprocess_ind;

COMMIT;


-- =========================================
-- Escenario 3
-- Tienda cerrada
-- Scenario 3
-- Closed store location
-- =========================================

UPDATE retail_analysis.item_location_analysis
SET
    comments = 'Tienda Cerrada'
WHERE
    location_id IN (
        SELECT
            store_id
        FROM
            retail_master.store
        WHERE
            store_close_date IS NOT NULL
    )
    AND process_status = &vprocess_ind
    AND comments IS NULL;

COMMIT;


-- =========================================
-- Escenario 4
-- Sin registro en STG
-- Scenario 4
-- Missing staging record
-- =========================================

UPDATE retail_analysis.item_location_analysis
SET
    comments = 'Sin STG RMSv16'
WHERE
    ( item_id, location_id ) IN (
        SELECT
            ilm.item_id, ilm.location_id
        FROM
            retail_analysis.item_location_analysis ilm
            LEFT JOIN (
                SELECT
                    *
                FROM
                    retail_pipeline.stg_replication_data
                WHERE
                    message_id IN (
                        SELECT
                            MAX(message_id)
                        FROM
                            retail_pipeline.stg_replication_data
                        GROUP BY
                            item_id, location_id
                    )
            )                                      sra ON sra.item_id = ilm.item_id
                     AND sra.location_id = ilm.location_id
        WHERE
                ilm.process_status = &vprocess_ind
            AND comments IS NULL
            AND sra.item_id IS NULL
    )
    AND process_status = &vprocess_ind;

COMMIT;
