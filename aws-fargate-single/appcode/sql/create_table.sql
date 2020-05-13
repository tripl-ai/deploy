CREATE EXTERNAL TABLE IF NOT EXISTS ${table_name}
(
  `lpep_pickup_datetime` timestamp, 
  `lpep_dropoff_datetime` timestamp, 
  `store_and_fwd_flag` boolean, 
  `rate_code_id` int, 
  `pickup_longitude` decimal(18,14), 
  `pickup_latitude` decimal(18,14), 
  `dropoff_longitude` decimal(18,14), 
  `dropoff_latitude` decimal(18,14), 
  `passenger_count` int, 
  `trip_distance` decimal(18,15), 
  `fare_amount` decimal(10,2), 
  `extra` decimal(10,2), 
  `mta_tax` decimal(10,2), 
  `tip_amount` decimal(10,2), 
  `tolls_amount` decimal(10,2), 
  `ehail_fee` decimal(10,2), 
  `total_amount` decimal(10,2), 
  `payment_type` int, 
  `trip_type` int
)
PARTITIONED BY ( `vendor_id` int)
ROW FORMAT SERDE 'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe'
STORED AS INPUTFORMAT 'org.apache.hadoop.hive.ql.io.SymlinkTextInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION ${datalake_loc}
TBLPROPERTIES (
  'classification'='parquet',
  'parquet.compress'='SNAPPY'
  )
