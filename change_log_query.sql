SELECT
  t.*,
  CASE
    WHEN t.expiry_date='9999-12-30' THEN NULL
  ELSE
  DATE_DIFF(t.expiry_date, t.create_date, DAY)
END
  AS days
FROM (
  SELECT
    cl.supplier_id,
    cl.supplier_name,
    cl.cargo_provider AS previous_outbound_cargo_provider,
    cl.rate AS previous_rate,
    LEAD(cl.cargo_provider, 1, '-1') OVER (PARTITION BY cl.supplier_id ORDER BY cl.create_date ASC) AS outbound_cargo_provider,
    LEAD(CAST(cl.rate AS string), 1, '0') OVER (PARTITION BY cl.supplier_id ORDER BY cl.create_date ASC) AS rate,
    MIN( cl.create_date ) OVER (PARTITION BY cl.supplier_id, cl.cargo_provider, rate, expiry_date) AS create_date,
    MAX(cl.expiry_date) OVER (PARTITION BY cl.supplier_id, cl.cargo_provider, rate, create_date) AS expiry_date
  FROM
    `project_name.schema_name.seller_cargo_providers` cl
    )t
ORDER BY
  t.create_date;