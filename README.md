This project identifies which air pollutants frequently exceed safe health limits in Delhi by combining SQL-based breach detection, Python data processing, and interactive Plotly charts to visualize exceedance patterns across monitoring stations.

```SQL Query 1: Identifying Most Polluted Locations
SELECT 
	locations,
	ROUND(AVG(values)::numeric,2) as avg_pollution
FROM air_quality_data
GROUP BY 1
ORDER BY 2 DESC;
```
### Purpose
This query calculates the average pollution level for each monitoring location across all recorded readings, ranking them from most to least polluted to identify the city's air quality hotspots.

Key Findings / Conclusion
Anand Vihar emerges as Delhi's most polluted location with the highest average pollution levels, followed closely by Punjabi Bagh and Vivek Vihar. These areas, known for their heavy traffic intersections and industrial clusters, consistently record pollution levels 2-3x higher than cleaner residential zones like Jawaharlal Nehru Stadium.
Visual Result Example
"Anand Vihar"	67.61
"R K Puram"	60.22
"Punjabi Bagh"	55.84
"Pusa"	36.44
