# Customer Analysis and Risk Assessment 
![3651295](https://github.com/user-attachments/assets/6c6fabce-f0e1-4554-8b83-fd4d30b43b55)

## Project Overview
The Aurora Bank Data Analysis and Risk Assessment project utilizes advanced data analytics and visualization to uncover key insights within customer, transaction, and card usage datasets. By employing robust analytics and interactive dashboards, this project aids stakeholders in understanding customer behavior, identifying risks, and optimizing financial strategies.

Key outcomes include a comprehensive view of spending trends, customer segmentation, and fraud detection, providing actionable insights for decision-making in a dynamic banking environment.

## Problem Statement
Aurora Bank is striving to enhance its operational efficiency and customer engagement while mitigating financial risks. The bank faces challenges in understanding customer behavior, identifying potential fraud, and assessing risks associated with transactions and card usage. Additionally, there is a need for clear, actionable insights to support data-driven decision-making by stakeholders.

This project aims to address these challenges by analyzing customer demographics, transaction patterns, and card usage data, and by visualizing these insights through interactive Power BI dashboards. The goal is to enable the bank to uncover hidden opportunities, mitigate risks, and drive better financial outcomes.

## Process
`Data Cleaning Using Power Query`
 
The first phase of the project focused on data cleaning using Power Query in Power BI. Key activities included:

- Removing Null Values: Handling missing data for key attributes such as transaction amounts, customer demographics, and card information.
- Removing Duplicates: Eliminating any duplicate rows to ensure the accuracy of the data.
- Data Type Adjustments: Ensuring the correct data types (e.g., date, numeric) were applied to the columns to avoid any discrepancies during analysis.
- Column Selection: Removing unnecessary columns to streamline the dataset and improve performance.

`Basic Transformation and Exploratory Data Analysis (EDA) Using SQL`

Once the data was cleaned, basic transformations were applied and exploratory data analysis (EDA) was conducted using SQL to uncover initial insights. Key tasks involved:

- Aggregating Data: Using SQL queries to aggregate transaction data by card type, customer, and merchant category.
- Identifying Data Patterns: Analyzing spending trends, high-risk behaviors, and potential fraud detection indicators based on transaction history.
- Data Profiling: Profiling customer demographics (e.g., age, gender) and identifying key attributes for further analysis.

`Data Modeling with Power BI Measures`

In this step, the data was further enhanced for in-depth analysis using Power BI. Key activities included:

<pre><code>
# Calculated Cart Types 
CardTypeCount = COUNTROWS(GROUPBY(cards_data, cards_data[card_type]))

# Calculated Average Transaction Value
AvgTransactionValue = AVERAGE(transactions_data[amount])

# High Risk Transactions 
HighRiskTransactions = 
COUNTROWS(
    FILTER(
        transactions_data,  -- Your transactions table
        transactions_data[amount] > 300  -- Flag transactions above $400 as high-risk
    )
)
  
# Transaction Without Error 
NoErrorTransactions = COUNTROWS(
  FILTER(transactions_data, transactions_data[errors] = "No Errors")
)

# Transaction Without Error (%)
PercentNoErrorTransactions = DIVIDE([NoErrorTransactions], [TotalTransactions], 0) * 100

# Created High Risk Customers DAX Measure 
HighRiskCustomers = 
CALCULATE(
    COUNTROWS(users_data),
    FILTER(
        users_data,
        users_data[credit_score] <= 579 || 
        (users_data[credit_score] <= 650 && DIVIDE(users_data[total_debt], users_data[yearly_income], 0) > 0.5)
    )
)

# Created Calculated Column for Different Age Group 
Age_Group = 
SWITCH(
    TRUE(),
    users_data[current_age] >= 18 && users_data[current_age] <= 30, "18-30",
    users_data[current_age] > 30 && users_data[current_age] <= 50, "31-50",
    users_data[current_age] > 50 && users_data[current_age] <= 70, "51-70",
    users_data[current_age] > 70 && users_data[current_age] <= 101, "71-101",
    "Unknown"
)

# Created Credit Score Bins with Calculated Column 
CreditScoreBin = 
SWITCH(
    TRUE(),
    users_data[credit_score] < 600, "<600",
    users_data[credit_score] >= 600 && users_data[credit_score] <= 700, "600-700",
    users_data[credit_score] > 700, ">700",
    "Unknown" -- Handles any null or invalid values
)

# Created Debit to Income Ratio Column 
DebtToIncomeRatio = 
DIVIDE(
    users_data[total_debt],
    users_data[yearly_income],
    0
)

# Calculated Different Income Groups via Calculated Columns
IncomeGroup = 
SWITCH(
    TRUE(),
    users_data[yearly_income] <= 30000, "Low Income (<=$30K)",
    users_data[yearly_income] > 30000 && users_data[yearly_income] <= 70000, "Mid Income ($30K-$70K)",
    users_data[yearly_income] > 70000 && users_data[yearly_income] <= 120000, "Upper-Mid Income ($70K-$120K)",
    users_data[yearly_income] > 120000, "High Income (>$120K)",
    "Unknown"
)

# Calculated Risky Customers Categories by Using  Credit Score & Debit to Income Ratio
RiskCategoryN = 
IF(
    users_data[credit_score] <= 579,
    "High Risk", 
    IF(
        users_data[credit_score] <= 650 && 
        DIVIDE(users_data[total_debt], users_data[yearly_income], 0) > 0.5,
        "High Risk", 
        IF(
            users_data[credit_score] > 700,
            "Low Risk", 
            IF(
                users_data[credit_score] <= 650 && 
                DIVIDE(users_data[total_debt], users_data[yearly_income], 0) <= 0.3,
                "Low Risk", 
                "Medium Risk"  -- This will be for customers that are neither high nor low risk
            )
        )
    )
)

</code></pre>

`Data Analysis`

Once the data was prepared and modeled, an in-depth data analysis was performed within Power BI. Key insights included:

- Customer Segmentation: Identifying high-value, low-risk, and at-risk customer groups based on transaction frequency and amount.
- Fraud Detection: Identifying suspicious patterns, such as multiple transactions in short intervals or large transaction amounts for certain customers.
- Merchant Category Trends: Analyzing spending trends across various merchant categories to identify growth opportunities or high-risk areas.

`Dashboard Creation`

The final phase of the project involved the creation of an interactive Power BI dashboard. The dashboard included:

- Dynamic KPIs: Displaying critical metrics such as total transactions, risk levels, and the number of high-risk customers.
- Drill-Through Functionality: Enabling users to drill down into detailed customer transaction histories, geographical spending patterns, and merchant category trends.
- Visual Insights: Interactive charts and maps showing transaction trends over time, risk classifications by customer segment, and spending distribution across regions.

This structured process ensured that key business challenges were addressed with actionable insights, while the visualizations provided stakeholders with a clear and concise understanding of the data.

## Dashboard Preview

Explore the interactive Power BI dashboard created as part of the project! The dashboard provides actionable insights into customer analysis, transaction trends, and risk assessments.

### Key Features:
- Dynamic KPIs: Metrics for total transactions, high-risk customers, and regional spends.
- Interactive Visualizations: Drill-down charts for customer behavior and merchant trends.
- Fraud Detection Insights: Highlighted suspicious patterns for proactive risk management.
  
### Dashboard Structure:

**Overview Page**


**Customer Analysis**


**Risk Assessment**




