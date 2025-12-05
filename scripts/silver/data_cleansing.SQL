WITH latest AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
    FROM bronze.crm_cust_info
    WHERE cst_id IS NOT NULL
)

SELECT
    cst_id,
    cst_key,
    TRIM(cst_firstname) AS cst_firstname,
    TRIM(cst_lastname) AS cst_lastname,

    CASE 
        WHEN UPPER(cst_material_status) = 'S' THEN 'Single'
        WHEN UPPER(cst_material_status) = 'M' THEN 'Married'
        ELSE 'N/A'
    END AS cst_material_status,

    CASE 
        WHEN UPPER(cst_gndr) = 'F' THEN 'Female'
        WHEN UPPER(cst_gndr) = 'M' THEN 'Male'
        ELSE 'N/A'
    END AS cst_gndr,

    cst_create_date

FROM latest
WHERE flag_last = 1;
