-- 1. Query to find the total business done by each store.
SELECT store.store_id, SUM(payment.amount) AS total_sales
FROM store
JOIN staff ON store.store_id = staff.store_id
JOIN payment ON staff.staff_id = payment.staff_id
GROUP BY store.store_id;

-- 2. Stored procedure to find the total business done by each store.
DELIMITER //

CREATE PROCEDURE TotalBusinessByStore()
BEGIN
    SELECT store.store_id, SUM(payment.amount) AS total_sales
    FROM store
    JOIN staff ON store.store_id = staff.store_id
    JOIN payment ON staff.staff_id = payment.staff_id
    GROUP BY store.store_id;
END //

DELIMITER ;

-- 3. Stored procedure that takes the input for `store_id` and displays the total sales for that store.
DELIMITER //

CREATE PROCEDURE TotalSalesByStore(IN store_id INT)
BEGIN
    SELECT store.store_id, SUM(payment.amount) AS total_sales
    FROM store
    JOIN staff ON store.store_id = staff.store_id
    JOIN payment ON staff.staff_id = payment.staff_id
    WHERE store.store_id = store_id
    GROUP BY store.store_id;
END //

DELIMITER ;

-- 4. Stored procedure with an OUT parameter for total sales value.
DELIMITER //

CREATE PROCEDURE GetTotalSalesByStore(IN store_id INT, OUT total_sales_value FLOAT)
BEGIN
    SELECT SUM(payment.amount) INTO total_sales_value
    FROM store
    JOIN staff ON store.store_id = staff.store_id
    JOIN payment ON staff.staff_id = payment.staff_id
    WHERE store.store_id = store_id;
END //

DELIMITER ;

-- Example call for the procedure and to print the results:
CALL GetTotalSalesByStore(1, @total_sales);
SELECT @total_sales AS TotalSales;

-- 5. Stored procedure with an OUT parameter for total sales value and a flag.
DELIMITER //

CREATE PROCEDURE GetTotalSalesAndFlagByStore(IN store_id INT, OUT total_sales_value FLOAT, OUT flag VARCHAR(10))
BEGIN
    SELECT SUM(payment.amount) INTO total_sales_value
    FROM store
    JOIN staff ON store.store_id = staff.store_id
    JOIN payment ON staff.staff_id = payment.staff_id
    WHERE store.store_id = store_id;

    IF total_sales_value > 30000 THEN
        SET flag = 'green_flag';
    ELSE
        SET flag = 'red_flag';
    END IF;
END //

DELIMITER ;

-- Example call for the procedure and to print the results:
CALL GetTotalSalesAndFlagByStore(1, @total_sales, @flag);
SELECT @total_sales AS TotalSales, @flag AS FlagStatus;