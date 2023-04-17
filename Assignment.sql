--1. Create a procedure that adds a late fee to any customer who returned their rental after 7 days.
Use the payment and rental tables.

CREATE OR REPLACE PROCEDURE latefee(
    cust_id INTEGER,
    pay_id INTEGER,
    late_fee_amount DECIMAL(5,2)
)
LANGUAGE plpgsql 
AS $$ 
BEGIN
    UPDATE payment 
    SET amount = amount + late_fee_amount
    WHERE customer_id = cust_id AND payment_id = pay_id;
END;
$$;

SELECT *
FROM payment
WHERE payment_id = 17503;

CALL latefee(341, 17503, 2.00);

SELECT *
FROM payment
WHERE payment_id = 17503;

-- 2. Add a new column in the customer table for Platinum Member. This can be a boolean.
-- Platinum Members are any customers who have spent over $200. 
-- Create a procedure that updates the Platinum Member column to True for any customer who has spent over $200 and False for any customer who has spent less than $200.
-- Use the payment and customer table.

ALTER TABLE customer
ADD platinum_member BOOLEAN;


DROP FUNCTION update_platinum_member_status(); -- Make sure to match the function's parameters if it has any

CREATE OR REPLACE PROCEDURE update_platinum_member_status_proc()
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE customer SET platinum_member = (
        SELECT SUM(amount)
        FROM payment
        WHERE payment.customer_id = customer.customer_id
    ) > 200;

    COMMIT;
END;
$$;


CALL update_platinum_member_status_proc();
SELECT customer_id, platinum_member FROM customer;










