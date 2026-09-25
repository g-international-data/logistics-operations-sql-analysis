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

1. **Database Setup**
![Logistics Database ERD](database-ERD.png)
* **Database Creation**: Created a database.
* **Table Creation**: Created tables for customers, drivers, trucks, trailers, loads, trips, routes, facilities, fuel purchases, maintenance records, delivery events, driver monthly metrics, truck utilization metrics, and safety incidents. Each table includes relevant columns and relationships.
