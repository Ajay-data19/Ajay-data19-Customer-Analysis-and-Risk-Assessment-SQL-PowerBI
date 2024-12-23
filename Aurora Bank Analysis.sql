-- Transaction Analysis

-- What are the highest spending categories?
SELECT 
    mc.Description AS Merchant_Category, 
    SUM(t.amount) AS Total_Spent
FROM 
    transactions_data t
JOIN 
    MCC_codes mc ON t.mcc = mc.mcc_id
GROUP BY 
    mc.Description
ORDER BY 
    Total_Spent DESC
LIMIT 10;

-- What are the top merchant cities by transaction count?
SELECT 
    merchant_city, 
    COUNT(*) AS Transaction_Count
FROM 
    transactions_data
GROUP BY 
    merchant_city
ORDER BY 
    Transaction_Count DESC
LIMIT 10;

-- What are the merchant categories with states?
SELECT 
    mc.Description AS Merchant_Category, 
    t.merchant_state, 
    COUNT(*) AS Transaction_Count
FROM 
    transactions_data t
JOIN 
    mcc_codes mc ON t.mcc = mc.mcc_id
GROUP BY 
    mc.Description, t.merchant_state
ORDER BY 
    Transaction_Count DESC;

-- What are the total transactions and amounts by state?
SELECT 
    merchant_state, 
    COUNT(*) AS Total_Transactions, 
    SUM(amount) AS Total_Amount
FROM 
    transactions_data
GROUP BY 
    merchant_state
ORDER BY 
    Total_Amount DESC 
LIMIT 10;

-- What is the transaction type overview?
SELECT 
    CASE 
        WHEN use_chip = 'Chip Transaction' THEN 'Chip Transaction'
        WHEN use_chip = 'Swipe Transaction' THEN 'Swipe Transaction'
        WHEN use_chip = 'Online Transaction' THEN 'Online Transaction'
        ELSE 'Unknown Transaction'
    END AS Transaction_Type,
    COUNT(*) AS Transaction_Count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM transactions_data), 2) AS Percentage_Contribution
FROM 
    transactions_data
GROUP BY 
    use_chip;

-- Who are the high-spending customers?
SELECT 
    t.client_id AS User_ID, 
    SUM(t.amount) AS Total_Spending
FROM 
    transactions_data t
GROUP BY 
    t.client_id
ORDER BY 
    Total_Spending DESC
LIMIT 10;

-- Who are the most active users by transaction count?
SELECT 
    t.client_id AS User_ID, 
    COUNT(*) AS Transaction_Count
FROM 
    transactions_data t
GROUP BY 
    t.client_id
ORDER BY 
    Transaction_Count DESC
LIMIT 10;

-- What is the card type distribution by gender?
SELECT 
    u.gender, 
    c.card_type, 
    COUNT(*) AS Card_Count
FROM 
    users_data u
JOIN 
    cards_data c ON u.id = c.client_id
GROUP BY 
    u.gender, c.card_type
ORDER BY 
    Card_Count DESC;

-- What is the average transaction amount by card type?
SELECT 
    c.card_type, 
    AVG(t.amount) AS Avg_Transaction_Amount
FROM 
    transactions_data t
JOIN 
    Cards_data c ON t.card_id = c.id
GROUP BY 
    c.card_type;

-- What are the monthly spending trends?
SELECT 
    DATE_FORMAT(t.date, '%Y-%m') AS Month, 
    SUM(t.amount) AS Total_Spent
FROM 
    transactions_data t
GROUP BY 
    Month
ORDER BY 
    Month;

-- Who are the customers with the most credit cards?
SELECT 
    u.id AS User_ID, 
    COUNT(c.id) AS Total_Cards
FROM 
    users_data u
JOIN 
    cards_data c ON u.id = c.client_id
GROUP BY 
    u.id
ORDER BY 
    Total_Cards DESC
LIMIT 10;

-- What are the top 5 cities with the highest credit card spends and their percentage contribution?
WITH total_spends_cte AS (
    SELECT SUM(amount) AS total_spends
    FROM transactions_data
),
city_spends_cte AS (
    SELECT 
        merchant_city, 
        SUM(amount) AS spends
    FROM transactions_data
    GROUP BY merchant_city
    ORDER BY spends DESC
    LIMIT 5
)
SELECT 
    merchant_city, 
    spends, 
    CONCAT(ROUND((spends * 100.0 / total_spends), 2), '%') AS percentage_contribution
FROM 
    city_spends_cte 
CROSS JOIN 
    total_spends_cte;

-- What is the highest spending month and amount for each card type?
WITH monthly_spends_cte AS (
    SELECT 
        cards_data.card_type,
        MONTHNAME(STR_TO_DATE(transactions_data.date, '%Y-%m-%d')) AS spend_month,
        YEAR(STR_TO_DATE(transactions_data.date, '%Y-%m-%d')) AS spend_year,
        SUM(transactions_data.amount) AS monthly_spends
    FROM 
        transactions_data
    INNER JOIN 
        cards_data ON transactions_data.card_id = cards_data.id
    GROUP BY 
        cards_data.card_type, MONTHNAME(STR_TO_DATE(transactions_data.date, '%Y-%m-%d')), YEAR(STR_TO_DATE(transactions_data.date, '%Y-%m-%d'))
)
SELECT 
    card_type, 
    spend_month, 
    spend_year, 
    monthly_spends
