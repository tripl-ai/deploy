SELECT count("_index") AS pickup_cnt
,sum(Passenger_count) AS Passenger_count
,pickup_longitude
,pickup_latitude
FROM ${inputView}
WHERE pickup_longitude is not null
GROUP BY pickup_longitude, pickup_latitude
ORDER BY 1 DESC
