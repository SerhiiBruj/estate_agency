CALL add_employee(
    'Юрій Андрухович',
    'andruhovych@example.com',
    '+380123456785',
    1,
    'вул. Головна, 123',
    2,
    1,
    5.00,
    1,
    '2023-01-15',
    1
);

CALL add_employee(
    'Оксана Забужко',
    'zabuzhko@example.com',
    '+380234567890',
    1,
    'вул. Дубова, 456',
    3,
    1,
    5.50,
    1,
    '2022-06-10',
    2
);

CALL add_employee(
    'Сергій Жадан',
    'zhadan@example.com',
    '+380345678901',
    2,
    'вул. Соснова, 789',
    2,
    1,
    6.00,
    1,
    '2023-08-23',
    3
);

CALL add_employee(
    'Ліна Костенко',
    'kostyenko@example.com',
    '+380456789012',
    2,
    'вул. Березова, 321',
    3,
    1,
    5.00,
    1,
    '2021-11-01',
    4
);

CALL add_employee(
    'Іван Драч',
    'drach@example.com',
    '+380567890123',
    3,
    'вул. Кедрова, 654',
    2,
    1,
    5.50,
    1,
    '2022-03-11',
    5
);

CALL add_employee(
    'Віктор Шевченко',
    'shevchenko@example.com',
    '+380678901234',
    3,
    'вул. Кленова, 123',
    3,
    1,
    6.00,
    1,
    '2023-05-06',
    6
);

CALL add_employee(
    'Андрій Курков',
    'kurkov@example.com',
    '+380789012345',
    4,
    'вул. Дубова, 789',
    2,
    1,
    5.00,
    1,
    '2023-07-12',
    7
);

CALL add_employee(
    'Марія Матіос',
    'matios@example.com',
    '+380890123456',
    4,
    'вул. Березова, 321',
    3,
    1,
    5.50,
    1,
    '2022-09-30',
    8
);

CALL add_employee(
    'Наталя Блок',
    'blok@example.com',
    '+380901234567',
    5,
    'вул. Соснова, 654',
    2,
    1,
    6.00,
    1,
    '2023-11-01',
    9
);

CALL add_employee(
    'Ігор Калинець',
    'kalynec@example.com',
    '+380123456759',
    5,
    'вул. Кленова, 987',
    3,
    1,
    5.00,
    1,
    '2022-08-19',
    10
);

CALL add_employee(
    'Василь Шкляр',
    'shklyar@example.com',
    '+380123456799',
    6,
    'вул. Липова, 123',
    2,
    1,
    5.50,
    1,
    '2021-05-15',
    11
);

CALL add_employee(
    'Юрій Винничук',
    'vynnychuk@example.com',
    '+3802345678908',
    6,
    'вул. Дубова, 456',
    3,
    1,
    6.00,
    1,
    '2023-02-28',
    12
);

CALL add_employee(
    'Олександр Ірванець',
    'irvanets@example.com',
    '+3803456789019',
    7,
    'вул. Березова, 321',
    2,
    1,
    5.00,
    1,
    '2023-06-15',
    13
);

CALL add_employee(
    'Тарас Прохасько',
    'prohasko@example.com',
    '+3804567890120',
    7,
    'вул. Кедрова, 654',
    3,
    1,
    5.50,
    1,
    '2022-07-07',
    14
);

CALL add_employee(
    'Ольга Токарчук',
    'tokarchuk@example.com',
    '+3805618906789',
    1,
    'вул. Сонячна, 111',
    1,
    1,
    7.00,
    1,
    '2024-01-05',
    15
);

CALL add_employee(
    'Дмитро Кріпі',
    'kripy@example.com',
    '+3806789117890',
    2,
    'вул. Миру, 222',
    4,
    1,
    6.50,
    1,
    '2024-01-10',
    16
);

CALL add_employee(
    'Ірина Жиленко',
    'zhilenko@example.com',
    '+3807810128901',
    3,
    'вул. Набережна, 333',
    5,
    1,
    6.00,
    1,
    '2024-01-15',
    17
);


CALL add_employee(
    'Григір Олійнк',
    'hryhir@gmail.com',
    '+3807890422901',
    3,
    'вул. Енергетиків, 333',
    1,
    1,
    6.00,
    1,
    '2024-01-15',
    17
);

CALL add_employee(
    'Денис Драгун',
    'denys@gmail.com',
    '+3807890432901',
    3,
    'вул. Медова Печера, 32',
    4,
    1,
    6.00,
    1,
    '2024-01-15',
    17
);


CALL add_employee(
    'Діма Костилізатор',
    'dimulya@gmail.com',
    '+3807890432901',
    3,
    'вул. Медова Печера, 32',
    5,
    1,
    6.00,
    1,
    '2024-01-15',
    17
);

-- CALL update_bank_account_for_employee(17,5355280212925943);
-- CALL update_bank_account_for_employee(18,4144555512145489);
-- CALL update_bank_account_for_employee(28,4144568935245895);
SELECT * FROM employees;
-- SELECT * FROM employees WHERE role_id IN (1,4,5)