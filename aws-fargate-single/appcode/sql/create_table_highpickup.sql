CREATE EXTERNAL TABLE IF NOT EXISTS ${table_name}(
  `pickup_cnt` int, 
  `Passenger_count` int,
  `pickup_longitude` decimal(18,14), 
  `pickup_latitude` decimal(18,14)
 )
STORED AS PARQUET
LOCATION ${datalake_loc}
TBLPROPERTIES (
  'classification'='parquet',
  'parquet.compress'='SNAPPY'
  )
