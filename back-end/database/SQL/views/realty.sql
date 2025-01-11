CREATE VIEW realty_info AS
SELECT 
    r.estate_id AS estate_id, 
    u.fullname AS owner_name
    r.owner_id AS owner_id, 
    r.is_actual AS is_actual, 
    r.realty_type_id AS realty_type_id,  
    rt.type_name AS realty_type,
    r.realty_purpose_id AS realty_purpose_id, 
    rp.type_name AS realty_purpose AS realty_purpose, 
    r.city_id AS city_id, 
    c.city_name AS city_name,
    r.estate_name AS estate_name, 
    r.estate_desc AS estate_desc, 
    r.address AS address, 
    r.price AS price, 
    r.commission_rate AS commission_rate, 
    r.area AS area, 
    r.photos AS photos, 
FROM 
    realty r
JOIN 
    realty_types rt ON r.realty_type_id = rt.type_id
JOIN 
    realty_purpose rp ON r.realty_purpose_id = rp.type_id
JOIN 
    users u ON r.owner_id = u.user_id
JOIN 
    cities c ON r.city_id = c.city_id;



SELECT * FROM realty_info WHERE city_id  = 2;