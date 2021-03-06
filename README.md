# Berkeley Final Project
Berkeley Data Analytics Bootcamp Final project - Sept-Oct 2020

- Last Updated: 2020-10-25


# Presentation:
- Our overall project plan & outcome(s) can be found [here](https://docs.google.com/presentation/d/1IJwm4imWicTFp8LapvV8N88eyIyjYjRl-6_hksx4jWI/edit?usp=sharing).

## Group:
- **Nathan Toy**: Machine Learning Lead & Project Manager Assist
- **Karen Pineda**: Dashboard
- **Jessica Scott**: ETL/Database Maintenance
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

## ETL Database Setup and Description:
The ETL process of this project involved the platforms of PostgresSQL PgAdmin and Jupyter Notebook (utilizing GoogleCloud connection via Python script and Pandas dataframe processing) to prepare the data obtained from Google Analytics BigQuery into new tables for the PostgresSQL database. An entity relationship model of the recreated BigQuery database was first visualized using an Entity Relationship Diagram (ERD) to outline which data needed to be separated in sections from BigQuery, and then analyzed for relevant data to add to tables building the final database structure. Columns with unusuable data and null values were excluded in queries performed in BigQuery. Finally, the data was separated into .csv tables, and joins were performed in pgAdmin utilizing queries and various unusable columns in PostgresSQL. The server for the PostgresSQL database is an RDS instance hosted via Amazon Web Services (AWS). 

![ERD](https://github.com/csparkma/berkeley-final-project/blob/master/ucb-finalproject-ERD-final.png)

The following tables were created in PostgresSQL PgAdmin, and correspond to the final ERD:
  - **Customers**
  - **Sessions**
  - **CustomerSessionsHabits (associative table to bridge *Customers* and *Sessions* table)**

The following tables (also shown in the final ERD) were aggregated with "CustomerSessionsHabits" using SQL queries to build a table that included user session data with analytics drawn from the Google Store website (examples include customer geographics, devices, peak time of day for transactions etc.):
  - **CustomerDevice**
  - **CustomerGeoNetwork**
  - **WebsiteTrafficSource**
  - **BigQuery_Totals_Join**
   
The final table *bigquery_totals_backup* is the rebuilt, joined, back-up copy of the original aggregated table *bigquery_totals* used for Machine Learning. 

- To maintain preserving the "customer session" aspect of the dataset and organization of dates of session occurrence, columns "FullVisitorId", "VisitId", and "Date" were maintained in the final *Bigquery_totals_backup* table. Column "Visits" was also dropped from the final dataset used for Machine Learning, but was used in queries to perform joins.

- *Bigquery_totals_backup* is available for small dataset storage (~1700 rows due to storage/computer memory limitations in pgAdmin and SQL), in addition to the original table *bigquery_totals* that is connected via GoogleCloud for updating with larger data sets (currently contains >600,000 rows of data) that was used for Machine Learning. 

## Machine Learning Description:
The Google Analytics BigQuery data must be prepared for Machine Learning methods to be applied. The data preprocessing steps include:
 - Connecting to RDS database containing data and populating NaN values as 0
 - "Bucketizing" qualitative components to reduce dimensionality for One Hot Encoding
   - Browser is reduced from 41to 12 dimensions
   - Subcontinent is reduced from 23 to 18 dimensions
   - Country is reduced from 215 to 21 dimensions
   - Source is reduced from 224 to 20 dimensions
 - Removing features from the original dataset that would not be worthwhile for modeling
   - Geographic features contained incomplete or missing values for > 30% of dataset 
     -  Region, Metro, and City are removed because of incomplete data
   - Features that would not be good predictors were removed. Those columns removed include:
     - Geographic information for the session, Full Visitor ID, Date of visit, referral path, date  
 - One Hot Encoding is applied to a clean dataset, and split on standard 75% training set and 25% test set via sklearn train_test_split function default
   - One Hot Encoding applied to features:
     - Social Engagement Type, Channel Grouping, Browser, Operating System, Device Category, Continent, Subcontinent, Country, Source, Medium
Once the dataset preprocessing is complete a variety of classification Machine Learning models are applied to predict if a session is going to result in a transaction. The Machine Learning models are trained on over 500,000 rows of data for customer sessions on the Google Store. Originally the data was upsampled because of an imbalance for transactions/sessions, but was found to have better performance without being upsampled.
 - Logistic Regression Classifier
   - This is used as a base level "simple" linearly separable type of model
   - Scores:
   
      ![Logistic Regression](https://github.com/csparkma/berkeley-final-project/blob/n-toy-working-branch/Resources/Logistic_Regression_Confusion_Matrix.PNG)
   - The Confusion Matrix shows 164,820 TN (True Negatives) , 1,894 FN (False Negative) , 453 FP (False Positive), and 478 TP (True Positive). The model predicts many False Negatives which drives the Recall and F1 Score low. 
   - Logistic Regression by the scores has an F1 Score of 0.289 which is fairly low. This model does not seem to be working well for predicting if a customer will have a transaction. This model is used to set a baseline score, and also check to linear-seperability for transactions. The scores of the model show this is not a linearly-separable problem.  The Accuracy of the model is 0.986, which given the imbalance of the dataset, is almost identical to as if it was predicted "No" for all records.
 - Random Forest Classifier
   - A higher complexity Random Forest Classifier is used because of its "simpleness", and ability to work well with imbalanced data sets
   - Scores:
    
      ![Random Forest](https://github.com/csparkma/berkeley-final-project/blob/n-toy-working-branch/Resources/Random_Forest_Confusion_Matrix.PNG)
   - The Confusion Matrix shows 164,879 TN, 833 FN, 394 FP, 1,539 TP. The model predicts more accuractely than the other models, and can be seen in the scores, and Confusion Matrix.
   - Random Forest shows tremendous results by the scores. Random Forest is doing well predicting if a customer will have a transaction, and most likely owes success to the tree decision based structure for given features. There are issues with interpreting a decision tree from the Random Forest however. The Accuracy of the model is 0.993 which is remarkably higher than other models.
 - Deep Learning Neural Network
   - A deep learning model is applied with 1 hidden layer underneath it
   - Scores: 
   
      ![Neural Network](https://github.com/csparkma/berkeley-final-project/blob/n-toy-working-branch/Resources/Neural_Network_Confusion_Matrix.png)
   -  The Confusion Matrix shows 164,715 TN, 1,698 FN, 558 FP, 674 TP. The model does marginally better than the Logistic Regression.
   - Neural Network is slightly better than Logistic Regression, but fails to Random Forest by the numbers. There may be better performance hidden in this model, but at the expensive cost of computation time. The Accuracy of the model is negligably better than Logistic Regression, with a score of 0.987
There is one clear model outperforming the rest. Random Forest is the leading model based off of all scores. This is expected because tree based models generally fair better than other models to capture irregularities within the dataset because of the tree decision split structure. However, interpreting the model is chaotic because of the complexity of each estimator within the forest. Using OneHotEncoding on categorical features is most likely the cause for the complexity in reading Decision trees.  
 
With the Random Forest model performing the best out of all three chosen models a transaction can be correctly predicted up to 99% (Accuracy Score)

# Technologies Used:
## Data Cleaning and Analysis
BigQuery will be used to clean the data and perform an exploratory analysis.
 
## Database Storage
 Amazon RDS will be used to store our data, and we will integrate it with Tableau to display the dashboard.

## Dashboard
Tableau will be used to create our Dashboard. It will be hosted through a webpage. 


## WEEK 2 
[Dashboard Google Slide](https://docs.google.com/presentation/d/1U8UInYX9gbfdw8o_efzpRncUv3fY-gJfF8pdPaCVu8A/edit?usp=sharing)

- Blueprint 1 & 2 attached above  

## WEEK 3
[Tableau Dashboard](https://public.tableau.com/shared/92WF9ZBZ6?:display_count=y&:origin=viz_share_link)

## WEEK 4
[Dashboard](https://csparkma.github.io/berkeley-final-project/)
