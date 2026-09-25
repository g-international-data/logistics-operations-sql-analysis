# Logistics Operations SQL Analysis

## Project Overview

This project demonstrates the implementation of a Logistics Operations Analysis system using PostgreSQL and SQL. It includes database design, table relationships, data validation, and advanced SQL queries to analyze drivers, fleet performance, fuel consumption, maintenance, delivery performance, and revenue. The goal is to showcase skills in database management, SQL analysis, and extracting business insights from operational data.

## Objectives

1. **Set up the Logistics Operations Database**: Create and populate the database with tables for customers, drivers, trucks, trailers, loads, trips, routes, facilities, fuel purchases, maintenance records, delivery events, and other operational data.
2. **Perform Data Quality Checks**: Identify missing values, duplicate records, and potential data inconsistencies to ensure data reliability.
3. **Perform Logistics Operations Analysis**: Analyze driver performance, fleet utilization, fuel consumption, maintenance costs, delivery performance, revenue, mileage, downtime, and overall operational efficiency.
4. **Perform Advanced SQL Queries**: Utilize joins, CTEs, aggregate functions, window functions, `RANK()`, `LAG()`, and date-based functions to answer complex business questions.
5. **Generate Business Insights**: Identify operational trends, potential cost-reduction opportunities, and areas requiring management attention based on key performance indicators.

## Project Structure

* **Database Setup**
![Logistics Database ERD](database%20ERD.png)
* **Database Creation**: Created the PostgreSQL database for the logistics operations analysis project.
* **Table Creation**: Created tables for customers, drivers, trucks, trailers, loads, trips, routes, facilities, fuel purchases, maintenance records, delivery events, driver monthly metrics, truck utilization metrics, and safety incidents. And established the relationships between them using primary and foreign keys. Each table includes relevant columns and relationships.

