# Berkeley Final Project
Berkeley Data Analytics Bootcamp Final project - Sept-Oct 2020
- Last Updated: 2020-10-18

# Presentation:
- Our overall project plan & outcome(s) can be found [here](https://docs.google.com/presentation/d/1IJwm4imWicTFp8LapvV8N88eyIyjYjRl-6_hksx4jWI/edit?usp=sharing).

## Group:
- **Nathan Toy**: Machine Learning Lead & Project Manager Assist
- **Karen Pineda**: Dashboard
- **Jessica Scott**: ETL
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

## ETL Database Setup:
Data obtained from Google Analytics BigQuery is taken in sections via queries to BigQuery to prepare the following tables in PostgresSQL PgAdmin (connected to RDS db hosted via AWS), that will be included in final ERD, queries, and schema:
  - Customers
  - Sessions
  - Hits (currently WIP)

Project-queries2.sql details queries run in SQL with comments for table creation and joins. 

## Machine Learning Description:
The Google Analytics BigQuery data must be prepared for Machine Learning methods to be applied. The data preprocessing steps include:
 - Connecting to RDS database containing data and populating NaN values as 0
 - "Bucketizing" qualitative components to reduce dimensionality for One Hot Encoding
   - Browser is reduced from 26 to 11 dimensions
   - Subcontinent is reduced from 23 to 13 dimensions
   - Country is reduced from 179 to 31 dimensions
   - Source is reduced from 96 to 21 dimensions
 - Removing features from the original dataset that would not be worthwhile for modeling
   - Geographic features contained incomplete or missing values for > 30% of dataset 
     -  Region, Metro, and City are removed because of incomplete data
   - Features that would not be good predictors were removed. Those columns removed include:
     - Geographic information for the session, Full Visitor ID, Date of visit, referral path, date  
 - One Hot Encoding is applied to a clean dataset, and split on standard 75% training set and 25% test set via sklearn train_test_split function default
   - One Hot Encoding applied to features:
     - Social Engagement Type, Channel Grouping, Browser, Operating System, Device Category, Continent, Subcontinent, Country, Source, Medium
Once the dataset preprocessing is complete a variety of classification Machine Learning models are applied to predict if a session is going to result in a transaction. The dataset has an imbalance for sessions/transactions (I.E. There are many records showing visitors browsing the Google Store, but not purchasing products),and the dataset is upsampled to boost the number of tranasctions for Machine Learning. For the models attempted they are:
 - Logistic Regression Classifier
   - This is used as a base level "simple" linearly separable type of model
   - Scores:
     - Accuracy: 0.952
     - F1 Score: 0.374
     - Recall Score:  0.932
   - Logistic Regression yields a very high Recall (True Positive/(True Positive + False Negative) because it does not predict False Negatives very often which leads to a very high score.
 - Random Forest Classifier
   - A higher complexity Random Forest Classifier is used because of its "simpleness", and ability to work well with imbalanced data sets
   - Scores:
     - Accuracy: 0.983
     - F1 Score: 0.428
     - Recall Score: 0.411
   - Random Forest has a lower Recall Score, but a higher F1 Score dictates this is a "healthier" model compared to Logistic Regression
 - Deep Learning Neural Network
   - A "simple" deep learning model is applied with 1 hidden layer underneath it
   - Scores: 
     - Accuracy: 0.983
     - F1 Score: 0.422
     - Recall SCore: 0.406
   - Neural Network shows by the scores as second to Random Forest, with very close performance. it may be worthwhile to explore additional hidden layers for this model.
Overall the models vary in their effectiveness. Random Forest is the leading model based off of F1 Score, Accuracy, and Recall. The accuracy scores across the models is >0.95 which is very high for models, but more often than not the accuracy is high because the model predicts no transactions a high percentage of the time. The group is optimistic to unpack more of the Neural Network to see if there is additional performance. The scores above represent the model with upsampled transactions. Model performance may improve with undersampling/SMOTE.
 
With the models classifying if a visitor will be making a transaction we can start focusing on presenting the predictions as a "propensity to purchase".

# Technologies Used:
## Data Cleaning and Analysis
BigQuery will be used to clean the data and perform an exploratory analysis.
 
## Database Storage
 Amazon RDS will be used to store our data, and we will integrate it with Tableau to display the dashboard.

## Dashboard
Tableau will be used to create our Dashboard. It will be hosted through a webpage. 


## WEEK 2 
Dashboard Google Slide Link https://docs.google.com/presentation/d/1U8UInYX9gbfdw8o_efzpRncUv3fY-gJfF8pdPaCVu8A/edit?usp=sharing

- Blueprint 1 & 2 attached above  

## WEEK 3
Tableau Dashboard Link 
https://public.tableau.com/shared/92WF9ZBZ6?:display_count=y&:origin=viz_share_link
