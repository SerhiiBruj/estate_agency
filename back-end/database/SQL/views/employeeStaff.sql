DROP VIEW IF EXISTS staff;
DROP VIEW IF EXISTS current_users;
DROP VIEW IF EXISTS deals_and_payments;


CREATE VIEW staff AS
SELECT employees.employee_id,
    employees.fullname,
    employees.phone_number,
    employees.email,
    employees.role_id,
    role_types.role_name,
    employees.employee_rank,
    employees.base_commission_rate,
    employees.employee_status,
    cities.city_name,
    employees.city_id
FROM employees
    JOIN cities ON employees.city_id = cities.city_id
    JOIN role_types ON employees.role_id = role_types.role_id;



CREATE VIEW current_users AS
SELECT users.user_id,
    users.email,
    users.fullname,
    users.phone_number,
    cities.city_name
FROM users
    JOIN cities ON users.city_id = cities.city_id
    RIGHT JOIN  enterances ON users.user_id = enterances.user_id
WHERE enterances.logged_at >= DATE_SUB(NOW(), INTERVAL 2 DAY);



CREATE VIEW deals_and_payments AS 
SELECT 
    deals.deal_id, 
    deal_type.type_name AS deal_type_name,
    deals.price, 
    deals.created_at AS deal_date, 
    users.fullname AS customer_name,
    deals.deal_status, 
    realty.address,
    users.user_id, 
    realty.estate_name, 
    deals.deal_type,
    realty.estate_id,
    deals.customer_id,
    deals.estate_agent_id,
    (
        SELECT SUM(payments.amount) 
        FROM payments 
        WHERE payments.deal_id = deals.deal_id
    ) AS total_paid 
FROM deals
JOIN users ON deals.customer_id = users.user_id
JOIN realty ON deals.estate_id = realty.estate_id
JOIN deal_type ON deals.deal_type = deal_type.type_id;

