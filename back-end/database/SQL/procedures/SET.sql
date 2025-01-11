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
    IN p_hire_date DATE
    IN p_employee_rank INT,
)
BEGIN
    INSERT INTO employees (fullname, email, phone_number, city_id, address, role_id, status, base_commission_rate, employee_status, hire_date,employee_rank)
    VALUES (p_fullname, p_email, p_phone_number, p_city_id, p_address, p_role_id, p_status, p_base_commission_rate, p_employee_status, p_hire_date, p_employee_rank);
END ;

-- Процедура для створення нової угоди +
CREATE PROCEDURE create_deal(
    IN p_deal_type INT,
    IN p_estate_id INT,
    IN p_owner_id INT,
    IN p_customer_id INT,
    IN p_estate_agent_id INT,
    IN p_commission_rate DECIMAL(5, 2)
)
BEGIN
    IF (SELECT is_actual FROM realty WHERE estate_id = p_estate_id) = TRUE THEN
        INSERT INTO deals (deal_type, estate_id, owner_id, customer_id, estate_agent_id, commission_rate)
        VALUES (p_deal_type, p_estate_id, p_owner_id, p_customer_id, p_estate_agent_id, p_commission_rate);

        UPDATE realty
        SET is_actual = FALSE
        WHERE estate_id = p_estate_id;

        UPDATE employees
        SET employee_rank = employee_rank + 1
        WHERE employee_id = p_estate_agent_id;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The realty is not actual and cannot be processed.';
    END IF;
END;









