CREATE PROCEDURE GetEmployeesWithDetails()
BEGIN
    SELECT e.employee_id, e.fullname, e.email, e.phone_number, e.address, e.hire_date, 
           r.role_name, c.city_name
    FROM employees e
    JOIN role_types r ON e.role_id = r.role_id
    JOIN cities c ON e.city_id = c.city_id;
END;


CREATE PROCEDURE GetRealtyDetails()
BEGIN
    SELECT r.estate_id, r.estate_name, r.estate_desc, r.price, r.commission_rate, r.area, r.address, 
           u.fullname AS owner_name, rp.type_name AS realty_purpose, rt.type_name AS realty_type, 
           c.city_name
    FROM realty r
    LEFT JOIN users u ON r.owner_id = u.user_id
    LEFT JOIN realty_purpose rp ON r.realty_purpose_id = rp.type_id
    LEFT JOIN realty_types rt ON r.realty_type_id = rt.type_id
    LEFT JOIN cities c ON r.city_id = c.city_id;
END;


CREATE PROCEDURE GetDealsDetails()
BEGIN
    SELECT d.deal_id, d.created_at, d.commission_rate, d.deal_status, 
           et.type_name AS deal_type, e.fullname AS agent_name, 
           u1.fullname AS customer_name, u2.fullname AS owner_name, 
           r.estate_name
    FROM deals d
    JOIN deal_type et ON d.deal_type = et.type_id
    JOIN employees e ON d.estate_agent_id = e.employee_id
    JOIN users u1 ON d.customer_id = u1.user_id
    JOIN users u2 ON d.owner_id = u2.user_id
    JOIN realty r ON d.estate_id = r.estate_id;
END;






CREATE PROCEDURE GetPokazyDetails()
BEGIN
    SELECT p.pokaz_id, p.pokaz_date, p.pokaz_status, 
           u1.fullname AS owner_name, u2.fullname AS customer_name, 
           e.fullname AS agent_name, r.estate_name
    FROM pokazy p
    JOIN users u1 ON p.owner_id = u1.user_id
    JOIN users u2 ON p.customer_id = u2.user_id
    JOIN employees e ON p.estate_agent_id = e.employee_id
    JOIN realty r ON p.estate_id = r.estate_id;
END;


CREATE PROCEDURE GetNotificationsForAgent(IN agent_id INT)
BEGIN
    SELECT n.notification_id, n.message, n.date_sent, n.is_read, 
           r.estate_name
    FROM notifications n
    JOIN realty r ON n.estate_id = r.estate_id
    WHERE n.agent_id = agent_id;
END;

CREATE PROCEDURE GetChatMessages(IN chat_id INT)
BEGIN
    SELECT c.chat_id, c.chat_name, m.message_id, m.is_customers, m.text, 
           m.is_seen, m.created_at
    FROM chats c
    JOIN messages m ON c.chat_id = m.chat_id
    WHERE c.chat_id = chat_id;
END;


CREATE PROCEDURE GetAllUsersWithCity()
BEGIN
    SELECT u.user_id, u.fullname, u.email, u.phone_number, 
           u.created_at, c.city_name
    FROM users u
    JOIN cities c ON u.city_id = c.city_id;
END;

CALL GetEmployeesWithDetails();
CALL GetRealtyDetails();
CALL GetDealsDetails();
CALL GetPaymentsForDeal(1);
CALL GetPokazyDetails();
CALL GetNotificationsForAgent(1);
CALL GetChatMessages(1);
CALL GetAllUsersWithCity();
