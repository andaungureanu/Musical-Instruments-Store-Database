CREATE OR REPLACE PROCEDURE get_favorite_manufacturers(
    result OUT sys_refcursor
)
IS
    v_manufacturer_name manufacturers.manufacturer_name%TYPE;
    v_full_name VARCHAR2(50);
BEGIN
    FOR cli_id IN (SELECT CUSTOMER_ID FROM CUSTOMERS) LOOP
        BEGIN
        SELECT MANUFACTURER_NAME, FIRST_NAME || ' ' || LAST_NAME
        INTO v_manufacturer_name, v_full_name
        FROM (SELECT COUNT(*) n, MANUFACTURER_NAME, LAST_NAME, FIRST_NAME FROM (
            SELECT M.MANUFACTURER_NAME, C.LAST_NAME, C.FIRST_NAME
            FROM MANUFACTURERS M INNER JOIN INSTRUMENTS INST ON M.MANUFACTURER_NAME = INST.MANUFACTURER_NAME
            INNER JOIN ITEMS I ON I.INSTRUMENT_ID = INST.INSTRUMENT_ID
            INNER JOIN ORDERED_ITEMS OI ON I.ITEM_ID = OI.ITEM_ID
            INNER JOIN ORDERS O ON OI.ORDER_ID = O.ORDER_ID
            INNER JOIN CUSTOMERS C ON O.CUSTOMER_ID = C.CUSTOMER_ID
            WHERE C.CUSTOMER_ID = cli_id.CUSTOMER_ID)
            GROUP BY MANUFACTURER_NAME, LAST_NAME, FIRST_NAME
            ORDER BY n, MANUFACTURER_NAME
            FETCH FIRST 1 ROWS ONLY);
        INSERT INTO favorite_manufacturers VALUES(v_full_name, v_manufacturer_name);
        EXCEPTION
        WHEN no_data_found THEN
            CONTINUE;
        END;
    END LOOP;
    OPEN result FOR
        SELECT manufacturer_name, COUNT(manufacturer_name) chosen_by
        FROM favorite_manufacturers
        GROUP BY manufacturer_name
        ORDER BY chosen_by DESC
        FETCH FIRST 5 ROWS ONLY;
END;

COMMIT;



