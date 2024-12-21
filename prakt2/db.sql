CREATE DATABASE pr2;
\c pr2;

CREATE TABLE location(
	location_id SERIAL PRIMARY KEY,
	regional_group VARCHAR(20)
);

COMMENT ON COLUMN location.location_id IS 'Код места размещения';
COMMENT ON COLUMN location.regional_group IS 'Город';

\d+ "location";

CREATE TABLE department(
	department_id SERIAL PRIMARY KEY,
	name VARCHAR(14),
	location_id INTEGER,
	FOREIGN KEY (location_id) REFERENCES location (location_id) ON DELETE CASCADE
);

COMMENT ON COLUMN department.department_id IS 'Код отдела';
COMMENT ON COLUMN department.name IS 'Название отдела';
COMMENT ON COLUMN department.location_id IS 'Код места размещения';

\d+ "department";

CREATE TABLE job(
	job_id SERIAL PRIMARY KEY,
	function VARCHAR(30)
);

COMMENT ON COLUMN job.job_id IS 'Код должности';
COMMENT ON COLUMN job.function IS 'Название должности';

\d+ "job";

CREATE TABLE employee(
	employee_id SERIAL PRIMARY KEY,
	last_name VARCHAR(15),
	first_name VARCHAR(15),
	middle_initial VARCHAR(1),
	manager_id INTEGER REFERENCES employee,
	job_id INTEGER,
	hire_date DATE,
	salary NUMERIC(7,2),
	commission NUMERIC(7,2),
	department_id INTEGER,
	FOREIGN KEY (job_id) REFERENCES job (job_id) ON DELETE CASCADE,
	FOREIGN KEY (department_id) REFERENCES department (department_id) ON DELETE CASCADE
);

COMMENT ON COLUMN employee.employee_id IS 'Код сотрудника';
COMMENT ON COLUMN employee.last_name IS 'Фамилия';
COMMENT ON COLUMN employee.first_name IS 'Имя';
COMMENT ON COLUMN employee.middle_initial IS 'Средний инициал';
COMMENT ON COLUMN employee.manager_id IS 'Код начальника';
COMMENT ON COLUMN employee.job_id IS 'Код должности';
COMMENT ON COLUMN employee.hire_date IS 'Дата поступления в фирму';
COMMENT ON COLUMN employee.salary IS 'Зарплата';
COMMENT ON COLUMN employee.commission IS 'Комиссионные';
COMMENT ON COLUMN employee.department_id IS 'Код отдела';

\d+ employee;

CREATE TABLE customer(
	customer_id SERIAL PRIMARY KEY,
	name VARCHAR(45),
	address VARCHAR (40),
	city VARCHAR (30),
	state VARCHAR (2),
	zip_code VARCHAR(9),
	are_code SMALLINT,
	phone_number SMALLINT,
	salesperson_id INTEGER,
	credit_limit NUMERIC(9,2),
	comments TEXT,
	FOREIGN KEY (salesperson_id) REFERENCES employee (employee_id) ON DELETE CASCADE
);

COMMENT ON COLUMN customer.customer_id IS 'Код покупателя';
COMMENT ON COLUMN customer.name IS 'Название покупателя';
COMMENT ON COLUMN customer.address IS 'Адрес';
COMMENT ON COLUMN customer.city IS 'Город';
COMMENT ON COLUMN customer.state IS 'Штат';
COMMENT ON COLUMN customer.zip_code IS 'Почтовый код';
COMMENT ON COLUMN customer.are_code IS 'Код региона';
COMMENT ON COLUMN customer.phone_number IS 'Телефон';
COMMENT ON COLUMN customer.salesperson_id IS 'Код сотрудника-продавца, обслуживающего данного покупателя';
COMMENT ON COLUMN customer.credit_limit IS 'Кредит для покупателя';
COMMENT ON COLUMN customer.comments IS 'Примечания';

\d+ "customer";

