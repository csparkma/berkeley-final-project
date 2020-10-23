-- Creating tables for Customer Analytics, Sessions, and BigQuery Transaction (Totals Table)
-- Note: Tables will be joined together through queries to make final "totals" table used for machine learning
CREATE TABLE customers (
     fullvisitorId VARCHAR(19) NOT NULL,
	 date DATE NOT NULL,
	 PRIMARY KEY (fullvisitorId)
);

CREATE TABLE sessions (
     fullvisitorId VARCHAR(19) NOT NULL,
     visitId INT NOT NULL,
     date DATE NOT NULL,
	 FOREIGN KEY (fullvisitorId) REFERENCES customers(fullvisitorId),
     PRIMARY KEY (visitId)
);

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
	FOREIGN KEY (fullvisitorId) REFERENCES sessions(fullvisitorId),
    FOREIGN KEY (visitId) REFERENCES sessions(visitId),
    PRIMARY KEY (fullvisitorId, visitId)
);


---Beginning of tables to be joined---
CREATE TABLE customersessionshabits (
     fullvisitorId VARCHAR(19) NOT NULL,
     visitNumber INT,
     visitStartTime INT,
     socialEngagementType VARCHAR(50),
     channelGrouping VARCHAR(15),
	 FOREIGN KEY (fullvisitorId) REFERENCES customers(fullvisitorId),
     PRIMARY KEY (fullvisitorId)
);

CREATE TABLE customerdevice (
     fullvisitorId VARCHAR(19) NOT NULL,
     browser VARCHAR(50),
     operatingSystem VARCHAR(15),
     deviceCategory VARCHAR(7),
	 FOREIGN KEY (fullvisitorId) REFERENCES customers(fullvisitorId),
     PRIMARY KEY (fullvisitorId)
);

CREATE TABLE customergeonetwork (
     fullvisitorId VARCHAR(19) NOT NULL,
     continent VARCHAR(30),
     subContinent VARCHAR(25),
     country VARCHAR(50),
     --region VARCHAR(50),
     --metro VARCHAR(50),
     --city VARCHAR(50),
	 FOREIGN KEY (fullvisitorId) REFERENCES customers(fullvisitorId),
     PRIMARY KEY (fullvisitorId)
);

CREATE TABLE websitetrafficsource (
     fullvisitorId VARCHAR(19) NOT NULL,
     referralPath VARCHAR(255),
     source VARCHAR(100),
     medium VARCHAR(10),
     isTrueDirect BOOLEAN,
	 FOREIGN KEY (fullvisitorId) REFERENCES customers(fullvisitorId),
     PRIMARY KEY (fullvisitorId)
);

CREATE TABLE bigquery_totals_join (
  	fullvisitorId VARCHAR(19) NOT NULL,
	bounces integer,
	hits integer,
	newVisits integer,
	pageviews integer,
	sessionQualityDim integer,
	totalTransactionRevenue bigint,
	transactionRevenue bigint,
	transactions integer,
	visits integer,
	FOREIGN KEY (fullvisitorId) REFERENCES customers(fullvisitorId),
    PRIMARY KEY (fullvisitorId)
);
--End of tables to be joined--



