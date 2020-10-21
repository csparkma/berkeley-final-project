#!/usr/bin/env python
# coding: utf-8

# In[28]:


import pandas as pd
import numpy as np
from sqlalchemy import create_engine
from config import db_password2
import psycopg2
import pandas as pd
import tensorflow as tf


# In[29]:


engine = psycopg2.connect(
    database = "postgres",
    user = "postgres",
    password = db_password2,
    host = "js-ucbfinalprojectdb.c8s02fywjegc.us-east-2.rds.amazonaws.com",
#     host = "dataviz-db.csxrf9ti2aba.us-east-2.rds.amazonaws.com",
    port = 5432)
cursor = engine.cursor()


# In[30]:


#use Pandas to see all data in table
sql = """
SELECT "table_name","column_name", "data_type", "table_schema"
FROM INFORMATION_SCHEMA.COLUMNS
WHERE "table_schema" = 'public'
ORDER BY table_name  
"""
pd.read_sql(sql, con=engine)


# In[33]:


#Pull all info into pandas dataframe from RDS dB
sql = """
SELECT *
from bigquery_totals
"""
bigquery_totals_df = pd.read_sql(sql,con = engine)
#plug NaN's as 0's
bigquery_totals_df = bigquery_totals_df.fillna(0)
print(bigquery_totals_df.shape)
bigquery_totals_df.head(n = 10)


# In[34]:



#Drop in Machine Learning libraries

from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler,OneHotEncoder
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score,f1_score,recall_score
from sklearn.ensemble import RandomForestClassifier
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn import metrics


# In[35]:


bigquery_totals_df.dtypes


# In[36]:


bigquery_totals_df.nunique()


# In[37]:


# # Lets work on reducing value dimensions in some of our columns to do oneHotEncoding
# print(bigquery_totals_df.browser.value_counts())
# # We can reduce by counting all browser values under 100 as OTHER

# print(bigquery_totals_df.subcontinent.value_counts())
# # We can reduce by count all subcontinent values under 500 as OTHER

# print(bigquery_totals_df.country.value_counts())
# bigquery_totals_df.country.value_counts().plot.density()
# bigquery_totals_df.country.value_counts()[bigquery_totals_df.country.value_counts()>250]
# # We can reduce by count of all countries values under 250 as OTHER

# print(bigquery_totals_df.region.value_counts())
# bigquery_totals_df.region.value_counts()[bigquery_totals_df.region.value_counts()>100]
# # A lot of "not available in demo dataset". I think we should remove this column.

# bigquery_totals_df.metro.value_counts()
# # A lot of "not available in demo dataset". I think we should remove this column.

# bigquery_totals_df.city.value_counts()
# # A lot of "not available in demo dataset". I think we should remove this column.

# bigquery_totals_df.referralpath.value_counts()
# bigquery_totals_df.referralpath.value_counts()[bigquery_totals_df.referralpath.value_counts()>10]
# # Unsure how well this column will be in our model. I think we should remove this column 

# bigquery_totals_df.source.value_counts()
# bigquery_totals_df.source.value_counts()[bigquery_totals_df.source.value_counts()>50]
# # We can reduce by count of all sources under 50 as OTHER




# In[38]:


#REPLACEEEEEEEEEEEEEEE
replace_browser_types = list(bigquery_totals_df.browser.value_counts()[bigquery_totals_df.browser.value_counts()<100].index)
replace_subcontinent_types = list(bigquery_totals_df.subcontinent.value_counts()[bigquery_totals_df.subcontinent.value_counts()<500].index)
replace_country_types = list(bigquery_totals_df.country.value_counts()[bigquery_totals_df.country.value_counts()<250].index)
replace_source_types = list(bigquery_totals_df.source.value_counts()[bigquery_totals_df.source.value_counts()<50].index)


replace_transactions_values = list(bigquery_totals_df.transactions.value_counts().index)
replace_transactions_values


# In[39]:


