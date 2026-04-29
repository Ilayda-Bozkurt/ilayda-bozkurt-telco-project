-------------------------------------------------------
-- 1. TARIFF-BASED CUSTOMER QUERIES
-------------------------------------------------------

-- 1.1 List the customers subscribed to 'Kobiye Destek'
/* This query joins the CUSTOMERS and TARIFFS tables using the TARIFF_ID foreign key. 
By filtering the TARIFF_NAME column for 'Kobiye Destek', we retrieve all customers associated with this specific plan. 
The join operation ensures that we only see valid customer-tariff matches from the database.
*/
SELECT c.NAME, t.TARIFF_NAME 
FROM CUSTOMERS c
JOIN TARIFFS t ON c.TARIFF_ID = t.TARIFF_ID
WHERE t.TARIFF_NAME = 'Kobiye Destek';

-------------------------------------------------------
-- 5. USAGE ANALYSIS
-------------------------------------------------------

-- 5.1 Customers who used at least 75% of their data limit
/* This query calculates the ratio of USED_DATA to the TARIFF's DATA_LIMIT for each customer. 
By multiplying the result by 100, we obtain the percentage and filter for values equal to or greater than 75. 
This analysis is crucial for identifying high-usage customers who might need a package upgrade.
*/
SELECT c.NAME, (ms.USED_DATA / t.DATA_LIMIT) * 100 as USAGE_PERCENT
FROM CUSTOMERS c
JOIN MONTHLY_STATS ms ON c.CUSTOMER_ID = ms.CUSTOMER_ID
JOIN TARIFFS t ON c.TARIFF_ID = t.TARIFF_ID
WHERE (ms.USED_DATA / t.DATA_LIMIT) >= 0.75;

-- 5.2 Customers who exhausted ALL limits (Data, Min, SMS)
/* This query filters customers whose usage values have met or exceeded all three individual limits: data, minutes, and SMS. 
It requires a triple comparison in the WHERE clause to ensure the customer has no remaining balance in any category. 
Identifying these customers helps the marketing team target users who are most likely to buy additional add-ons.
*/
SELECT c.NAME 
FROM CUSTOMERS c
JOIN MONTHLY_STATS ms ON c.CUSTOMER_ID = ms.CUSTOMER_ID
JOIN TARIFFS t ON c.TARIFF_ID = t.TARIFF_ID
WHERE ms.USED_DATA >= t.DATA_LIMIT 
  AND ms.USED_MIN >= t.MIN_LIMIT 
  AND ms.USED_SMS >= t.SMS_LIMIT;

-------------------------------------------------------
-- 6. PAYMENT ANALYSIS
-------------------------------------------------------

-- 6.1 Customers with unpaid fees
/* This query targets the IS_PAID column in the MONTHLY_STATS table to find records marked with 'N'. 
It links these records to the CUSTOMERS table to display the names of individuals with outstanding balances. 
This is a fundamental operation for the billing department to manage debt collection and service suspension.
*/
SELECT c.NAME, ms.IS_PAID
FROM CUSTOMERS c
JOIN MONTHLY_STATS ms ON c.CUSTOMER_ID = ms.CUSTOMER_ID
WHERE ms.IS_PAID = 'N';
