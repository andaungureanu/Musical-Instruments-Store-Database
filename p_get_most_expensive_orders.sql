CREATE OR REPLACE PROCEDURE get_most_expensive_orders(
    result OUT sys_refcursor
)
IS
    v_price ORDERS.amount_to_pay%type;
    v_final_price ORDERS.amount_to_pay%type;
    v_discount ORDERS.discount%type;
    v_name varchar2(50);
BEGIN
    FOR ord IN (SELECT ORDER_ID FROM ORDERS) LOOP
        SELECT SUM(price), FIRST_NAME || ' ' || LAST_NAME
        INTO v_price, v_name
        FROM ITEMS I INNER JOIN ORDERED_ITEMS OI on I.ITEM_ID = OI.ITEM_ID
        INNER JOIN ORDERS O ON OI.ORDER_ID = O.ORDER_ID
        INNER JOIN CUSTOMERS C on O.CUSTOMER_ID = C.CUSTOMER_ID
        WHERE O.ORDER_ID = ord.ORDER_ID
        GROUP BY FIRST_NAME || ' ' || LAST_NAME;

        SELECT discount
        INTO v_discount
        FROM ORDERS WHERE ORDER_ID = ord.ORDER_ID;

        v_final_price := v_price - nvl(v_discount, 0) * v_price / 100;

        UPDATE ORDERS SET amount_to_pay = v_final_price WHERE ORDER_ID = ord.ORDER_ID;
        INSERT INTO NAMES_AND_PAYS VALUES(v_name, v_final_price);
    END LOOP;
    OPEN result FOR
        SELECT * FROM NAMES_AND_PAYS
        ORDER BY paid DESC
        FETCH FIRST 5 ROWS ONLY;
END;