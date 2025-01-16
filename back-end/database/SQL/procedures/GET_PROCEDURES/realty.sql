DROP PROCEDURE IF EXISTS get_selection_parameters;
DROP PROCEDURE IF EXISTS search_realty;
DROP PROCEDURE IF EXISTS get_avalible_cities;
DROP PROCEDURE IF EXISTS get_realty_by_owner;
DROP PROCEDURE IF EXISTS get_detailed_realty_info;


CREATE PROCEDURE get_selection_parameters()
BEGIN
    SELECT 'cities' AS category, city_id AS id, city_name AS name FROM cities
    UNION ALL
    SELECT 'realty_types' AS category, type_id AS id, type_name AS name FROM realty_types
    UNION ALL
    SELECT 'realty_purpose' AS category, type_id AS id, type_name AS name FROM realty_purpose;
END;

CREATE PROCEDURE get_avalible_cities(
)
BEGIN
    SELECT city_id, city_name
    FROM cities;
END;





CREATE PROCEDURE get_realty_by_owner(
IN p_owner_id INT
)
BEGIN
 SELECT * FROM realty_info WHERE owner_id = p_owner_id;
END;

CREATE PROCEDURE get_detailed_realty_info(
    IN p_estate_id INT
)
BEGIN
    SELECT r.estate_id, r.owner_id, r.is_actual, r.realty_type_id, rt.type_name AS realty_type,
           r.realty_purpose_id, rp.type_name AS realty_purpose, r.city_id, c.city_name,
           r.estate_name, r.estate_desc, r.address, r.price, r.commission_rate, r.area, r.photos, u.fullname AS owner
    FROM realty r
    JOIN realty_types rt ON r.realty_type_id = rt.type_id
    JOIN realty_purpose rp ON r.realty_purpose_id = rp.type_id
    JOIN useers u ON r.owner_id = u.user_id
    JOIN cities c ON r.city_id = c.city_id
    WHERE r.estate_id = p_estate_id;
END;


-- CALL search_realty(5,500,5000000,2,2,1,5);
CALL search_realty(3,NULL ,NULL,2,5,1,10);
CALL search_realty(3,NULL ,NULL,2,5,1,10);
CALL search_realty(3,NULL ,NULL,2,5,1,10);
CALL search_realty(3,NULL ,NULL,2,5,1,10);
CALL search_realty(3,NULL ,NULL,2,5,1,10);

CREATE PROCEDURE search_realty(
    IN p_city_id INT,
    IN p_min_price DECIMAL(10, 2),
    IN p_max_price DECIMAL(10, 2),
    IN p_realty_type INT,
    IN p_realty_purpose INT,
    IN p_page INT,  
    IN p_per_page INT
)
BEGIN
    SET @sql_query = '
        SELECT r.estate_id, r.estate_name, r.price, r.area, r.address, 
               rp.type_name AS realty_purpose, c.city_name, rt.type_name AS realty_type, r.photos
        FROM realty r
        JOIN realty_types rt ON r.realty_type_id = rt.type_id
        JOIN realty_purpose rp ON r.realty_purpose_id = rp.type_id
        JOIN cities c ON r.city_id = c.city_id
        WHERE r.is_actual = TRUE';

    -- Фільтр за містом
    IF p_city_id IS NOT NULL THEN
        SET @sql_query = CONCAT(@sql_query, ' AND r.city_id = ', p_city_id);
    END IF;
    -- Фільтр за мінімальною ціною
    IF p_min_price IS NOT NULL THEN
        SET @sql_query = CONCAT(@sql_query, ' AND r.price >= ', p_min_price);
    END IF;
    -- Фільтр за максимальною ціною
    IF p_max_price IS NOT NULL THEN
        SET @sql_query = CONCAT(@sql_query, ' AND r.price <= ', p_max_price);
    END IF;
    -- Фільтр за типом нерухомості
    IF p_realty_type IS NOT NULL THEN
        SET @sql_query = CONCAT(@sql_query, ' AND r.realty_type_id = ', p_realty_type);
    END IF;
    -- Фільтр за метою нерухомості
    IF p_realty_purpose IS NOT NULL AND p_realty_purpose != 5 THEN
        SET @sql_query = CONCAT(@sql_query, ' AND r.realty_purpose_id = ', p_realty_purpose);
    ELSEIF p_realty_purpose = 5 THEN
        SET @sql_query = CONCAT(@sql_query, ' AND r.realty_purpose_id IN (2,3,4,5)');
    END IF;
    -- Пагінація
    SET @offset = (p_page - 1) * p_per_page;
    SET @sql_query = CONCAT(@sql_query, ' LIMIT ', p_per_page, ' OFFSET ', @offset);
    -- Виконання запиту
    PREPARE stmt FROM @sql_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END;