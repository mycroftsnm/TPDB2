SELECT
    B.BILLING_ID,
    B.DATE AS BILLING_DATE,
    B.CUSTOMER_ID,
    B.EMPLOYEE_ID,
    D.PRODUCT_ID,
    D.QUANTITY,
    P.PRICE,
    D.QUANTITY * P.PRICE AS TOTAL,
    IFNULL(DIS.UNTIL, CURDATE()) AS DISCOUNT_UNTIL,
    DIS.PERCENTAGE
FROM
    Billing B
INNER JOIN
    billing_detail D ON B.BILLING_ID = D.BILLING_ID
INNER JOIN
    Prices P ON D.PRODUCT_ID = P.PRODUCT_ID
               AND P.DATE = (
                    SELECT MAX(PR2.DATE)
                    FROM Prices PR2
                    WHERE PR2.PRODUCT_ID = D.PRODUCT_ID
                      AND PR2.DATE <= B.DATE
               )
LEFT JOIN
    discounts DIS ON D.QUANTITY * P.PRICE >= DIS.TOTAL_BILLING
                  AND B.DATE >= DIS.FROM 
                  AND B.DATE <= IFNULL(DIS.UNTIL, CURDATE());
