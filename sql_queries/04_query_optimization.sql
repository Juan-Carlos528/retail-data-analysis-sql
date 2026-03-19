-- =====================================================
-- DATA PIPELINE RECOVERY
-- RECUPERACIÓN DE PIPELINE DE DATOS
-- =====================================================
--
-- Este script identifica registros con error en el
-- pipeline de replicación y los reinicia para su reproceso.
--
-- This script identifies records with errors in the
-- replication pipeline and resets them for reprocessing.
-- =====================================================

DEFINE vprocess_ind = "'D'";

-- =========================================
-- Identificar registros con error
-- Identify records with processing errors
-- =========================================

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
        WHERE
            ( item_id, location_id ) IN (
                SELECT
                    item_id, location_id
                FROM
                    retail_analysis.item_location_analysis
                WHERE
                        process_status = &vprocess_ind
                    AND comments LIKE '%Error STG RMSv16%'
            )
        GROUP BY
            item_id, location_id
        HAVING
            COUNT(1) >= 1
    )
    AND process_ind = &vprocess_ind;


-- =========================================
-- Reiniciar registros para reproceso
-- Reset records for reprocessing
-- =========================================

UPDATE (
    SELECT
        message_id,
        process_ind,
        process_date
    FROM
        retail_pipeline.stg_replication_data
    WHERE
        message_id IN (
            SELECT
                MAX(message_id)
            FROM
                retail_pipeline.stg_replication_data
            WHERE
                ( item_id, location_id ) IN (
                    SELECT
                        item_id, location_id
                    FROM
                        retail_analysis.item_location_analysis
                    WHERE
                            process_status = &vprocess_ind
                        AND comments LIKE '%Error STG RMSv16%'
                )
            GROUP BY
                item_id, location_id
            HAVING
                COUNT(1) >= 1
        )
) t
SET
    t.process_ind = 'N',
    t.process_date = NULL;

COMMIT;