CREATE TABLE sales_order(
	order_id INTEGER NOT NULL PRIMARY KEY,
	order_date DATE,
	customer_id INTEGER,
	ship_date DATE,
	total NUMERIC(8,2),
	FOREIGN KEY (customer_id) REFERENCES customer (customer_id) ON DELETE CASCADE
);

COMMENT ON COLUMN sales_order.order_id IS 'Код договора';
COMMENT ON COLUMN sales_order.order_date IS 'Дата договора';
COMMENT ON COLUMN sales_order.customer_id IS 'Код покупателя';
COMMENT ON COLUMN sales_order.ship_date IS 'Дата поставки';
COMMENT ON COLUMN sales_order.total IS 'Общая сумма договора';

\d+ "sales_order";

CREATE TABLE product(
	product_id SERIAL PRIMARY KEY,
	description VARCHAR(30)
);

COMMENT ON COLUMN product.product_id IS 'Код продукта';
COMMENT ON COLUMN product.description IS 'Название продукта';

\d+ "product";

CREATE TABLE price(
	product_id SERIAL,
	list_price NUMERIC(8,2),
	min_price NUMERIC(8,2),
	start_date DATE,
	end_date DATE,
	PRIMARY KEY (product_id, start_date),
	FOREIGN KEY (product_id) REFERENCES product (product_id) ON DELETE CASCADE
);

COMMENT ON COLUMN price.product_id IS 'Код продукта';
COMMENT ON COLUMN price.list_price IS 'Объявленная цена';
COMMENT ON COLUMN price.min_price IS 'Минимально возможная цена';
COMMENT ON COLUMN price.start_date IS 'Дата установления цены';
COMMENT ON COLUMN price.end_date IS 'Дата отмены цены';

\d+ "price";

CREATE TABLE item(
	order_id INTEGER,
	item_id SERIAL,
	product_id INTEGER,
	actual_price NUMERIC(8,2),
	quantity INTEGER,
	total NUMERIC(8,2),
	PRIMARY KEY (order_id, item_id),
	FOREIGN KEY (order_id) REFERENCES sales_order (order_id) ON DELETE CASCADE,
	FOREIGN KEY (product_id) REFERENCES product (product_id) ON DELETE CASCADE
);

COMMENT ON COLUMN item.order_id IS 'Код договора, в состав которого входит акт';
COMMENT ON COLUMN item.item_id IS 'Код акта';
COMMENT ON COLUMN item.product_id IS 'Код продукта';
COMMENT ON COLUMN item.actual_price IS 'Цена продажи';
COMMENT ON COLUMN item.quantity IS 'Количество';
COMMENT ON COLUMN item.total IS 'Общая сумма';

\d+ "item";

INSERT INTO location (regional_group) values ('Moscow');
INSERT INTO location (regional_group) values ('Paris');
INSERT INTO location (regional_group) values ('Saint-Petesrburg');
INSERT INTO location (regional_group) values ('London');
INSERT INTO location (regional_group) values ('Praga');

SELECT * FROM location;

INSERT INTO department (name, location_id) values ('DME', 1);
INSERT INTO department (name, location_id) values ('DPE', 2);
INSERT INTO department (name, location_id) values ('DSPE', 3);
INSERT INTO department (name, location_id) values ('DLE', 4);
INSERT INTO department (name, location_id) values ('DPrE', 5);
INSERT INTO department (name, location_id) values ('SDLA', 4);

SELECT * FROM department;

INSERT INTO job (function) values ('function1');
INSERT INTO job (function) values ('function2');
INSERT INTO job (function) values ('function3');
INSERT INTO job (function) values ('function4');
INSERT INTO job (function) values ('function5');

SELECT * FROM job;

INSERT INTO employee (last_name, first_name, middle_initial, manager_id, job_id, hire_date, salary, commission,	department_id) 
	values ('Admas', 'Edvard', '1', '1', '1', '2022-01-01', 90000, 9000, 1);
INSERT INTO employee (last_name, first_name, middle_initial, manager_id, job_id, hire_date, salary, commission,	department_id) 
	values ('Smit', 'Bill', '1', '2', '1', '2022-01-02', 90000, 9000, 4);
