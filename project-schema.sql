-- Creating tables for Customers and BigQuery Totals
CREATE TABLE customers (
     fullvisitorId VARCHAR(19) NOT NULL,
     visitId INT NOT NULL,
	 PRIMARY KEY (fullvisitorId),
	 UNIQUE (visitId)
);

CREATE TABLE bigquery_totals (
  	fullvisitorId VARCHAR(19),
	visitId integer,
	visitNumber integer,
	visitStartTime integer,
	date date,
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
	isTrueDirect boolean,
	bounces integer,
	hits integer,
	newVisits integer,
	pageviews integer,
	sessionQualityDim integer,
	totalTransactionRevenue bigint,
	transactionRevenue bigint,
	transactions integer,
	visits integer,
	FOREIGN KEY (fullvisitorId) REFERENCES customers (fullvisitorId),
	PRIMARY KEY (fullvisitorId)
);