```sql
/* creating tables */
-- create customers table
CREATE TABLE IF NOT EXISTS customers (
	customer_id VARCHAR(15) PRIMARY KEY, -- unique identifier for each customer
	customer_nanme VARCHAR(30),
	customer_type VARCHAR(20),
	credit_terms_days INTEGER,
	primary_freight_type VARCHAR(20),
	account_status VARCHAR(15),
	contract_start_date DATE,
	annual_revenue_potential NUMERIC
);

-- create drivers table
CREATE TABLE IF NOT EXISTS drivers (
	driver_id VARCHAR(15) PRIMARY KEY, --unique identifier for each driver
	first_name VARCHAR(15),
	last_name VARCHAR(15),
	hire_date DATE,
	termination_date DATE,
	license_number VARCHAR(15),
	license_state VARCHAR(7),
	date_of_birth DATE,
	home_terminal VARCHAR(20),
	employment_status VARCHAR(15),
	cdl_class VARCHAR(5),
	years_experience INTEGER
);

-- create drivers monthly metrics table
CREATE TABLE IF NOT EXISTS driver_monthly_metrics (
	driver_id VARCHAR(15),
	month DATE,
	trips_completed INTEGER,
	total_miles NUMERIC,
	total_revenue NUMERIC,
	average_mpg NUMERIC,
	total_fuel_gallons NUMERIC,
	on_time_delivery_rate NUMERIC,
	average_idle_hours NUMERIC,
	FOREIGN KEY (driver_id)
		REFERENCES drivers(driver_id)
);  

-- create facilities table
CREATE TABLE IF NOT EXISTS facilities (
	facility_id VARCHAR(15) PRIMARY KEY, --unique identifier for each facility
	facility_name VARCHAR(40),
	facility_type VARCHAR(30),
	city VARCHAR(20),
	state VARCHAR(7),
	latitude NUMERIC,
	longitude NUMERIC,
	dock_doors INTEGER,
	operating_hours VARCHAR(15)
);

-- create routes table
CREATE TABLE IF NOT EXISTS routes (
	route_id VARCHAR(15) PRIMARY KEY, --unique identifier for each route
	origin_city VARCHAR(15),
	origin_state VARCHAR(7),
	destination_city VARCHAR(20),
	destination_state VARCHAR(7),
	typical_distance_miles INTEGER,
	base_rate_per_mile NUMERIC,
	fuel_surcharge_rate NUMERIC,
	typical_transit_days INTEGER
);

-- create trailers table
CREATE TABLE IF NOT EXISTS trailers (
	trailer_id VARCHAR(15) PRIMARY KEY, --unique identifier for each trailer
	trailer_number INTEGER,
	trailer_type VARCHAR(20),
	length_feet INTEGER,
	model_year INTEGER,
	vin VARCHAR(25),
	acquisition_date DATE,
	status VARCHAR(15),
	current_location VARCHAR(20)
);

-- create trucks table
CREATE TABLE IF NOT EXISTS trucks (
	truck_id VARCHAR(15) PRIMARY KEY, --unique identifier for each truck
	unit_number INTEGER,
	make VARCHAR(20),
	model_year INTEGER,
	vin VARCHAR(25),
	acquisition_date DATE,
	acquisition_mileage INTEGER,
	fuel_type VARCHAR(15),
	tank_capacity_gallons INTEGER,
	status VARCHAR(15),
	home_terminal VARCHAR(20)
);

-- create utilitization table
CREATE TABLE IF NOT EXISTS truck_utilitization_metrics (
	truck_id VARCHAR(15),
	month DATE,
	trips_completed INTEGER,
	total_miles INTEGER,
	total_revenue NUMERIC,
	average_mpg NUMERIC,
	maintenance_events INTEGER,
	maintenance_cost NUMERIC,
	downtime_hours NUMERIC,
	utilization_rate NUMERIC,
	FOREIGN KEY (truck_id)
		REFERENCES trucks(truck_id)
);

-- create loads table
CREATE TABLE IF NOT EXISTS loads (
	load_id VARCHAR(15) PRIMARY KEY, --unique identifier for each load
	customer_id VARCHAR(15),
	route_id VARCHAR(15),
	load_date DATE,
	load_type VARCHAR(15),
	weight_lbs INTEGER,
	pieces INTEGER,
	revenue NUMERIC,
	fuel_surcharge NUMERIC,
	accessorial_charges INTEGER,
	load_status VARCHAR(15),
	booking_type VARCHAR(15),
	FOREIGN KEY (customer_id)
		REFERENCES customers(customer_id),
	FOREIGN KEY (route_id)
		REFERENCES routes(route_id)
);

-- create trips table
CREATE TABLE IF NOT EXISTS trips (
	trip_id VARCHAR(15) PRIMARY KEY, --unique identifier for each trip
	load_id VARCHAR(15),
	driver_id VARCHAR(15),
	truck_id VARCHAR(15),
	trailer_id VARCHAR(15),
	dispatch_date DATE,
	actual_distance_miles INTEGER,
	actual_duration_hours NUMERIC,
	fuel_gallons_used NUMERIC,
	average_mpg NUMERIC,
	idle_time_hours NUMERIC,
	trip_status VARCHAR(15),
	FOREIGN KEY (load_id)
		REFERENCES loads(load_id),
	FOREIGN KEY (driver_id)
		REFERENCES drivers(driver_id),
	FOREIGN KEY (truck_id)
		REFERENCES trucks(truck_id),
	FOREIGN KEY (trailer_id)
		REFERENCES trailers(trailer_id)
);

-- create safety incidents table
CREATE TABLE IF NOT EXISTS safety_incidents (
	incident_id VARCHAR(15) PRIMARY KEY, --unique identifier for each safety incident
	trip_id VARCHAR(15),
	truck_id VARCHAR(15),
	driver_id VARCHAR(15),
	incident_date TIMESTAMP,
	incident_type VARCHAR(25),
	location_city VARCHAR(20),
	location_state VARCHAR(7),
	at_fault_flag BOOLEAN,
	injury_flag BOOLEAN,
	vehicle_damage_cost NUMERIC,
	cargo_damage_cost NUMERIC,
	claim_amount NUMERIC,
	preventable_flag BOOLEAN,
	description VARCHAR(60),
	FOREIGN KEY (trip_id)
		REFERENCES trips(trip_id),
	FOREIGN KEY (truck_id)
		REFERENCES trucks(truck_id),
	FOREIGN KEY (driver_id)
		REFERENCES drivers(driver_id)
);

-- create maintenance records table
CREATE TABLE IF NOT EXISTS maintenance_records (
	maintenance_id VARCHAR(15) PRIMARY KEY, --unique identifier for each maintenance record
	truck_id VARCHAR(15),
	maintenance_date DATE,
	maintenance_type VARCHAR(15),
	odometer_reading INTEGER,
	labor_hours NUMERIC,
	labor_cost NUMERIC,
	parts_cost NUMERIC,
	total_cost NUMERIC,
	facility_location VARCHAR(20),
	downtime_hours NUMERIC,
	service_description VARCHAR(30),
	FOREIGN KEY (truck_id)
		REFERENCES trucks(truck_id)
);

-- create fuel purchases table
CREATE TABLE IF NOT EXISTS fuel_purchases (
	fuel_purchase_id VARCHAR(15) PRIMARY KEY, --unique identifier for each fuel purchase
	trip_id VARCHAR(15),
	truck_id VARCHAR(15),
	driver_id VARCHAR(15),
	purchase_date TIMESTAMP,
	location_city VARCHAR(20),
	location_state VARCHAR(7),
	gallons NUMERIC,
	price_per_gallon NUMERIC,
	total_cost NUMERIC,
	fuel_card_number VARCHAR(15),
	FOREIGN KEY (trip_id)
		REFERENCES trips(trip_id),
	FOREIGN KEY (truck_id)
		REFERENCES trucks(truck_id),
	FOREIGN KEY (driver_id)
		REFERENCES drivers(driver_id)
);

-- create delivery events table
CREATE TABLE IF NOT EXISTS delivery_events (
	event_id VARCHAR(15) PRIMARY KEY, --unique identifier for each delivery event
	load_id VARCHAR(15),
	trip_id VARCHAR(15),
	event_type VARCHAR(15),
	facility_id VARCHAR(15),
	scheduled_datetime TIMESTAMP,
	actual_datetime TIMESTAMP,
	detention_minutes INTEGER,
	on_time_flag BOOLEAN,
	location_city VARCHAR(20),
	location_state VARCHAR(7),
	FOREIGN KEY (load_id)
		REFERENCES loads(load_id),
	FOREIGN KEY (trip_id)
		REFERENCES trips(trip_id),
	FOREIGN KEY (facility_id)
		REFERENCES facilities(facility_id)
);
```

