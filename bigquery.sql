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

<<<<<<< HEAD
--Nested field "totals"--
=======
--Nested field "totals"
>>>>>>> 422284b63d219581a227e5937ad2a35ca7474df7
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
<<<<<<< HEAD

  `bigquery-public-data.google_analytics_sample.ga_sessions_*'
  --`bigquery-public-data.google_analytics_sample.ga_sessions_20160801`
 WHERE
    --_TABLE_SUFFIX BETWEEN '20160801' AND '20170801'
  _TABLE_SUFFIX BETWEEN '20160801' AND '20160930'
 ORDER BY date ASC
=======
 FROM
  --`bigquery-public-data.google_analytics_sample.ga_sessions_*`
  `bigquery-public-data.google_analytics_sample.ga_sessions_20160801`
 --WHERE
  --_TABLE_SUFFIX BETWEEN '20160801' AND '20170801'
 --ORDER BY date ASC
>>>>>>> 422284b63d219581a227e5937ad2a35ca7474df7
 ;