#Replace in dataframe
for browser_replace in replace_browser_types:
    bigquery_totals_df.browser = bigquery_totals_df.browser.replace(browser_replace,"Other")

for subcontinent_replace in replace_subcontinent_types:
    bigquery_totals_df.subcontinent = bigquery_totals_df.subcontinent.replace(subcontinent_replace,"Other")
    
for country_replace in replace_country_types:
    bigquery_totals_df.country = bigquery_totals_df.country.replace(country_replace,"Other")
    
for source_replace in replace_source_types:
    bigquery_totals_df.source = bigquery_totals_df.source.replace(source_replace,"Other")
    
# Our predicting variable transactions, is an integer value for total number of ecommerce transactions. We want to make this a categorical variable
for trans_vals in replace_transactions_values:
    if trans_vals > 0.0:
        bigquery_totals_df.transactions[bigquery_totals_df.transactions == trans_vals] = 1
    elif trans_vals == 0.0:
        bigquery_totals_df.transactions[bigquery_totals_df.transactions == trans_vals] = 0
    
bigquery_totals_df.transactions = bigquery_totals_df.transactions.astype(int)
#bigquery_totals_df.transactions.unique() 
bigquery_totals_df.nunique() 


# In[43]:


#Create a list of the categorical variables
bigquery_totals_cat = bigquery_totals_df.dtypes[bigquery_totals_df.dtypes == "object"].index.tolist()


# From the list of categorical variables we DONT want some of them. We'll .remove() the columns we want from the list
removal_list = ['fullvisitorid','region','metro','city','referralpath','date']

for elem in removal_list:
    bigquery_totals_cat.remove(elem)


# Fix Boolean istruedirect column from True/None to 1/0
# bigquery_totals_df["istruedirect"] = bigquery_totals_df["istruedirect"].astype(int)

# #get number of unique values per category column
bigquery_totals_df[bigquery_totals_cat].head()


# In[67]:


bigquery_totals_df.dtypes[bigquery_totals_df.dtypes == "object"].index.tolist()


# In[44]:


#slap a OneHotEncoding on this for categorical columns
enc = OneHotEncoder(sparse=False)

#fit and transform the encoding using the categorical variable list
encode_df = pd.DataFrame(enc.fit_transform(bigquery_totals_df[bigquery_totals_cat]))

#add the encoded variable names to the DataFrame
encode_df.columns = enc.get_feature_names(bigquery_totals_cat)
encode_df.head()


# In[45]:


#merge one-hot encoded features and drop the originals
bigquery_totals_df1 = bigquery_totals_df.merge(encode_df,left_index = True, right_index = True)
bigquery_totals_df1 = bigquery_totals_df1.drop(columns = bigquery_totals_cat+removal_list)
#bigquery_hits_df1 = bigquery_hits_df1.drop(columns = remove_these_columns)
bigquery_totals_df1.head()
#bigquery_hits_df1.productprice


# In[ ]:





# In[46]:


#Remove Action type from our features dataset
y = bigquery_totals_df1.transactions

X = bigquery_totals_df1.drop(columns =['transactions','totaltransactionrevenue','transactionrevenue'])

# Split training/test datasets
X_train, X_test, y_train, y_test = train_test_split(X, y, random_state=1337,stratify = y)

#y.unique()


# In[47]:


# Upsampling to boost our test variable!
from sklearn.utils import resample

# What we'll do is rejoin our traning data set back together, and then resample data from the training data
# such that we have an equal number of transactions (value of 1) and no transactions (value of 0)

# Concatenate our training data back together
X = pd.concat([X_train,y_train], axis = 1)

# Separate minority and majority classes
not_transaction = X[X.transactions == 0]
transaction = X[X.transactions == 1]

# Upsample minority
transaction_upsampled = resample(transaction,
                                replace = True, # sample with replacement
                                n_samples = len(not_transaction), # match number in majority class
                                random_state = 27) # reproducible results

