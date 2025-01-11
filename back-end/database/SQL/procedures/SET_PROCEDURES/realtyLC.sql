DROP PROCEDURE If EXISTS add_realty;
DROP PROCEDURE If EXISTS update_realty;
DROP PROCEDURE If EXISTS change_is_actual;

-- Процедура для додавання нерухомості +
CREATE PROCEDURE add_realty(
    IN p_owner_id INT,
    IN p_realty_type_id INT,
    IN p_realty_purpose_id INT,
    IN p_city_id INT,
    IN p_estate_name VARCHAR(50),
    IN p_estate_desc TEXT,
    IN p_address TEXT,
    IN p_price DECIMAL(10, 2),
    IN p_commission_rate DECIMAL(5, 2),
    IN p_area DECIMAL(10, 1),
    IN p_photos JSON
)
BEGIN
    INSERT INTO realty (owner_id, realty_type_id, realty_purpose_id, city_id, estate_name, estate_desc, address, price, commission_rate, area, photos)
    VALUES (p_owner_id, p_realty_type_id, p_realty_purpose_id, p_city_id, p_estate_name, p_estate_desc, p_address, p_price, p_commission_rate, p_area, p_photos);
END ;

-- Процедура для оновлення інформації про нерухомість +
CREATE PROCEDURE update_realty(
    IN p_estate_id INT,
    IN p_estate_name VARCHAR(50),
    IN p_estate_desc TEXT,
    IN p_address TEXT,
    IN p_price DECIMAL(10, 2),
    IN p_commission_rate DECIMAL(5, 2),
    IN p_area DECIMAL(10, 1),
    IN p_photos JSON
)
BEGIN
    UPDATE realty
    SET estate_name = p_estate_name,
        estate_desc = p_estate_desc,
        address = p_address,
        price = p_price,
        commission_rate = p_commission_rate,
        area = p_area,
        photos = p_photos
    WHERE estate_id = p_estate_id;
END ;


-- Процедура для оновлення інформації про нерухомість
CREATE PROCEDURE change_is_actual(
    IN p_is_actual BOOLEAN,
    IN p_estate_id INT
)
BEGIN
    UPDATE realty
    SET is_actual = p_is_actual
    WHERE estate_id = p_estate_id;
END;
CALL change_is_actual(TRUE, 5);
