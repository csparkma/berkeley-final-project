------------------
--BQ Test Table Setup
------------------
CREATE TABLE sessions_test (
     fullvisitorId VARCHAR(19) NOT NULL,
    visitId INT NOT NULL, 
	date DATE NOT NULL
	 --PRIMARY KEY (visitId),
	--FOREIGN KEY (fullvisitorId)
);

-- Check the sample sessions table.
SELECT * FROM sessions_test
SELECT COUNT (*) FROM sessions_test


-- Create customers_test table--
CREATE TABLE customers_test (
     fullvisitorId VARCHAR(19) NOT NULL,
	 date DATE NOT NULL
	 --PRIMARY KEY (fullvisitorId),
);
-- Check the new customers_test table.
SELECT * FROM customers_test
SELECT COUNT (*) FROM customers_test

--Create new BQ table with test data set--
CREATE TABLE bigquery_totals_test (
  	fullvisitorId VARCHAR(19) NOT NULL,
	visitId INT NOT NULL,
	visitNumber INT,
	visitStartTime INT,
	date date NOT NULL,
	socialEngagementType VARCHAR(50),
	channelGrouping VARCHAR(15),
	browser VARCHAR(50),
	operatingSystem VARCHAR(15),
	deviceCategory VARCHAR(7),
	subContinent VARCHAR(25),
	country VARCHAR(50),
	region VARCHAR(50),
	metro VARCHAR(50),
	city VARCHAR(50),
	--keyword VARCHAR (100),
	referralPath VARCHAR(255),
	source VARCHAR(100),
	medium VARCHAR(10),
	isTrueDirect BOOLEAN,
	bounces INT,
	hits INT,
	newVisits INT,
	pageviews INT,
	sessionQualityDim INT,
	timeOnScreen INT,
	timeOnSite INT,
	totalTransactionRevenue BIGINT,
	transactionRevenue BIGINT,
	transactions INT
);
-- Check the new BigQuery results test table -- 
SELECT * FROM bigquery_totals_test
SELECT COUNT (*) FROM bigquery_totals_test

------------------
--BQ Table Setup
------------------
-- Create new BQ table with full data results--
CREATE TABLE bigquery_totals (
  	fullvisitorId VARCHAR(19) NOT NULL,
    visitId INT NOT NULL,
	visitNumber INT,
	visitStartTime INT,
    date DATE NOT NULL,
	socialEngagementType VARCHAR(50),
	channelGrouping VARCHAR(15),
	browser VARCHAR(50),
	operatingSystem VARCHAR(15),
	deviceCategory VARCHAR(7),
	subContinent VARCHAR(25),
	country VARCHAR(50),
	region VARCHAR(50),
	metro VARCHAR(50),
	city VARCHAR(50),
	referralPath VARCHAR(255),
	source VARCHAR(100),
	medium VARCHAR(10),
	isTrueDirect BOOLEAN,
	bounces INT,
	hits INT,
	newVisits INT,
	pageviews INT,
	sessionQualityDim INT,
    timeOnScreen INT,
	timeOnSite INT,
	totalTransactionRevenue BIGINT,
	transactionRevenue BIGINT,
	transactions INT,
    visits INT
);
-- Check the new BigQuery results table --
SELECT * FROM bigquery_totals
SELECT COUNT (*) FROM bigquery_totals

---------------------
--Alternate ETL:
--BQ Joined Tables to form Bigquery_totals Table from BigQuery Source--
---------------------
---Beginning of tables to be joined---
---Join CustomerSessionsHabits, CustomerDevice, CustomerGeoNetwork, WebsiteTrafficSource, BQTotalsJoin
SELECT customersessionshabits.visitNumber,
    customersessionshabits.visitStartTime,
    customersessionshabits.socialEngagementType,
    customersessionshabits.channelGrouping,
    customerdevice.browser,
    customerdevice.operatingSystem,
    customerdevice.deviceCategory,
    customergeonetwork.continent,
    customergeonetwork.subContinent,
    customergeonetwork.country,
    websitetrafficsource.referralPath,
    websitetrafficsource.source,
    websitetrafficsource.medium,
    websitetrafficsource.isTrueDirect,
    bigquery_totals_join.bounces,
    bigquery_totals_join.hits,
    bigquery_totals_join.newVisits,
    bigquery_totals_join.pageViews,
    bigquery_totals_join.sessionQualityDim,
    bigquery_totals_join.totalTransactionRevenue,
    bigquery_totals_join.transactionRevenue,
    bigquery_totals_join.transactions,
    bigquery_totals_join.visits
INTO customer_sessions
FROM customersessionshabits
JOIN customerdevice
    ON customersessionshabits.fullvisitorId = customerdevice.fullvisitorId
JOIN customergeonetwork
    ON customergeonetwork.fullvisitorId = customerdevice.fullvisitorId
JOIN websitetrafficsource
    ON websitetrafficsource.fullvisitorId = customerdevice.fullvisitorId
JOIN bigquery_totals_join
    ON bigquery_totals_join.fullvisitorId = customerdevice.fullvisitorId;

----------------------------------------
-- Create new sessions joiner table --
----------------------------------------
CREATE TABLE sessions_visits (
    fullvisitorId VARCHAR(19) NOT NULL,
     visitId INT NOT NULL,
     date DATE NOT NULL,
	 visits INT
);

------------------------------------------
-- Customer_sessions to Sessions_visits join
------------------------------------------
------------------------------------------
-- Final BQ Backup Table
------------------------------------------
SELECT customer_sessions.visitNumber,
    customer_sessions.visitStartTime,
    customer_sessions.socialEngagementType,
    customer_sessions.channelGrouping,
    customer_sessions.browser,
    customer_sessions.operatingSystem,
    customer_sessions.deviceCategory,
    customer_sessions.continent,
    customer_sessions.subContinent,
    customer_sessions.country,
    customer_sessions.referralPath,
    customer_sessions.source,
    customer_sessions.medium,
    customer_sessions.isTrueDirect,
    customer_sessions.bounces,
    customer_sessions.hits,
    customer_sessions.newVisits,
    customer_sessions.pageViews,
    customer_sessions.sessionQualityDim,
    customer_sessions.totalTransactionRevenue,
    customer_sessions.transactionRevenue,
    customer_sessions.transactions,
    sessions_visits.fullvisitorId,
	sessions_visits.visitId,
	sessions_visits.date
INTO bigquery_totals_backup
FROM customer_sessions
JOIN sessions_visits
    ON customer_sessions.visits = sessions_visits.visits;

SELECT * FROM bigquery_totals_backup