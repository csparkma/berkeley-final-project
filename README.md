# Berkeley Final Project
Berkeley Data Analytics Bootcamp Final project - Sept-Oct 2020

## Group:
- **Nathan Toy**: Machine Learning Lead & Project Manager Assist
- **Karen Pineda**: Dashboard
- **Jessica Scott**: ETL
- **Luis Gomez**: ETL/Floater
- **Connor Sparkman**: Project Manager Lead & Machine Learning Assist

## Project Goal:
 #### Understand the Audience and Behavior of visitors to the Google Merchandise Store (eCommerce platform) in order to better optimize the buyers journey and increase purchase rate of visitors.

## Reason:
eCommerce is one of the most popular ways that people purchase. Successful eCommerce companies track just about everything you do on their website, from the buttons you click to how far down the page you scroll. One of the most common use-cases for applying this data is to understand the customer journey and how to identify paths that lead to a purchase. 
In order to understand this real-world business problem, we have chosen to use Google Analytic's public dataset, which contains sample data from the Google Merchandise store.

## Dataset:
We have chosen to analyze [Google Analytic's public data set](https://support.google.com/analytics/answer/7586738?hl=en), which contains session/visit level data for a 1.5 years worth of web data. The data is housed in BigQuery and can be accessed by setting up a free account to query the database.
However, in order to avoid costs (as BigQuery charges per query) and optimize the ETL & data preprocesing phase, we will be exporting the majority of the data that we need and importing it into our own RDS database on AWS.

## Questions to Answer:
Our project will focus on:
- **Identifying common paths to success on the Google Merchandise Store**
  - (i.e. What are the most popular items purchased? What are the most common sources that people used to get to the website?). 
- **The Behavioral & Demographic makeup of "ideal" customers**
  - (i.e. What countries are customers with repeat purchases from? How many pages does the ideal customer visit prior to purchase? How many visits to the website before a purchase?)
- **Building a machine learning model to assign a "Propensity to Purchase" score for each unique visitor of the website**

## Machine Learning Description:
The Google Analytics BigQuery data must be prepared for Machine Learning methods to be applied. The data preprocessing steps include:
 - Connecting to RDS database containing data and populating NaN values as 0
 - "Bucketizing" qualitative components to reduce dimensionality for One Hot Encoding
   - E.G. type of browser for session, subcontinent, country etc. were reduced to ~10 dimensions with less occuring values populated as "Other"
 - Removing preliminary columns from the original dataset that would not be worthwhile for modeling
   - E.G. Geographic columns contained incomplete or missing values for > 30% of dataset 
   - Columns that would not be good predictors were removed. Those columns removed include:
     - Geographic information for the session, Full Visitor ID, Date of visit, referral path, etc.  
 - One Hot Encoding is applied to a clean dataset, and split on standard 75% training set and 25% test set via sklearn train_test_split function default
Once the dataset preprocessing is complete a variety of classification Machine Learning models are applied to predict if a session is going to result in a transaction. For the models attempted they are:
 - Logistic Regression Classifier
   - This is used as a base level "simple" linearly seperable type of model
   - This model ultimately predicts that every session is not going to result in a transaction, and boasts a 98.6% accuracy with predicting 'No' for every session
     - The F1 Score for the Logistc Regression is 0% because there were no valid predictions (False Positives, False Negatives, True Negatives) 
 - Random Forest Classifier
   - A higher complexity Random Forest Classifier is used because of its "simpleness", and ability to work well with imbalanced data sets
   - This model returns the same accuracy as the Logistic Regression model (98.6%), but does it without guessing 'No' for every session
     - The F1 Score for the Random Forest is 28%
 - Deep Learning Neural Network
   - A "simple" deep learning model is applied with 1 hidden layer underneath it
   - This model returns still the same accuracy as the previous models
     - The team is optimistic that the Deep Learning Neural Network can be improved with additional hidden layers, and undersampling/oversampling because of the imbalanced dataset
There is some additional work that needs to be done to boost the performance of the Machine Learning models. The group intends to use undersampling/oversampling to train the model because of the imbalance of session/transactions. It will also be worthwhile to explore improvements to the Random Forest model since it is predicing successful and unsuccessful transactions. At the same time the group is optimistic to unpack more of the Neural Network to understand predicted values, and accuracy/F1 score for the model's predictions.  
  
 
  
