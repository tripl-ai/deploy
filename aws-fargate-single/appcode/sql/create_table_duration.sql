CREATE EXTERNAL TABLE IF NOT EXISTS ${table_name}(
  `avg_trip_duration` decimal(18,2)
  ,`pickup_hour` int
  )
STORED AS PARQUET
LOCATION ${datalake_loc}
TBLPROPERTIES (
  'classification'='parquet',
  'parquet.compress'='SNAPPY'
  )