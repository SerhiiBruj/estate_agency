DROP PROCEDURE IF EXISTS get_monthly_users;
DROP PROCEDURE IF EXISTS calculate_agent_salaries;
DROP PROCEDURE IF EXISTS get_employee_shows_for_week;
DROP PROCEDURE IF EXISTS get_employee_shows_for_month;
DROP PROCEDURE IF EXISTS get_employee_pokazy_for_month;
DROP PROCEDURE IF EXISTS get_employees_in_particular_city_role ;
DROP PROCEDURE IF EXISTS get_payments_for_deal ;
DROP PROCEDURE IF EXISTS get_deals_and_payments_for_certain_agent ;
DROP PROCEDURE IF EXISTS get_deals_documents_by_deal_id ;
DROP PROCEDURE IF EXISTS get_deals_by_user_id ;
DROP PROCEDURE IF EXISTS get_info_for_estate_agent_from_realty;


-- перегляд кількості юзерів +++++++++++++++
CREATE PROCEDURE get_monthly_users(
    IN p_year INT,
    IN p_month INT
)
BEGIN
    SELECT COUNT(*) AS total_records
    FROM entarences
    WHERE YEAR(logged_at) = p_year
      AND MONTH(logged_at) = p_month;
END;


CREATE PROCEDURE get_info_for_estate_agent_from_realty(
    IN p_estate_id INT
)
BEGIN
SELECT info_for_estate_agent FROM realty WHERE estate_id = p_estate_id;
END;

CREATE PROCEDURE get_employees_in_particular_city_role(
    IN p_city_id INT,
    IN p_role_id INT,
    IN p_is_active TINYINT
)
BEGIN
    SET @sql_query = '
        SELECT * FROM staff WHERE 1=1 ';
    IF p_city_id IS NOT NULL THEN
        SET @sql_query = CONCAT(@sql_query, ' AND city_id = ', p_city_id);
    END IF;
    IF p_role_id IS NOT NULL THEN
        SET @sql_query = CONCAT(@sql_query, ' AND role_id IN ', p_role_id);
    END IF;
    IF p_is_active IS NOT NULL THEN
        SET @sql_query = CONCAT(@sql_query, ' AND employee_status = ', p_is_active);
    END IF;
    PREPARE stmt FROM @sql_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END;

-- перегляд запланованих показів ++++++
CREATE PROCEDURE get_employee_pokazy_for_month(
    IN p_employee_id INT,
    IN p_year INT,
    IN p_month INT
)
BEGIN
    SELECT * 
    FROM pokazy
    WHERE estate_agent_id = p_employee_id
      AND YEAR(pokaz_date) = p_year
      AND MONTH(pokaz_date) = p_month
    ORDER BY pokaz_date;
END;

CREATE TABLE IF NOT EXISTS agent_salaries (
    estate_agent_id INT PRIMARY KEY,
    total_salary DECIMAL(10, 2) DEFAULT 0
);


--  call calculate_agent_salaries(2025,1)
CREATE PROCEDURE calculate_agent_salaries(
    IN p_year INT,
    IN p_month INT
)
BEGIN
    DECLARE done BOOLEAN DEFAULT FALSE;
    DECLARE cur_agent_id INT;
    DECLARE cur_deal_type INT;
    DECLARE cur_estate_id INT;
    DECLARE cur_price DECIMAL(10, 2);
    DECLARE agent_commission_rate DECIMAL(5, 2);
    DECLARE salary DECIMAL(10, 2) DEFAULT 0;

    DECLARE closed_deals_cursor CURSOR FOR
    SELECT estate_agent_id, deal_type, price, commission_rate, estate_id
    FROM deals
    WHERE deal_status = 'closed'
      AND YEAR(created_at) = p_year
      AND MONTH(created_at) = p_month;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

   

    DELETE FROM agent_salaries;

    OPEN closed_deals_cursor;

    fetch_loop: LOOP
        FETCH closed_deals_cursor INTO cur_agent_id, cur_deal_type, cur_price, agent_commission_rate, cur_estate_id;
        IF done THEN
            LEAVE fetch_loop;
        END IF;

        IF cur_deal_type = 1 THEN
            SET salary = (cur_price * (SELECT commission_rate FROM realty WHERE estate_id = cur_estate_id)/100) * (agent_commission_rate / 100);
        END IF;
        IF cur_deal_type = 2 THEN
            SET salary = (cur_price *(SELECT commission_rate FROM realty WHERE estate_id = cur_estate_id)/100) * (agent_commission_rate / 100);
        END IF;

        INSERT INTO agent_salaries (estate_agent_id, total_salary)
        VALUES (cur_agent_id, salary)
        ON DUPLICATE KEY UPDATE
        total_salary = total_salary + VALUES(total_salary);
    END LOOP;

    CLOSE closed_deals_cursor;

    SELECT agent_salaries.*, employees.fullname,employees.employee_rank,employees.bank_account, cities.city_name
    FROM agent_salaries
    JOIN employees ON agent_salaries.estate_agent_id = employees.employee_id
    JOIN cities ON employees.city_id = cities.city_id;


    DELETE FROM agent_salaries;
END;


CREATE PROCEDURE get_payments_for_deal(IN deal_id INT)
BEGIN
    SELECT p.payment_id, p.amount, u1.fullname AS customer_name, u2.fullname AS owner_name, 
           e.fullname AS agent_name, r.estate_name
    FROM payments p
    JOIN users u1 ON p.customer_id = u1.user_id
    JOIN users u2 ON p.owner_id = u2.user_id
    JOIN employees e ON p.estate_agent_id = e.employee_id
    JOIN realty r ON p.estate_id = r.estate_id
    WHERE p.deal_id = deal_id;
END;


CREATE PROCEDURE get_deals_and_payments_for_certain_agent(IN p_agent_id INT)
BEGIN
    SELECT 
        deal_type_name,
        total_paid, 
        deal_id,
        price, 
        deal_date, 
        customer_name,
        deal_status, 
        address,
        estate_name, 
        estate_id,
        customer_id
    FROM deals_and_payments
    WHERE estate_agent_id = p_agent_id;
END;

CREATE PROCEDURE get_deals_documents_by_deal_id(IN p_deal_id INT)
BEGIN
SELECT deal_document FROM deals WHERE deal_id = p_deal_id;
END;

CREATE PROCEDURE get_deals_by_user_id(IN p_user_id INT)
BEGIN
    SELECT * FROM deals
    WHERE deals.customer_id = p_user_id;
END;


CALL get_deals_by_user_id(3)