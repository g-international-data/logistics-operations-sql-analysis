/* 1.How many trucks, trailers, drivers, customers, and facilities are in the database? */
SELECT COUNT(DISTINCT truck_id) FROM trucks;
SELECT COUNT(DISTINCT trailer_id) FROM trailers;
SELECT COUNT(DISTINCT driver_id) FROM drivers;
SELECT COUNT(DISTINCT customer_id) FROM customers;
SELECT COUNT(DISTINCT facility_id) FROM facilities;

/* 2.How many drivers are currently represented in the drivers table, and how are they distributed 
by their employment status? */
SELECT 
	employment_status,
	COUNT(driver_id) AS employment_status_count
FROM drivers
GROUP BY 1
ORDER BY 1 ASC;

/* 3.What is the total distance traveled, average distance per trip, and longest trip recorded
in the trips table? */
SELECT 
	SUM(actual_distance_miles) AS total_distance_travelled_in_miles,
	ROUND(AVG(actual_distance_miles),1) AS average_distance_per_trip_in_miles,
	MAX(actual_duration_hours + idle_time_hours) AS longest_trip_recorded_in_hours
FROM trips;

/* 4.Which drivers completed the most trips? */
SELECT
	driver_id,
	COUNT(*) AS total_trips_completed
FROM trips
GROUP BY 1
ORDER BY 2 DESC
LIMIT 2;
-- OBSERVATION: No driver recorded for 1714 trips completed, which was the highest number of trips completed.

/* 5.Which trucks have the best average fuel efficiency (MPG) based on their recorded trips? */
SELECT
	truck_id,
	MAX(average_mpg) AS best_avg_fuel_efficiency
FROM trips
GROUP BY 1
ORDER BY 2 DESC;

/* 6.Which customers generated the highest number of loads? */
SELECT 
	customer_id,
	COUNT(*) AS highest_load_generated_by_customer
FROM loads
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

/* 7.Which trucks consumed the most fuel, and how does their fuel consumption compare with the distance they traveled? */
SELECT
    truck_id,
    SUM(fuel_gallons_used) AS total_fuel_used,
    SUM(actual_distance_miles) AS total_distance_traveled,
    SUM(fuel_gallons_used) / SUM(actual_distance_miles) AS fuel_per_mile
FROM trips
GROUP BY 1
ORDER BY 1 DESC
LIMIT 5;

/* 8.Rank drivers based on their total distance traveled and show their position within the overall driver population. */
SELECT  
	d.driver_id,
	d.first_name,
	d.last_name,
	SUM(t.actual_distance_miles) AS total_distance_travelled,
	RANK() OVER(ORDER BY SUM(t.actual_distance_miles) DESC) AS position_by_distance_travelled
FROM drivers d
INNER JOIN trips t
	ON d.driver_id = t.driver_id
GROUP BY 1,2,3;

/* 9.For each month, identify the drivers who recorded the highest number of trips. */
WITH driver_monthly_trip AS (
	SELECT
		driver_id,
		EXTRACT(MONTH FROM dispatch_date) AS monthly_trip,
		TO_CHAR(dispatch_date,'Month') AS month_name,
		COUNT(*) AS number_of_trip
	FROM trips
	WHERE driver_id IS NOT NULL
	GROUP BY 1,2,3
)
SELECT
	driver_id,
	month_name,
	number_of_trip,
	ROW_NUMBER() OVER(PARTITION BY monthly_trip ORDER BY number_of_trip DESC)
	AS driver_with_highest_number_of_trip_per_month
FROM driver_monthly_trip;

/* 10. How has the company's fuel cost and fuel price per gallon changed over time, 
and which locations experienced the highest fuel prices? */
SELECT
    DATE_TRUNC('month', purchase_date) AS each_month,
    SUM(total_cost) AS total_fuel_cost,
    SUM(gallons) AS total_gallons,
    SUM(total_cost) / SUM(gallons) AS price_per_gallon
FROM fuel_purchases
GROUP BY 1
ORDER BY 1;
-- which locations experienced the highest fuel prices?
SELECT
	location_city,
	location_state,
	SUM(total_cost) / SUM(gallons) AS price_per_gallon
FROM fuel_purchases
GROUP BY 1,2
ORDER BY 3 DESC;

/* 11. Which customers generate the highest total revenue, and what proportion of the company's overall 
load revenue comes from those customers? */
WITH customer_revenue AS (
    SELECT
        customer_id,
        SUM(revenue) AS total_revenue
    FROM loads
    GROUP BY 1
)
SELECT
    customer_id,
    total_revenue,
    ROUND(total_revenue * 100.0 / SUM(total_revenue) OVER(), 2):: TEXT || '%' AS revenue_percentage
FROM customer_revenue
ORDER BY 3 DESC;

