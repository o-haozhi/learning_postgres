
create table car (
	id BIGSERIAL NOT NULL PRIMARY KEY,
	make VARCHAR(50) NOT NULL,
	model VARCHAR(50) NOT NULL,
	price DECIMAL(19,2) NOT NULL
);

create table person (
	id BIGSERIAL NOT NULL PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	email VARCHAR(150),
	gender VARCHAR(12) NOT NULL,
	date_of_birth DATE NOT NULL,
	country_of_birth VARCHAR(50) NOT NULL,
    car_id BIGINT REFERENCES car (id),
    UNIQUE(car_id)
);

insert into car (id, make, model, price) values (1, 'Lotus', 'Esprit', 74712.62);
insert into car (id, make, model, price) values (2, 'Infiniti', 'EX', 40233.81);
insert into person (first_name, last_name, email, gender, date_of_birth, country_of_birth) values ('Minne', 'Hum', 'mhum0@360.cn', 'Female', '2026-07-17', 'Papua New Guinea');
insert into person (first_name, last_name, email, gender, date_of_birth, country_of_birth) values ('Morry', 'Daintier', 'mdaintier1@shop-pro.jp', 'Male', '2025-12-11', 'Dominican Republic');
insert into person (first_name, last_name, email, gender, date_of_birth, country_of_birth) values ('Edd', 'Kennelly', 'ekennelly2@flavors.me', 'Male', '2025-10-20', 'China');
