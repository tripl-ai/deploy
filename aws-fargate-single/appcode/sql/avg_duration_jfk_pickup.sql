SELECT CAST(avg(trip_duration) as DECIMAL(18,2)) AS avg_trip_duration, HOUR(lpep_pickup_datetime) AS pickup_hour
FROM
(
  SELECT (unix_timestamp(lpep_dropoff_datetime) - unix_timestamp(lpep_pickup_datetime))/60 AS trip_duration
        ,lpep_pickup_datetime
        ,lpep_dropoff_datetime
  FROM ${inputView}
  WHERE dropoff_latitude BETWEEN 40.640668 AND 40.651381
  AND dropoff_longitude BETWEEN -73.794694 AND -73.776283
 )
GROUP BY 2
ORDER BY 1