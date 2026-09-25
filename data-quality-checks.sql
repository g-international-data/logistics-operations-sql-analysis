/* data quality checks */
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

-- check for duplicates records
SELECT * FROM drivers;
SELECT 
	first_name, last_name, hire_date, termination_date, license_number, date_of_birth, home_terminal,
	employment_status, cdl_class, years_experience,
	COUNT(*) AS duplicate_check
FROM drivers
GROUP BY 1,2,3,4,5,6,7,8,9,10
HAVING COUNT(*) > 1;

-- check for NULL values
SELECT * FROM driver_monthly_metrics
WHERE driver_id IS NULL OR month IS NULL OR trips_completed IS NULL OR total_miles IS NULL
	OR total_revenue IS NULL OR average_mpg IS NULL OR total_fuel_gallons IS NULL
	OR on_time_delivery_rate IS NULL or average_idle_hours IS NULL;
	
-- check for duplicates records
SELECT 
	driver_id, month, trips_completed, total_miles, total_revenue, average_mpg, total_fuel_gallons,
	on_time_delivery_rate, average_idle_hours,
	COUNT(*) AS duplicate_check
FROM driver_monthly_metrics
GROUP BY 1,2,3,4,5,6,7,8,9
HAVING COUNT(*) > 1;
	
SELECT * FROM facilities;

SELECT * FROM routes;

SELECT * FROM trailers;

SELECT * FROM trucks;

-- check for NULL values
SELECT * FROM truck_utilitization_metrics
WHERE truck_id IS NULL OR month IS NULL OR trips_completed IS NULL OR total_miles IS NULL
	OR total_revenue IS NULL OR average_mpg IS NULL OR maintenance_events IS NULL
	OR maintenance_cost IS NULL OR downtime_hours IS NULL OR utilization_rate IS NULL;

-- rename table for clearer naming
ALTER TABLE truck_utilitization_metrics
RENAME TO truck_utilization_metrics;

SELECT * FROM truck_utilization_metrics;

-- check for duplicates records
SELECT
	truck_id, month, trips_completed, total_miles, total_revenue, average_mpg, maintenance_events, 
	maintenance_cost, downtime_hours, utilization_rate,
	COUNT(*) AS duplicate_check
FROM truck_utilization_metrics
GROUP BY 1,2,3,4,5,6,7,8,9,10
HAVING COUNT(*) > 1

-- check for NULL values
SELECT * FROM loads
WHERE load_date IS NULL OR load_type IS NULL OR weight_lbs IS NULL OR pieces IS NULL OR revenue IS NULL
	OR fuel_surcharge IS NULL OR accessorial_charges IS NULL OR load_status IS NULL OR booking_type IS NULL;

SELECT * FROM delivery_events
WHERE event_type IS NULL OR scheduled_datetime IS NULL OR actual_datetime IS NULL OR detention_minutes IS NULL
	OR on_time_flag IS NULL OR location_city IS NULL OR location_state IS NULL;

SELECT * FROM fuel_purchases
WHERE purchase_date IS NULL OR location_city IS NULL OR location_state IS NULL OR gallons IS NULL 
	OR price_per_gallon IS NULL OR total_cost IS NULL OR fuel_card_number IS NULL;

SELECT * FROM maintenance_records;

SELECT * FROM safety_incidents;

-- check for NULL values
SELECT * FROM trips
WHERE dispatch_date IS NULL OR actual_distance_miles IS NULL OR actual_duration_hours IS NULL
	OR fuel_gallons_used IS NULL OR average_mpg IS NULL OR idle_time_hours IS NULL OR trip_status IS NULL;
