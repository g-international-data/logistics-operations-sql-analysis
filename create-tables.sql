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
