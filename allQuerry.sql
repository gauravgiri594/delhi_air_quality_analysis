SELECT * FROM air_quality_data
LIMIT 25;

-- let see most polluted locatiions 
SELECT 
	locations,
	ROUND(AVG(values)::numeric,2) as avg_pollution
FROM air_quality_data
GROUP BY 1
ORDER BY 2 DESC;

-- let see peak pollution hours
SELECT 
	locations,
	hour,
	ROUND(AVG(values)::numeric,2) avg_vaue
FROM air_quality_data
GROUP BY 1,2
ORDER BY 1;

-- let see wors pollutant parameter
SELECT 
	parameters,
	ROUND(AVG(values)::numeric,2) as avg_values
FROM air_quality_data
GROUP BY 1
ORDER BY 2 DESC;

-----------------------------------------
-- now lets analyse some trendy questions
-----------------------------------------
-- which hour of the day have the highest or lowest pollution
SELECT 
	locations,
	hour,
	AVG(values) as avg_pollution,
	RANK() OVER(ORDER BY AVG(values) DESC) AS pollution_rank
FROM air_quality_data
GROUP BY 1,2
ORDER BY 4;

-- How much did the pollutant level change compared to the previous reading?

SELECT 
	datetime,
	values,
	LAG(values,1) OVER(PARTITION BY locations, parameters ORDER BY datetime) as previous_value,
	ROUND((values - LAG(values,1) OVER(PARTITION BY locations, parameters ORDER BY datetime))::numeric,2) as value_change
FROM air_quality_data;

-- What are the maximum and minimum pollution levels recorded for each hour?
SELECT 
	date,
	hour,
	MIN(values) as min_pollution,
	MAX(values) as max_pollution,
	ROUND((MAX(values) - MIN(values))::numeric,2) as variance
FROM air_quality_data 
GROUP BY 1,2
ORDER BY 1,2;

-- Which records exceeded a specific safety threshold(safe air ppb value)
SELECT
	datetime,
	locations,
	parameters,
	values,
	units
FROM air_quality_data
WHERE values > 85.0
ORDER BY values DESC;

-- Which pollutant exceeded its safe limit most often?
SELECT 
	parameters,
	COUNT(*) AS total_readings,
	COUNT(*) FILTER (WHERE
	(parameters = 'pm25' AND values::numeric > 60)
	OR(parameters = 'pm10' AND values::numeric > 100)
	OR(parameters = 'no2' AND values::numeric > 80)
	OR(parameters = 'co' AND values::numeric > 2000)
	OR(parameters = 'O3' AND values::numeric > 100)
	) AS exceedences,
	ROUND(	
	100.0 * COUNT(*) FILTER (WHERE
	(parameters = 'pm25' AND values::numeric > 60)
	OR(parameters = 'pm10' AND values::numeric > 100)
	OR(parameters = 'no2' AND values::numeric > 80)
	OR(parameters = 'co' AND values::numeric > 350)
	OR(parameters = 'O3' AND values::numeric > 100)	
	) / NULLIF(COUNT(*),0), 1
	) AS exceeding_pct
FROM air_quality_data
GROUP BY 1
ORDER BY 3 DESC;






