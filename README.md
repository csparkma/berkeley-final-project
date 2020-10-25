# Berkeley Final Project
Berkeley Data Analytics Bootcamp Final project - Sept-Oct 2020

- Last Updated: 2020-10-25


# Presentation:
- Our overall project plan & outcome(s) can be found [here](https://docs.google.com/presentation/d/1IJwm4imWicTFp8LapvV8N88eyIyjYjRl-6_hksx4jWI/edit?usp=sharing).

## Group:
- **Nathan Toy**: Machine Learning Lead & Project Manager Assist
- **Karen Pineda**: Dashboard
=======
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

## ETL Database Setup:
The ETL process of this project involved the platforms of PostgresSQL PgAdmin and Jupyter Notebook (utilizing GoogleCloud connection via Python script and Pandas dataframe processing) to prepare the data obtained from Google Analytics BigQuery. An ERD was used to first outline which data needed to be separated in sections from BigQuery, and then analyzed for relevance to the final model. Unusuable data and null values in columns were dropped from the tables, before final joins were performed in SQL. The following tables were created in PostgresSQL PgAdmin (connected to RDS db hosted via AWS), and correspond to the final ERD found in the database.:
  - Customers
  - Sessions
  - CustomerSessionsHabits (Joiner Table to bridge Customers and Sessions table)
   - The following tables were aggregated with "CustomerSessionsHabits" using SQL to rebuild a final "Totals" backup table that included user session data with analytics and geographical demographics:
       - CustomerDevice
       - CustomerGeoNetwork
       -WebsiteTrafficSource
       -BigQuery_Totals_Join.
   
A back-up copy of the original database is available for use (holds a small sample set of data, of ~1700 rows as a placeholder), in addition to the original database that is connected via GoogleCloud for updating with larger data (contains ~500,000 rows of data). 

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
Once the dataset preprocessing is complete a variety of classification Machine Learning models are applied to predict if a session is going to result in a transaction. The Machine Learning models are trained on over 500,000 rows of data for customer sessions on the Google Store.
 - Logistic Regression Classifier
   - This is used as a base level "simple" linearly separable type of model
   - Scores:
   
      ![Logistic Regression](https://github.com/csparkma/berkeley-final-project/blob/n-toy-working-branch/Resources/Logistic_Regression_Confusion_Matrix.PNG)
   - Logistic Regression by the scores has an F1 Score of 0.289 which is not that impressive. This model does not seem to be working well for predicting if a customer will have a transaction. This model is used to set a baseline score, and also check to linear-seperability for transactions. The scores of the model show this is not a linearly-separable problem.  
 - Random Forest Classifier
   - A higher complexity Random Forest Classifier is used because of its "simpleness", and ability to work well with imbalanced data sets
   - Scores:
    
      ![Random Forest](https://github.com/csparkma/berkeley-final-project/blob/n-toy-working-branch/Resources/Random_Forest_Confusion_Matrix.PNG)
   - Random Forest shows tremendous results by the scores. Random Forest is doing well predicting if a customer will have a transaction, and most likely owes success to the tree decision based structure for given features. There are issues with interpreting a decision tree from the Random Forest however. 
 - Deep Learning Neural Network
   - A deep learning model is applied with 1 hidden layer underneath it
   - Scores: 
   
      ![Neural Network](https://github.com/csparkma/berkeley-final-project/blob/n-toy-working-branch/Resources/Neural_Network_Confusion_Matrix.png)
   - Neural Network is slightly better than Logistic Regression, but fails to Random Forest by the numbers. There may be better performance hidden in this model, but at the expensive cost of computation time. 
There is one clear model outperforming the rest. Random Forest is the leading model based off of all scores. This is expected because tree based models generally fair better than other models to capture irregularities within the dataset because of the tree decision split structure. However, interpreting the model is chaotic because of the complexity of each estimator within the forest. Using OneHotEncoding on categorical features is most likely the cause for the complexity in reading Decision trees.  
 
With the models classifying if a visitor will be making a transaction we can start focusing on presenting the predictions as a "propensity to purchase".

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
