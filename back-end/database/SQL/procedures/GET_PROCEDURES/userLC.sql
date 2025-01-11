DROP PROCEDURE IF EXISTS get_realtors_by_role_and_city;
DROP PROCEDURE IF EXISTS authenticate_user;
DROP PROCEDURE IF EXISTS get_chats_info;
DROP PROCEDURE IF EXISTS get_messages_in_chat;
DROP PROCEDURE IF EXISTS authenticate_user;
DROP PROCEDURE IF EXISTS get_notification_by_id;
DROP PROCEDURE IF EXISTS get_realties_by_owner;




CREATE PROCEDURE get_realtors_by_role_and_city(
    IN p_role_id INT,
    IN p_city_id INT
)
BEGIN
    SELECT e.employee_id, e.fullname, e.phone_number, e.email, e.employee_rank, e.base_commission_rate, c.city_name
    FROM employees e
    JOIN cities c ON e.city_id = c.city_id
    WHERE e.role_id = p_role_id
      AND e.city_id = p_city_id
      AND e.employee_status = 1
END;




CREATE PROCEDURE authenticate_user(
    IN p_email VARCHAR(100),
    IN p_password VARCHAR(255)
)
BEGIN
    DECLARE v_user_id INT;
    DECLARE v_fullname VARCHAR(50);
    DECLARE v_stored_password VARCHAR(255);
    DECLARE v_phone_number VARCHAR(30);
    DECLARE v_city_id INT;
    
    SELECT user_id, fullname, password, phone_number, city_id
    INTO v_user_id, v_fullname, v_stored_password, v_phone_number, v_city_id
    FROM users
    WHERE email = p_email;
    
    IF v_user_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User not found';
    END IF;
    
    IF v_stored_password != p_password THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Incorrect password';
    END IF;
    
    INSERT INTO entrances (user_id)
    VALUES (v_user_id);
    
    SELECT 
        'Authentication successful' AS message,
        v_user_id AS user_id,
        p_email AS email,
        v_fullname AS fullname,
        v_phone_number AS phone_number,
        v_city_id AS city_id;
END;


CREATE PROCEDURE get_chats_info(
    IN p_user_id INT
)
BEGIN
    SELECT c.chat_id, c.chat_name, c.customer_id, c.estate_agent_id,
           u.fullname AS customer_name, e.fullname AS agent_name
    FROM chats c
    JOIN users u ON c.customer_id = u.user_id
    JOIN employees e ON c.estate_agent_id = e.employee_id
    WHERE c.customer_id = p_user_id OR c.estate_agent_id = p_user_id;

    SELECT m.message_id, m.text, m.is_customers, m.is_seen, m.created_at
    FROM messages m
    JOIN chats c ON m.chat_id = c.chat_id
    WHERE c.customer_id = p_user_id OR c.estate_agent_id = p_user_id
    ORDER BY m.created_at DESC
    LIMIT 10;
END;

CREATE PROCEDURE get_messages_in_chat(
    IN p_chat_id INT,
    IN p_limit INT
)
BEGIN
    SELECT m.message_id, m.text, m.is_customers, m.is_seen, m.created_at
    FROM messages m
    WHERE m.chat_id = p_chat_id
    ORDER BY m.created_at DESC
    LIMIT p_limit;
END;





CREATE PROCEDURE get_notification_by_id(
    IN p_notification_id INT
)
BEGIN
    SELECT notification_id, estate_id, agent_id, message, date_sent, is_read
    FROM notifications
    WHERE notification_id = p_notification_id;
END;




CREATE PROCEDURE get_realties_by_owner(
    IN p_owner_id INT
)
BEGIN
    SELECT 
        r.estate_id,
        r.owner_id,
        r.estate_name, 
        r.estate_desc, 
        r.address, 
        r.price, 
        r.commission_rate, 
        r.area, 
        r.photos, 
        rt.type_name AS realty_type, 
        rp.type_name AS realty_purpose, 
        c.city_name, 
        r.is_actual
    FROM 
        realty r
    JOIN 
        realty_types rt ON r.realty_type_id = rt.type_id
    JOIN 
        realty_purpose rp ON r.realty_purpose_id = rp.type_id
    JOIN 
        cities c ON r.city_id = c.city_id
    WHERE 
        r.owner_id = p_owner_id
    ORDER BY 
        r.estate_name;
END;
