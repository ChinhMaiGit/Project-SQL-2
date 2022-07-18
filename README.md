# SQL Project 2: Olist public data exploratory analysis
**Author**: Chinh X. Mai, **Date**: July 18, 2022

![README_banner](https://user-images.githubusercontent.com/89245616/179622176-929874a2-e6be-46a9-ba20-29756bc9e139.png)

## Dataset introduction

Welcome! This is a Brazilian ecommerce public dataset of orders made at [Olist Store](https://olist.com/pt-br/). The dataset has information of 100k orders from 2016 to 2018 made at multiple marketplaces in Brazil. Its features allows viewing an order from multiple dimensions: from order status, price, payment and freight performance to customer location, product attributes and finally reviews written by customers. We also released a geolocation dataset that relates Brazilian zip codes to lat/lng coordinates.

This is real commercial data, it has been anonymised, and references to the companies and partners in the review text have been replaced with the names of Game of Thrones great houses.

**Context**

This dataset was generously provided by Olist, the largest department store in Brazilian marketplaces. Olist connects small businesses from all over Brazil to channels without hassle and with a single contract. Those merchants are able to sell their products through the Olist Store and ship them directly to the customers using Olist logistics partners. See more on our website: www.olist.com

After a customer purchases the product from Olist Store a seller gets notified to fulfill that order. Once the customer receives the product, or the estimated delivery date is due, the customer gets a satisfaction survey by email where he can give a note for the purchase experience and write down some comments.

**Acknowledgements**

Thanks to Olist for releasing this dataset.

# Executive summary

In this project, an exploratory data analysis is carried out using SQL as the main tool for extracting and manipulating data from the database and `plotly` is used as the main package for visualizing query result. The thought process when analyzing the data is also briefly described in order to provide insights to the way I reason and approach the data. The achievements of this project include

* Gaining many insights of each separate component of the e-commerce platform Olist 
* Visualizing some extracted tables by proper types of chart
* Many useful insights for further investigations are also presented during the analysis
* Some relevant connections among the tables are also discussed so that they can be utilized for other potential projects
* Both SQL and Python codes are used to carry out the analysis together

Furthermore, many SQL techniques are also applied to manifest the though process and the intuitions of the implemented charts are also discussed. These technical aspects include

* Basic SQL operations like extract, filter, and order data from a certain table
* Joining tables to combine data from different tables
* Set intersection is used to combine results of different queries
* Using common table expression (CTE) to support the table manipulation
* Aggregating data by the GROUP BY clause and by window functions
* Pivoting table using the CROSSTAB function of tablefunc extension
* Casting data type and other complicated calculations

Not so many complicated charts are used to visualize data in this project. Both vertical and horizontal bar charts are used to present count data and donut chart is used to illustrate shares. Chorolepth graph used to visualize the geographical distribution might be considered as the only complicated visualization implemented in this project.

## Detailed documentation

For detailed documentation, please refer to the Github repository using the following link

[SQL Project 2 Github](https://github.com/ChinhMaiGit/Project-SQL-2/)

or access the analysis workbook directly

[SQL project 1 Workbook](/html/project1.html)

# References

1. [Olist public data on Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
