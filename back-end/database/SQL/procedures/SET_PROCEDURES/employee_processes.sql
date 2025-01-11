DROP PROCEDURE IF EXISTS add_employee;
DROP PROCEDURE IF EXISTS create_deal;
DROP PROCEDURE IF EXISTS create_payment;
DROP PROCEDURE IF EXISTS set_notification;
DROP PROCEDURE IF EXISTS update_bank_account_for_employee;
DROP PROCEDURE IF EXISTS update_realty_has_keys;
DROP PROCEDURE IF EXISTS set_employee_status;

-- Процедура для додавання нового співробітника +
CREATE PROCEDURE add_employee(
    IN p_fullname VARCHAR(50),
    IN p_email VARCHAR(50),
    IN p_phone_number VARCHAR(50),
    IN p_city_id INT,
    IN p_address VARCHAR(255),
    IN p_role_id INT,
    IN p_status INT,
    IN p_base_commission_rate DECIMAL(5, 2),
    IN p_employee_status TINYINT(1),
    IN p_hire_date DATE,
    IN p_employee_rank INT
)
BEGIN
    INSERT INTO employees (fullname, email, phone_number, city_id, address, role_id, status, base_commission_rate, employee_status, hire_date, employee_rank)
    VALUES (p_fullname, p_email, p_phone_number, p_city_id, p_address, p_role_id, p_status, p_base_commission_rate, p_employee_status, p_hire_date, p_employee_rank);
END;

CREATE PROCEDURE update_bank_account_for_employee(
    IN p_employee_id INT,
    IN p_bank_account BIGINT
)
BEGIN
    IF EXISTS (SELECT 1 FROM employees WHERE employee_id = p_employee_id) THEN
        UPDATE employees
        SET bank_account = p_bank_account
        WHERE employee_id = p_employee_id;
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'User with the specified ID does not exist.';
    END IF;
END;



CREATE PROCEDURE update_realty_has_keys(
    IN p_estate_id INT)
BEGIN
    UPDATE realty
    SET has_keys_in_office = TRUE 
    WHERE estate_id = p_estate_id;
END ;


-- CALL create_deal(37,12,23);
-- Процедура для створення нової угоди +
CREATE PROCEDURE create_deal(
    IN p_estate_id INT,
    IN p_customer_id INT,
    IN p_estate_agent_id INT
)
BEGIN
    DECLARE is_estate_actual BOOLEAN;
    DECLARE estate_price DECIMAL(10, 2);
    DECLARE deal_estate_name VARCHAR(50);
    DECLARE estate_owner_id INT;
    DECLARE agent_commission_rate DECIMAL(5, 2);
    DECLARE to_write_deal_type INT;

    SELECT is_actual, price, owner_id, realty_purpose_id,estate_name
    INTO is_estate_actual, estate_price, estate_owner_id, to_write_deal_type,deal_estate_name
    FROM realty
    WHERE estate_id = p_estate_id;
    IF to_write_deal_type > 1 THEN
        SET to_write_deal_type = 1;
    ELSE
        SET to_write_deal_type = 2;
    END IF;
    IF estate_owner_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Owner ID not found for the given estate ID.';
    ELSE
        SELECT base_commission_rate
        INTO agent_commission_rate
        FROM employees
        WHERE employee_id = p_estate_agent_id;
        IF is_estate_actual = TRUE THEN
            INSERT INTO deals (deal_type, estate_id, owner_id, customer_id, estate_agent_id, commission_rate, price)
            VALUES (to_write_deal_type, p_estate_id, estate_owner_id, p_customer_id, p_estate_agent_id, agent_commission_rate, estate_price);
            UPDATE realty
            SET is_actual = FALSE
            WHERE estate_id = p_estate_id;
            CALL set_notification(estate_owner_id, FALSE, CONCAT('deal about your estate',deal_estate_name , 'was just made'), CURDATE());
            CALL set_notification(p_customer_id, FALSE, 'You`vw just made a new deal', CURDATE());
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The realty is not actual and cannot be processed.';
        END IF;
    END IF;
END;


CREATE PROCEDURE set_notification(
    IN p_recieber_id INT,
    IN p_is_for_agent BOOLEAN,
    IN p_message TEXT,
    IN p_date_sent DATE
)
BEGIN
        INSERT INTO notifications (reciever_id, message, date_sent)
        VALUES (p_recieber_id, p_message, p_date_sent);
END;


-- CALL create_payment(12,10,41);

-- Процедура для додавання нового платежу +
CREATE PROCEDURE create_payment(
    IN p_customer_id INT,
    IN p_deal_id INT,
    IN p_amount DECIMAL(10, 2)
)
BEGIN
    DECLARE estate_price DECIMAL(10, 2);
    DECLARE estate_owner_id INT;
    DECLARE p_estate_agent_id INT;
    DECLARE p_estate_id INT;

    -- Отримання estate_id та estate_agent_id
    SELECT estate_id, estate_agent_id, owner_id INTO p_estate_id, p_estate_agent_id, estate_owner_id
    FROM deals
    WHERE estate_id =p_deal_id
    LIMIT 1;
    -- Додавання платежу
    INSERT INTO payments (customer_id, owner_id, estate_agent_id, estate_id, deal_id, amount)
    VALUES (p_customer_id, estate_owner_id, p_estate_agent_id, p_estate_id, p_deal_id, p_amount);
    -- Оновлення рангу співробітника
    UPDATE employees
    SET employee_rank = employee_rank + 1
    WHERE employee_id = p_estate_agent_id;
    -- Отримання ціни нерухомості
    SELECT price INTO estate_price
    FROM deals
    WHERE deal_id = p_deal_id;
    -- Відправлення повідомлень
    CALL set_notification(p_estate_agent_id, TRUE, 'New payment has been made', CURDATE());
    CALL set_notification(p_customer_id, FALSE, 'New payment has been made', CURDATE());
    -- Перевірка повної оплати
    IF (SELECT COALESCE(SUM(amount), 0) FROM payments WHERE deal_id = p_deal_id) >= estate_price THEN
        UPDATE deals
        SET deal_status = 'closed'
        WHERE deal_id = p_deal_id;
        
    -- Оновлення базової комісії
            UPDATE employees
    SET base_commission_rate = base_commission_rate + 0.5
    WHERE employee_id = p_estate_agent_id
      AND base_commission_rate < 45;
    END IF;
END;






CREATE PROCEDURE set_employee_status(
    IN p_employee_id INT
)
BEGIN
    UPDATE employees
    SET status = 1
    WHERE employee_id = p_employee_id;
END;



UPDATE realty SET realty_type_id = 3 WHERE estate_id = 26;