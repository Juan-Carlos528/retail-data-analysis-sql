-- =====================================================
-- INVENTORY SCENARIO CLASSIFICATION
-- CLASIFICACIÓN DE ESCENARIOS DE INVENTARIO
-- =====================================================

DEFINE vprocess_ind = "'D'";

-- =====================================================
-- RESET COMMENTS
-- LIMPIEZA INICIAL DE COMENTARIOS
-- =====================================================

UPDATE retail_analysis.item_location_analysis
SET
    comments = NULL
WHERE
    process_status = &vprocess_ind;

COMMIT;

-- =====================================================
-- ESCENARIO 1: RIL CONFIGURADO CORRECTAMENTE
-- SCENARIO 1: CORRECT RIL CONFIGURATION
-- =====================================================

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

-- =====================================================
-- ESCENARIO 2: PENDIENTE EN PIPELINE
-- SCENARIO 2: PENDING IN PIPELINE
-- =====================================================

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

-- =====================================================
-- ESCENARIO 3: TIENDA CERRADA
-- SCENARIO 3: CLOSED STORE
-- =====================================================

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

-- =====================================================
-- ESCENARIO 4: SIN STG
-- SCENARIO 4: MISSING STAGING RECORD
-- =====================================================

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

-- =====================================================
-- ESCENARIO 5: ERROR EN STG
-- SCENARIO 5: STAGING ERROR
-- =====================================================

UPDATE retail_analysis.item_location_analysis
SET
    comments = 'Error STG RMSv16'
WHERE
    ( item_id, location_id ) IN (
        SELECT
            ilm.item_id, ilm.location_id
        FROM
                 retail_analysis.item_location_analysis ilm
            INNER JOIN (
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
            ) sra ON sra.item_id = ilm.item_id
                     AND sra.location_id = ilm.location_id
        WHERE
                ilm.process_status = &vprocess_ind
            AND comments IS NULL
            AND sra.process_ind = 'E'
    )
    AND process_status = &vprocess_ind;

COMMIT;

-- =====================================================
-- ESCENARIO 6: STATUS INACTIVO EN RMSv16
-- SCENARIO 6: INACTIVE STATUS IN RMSv16
-- =====================================================

UPDATE retail_analysis.item_location_analysis
SET
    comments = 'Inactivo RMSv16'
WHERE
    ( item_id, location_id ) IN (
        SELECT
            ilm.item_id, ilm.location_id
        FROM
                 retail_analysis.item_location_analysis ilm
            INNER JOIN retail_master.item_location il16 ON ilm.item_id = il16.item_id
                                                           AND ilm.location_id = il16.location_id
        WHERE
                ilm.process_status = &vprocess_ind
            AND comments IS NULL
            AND il16.status <> 'A'
    )
    AND process_status = &vprocess_ind;

COMMIT;

-- =====================================================
-- ESCENARIO 7: NO EXISTE EN RMSv10
-- SCENARIO 7: MISSING IN RMSv10
-- =====================================================

UPDATE retail_analysis.item_location_analysis
SET
    comments = 'No existe RMSv10'
WHERE
    ( item_id, location_id ) IN (
        SELECT
            ilm.item_id, ilm.location_id
        FROM
            retail_analysis.item_location_analysis ilm
            LEFT JOIN legacy_retail.item_location            il10 ON ilm.item_id = il10.item_id
                                                          AND ilm.location_id = il10.location_id
        WHERE
                ilm.process_status = &vprocess_ind
            AND comments IS NULL
            AND il10.item_id IS NULL
    )
    AND process_status = &vprocess_ind;

COMMIT;

-- =====================================================
-- ESCENARIO FINAL: SIN CLASIFICACIÓN
-- FINAL SCENARIO: UNCLASSIFIED
-- =====================================================

UPDATE retail_analysis.item_location_analysis
SET
    comments = 'Sin Clasificación'
WHERE
        process_status = &vprocess_ind
    AND comments IS NULL;

COMMIT;

-- =====================================================
-- RESUMEN FINAL DE ESCENARIOS
-- FINAL SCENARIO SUMMARY
-- =====================================================
--
-- Este query muestra la distribución de los registros
-- según el escenario asignado durante el análisis.
--
-- This query shows the distribution of records
-- based on the scenario assigned during the analysis.
-- =====================================================

SELECT
    comments AS scenario,
    COUNT(*) AS total_records
FROM
    retail_analysis.item_location_analysis
WHERE
    process_status = &vprocess_ind
GROUP BY
    comments
ORDER BY
    total_records DESC;
