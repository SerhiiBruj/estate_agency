-- Таблиця role_types +
CREATE TABLE IF NOT EXISTS role_types (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(25) NOT NULL UNIQUE
);
-- Таблиця cities +
CREATE TABLE IF NOT EXISTS cities (
    city_id INT AUTO_INCREMENT PRIMARY KEY,
    city_name VARCHAR(50) UNIQUE
);
-- Таблиця realty_purpose +
CREATE TABLE IF NOT EXISTS realty_purpose (
    type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL UNIQUE
);
-- Таблиця realty_types 
CREATE TABLE IF NOT EXISTS realty_types (
    type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL UNIQUE
);
-- Таблиця deal_type - +
CREATE TABLE IF NOT EXISTS deal_type (
    type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(40) NOT NULL UNIQUE
);
-- Таблиця users ++
CREATE TABLE IF NOT EXISTS users (
    user_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) UNIQUE NOT NULL,
    fullname VARCHAR(50),
    password VARCHAR(255) NOT NULL,
    phone_number VARCHAR(30) UNIQUE,
    city_id INT,
    bank_account BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (city_id) REFERENCES cities(city_id)
);
-- Таблиця enterances +
CREATE TABLE IF NOT EXISTS enterances(
    logged_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
-- Таблиця bookmarks 
CREATE TABLE IF NOT EXISTS bookmarks (
    bookmark_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    estate_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (estate_id) REFERENCES realty(estate_id)
);

-- Таблиця chats +
CREATE TABLE IF NOT EXISTS chats (
    chat_id INT AUTO_INCREMENT PRIMARY KEY,
    chat_name TEXT,
    customer_id INT,
    estate_agent_id INT,
    FOREIGN KEY (customer_id) REFERENCES users(user_id),
    FOREIGN KEY (estate_agent_id) REFERENCES employees(employee_id)
);

-- Таблиця messages +
CREATE TABLE IF NOT EXISTS messages (
    message_id INT AUTO_INCREMENT PRIMARY KEY,
    chat_id INT NOT NULL,
    is_customers BOOLEAN DEFAULT TRUE,
    text TEXT,
    is_seen BOOLEAN,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (chat_id) REFERENCES chats(chat_id)
);

-- Таблиця realty +
-- UPDATE realty SET commission_rate = 50.00 WHERE realty_purpose_id IS NOT 1;

CREATE TABLE IF NOT EXISTS realty (
    estate_id INT AUTO_INCREMENT PRIMARY KEY,
    owner_id INT NOT NULL,
    is_actual BOOLEAN DEFAULT TRUE,
    realty_type_id INT NOT NULL,
    realty_purpose_id INT NOT NULL,
    city_id INT NOT NULL,
    estate_name VARCHAR(50),
    estate_desc TEXT NOT NULL,
    info_for_estate_agent TEXT ,
    address TEXT,
    price DECIMAL(10, 2),
    commission_rate DECIMAL(5, 2),
    area DECIMAL(10, 1),
    rooms TINYINT,
    photos JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    has_keys_in_office BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (owner_id) REFERENCES users(user_id),
    FOREIGN KEY (realty_type_id) REFERENCES realty_types(type_id),
    FOREIGN KEY (realty_purpose_id) REFERENCES realty_purpose(type_id),
    FOREIGN KEY (city_id) REFERENCES cities(city_id)
);

-- Таблиця employees +
CREATE TABLE IF NOT EXISTS employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_rank INT,
    phone_number VARCHAR(50) NOT NULL UNIQUE,
    private_phone_number VARCHAR(50),
    fullname VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL UNIQUE,
    city_id INT NOT NULL,
    address VARCHAR(255),
    role_id INT NOT NULL,
    base_commission_rate DECIMAL(5, 2),
    employee_status TINYINT DEFAULT 1, 
    bank_account BIGINT,
    hire_date DATE,
    FOREIGN KEY (city_id) REFERENCES cities(city_id),
    FOREIGN KEY (role_id) REFERENCES role_types(role_id)
);
-- Таблиця deals *
CREATE TABLE IF NOT EXISTS deals (
    deal_id INT AUTO_INCREMENT PRIMARY KEY,
    deal_type INT NOT NULL,
    estate_id INT NOT NULL,
    owner_id INT NOT NULL,
    customer_id INT NOT NULL,
    estate_agent_id INT NOT NULL,
    commission_rate DECIMAL(5, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deal_status ENUM('in_progress', 'closed', 'rejected') DEFAULT 'in_progress',
    price DECIMAL(10, 2),
    deal_document LONGBLOB,
    FOREIGN KEY (deal_type) REFERENCES deal_type(type_id),
    FOREIGN KEY (estate_id) REFERENCES realty(estate_id),
    FOREIGN KEY (owner_id) REFERENCES users(user_id),
    FOREIGN KEY (customer_id) REFERENCES users(user_id),
    FOREIGN KEY (estate_agent_id) REFERENCES employees(employee_id)
);
-- Таблиця payments
CREATE TABLE IF NOT EXISTS payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    owner_id INT NOT NULL,
    estate_agent_id INT NOT NULL,
    estate_id INT NOT NULL,
    deal_id INT NOT NULL,
    amount DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES users(user_id),
    FOREIGN KEY (owner_id) REFERENCES users(user_id),
    FOREIGN KEY (estate_agent_id) REFERENCES employees(employee_id),
    FOREIGN KEY (estate_id) REFERENCES realty(estate_id),
    FOREIGN KEY (deal_id) REFERENCES deals(deal_id)
);
-- Таблиця pokazy
CREATE TABLE IF NOT EXISTS pokazy (
    pokaz_id INT AUTO_INCREMENT PRIMARY KEY,
    owner_id INT NOT NULL,
    customer_id INT NOT NULL,
    estate_agent_id INT NOT NULL,
    estate_id INT NOT NULL,
    pokaz_date DATETIME,
    pokaz_status ENUM('scheduled', 'completed', 'cancelled') DEFAULT 'scheduled',
    FOREIGN KEY (owner_id) REFERENCES users(user_id),
    FOREIGN KEY (customer_id) REFERENCES users(user_id),
    FOREIGN KEY (estate_agent_id) REFERENCES employees(employee_id),
    FOREIGN KEY (estate_id) REFERENCES realty(estate_id)
);
-- Таблиця notifications
CREATE TABLE IF NOT EXISTS notifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    estate_id INT,
    is_for_agent BOOLEAN DEFAULT FALSE,
    reciever_id INT,
    message TEXT,
    date_sent DATE,
    is_read TINYINT(1) DEFAULT 0,
    FOREIGN KEY (estate_id) REFERENCES realty(estate_id)
);

CREATE TABLE IF NOT EXISTS salary_payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    amount DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