* **Data Import**: Imported the CSV datasets into their respective PostgreSQL tables using pgAdmin.
* **Dataset Source**: *(https://www.kaggle.com/datasets/yogape/logistics-operations-database)*
* **Dataset Files**: The original CSV files used in the project are available in this repository for reference and reproducibility.

### Data Quality Checks
```sql
-- check for NULL values in customers table
SELECT * FROM customers
WHERE customer_id IS NULL OR customer_name IS NULL OR customer_type IS NULL OR credit_terms_days IS NULL
	OR primary_freight_type IS NULL OR account_status IS NULL OR contract_start_date IS NULL
	OR annual_revenue_potential IS NULL;
	
-- rename column for clearer naming
ALTER TABLE customers
RENAME COLUMN customer_nanme TO customer_name;

-- check for duplicates records
SELECT
	customer_name, credit_terms_days, primary_freight_type, account_status, contract_start_date, 
	annual_revenue_potential,
	COUNT(*) AS duplicate_check
FROM customers
GROUP BY 1,2,3,4,5,6 
HAVING COUNT(*) > 1;
```

Data quality checks were performed across the logistics tables to identify missing values, duplicate records, and potential data inconsistencies.
The checks included NULL validation, duplicate detection, and consistency checks across the relevant tables.
[View All Data Quality Queries](data-quality-checks.sql)

## Operations Analysis

### Question 1: How many trucks, trailers, drivers, customers, and facilities are in the database?

```sql
SELECT COUNT(DISTINCT truck_id) FROM trucks;
SELECT COUNT(DISTINCT trailer_id) FROM trailers;
SELECT COUNT(DISTINCT driver_id) FROM drivers;
SELECT COUNT(DISTINCT customer_id) FROM customers;
SELECT COUNT(DISTINCT facility_id) FROM facilities;
```

### Question 2: How many drivers are currently represented in the drivers table, and how are they distributed by their employment status?

```sql
SELECT 
	employment_status,
	COUNT(driver_id) AS employment_status_count
FROM drivers
GROUP BY 1
ORDER BY 1 ASC;
```

### Question 3: What is the total distance traveled, average distance per trip, and longest trip recorded in the trips table?

```sql
SELECT 
	SUM(actual_distance_miles) AS total_distance_travelled_in_miles,
	ROUND(AVG(actual_distance_miles),1) AS average_distance_per_trip_in_miles,
	MAX(actual_duration_hours + idle_time_hours) AS longest_trip_recorded_in_hours
FROM trips;
```

### Question 4: Which drivers completed the most trips?

```sql
SELECT
	driver_id,
	COUNT(*) AS total_trips_completed
FROM trips
GROUP BY 1
ORDER BY 2 DESC
LIMIT 2;
```

### Question 5: Which trucks have the best average fuel efficiency (MPG) based on their recorded trips?

```sql
SELECT
	truck_id,
	MAX(average_mpg) AS best_avg_fuel_efficiency
FROM trips
GROUP BY 1
ORDER BY 2 DESC;
```

### Question 6: Which customers generated the highest number of loads?

```sql
SELECT 
	customer_id,
	COUNT(*) AS highest_load_generated_by_customer
FROM loads
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;
```

### Question 7: Which trucks consumed the most fuel, and how does their fuel consumption compare with the distance they traveled?

```sql
SELECT
    truck_id,
    SUM(fuel_gallons_used) AS total_fuel_used,
    SUM(actual_distance_miles) AS total_distance_traveled,
    SUM(fuel_gallons_used) / SUM(actual_distance_miles) AS fuel_per_mile
FROM trips
GROUP BY 1
ORDER BY 1 DESC
LIMIT 5;
```

### Question 8: Rank drivers based on their total distance traveled and show their position within the overall driver population?

```sql
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
```

### Questioin 9: For each month, identify the drivers who recorded the highest number of trips?

```sql
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
```