INSERT INTO employee (last_name, first_name, middle_initial, manager_id, job_id, hire_date, salary, commission,	department_id) 
	values ('Chan', 'Lui', '3', '1', '3', '2022-01-05', 50000, 4000, 1);
INSERT INTO employee (last_name, first_name, middle_initial, manager_id, job_id, hire_date, salary, commission,	department_id) 
	values ('Korneho', 'Edvin', '5', '2', '4', '2022-01-07', 40000, 4000, 4);
INSERT INTO employee (last_name, first_name, middle_initial, manager_id, job_id, hire_date, salary, commission,	department_id) 
	values ('Snow', 'James', '7', '5', '2', '2022-01-14', 35000, 3000, 4);

SELECT * FROM employee;

INSERT INTO customer (name, address, city, state, zip_code, are_code, phone_number, salesperson_id, credit_limit)
	values ('Jamуs Gunn', 'address', 'Moscow', 'RU', 132, 7, 342, 3, 500000);
INSERT INTO customer (name, address, city, state, zip_code, are_code, phone_number, salesperson_id, credit_limit)
	values ('Stown Annit', 'address', 'London', 'EU', 421, 32, 883, 4, 150000);
INSERT INTO customer (name, address, city, state, zip_code, are_code, phone_number, salesperson_id, credit_limit)
	values ('Will Smith', 'address', 'Boston', 'US', 221, 13, 133, 4, 500000);
INSERT INTO customer (name, address, city, state, zip_code, are_code, phone_number, salesperson_id, credit_limit)
	values ('Adam Sandler', 'address', 'Los Angeles', 'US', 741, 91, 123, 2, 100000);
INSERT INTO customer (name, address, city, state, zip_code, are_code, phone_number, salesperson_id, credit_limit)
	values ('Din Brendon', 'address', 'Saint Petersburg', 'RU', 431, 7, 915, 3, 100000);

SELECT * FROM customer;

INSERT INTO sales_order (order_id, order_date, customer_id, ship_date, total) values (432, '2022-02-01', 2, '2022-02-15', 23000);
INSERT INTO sales_order (order_id, order_date, customer_id, ship_date, total) values (124, '2022-01-25', 1, '2022-02-04', 130000);
INSERT INTO sales_order (order_id, order_date, customer_id, ship_date, total) values (734, '2022-02-13', 5, '2022-02-27', 72000);
INSERT INTO sales_order (order_id, order_date, customer_id, ship_date, total) values (442, '2022-02-01', 2, '2022-02-16', 30000);
INSERT INTO sales_order (order_id, order_date, customer_id, ship_date, total) values (831, '2022-02-16', 4, '2022-02-28', 160000);

SELECT * FROM sales_order;

INSERT INTO product (description) values ('product1');
INSERT INTO product (description) values ('product2');
INSERT INTO product (description) values ('product3');
INSERT INTO product (description) values ('product4');
INSERT INTO product (description) values ('product5');

SELECT * FROM product;

INSERT INTO price (product_id, list_price, min_price, start_date, end_date) values (1, 13000, 7000, '2022-01-01', '2022-07-01');
INSERT INTO price (product_id, list_price, min_price, start_date, end_date) values (2, 25000, 15000, '2022-01-01', '2022-07-01');
INSERT INTO price (product_id, list_price, min_price, start_date, end_date) values (3, 8000, 4000, '2022-01-01', '2022-07-01');
INSERT INTO price (product_id, list_price, min_price, start_date, end_date) values (4, 45000, 30000, '2022-01-01', '2022-07-01');
INSERT INTO price (product_id, list_price, min_price, start_date, end_date) values (5, 35000, 20000, '2022-07-01', '2023-01-01');

SELECT * FROM price;