#combine majority and upsampled minority
upsampled = pd.concat([not_transaction,transaction_upsampled])

# check new transaction counts
upsampled.transactions.value_counts()


# In[66]:


# Undersampling to even our test variable!
# use the same tranasction and not_transaction from above

# downsampled majority
not_transaction_downsampled = resample(not_transaction,
                                replace = False, # sample without replacement
                                n_samples = len(transaction), # match number in minority class
                                random_state = 27) # reproducible results

# Combine minority and downsampled majority
downsampled = pd.concat([not_transaction_downsampled,transaction])

# Checking counts
downsampled.transactions.value_counts()


# In[ ]:





# In[49]:


# Point to our upsampled/downsampled data
# Upsampled
y_train = upsampled.transactions
X_train = upsampled.drop('transactions',axis = 1)

# Downsampled
# y_train = downsampled.transactions
# X_train = downsampled.drop('transactions',axis = 1)


# In[50]:


#Standar scaler time lets get it

#create a StandardScaler instance
scaler = StandardScaler()

#Fit the StandardScaler
X_scaler = scaler.fit(X_train)

# Scale the data
X_train_scaled = X_scaler.transform(X_train)
X_test_scaled = X_scaler.transform(X_test)


# In[62]:


# Function for all Machine Learning methods. This will help compare results
def run_ml_model(x_data_train,x_data_test,y_data_train,y_data_test,model,n_runs):
    my_cm = 0
    my_acc = 0
    my_f1 = 0
    my_recall = 0
    if model == 'Logistic Regression':
        # Define the logistic regression model
        log_classifier = LogisticRegression(solver="lbfgs",max_iter=n_runs)

        # Train the model
        log_classifier.fit(x_data_train,y_data_train)

        # Evaluate the model
        y_pred = log_classifier.predict(x_data_test)

        my_cm = metrics.confusion_matrix(y_data_test,y_pred)
        my_acc = accuracy_score(y_data_test,y_pred)
        my_f1  = f1_score(y_data_test,y_pred)
        my_recall = recall_score(y_data_test,y_pred)
        
    if model == 'Random Forest':
        # Create a random forest classifier.
        rf_model = RandomForestClassifier(n_estimators=n_runs, random_state=1337)

        # Fitting the model
        rf_model = rf_model.fit(x_data_train, y_data_train)

        # Evaluate the model
        y_pred = rf_model.predict(x_data_test)
        my_cm = metrics.confusion_matrix(y_data_test,y_pred)
        my_acc = accuracy_score(y_data_test,y_pred)
        my_f1  = f1_score(y_data_test,y_pred)
        my_recall = recall_score(y_data_test,y_pred)
    
    if model == 'Neural Network':
        # Define the basic neural network model
        nn_model = tf.keras.models.Sequential()
        nn_model.add(tf.keras.layers.Dense(units=25, activation="tanh", input_dim=124))
        nn_model.add(tf.keras.layers.Dense(units=10, activation="relu"))

        # Compile the Sequential model together and customize metrics
        nn_model.compile(loss="binary_crossentropy", optimizer="adam", metrics=["accuracy"])

        # Train the model
        fit_model = nn_model.fit(x_data_train, y_data_train, epochs=n_runs)

        y_pred = nn_model.predict_classes(x_data_test,verbose = 1)

        # Evaluate the model using the test data
        nn_model.evaluate(x_data_test,y_data_test,verbose=0)
        my_cm = metrics.confusion_matrix(y_data_test,y_pred)
        my_acc = accuracy_score(y_data_test,y_pred)
        my_f1  = f1_score(y_data_test,y_pred)
        my_recall = recall_score(y_data_test,y_pred)
        
    #return print(cm), print(f" Logistic regression model accuracy: {accuracy_score(y_data_test,y_pred):.3f}"), print(f" F1 Score: {f1_score(y_data_test,y_pred):.3f}"),print(f" Recall Score: {recall_score(y_data_test,y_pred):.3f}")
    return my_cm, my_acc, my_f1,my_recall


