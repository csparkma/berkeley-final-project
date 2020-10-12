# Berkeley Final Project
Berkeley Data Analytics Bootcamp Final project - Sept-Oct 2020

# Presentation:
- Our overall project plan & outcome(s) can be found [here](https://docs.google.com/presentation/d/1IJwm4imWicTFp8LapvV8N88eyIyjYjRl-6_hksx4jWI/edit?usp=sharing).

## Group:
- **Nathan Toy**: Machine Learning Lead & Project Manager Assist
- **Karen Pineda**: Dashboard
- **Jessica Scott**: ETL
- **Connor Sparkman**: Project Manager Lead & Machine Learning Assist

## Communication Protocols:
- 60% *Slack*: Main source of communication used for collaboration and questions
- 35% *Video Chat*: Secondary source for us to brainstorm and make project decisions
- 5% *Phone*: Last resort communication to schedule meetings or get ahold of group member that is away from the computer.

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
  - Machine learning model will depend on overall testing, but will be a classification model as we are aiming to undersand specific individuals propensity (or liklihood) to purchase

# Technologies Used:
## Data Cleaning and Analysis
BigQuery will be used to clean the data and perform an exploratory analysis.
 
## Database Storage
 Amazon RDS will be used to store our data, and we will integrate it with Tableau to display the dashboard.
 
## Machine Learning

## Dashboard
Tableau will be used to create our Dashboard. It will be hosted through a webpage. 


## WEEK 2 
Dashboard Google Slide Link https://docs.google.com/presentation/d/1U8UInYX9gbfdw8o_efzpRncUv3fY-gJfF8pdPaCVu8A/edit?usp=sharing

- Blueprint 1 & 2 attached above  
