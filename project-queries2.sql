-- Creating tables for Customers and BigQuery Totals --
CREATE TABLE customers (
     fullvisitorId VARCHAR(19) NOT NULL,
     visitId INT NOT NULL,
	 date DATE NOT NULL,
	 --PRIMARY KEY (fullvisitorId),
);
-- Check the new customers tables.
SELECT * FROM customers

--Recreate new table "customers" as "sessions".
DROP TABLE customers;

CREATE TABLE sessions (
     fullvisitorId VARCHAR(19) NOT NULL,
     date DATE NOT NULL,
     visitId INT NOT NULL,
	 --PRIMARY KEY (visitId),
	--FOREIGN KEY (fullvisitorId)
);

-- Check the new sessions table.
SELECT * FROM sessions
SELECT COUNT (*) FROM sessions

-- Create new customers table--
CREATE TABLE customers (
     fullvisitorId VARCHAR(19) NOT NULL,
	 date DATE NOT NULL,
	 --PRIMARY KEY (fullvisitorId),
);
-- Check the new customers table.
SELECT * FROM customers
SELECT COUNT (*) FROM customers

------------------
--BQ Table Setup
------------------
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

-- Create new BQ table with full data results w/o session dates --
CREATE TABLE bigquery_totals (
  	fullvisitorId VARCHAR(19) NOT NULL,
    visitId INT NOT NULL,
	visitNumber INT,
	visitStartTime INT,
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
	transactions INT
	--PRIMARY KEY (fullvisitorId, visitId)
);
-- Check the new BigQuery results table --
SELECT * FROM bigquery_totals
SELECT COUNT (*) FROM bigquery_totals

-- Create a new table for BQ results that joins sessions and BQ totals w/ dates.
SELECT sessions.fullvisitorId,
     sessions.visitId,
     sessions.date,
     bigquery_totals.fullvisitorId,
     bigquery_totals.visitId,
	 bigquery_totals.visitNumber,
	 bigquery_totals.visitStartTime,
	 bigquery_totals.socialEngagementType,
	 bigquery_totals.channelGrouping,
	 bigquery_totals.browser,
	 bigquery_totals.operatingSystem,
	 bigquery_totals.deviceCategory,
	 bigquery_totals.subContinent,
	 bigquery_totals.country,
	 bigquery_totals.region,
	 bigquery_totals.metro,
	 bigquery_totals.city,
	 bigquery_totals.referralPath,
	 bigquery_totals.source,
	 bigquery_totals.medium,
	 bigquery_totals.isTrueDirect,
	 bigquery_totals.bounces,
	 bigquery_totals.hits,
	 bigquery_totals.newVisits,
	 bigquery_totals.pageviews,
	 bigquery_totals.sessionQualityDim,
     bigquery_totals.timeOnScreen,
	 bigquery_totals.timeOnSite,
	 bigquery_totals.totalTransactionRevenue,
	 bigquery_totals.transactionRevenue,
	 bigquery_totals.transactions
INTO bq_totals_sessions     
FROM sessions
LEFT JOIN bigquery_totals
ON sessions.fullvisitorId = bigquery_totals.fullvisitorId
WHERE (date BETWEEN '20160801' AND '20160930')
ORDER BY date ASC;

-- Check the new bq_totals_sessions table. --
SELECT * FROM bq_totals_sessions
SELECT COUNT (*) FROM bq_totals_sessions