# In[65]:


print('====== Logistic Regression')
log_cm,log_acc,log_f1,log_recall = run_ml_model(X_train_scaled,X_test_scaled,y_train,y_test,'Logistic Regression',n_runs = 10000)
print(log_cm,'\n',f" Logistic regression model accuracy: {log_acc:.3f}",'\n',f" F1 Score: {log_f1:.3f}",'\n',f" Recall Score: {log_recall:.3f}")
print('===========================\n')

print('====== Random Forest')
rf_cm,rf_acc,rf_f1,rf_recall = run_ml_model(X_train_scaled,X_test_scaled,y_train,y_test,'Random Forest',n_runs = 50)
print(rf_cm,'\n',f" Random Forest model accuracy: {rf_acc:.3f}",'\n',f" F1 Score: {rf_f1:.3f}",'\n',f" Recall Score: {rf_recall:.3f}")
print('===========================\n')

print('====== Neural Network')
nn_cm,nn_acc,nn_f1,nn_recall = run_ml_model(X_train_scaled,X_test_scaled,y_train,y_test,'Random Forest',n_runs = 200)
print(nn_cm,'\n',f" Neural Network model accuracy: {nn_acc:.3f}",'\n',f" F1 Score: {nn_f1:.3f}",'\n',f" Recall Score: {nn_recall:.3f}")
print('===========================\n')


# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# # Scratchwork below

# In[53]:


# Define the logistic regression model
log_classifier = LogisticRegression(solver="lbfgs",max_iter=10000)

# Train the model
log_classifier.fit(X_train_scaled,y_train)

# Evaluate the model
y_pred = log_classifier.predict(X_test_scaled)

cm = metrics.confusion_matrix(y_test,y_pred)
print(cm)

print(f" Logistic regression model accuracy: {accuracy_score(y_test,y_pred):.3f}")



print(f" F1 Score: {f1_score(y_test,y_pred):.3f}")
print(f" Recall Score: {recall_score(y_test,y_pred):.3f}")


# In[54]:


# Create a random forest classifier.
rf_model = RandomForestClassifier(n_estimators=350, random_state=1337)

# Fitting the model
rf_model = rf_model.fit(X_train_scaled, y_train)

# Evaluate the model
y_pred = rf_model.predict(X_test_scaled)
cm = metrics.confusion_matrix(y_test,y_pred)
print(cm)


print(f" Random forest predictive accuracy: {accuracy_score(y_test,y_pred):.3f}")

print(f" F1 Score: {f1_score(y_test,y_pred):.3f}")
print(f" Recall Score: {recall_score(y_test,y_pred):.3f}")


# In[60]:


# Define the deep neural network model
nn_model = tf.keras.models.Sequential()
nn_model.add(tf.keras.layers.Dense(units=5, activation="tanh", input_dim=124))
nn_model.add(tf.keras.layers.Dense(units=1, activation="relu"))

# Compile the Sequential model together and customize metrics
nn_model.compile(loss="binary_crossentropy", optimizer="adam", metrics=["accuracy"])

# Train the model
fit_model = nn_model.fit(X_train_scaled, y_train, epochs=20)

y_pred = nn_model.predict_classes(X_test_scaled,verbose = 1)

# Evaluate the model using the test data
model_loss, model_accuracy = nn_model.evaluate(X_test_scaled,y_test,verbose=1)
print(f"Loss: {model_loss}, Accuracy: {model_accuracy}")




# In[57]:


cm = metrics.confusion_matrix(y_test,y_pred)
print(cm)
print(f" Neural Network predictive accuracy: {accuracy_score(y_test,y_pred):.3f}")
print(f" F1 Score: {f1_score(y_test,y_pred):.3f}")
print(f" Recall Score: {recall_score(y_test,y_pred):.3f}")


# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:




