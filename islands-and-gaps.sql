SELECT
    t.*,
    SUM(CASE
        WHEN prev_expiry_date = create_date THEN 0
      ELSE
      1
    END
      ) OVER (PARTITION BY supplier_id, cargo_provider ORDER BY create_date) AS island
  FROM (
    SELECT
      t.*,
      LAG(expiry_date) OVER (PARTITION BY supplier_id, cargo_provider ORDER BY create_date) AS prev_expiry_date
    FROM
     `project_name.schema_name.seller_cargo_providers` t 
     ) t
     order by create_date;