FROM (
    SELECT 
        card_type,
        spend_month,
        spend_year,
        monthly_spends,
        RANK() OVER (PARTITION BY card_type ORDER BY monthly_spends DESC) AS rank_value
    FROM 
        monthly_spends_cte
) ranked_spends
WHERE rank_value = 1;

-- What are the transaction details for each card type when cumulative spends exceed 500 $? 
WITH cumulative_spends_cte AS (
    SELECT 
        card_id, 
        date, 
        amount, 
        SUM(amount) OVER (PARTITION BY card_id ORDER BY date) AS cumulative_spends
    FROM 
        transactions_data
)
SELECT 
    card_id, 
    date, 
    amount, 
    cumulative_spends
FROM (
    SELECT 
        card_id, 
        date, 
        amount, 
        cumulative_spends, 
        RANK() OVER (PARTITION BY card_id ORDER BY cumulative_spends) AS rank_value
    FROM 
        cumulative_spends_cte
    WHERE 
        cumulative_spends >= 500
) ranked_data
WHERE 
    rank_value = 1;

-- Risk Analysis

-- Which merchant categories have the most errors?
SELECT 
    mc.Description AS Merchant_Category, 
    COUNT(t.errors) AS Error_Count
FROM 
    transactions_data t
JOIN 
    mcc_codes mc ON t.mcc = mc.mcc_id
WHERE 
    t.errors IS NOT NULL
GROUP BY 
    mc.Description
ORDER BY 
    Error_Count DESC;

-- What are the most common transaction errors?
SELECT 
    errors, 
    COUNT(*) AS Error_Count
FROM 
    transactions_data
WHERE 
    errors IS NOT NULL
GROUP BY 
    errors
ORDER BY 
    Error_Count DESC;

-- Which high-value transactions should be flagged for fraud analysis?
SELECT 
    id AS Transaction_ID, 
    amount
FROM 
    transactions_data
WHERE 
    amount > (SELECT AVG(amount) * 3 FROM transactions_data);

-- What is the age distribution of customers with debt?
SELECT 
    current_age, 
    COUNT(*) AS Customer_Count,
    SUM(total_debt) AS Total_Debt
FROM 
    users_data
WHERE 
    total_debt > 0
GROUP BY 
    current_age
ORDER BY 
    Customer_Count DESC;

-- Who are the customers with credit scores below the threshold?
SELECT 
    id AS User_ID, 
    credit_score
FROM 
    users_data
WHERE 
    credit_score < 600
ORDER BY 
    credit_score DESC;

-- Which customers are high-risk based on debt-to-income ratio?
SELECT 
    id AS User_ID, 
    yearly_income, 
    total_debt, 
    (total_debt / NULLIF(yearly_income, 0)) AS Debt_to_Income_Ratio
FROM 
    users_data
WHERE 
    (total_debt / NULLIF(yearly_income, 0)) > 0.5;

-- Which cards are expired?
SELECT 
    id AS Card_ID, 
    client_id AS User_ID, 
    expires
FROM 
    cards_data
WHERE 
    expires < CURDATE();

-- Special Analyses

-- Which city has the lowest percentage spend for "Debit (Prepaid)" card type?
WITH total_spends_cte AS (
    SELECT 
        SUM(amount) AS total_spends
    FROM 
        transactions_data
),
city_spends_cte AS (
    SELECT 
        merchant_city, 
        card_type,
        SUM(amount) AS spends
    FROM 
        transactions_data
    INNER JOIN 
        cards_data ON transactions_data.card_id = cards_data.id
    GROUP BY 
        merchant_city, card_type
)
SELECT 
    merchant_city, 
    spends, 
    CONCAT(ROUND(CAST((spends * 100.0 / total_spends) AS FLOAT), 2), '%') AS percentage_contribution
FROM 
    city_spends_cte
CROSS JOIN 
    total_spends_cte
WHERE 
    card_type = 'Debit (Prepaid)'
ORDER BY 
    percentage_contribution ASC
LIMIT 1;


-- What is the percentage contribution of spends by females for each merchant city?

WITH total_spends_cte AS (
    SELECT 
        SUM(amount) AS total_spends
    FROM 
        transactions_data
),
city_spends_cte AS (
    SELECT 
        merchant_city, 
        SUM(amount) AS spends
    FROM 
        transactions_data
    INNER JOIN 
        users_data ON transactions_data.client_id = users_data.id
    WHERE 
        users_data.gender = 'Female'
    GROUP BY 
        merchant_city
)
SELECT 
    merchant_city, 
    spends, 
    CONCAT(ROUND(CAST((spends * 100.0 / total_spends) AS FLOAT), 2), '%') AS percentage_contribution
FROM 
    city_spends_cte
CROSS JOIN 
    total_spends_cte
ORDER BY 
    percentage_contribution DESC;
