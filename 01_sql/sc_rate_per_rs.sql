SELECT
  kabupaten,
  jenis_faskes,
  provider_id,
  provider_name,
  COUNT(*) AS total,
  SUM(CASE WHEN jenis_persalinan = 'SC' THEN 1 ELSE 0 END) AS total_sc,
  SAFE_DIVIDE(
    SUM(CASE WHEN jenis_persalinan = 'SC' THEN 1 ELSE 0 END),
    COUNT(*)
  ) AS sc_rate
FROM `bpjs-kediri.mart_prod.persalinan_all`
WHERE jenis_faskes = 'RS'
GROUP BY 
    kabupaten,
    jenis_faskes,
    provider_id,
    provider_name
HAVING COUNT(*) > 30
ORDER BY sc_rate DESC;