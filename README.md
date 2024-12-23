# Customer Analysis and Risk Assessment 
![3651295](https://github.com/user-attachments/assets/6c6fabce-f0e1-4554-8b83-fd4d30b43b55)

## Project Overview
The Aurora Bank KYC Analysis and Risk Assessment project utilizes advanced data analytics and visualization to uncover key insights within customer, transaction, and card usage datasets. By employing robust analytics and interactive dashboards, this project aids stakeholders in understanding customer behavior, identifying risks, and optimizing financial strategies.

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

![Screenshot 2024-12-21 230145](https://github.com/user-attachments/assets/997576d4-1644-4302-a195-babeaa906054)

**Customer Analysis**

![Screenshot 2024-12-21 230226](https://github.com/user-attachments/assets/6f07e5dd-1efa-4bbc-afe6-79d6123afe44)

**Risk Assessment**

![Screenshot 2024-12-21 230301](https://github.com/user-attachments/assets/be079fb1-c75a-4fdd-8489-d5eda27871e8)

**[Click here to access the interactive dashboard](https://app.powerbi.com/view?r=eyJrIjoiYjY2ZmIyZTctNjhiNS00ODViLTg5MWMtMzI0NDZjMjhlZWU4IiwidCI6ImY0M2MzMTgyLTcxZjAtNGRjOS04YjA0LTc0OTMwZTNmOGNkYSJ9)** 

## Key Insights

- The top merchant categories by transaction amount include Money Transfer, Grocery Stores, and Wholesale Clubs, reflecting essential spending trends.

- Debit Cards account for 57.52% of transaction amounts, dominating over Credit Cards (39.38%) and Prepaid Debit Cards (3.10%).

- Spending via Chip Transactions remains the highest across all years, with steady contributions from Online and Swipe Transactions.

- Customers aged 31-50 years form the largest demographic, followed by 51-70 years, with a balanced gender distribution across all groups.

- The Mid-Income Group has the highest concentration of credit card holders (1.48k), while the High-Income Group remains significantly smaller (19).

- Customers with credit scores <700 contribute to 63% of the transaction amount, indicating financial instability among a significant customer segment.

- High-risk transactions are primarily observed in Telecommunication Services, Utilities, and Wholesale Clubs, with spikes in Quarter 2 and 3 of recent years.

- An impressive 98.26% of transactions are error-free, though errors such as Insufficient Balance and Bad PIN require attention.

## Recommendations

- Focus on high-performing merchant categories such as Grocery Stores and Wholesale Clubs to capitalize on customer preferences.

- Introduce targeted campaigns to increase the adoption of Prepaid Debit Cards, which currently hold the smallest market share.

- Develop programs to improve financial health for customers with credit scores <700, particularly those aged 18-50 years.

- Strengthen fraud detection systems during Quarter 2 and 3, with specific attention to high-risk merchant categories.

- Enhance transaction systems to address frequent issues like Insufficient Balance and Bad PIN errors.

- Leverage Power BI dashboards to monitor risk zones and spending trends dynamically, enabling timely interventions.

## Learnings
`Data Integration`

Effectively combined and processed data from multiple sources, ensuring seamless integration for analysis despite initial inconsistencies.

`Advanced SQL and Power BI Techniques`

Enhanced proficiency in SQL for exploratory data analysis and Power BI for building interactive dashboards, showcasing the ability to extract, transform, and visualize data effectively.

`Risk Assessment Understanding`

Gained a deeper understanding of customer behavior, spending trends, and risk assessment, uncovering patterns critical for financial institutions.

`Error Analysis and Mitigation`

Learned to identify and address transactional errors like insufficient balances and bad PINs, emphasizing the importance of operational accuracy.

`Actionable Decision-Making`

Developed the ability to translate complex data into actionable insights, supporting stakeholder decisions with clear, data-driven recommendations.

## Files Information

- **Dataset**: The fully cleaned dataset is available in the main section for reference and further analysis.
 
- **SQL Analysis File**: The SQL queries and analysis conducted during the project are included in the file for review and reuse.
  
- **Interactive Dashboard** : Access the interactive Power BI dashboard through the link provided in the 'Dashboard Preview' section of this README file.

## Database Schema
![example_data_model](https://github.com/user-attachments/assets/2e639555-a48c-4752-a6b4-5f7a517d6774)

## Tech Stack
`Power Query` Employed for data adjustments and transformations.

`MySQL` Utilized for Exploratorary data analysis and querying.

`Power BI` Leveraged to create comprehensive reports and visualizations.

`DAX (Data Analysis Expressions)` Applied for creating  necessary measures and calculations.


## License
This project is licensed under the MIT License, allowing you to use, modify, and distribute the code and visuals while maintaining the original license terms.

---

For questions or feedback, please contact: ajaysonkatar@gmail.com

Enjoy exploring the project!







