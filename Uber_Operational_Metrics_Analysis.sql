-- ====================================================================
-- PROJECT: Uber Operational & Financial Metrics Analysis
-- TECH STACK: SQL (Structured Query Language)
-- OBJECTIVE: Analyze ride status, driver ratings, and revenue insights.
-- ====================================================================

-- Step 1: Create Database Schema for Uber Rides
CREATE TABLE uber_rides (
    RideID VARCHAR(10) PRIMARY KEY,
    CustomerName VARCHAR(50),
    City VARCHAR(50),
    DriverRating FLOAT,
    RideDistance_KM FLOAT,
    FareAmount INT,
    Payment_Method VARCHAR(20),
    RideStatus VARCHAR(20)
);

-- Step 2: Populate Table with Realistic Operational Data
INSERT INTO uber_rides VALUES ('R101', 'Aman', 'Delhi', 4.8, 12.5, 350, 'UPI', 'Completed');
INSERT INTO uber_rides VALUES ('R102', 'Priya', 'Mumbai', 3.2, 5.0, 180, 'Cash', 'Completed');
INSERT INTO uber_rides VALUES ('R103', 'Rahul', 'Bangalore', 4.5, 22.1, 650, 'Credit Card', 'Completed');
INSERT INTO uber_rides VALUES ('R104', 'Sneha', 'Delhi', NULL, 8.2, 0, 'UPI', 'Cancelled');
INSERT INTO uber_rides VALUES ('R105', 'Vikram', 'Delhi', 4.9, 18.0, 480, 'UPI', 'Completed');
INSERT INTO uber_rides VALUES ('R106', 'Rohit', 'Mumbai', 4.2, 15.5, 420, 'Credit Card', 'Completed');
INSERT INTO uber_rides VALUES ('R107', 'Ananya', 'Bangalore', 2.8, 3.5, 120, 'Cash', 'Completed');
INSERT INTO uber_rides VALUES ('R108', 'Amit', 'Bangalore', 4.7, 30.0, 850, 'Credit Card', 'Completed');
INSERT INTO uber_rides VALUES ('R109', 'Riya', 'Mumbai', NULL, 1.2, 0, 'Cash', 'Cancelled');
INSERT INTO uber_rides VALUES ('R110', 'Karan', 'Delhi', 4.6, 25.4, 700, 'UPI', 'Completed');


-- --------------------------------------------------------------------
-- BUSINESS QUERIES & INSIGHTS EXTRACTION
-- --------------------------------------------------------------------

-- Q1: Fetch all rides that occurred in 'Delhi' and have a 'Completed' status.
-- Purpose: To analyze successful operations in the capital region.
SELECT * 
FROM uber_rides 
WHERE city = 'Delhi' AND ridestatus = 'Completed';


-- Q2: Extract data of drivers with a rating below 4.5.
-- Purpose: Identifying low-performing drivers for quality warnings and training.
SELECT * 
FROM uber_rides
WHERE driverrating < 4.5;


-- Q3: Calculate the total revenue (FareAmount) generated from each city.
-- Purpose: To find the highest grossing market for business expansion.
SELECT city, SUM(fareamount) AS Total_Revenue
FROM uber_rides
GROUP BY city
ORDER BY Total_Revenue DESC;


-- Q4: Identify the single longest ride registered in the database based on distance.
-- Purpose: Analyzing peak long-distance commuter behavior.
SELECT * 
FROM uber_rides
ORDER BY RideDistance_KM DESC
LIMIT 1;


-- Q5: Determine the most popular payment method used by customers.
-- Purpose: Finding transaction patterns to optimize digital payment partnerships.
SELECT payment_method, COUNT(*) AS Total_Count
FROM uber_rides
GROUP BY payment_method 
ORDER BY Total_Count DESC;
