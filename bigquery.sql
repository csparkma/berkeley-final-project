--BigQuery query list--

SELECT
--unnested fields"--
fullVisitorID
,visitId
,visitNumber
,visitStartTime
,date
,socialEngagementType
,channelGrouping

--Nested field "device"--
,device.browser
,device.operatingSystem
,device.deviceCategory

--Nested field "geoNetwork"--
,geoNetwork.subContinent
,geoNetwork.country
,geoNetwork.region
,geoNetwork.metro
,geoNetwork.city

--Nested field "trafficSource"--
,trafficSource.keyword
,trafficSource.referralPath
,trafficSource.source
,trafficSource.medium
,trafficSource.isTrueDirect

--Nested field "totals"
,totals.bounces
,totals.hits
,totals.newVisits
,totals.pageviews
,totals.sessionQualityDim
,totals.timeOnScreen
,totals.timeOnSite
,totals.totalTransactionRevenue
,totals.transactionRevenue
,totals.transactions
,totals.visits
 FROM
  --`bigquery-public-data.google_analytics_sample.ga_sessions_*`
  `bigquery-public-data.google_analytics_sample.ga_sessions_20160801`
 --WHERE
  --_TABLE_SUFFIX BETWEEN '20160801' AND '20170801'
 --ORDER BY date ASC
 ;