INSERT INTO item (order_id, product_id, actual_price, quantity, total) values (432, 2, 23000, 1, 23000);
INSERT INTO item (order_id, product_id, actual_price, quantity, total) values (124, 4, 40000, 3, 120000);
INSERT INTO item (order_id, product_id, actual_price, quantity, total) values (442, 1, 11000, 2, 22000);
INSERT INTO item (order_id, product_id, actual_price, quantity, total) values (442, 3, 8000, 1, 8000);
INSERT INTO item (order_id, product_id, actual_price, quantity, total) values (734, 4, 40000, 1, 40000);
INSERT INTO item (order_id, product_id, actual_price, quantity, total) values (734, 2, 20000, 1, 20000);
INSERT INTO item (order_id, product_id, actual_price, quantity, total) values (734, 1, 12000, 1, 12000);

SELECT * FROM item;

BEGIN;
INSERT INTO sales_order (order_id, order_date, customer_id, ship_date, total) values (532, '2022-03-11', 2, '2022-03-11', 27000);
INSERT INTO item (order_id, product_id, actual_price, quantity, total) values (532, 1, 12000, 1, 27000);
INSERT INTO item (order_id, product_id, actual_price, quantity, total) values (532, 2, 15000, 1, 27000);
ROLLBACK;

SELECT * FROM sales_order;
SELECT * FROM item;

BEGIN;
INSERT INTO sales_order (order_id, order_date, customer_id, ship_date, total) values (532, '2022-03-11', 2, '2022-03-11', 27000);
SAVEPOINT addit;
INSERT INTO item (order_id, product_id, actual_price, quantity, total) values (532, 1, 12000, 1, 27000);
SAVEPOINT addit;
INSERT INTO item (order_id, product_id, actual_price, quantity, total) values (532, 2, 15000, 1, 27000);
ROLLBACK TO addit;

SELECT * FROM sales_order;
SELECT * FROM item;

INSERT INTO item (order_id, product_id, actual_price, quantity, total) values (532, 2, 15000, 1, 27000);
COMMIT;
SELECT * FROM sales_order;
SELECT * FROM item;

BEGIN;
UPDATE sales_order SET total = total * 2 WHERE total = 1000;

BEGIN;
INSERT INTO sales_order (order_id, order_date, customer_id, ship_date, total) values (632, '2022-03-11', 2, '2022-03-11', 1000);
COMMIT;

UPDATE sales_order SET total = total * 2 WHERE total = 1000;
COMMIT;
SELECT * FROM sales_order;

Сумма добавленного заказа второй транзакцией не осталась равной 1000.

В ходе исполнения транзакций первая транзакция получила данные из таблицы, занесённые второй транзакцией, которая сохранила своё состояние раньше, и смогла их изменить. Это связано с имеющимся уровнем изоляции Read Committed, который допускает аномалию фантомного чтения.

BEGIN isolation level repeatable read;
UPDATE sales_order SET total = total * 2 WHERE total = 1000;

BEGIN;
INSERT INTO sales_order (order_id, order_date, customer_id, ship_date, total) values (732, '2022-03-11', 2, '2022-03-11', 1000);
COMMIT;

UPDATE sales_order SET total = total * 2 WHERE total = 1000;
COMMIT;
SELECT * FROM sales_order;

В ходе выполнения этих транзакций аномалии фантомного чтения не обнаружена, т.к. уровень изоляции Repeatable Read исключает её, путём изолирования представлений таблиц.

BEGIN isolation level repeatable read;
SELECT COUNT(*) FROM sales_order WHERE total = 20000;

BEGIN isolation level repeatable read;
SELECT COUNT(*) FROM sales_order WHERE total = 30000;

INSERT INTO sales_order (order_id, order_date, customer_id, ship_date, total) values (832, '2022-03-11', 2, '2022-03-11', 30000);
SELECT COUNT(*) FROM sales_order WHERE total = 20000;

INSERT INTO sales_order (order_id, order_date, customer_id, ship_date, total) values (932, '2022-03-11', 2, '2022-03-11', 20000);
SELECT COUNT(*) FROM sales_order WHERE total = 30000;

COMMIT;

COMMIT;

Данные транзакции можно выполнять параллельно с обновлением состояния таблиц в транзакциях, если отказаться от изоляции Repeatable Read и перейти на изоляцию Read Committed.
