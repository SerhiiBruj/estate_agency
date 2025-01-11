DROP PROCEDURE IF EXISTS create_user;
DROP PROCEDURE IF EXISTS update_bank_account_for_user;
DROP PROCEDURE IF EXISTS create_chat;
DROP PROCEDURE IF EXISTS add_message;
DROP PROCEDURE IF EXISTS update_is_seen;
DROP PROCEDURE IF EXISTS create_pokaz;
DROP PROCEDURE IF EXISTS create_payment;
DROP PROCEDURE IF EXISTS cancel_deal;
DROP PROCEDURE IF EXISTS cancel_pokaz;

-- Процедура для створення нового користувача +
CREATE PROCEDURE create_user(
    IN p_email VARCHAR(100),
    IN p_fullname VARCHAR(50),
    IN p_password VARCHAR(255),
    IN p_phone_number VARCHAR(30),
    IN p_city_id INT
)
BEGIN
    INSERT INTO users (email, fullname, password, phone_number, city_id)
    VALUES (p_email, p_fullname, p_password, p_phone_number, p_city_id);
    
    INSERT INTO enterances (user_id)
    VALUES (LAST_INSERT_ID());
END;


CREATE PROCEDURE update_bank_account_for_user(
    IN p_user_id INT,
    IN p_bank_account BIGINT
)
BEGIN
    IF EXISTS (SELECT 1 FROM users WHERE user_id = p_user_id) THEN
        UPDATE users
        SET bank_account = p_bank_account
        WHERE user_id = p_user_id;
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'User with the specified ID does not exist.';
    END IF;
END;

-- Процедура для створення нового чату
CREATE PROCEDURE create_chat(
    IN p_chat_name TEXT,
    IN p_customer_id INT,
    IN p_estate_agent_id INT
)
BEGIN
    INSERT INTO chats (chat_name, customer_id, estate_agent_id)
    VALUES (p_chat_name, p_customer_id, p_estate_agent_id);
END;



-- Процедура для додавання повідомлення в чат
CREATE PROCEDURE add_message(
    IN p_chat_id INT,
    IN p_is_customers BOOLEAN,
    IN p_text TEXT
)
BEGIN
    INSERT INTO messages (chat_id, is_customers, text)
    VALUES (p_chat_id, p_is_customers, p_text);
END;

CREATE PROCEDURE update_is_seen(
    IN p_message_id INT,
    IN p_is_seen BOOLEAN
)
BEGIN
    UPDATE messages
    SET is_seen = p_is_seen
    WHERE message_id = p_message_id;
END;

-- Процедура для додавання нового показу +
CREATE PROCEDURE create_pokaz(
    IN p_owner_id INT,
    IN p_customer_id INT,
    IN p_estate_agent_id INT,
    IN p_estate_id INT,
    IN p_pokaz_date DATETIME
)
BEGIN
    INSERT INTO pokazy (owner_id, customer_id, estate_agent_id, estate_id, pokaz_date)
    VALUES (p_owner_id, p_customer_id, p_estate_agent_id, p_estate_id, p_pokaz_date);
END;

-- Процедура для створення нового платежу +
CREATE PROCEDURE create_payment(
    IN p_customer_id INT,
    IN p_owner_id INT,
    IN p_estate_agent_id INT,
    IN p_estate_id INT,
    IN p_deal_id INT,
    IN p_amount DECIMAL(10, 2)
)
BEGIN
    INSERT INTO payments (customer_id, owner_id, estate_agent_id, estate_id, deal_id, amount)
    VALUES (p_customer_id, p_owner_id, p_estate_agent_id, p_estate_id, p_deal_id, p_amount);
END ;


-- Процедура для скасування угоди та додавання повідомлення в notifications
CREATE PROCEDURE cancel_deal(
    IN p_deal_id INT,
    IN p_user_id INT
)
BEGIN
    DECLARE owner_id INT;
    DECLARE estate_agent_id INT;
    DECLARE estate_id INT;
    DECLARE customer_id INT;
    
    SELECT owner_id, estate_agent_id, estate_id, customer_id INTO owner_id, estate_agent_id, estate_id, customer_id
    FROM deals
    WHERE deal_id = p_deal_id;
    
    IF p_user_id = owner_id OR p_user_id = estate_agent_id OR p_user_id = customer_id THEN
        UPDATE deals
        SET deal_status = 'rejected'
        WHERE deal_id = p_deal_id;
        
        INSERT INTO notifications (estate_id, agent_id, message, date_sent, is_read)
        VALUES (
            estate_id, 
            estate_agent_id, 
            CONCAT('The deal with ID ', p_deal_id, ' has been cancelled.'),
            CURDATE(), 
            0
        );
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User is not authorized to cancel this deal';
    END IF;
END;


CREATE PROCEDURE cancel_pokaz(
    IN p_pokaz_id INT,
    IN p_user_id INT,
    IN p_text VARCHAR(100)
)
BEGIN
    DECLARE s_owner_id INT;
    DECLARE s_estate_agent_id INT;
    DECLARE s_estate_id INT;
    DECLARE s_customer_id INT;
    DECLARE s_pokaz_status ENUM('scheduled', 'completed', 'cancelled');
    
    -- Отримуємо дані показу
    SELECT owner_id, estate_agent_id, estate_id, customer_id, pokaz_status
    INTO s_owner_id, s_estate_agent_id, s_estate_id, s_customer_id, s_pokaz_status
    FROM pokazy
    WHERE pokaz_id = p_pokaz_id AND (customer_id = p_user_id OR owner_id = p_user_id OR estate_agent_id = p_user_id);
    
    -- Якщо показ вже скасовано
    IF s_pokaz_status = 'cancelled' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Pokaz is already cancelled';
    END IF;

    -- Перевірка прав користувача
    IF s_customer_id = p_user_id OR s_owner_id = p_user_id OR s_estate_agent_id = p_user_id THEN
        -- Якщо показ ще не завершено або не скасовано
        IF s_pokaz_status = 'scheduled' THEN
            UPDATE pokazy
            SET pokaz_status = 'cancelled'
            WHERE pokaz_id = p_pokaz_id;
            
            -- Додавання повідомлення
            INSERT INTO notifications (estate_id, agent_id, message, date_sent, is_read)
            VALUES (
                s_estate_id, 
                s_estate_agent_id, 
                CONCAT('The pokaz with ID ', p_pokaz_id, ' has been cancelled. ', p_text), 
                CURDATE(), 
                0
            );
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The pokaz is already completed or cancelled';
        END IF;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User is not authorized to cancel this pokaz';
    END IF;
END;



DROP PROCEDURE IF EXISTS check_pokaz;
CREATE PROCEDURE check_pokaz(
    IN p_pokaz_id INT,
    IN p_user_id INT,
    IN p_text VARCHAR(100)
)
BEGIN
    DECLARE s_owner_id INT;
    DECLARE s_estate_agent_id INT;
    DECLARE s_estate_id INT;
    DECLARE s_customer_id INT;
    DECLARE s_pokaz_status ENUM('scheduled', 'completed', 'cancelled');
    
    SELECT owner_id, estate_agent_id, estate_id, customer_id, pokaz_status
    INTO s_owner_id, s_estate_agent_id, s_estate_id, s_customer_id, s_pokaz_status
    FROM pokazy
    WHERE pokaz_id = p_pokaz_id AND customer_id =p_user_id OR owner_id =p_user_id OR estate_agent_id =p_user_id;
    


    SELECT p_user_id AS 'User ID', s_owner_id, s_estate_agent_id, s_estate_id, s_pokaz_status;

   
END;