/* 12. Which loads experienced significant delays between their scheduled and actual delivery times, 
and what patterns can be observed in their locations, load types, or booking types? */
SELECT
	d.load_id,
	d.event_type,
	d.location_city,
	d.location_state,
	l.load_type,
	l.booking_type,
	d.scheduled_datetime,
	d.actual_datetime,
	(d.actual_datetime - d.scheduled_datetime) AS delivery_delay
FROM delivery_events d
LEFT JOIN loads l
	ON d.load_id = l.load_id
WHERE d.event_type = 'Delivery' AND (d.actual_datetime - d.scheduled_datetime) > '00:00:00'
ORDER BY delivery_delay DESC;

/* 13. For each customer, calculate the number of loads, total revenue, average revenue per load.
Which customers contribute the most to the business? */
SELECT 
	c.customer_id,
	COUNT(*) AS number_of_load,
	SUM(l.revenue) AS total_revenue,
	ROUND(AVG(l.revenue), 2) AS avg_revenue_per_load
FROM customers c
LEFT JOIN loads l
	ON c.customer_id = l.customer_id
GROUP BY 1

/* 14. Which areas of the operation appear to have the greatest potential for cost reduction based on fuel,
maintenance, downtime, and idle-time patterns? */
SELECT
    truck_id,
    SUM(total_miles) AS total_miles,
	SUM(maintenance_events) AS total_maintenance_events,
    SUM(maintenance_cost) AS total_maintenance_cost,
    ROUND(AVG(average_mpg), 2) AS average_mpg,
    SUM(downtime_hours) AS total_downtime_hours
FROM truck_utilization_metrics
GROUP BY 1
ORDER BY 5, 4 DESC;
-- base on idle time 
SELECT
    driver_id,
    ROUND(AVG(average_idle_hours), 2) AS avg_idle_hours,
    ROUND(AVG(average_mpg), 2) AS avg_mpg,
    ROUND(AVG(on_time_delivery_rate), 2) AS avg_on_time_rate
FROM driver_monthly_metrics
GROUP BY driver_id
ORDER BY avg_idle_hours DESC;

/* 15.Which trucks should management investigate based on unusually poor combinations of 
utilization, revenue, MPG, maintenance cost, and downtime? */
WITH truck_performance AS (
	SELECT
	    truck_id,
	    ROUND(AVG(utilization_rate), 2) AS avg_utilization,
	    SUM(total_revenue) AS total_revenue,
	    ROUND(AVG(average_mpg), 2) AS avg_mpg,
	    SUM(maintenance_cost) AS total_maintenance_cost,
	    SUM(downtime_hours) AS total_downtime
	FROM truck_utilization_metrics
	GROUP BY 1
),
rank_truck AS (
	SELECT
		*,
		RANK() OVER(ORDER BY avg_utilization) AS utilization_rank,
		RANK() OVER(ORDER BY total_revenue) AS revenue_rank,
		RANK() OVER(ORDER BY avg_mpg) AS avg_mpg_rank,
		RANK() OVER(ORDER BY total_maintenance_cost) AS maintenance_cost_rank,
		RANK() OVER(ORDER BY total_downtime) AS downtime_rank
	FROM truck_performance
)
SELECT
	truck_id,
	avg_utilization,
	utilization_rank,
	total_revenue,
	revenue_rank,
	avg_mpg,
	avg_mpg_rank,
	total_maintenance_cost,
	maintenance_cost_rank,
	total_downtime,
	downtime_rank
FROM rank_truck;

/* 16.Over the available period, is the company becoming more or less operationally efficient based 
on revenue, miles, fuel efficiency, utilization, downtime, and delivery performance? */
WITH monthly_performance AS (
    SELECT
        month,
        SUM(total_revenue) AS total_revenue,
        SUM(total_miles) AS total_miles,
        AVG(average_mpg) AS average_mpg,
        AVG(utilization_rate) AS average_utilization,
        SUM(downtime_hours) AS total_downtime
    FROM truck_utilization_metrics
    GROUP BY 1
)
SELECT
    month,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(total_miles, 2) AS total_miles,
    ROUND(average_mpg, 2) AS average_mpg,
    ROUND(average_utilization, 2) AS average_utilization,
    ROUND(total_downtime, 2) AS total_downtime,
    ROUND(total_revenue - LAG(total_revenue) OVER (ORDER BY month), 2) AS revenue_change,
    ROUND(total_miles - LAG(total_miles) OVER (ORDER BY month), 2) AS miles_change,
    ROUND(average_mpg - LAG(average_mpg) OVER (ORDER BY month), 2) AS mpg_change,
    ROUND(average_utilization - LAG(average_utilization) OVER (ORDER BY month), 2) AS utilization_change,
    ROUND(total_downtime - LAG(total_downtime) OVER (ORDER BY month), 2) AS downtime_change
FROM monthly_performance
ORDER BY 1;
