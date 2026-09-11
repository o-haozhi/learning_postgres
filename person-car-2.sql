create table car (
	car_uid UUID NOT NULL PRIMARY KEY,
	make VARCHAR(50) NOT NULL,
	model VARCHAR(50) NOT NULL,
	price DECIMAL(19,2) NOT NULL CHECK (price > 0)
);

create table person (
	person_uid UUID NOT NULL PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	email VARCHAR(150),
	gender VARCHAR(12) NOT NULL,
	date_of_birth DATE NOT NULL,
	country_of_birth VARCHAR(50) NOT NULL,
    car_uid UUID REFERENCES car (car_uid),
    UNIQUE(car_uid),
	UNIQUE(email)
);


-- INSERT INTO CAR
insert into car (car_uid, make, model, price) values (uuid_generate_v4(), 'Lotus', 'Esprit', 74712.62);
insert into car (car_uid, make, model, price) values (uuid_generate_v4(), 'Infiniti', 'EX', 40233.81);

-- INSERT INTO PERSON
insert into person (person_uid, first_name, last_name, email, gender, date_of_birth, country_of_birth) values (uuid_generate_v4(), 'Minne', 'Hum', 'mhum0@360.cn', 'Female', '2026-07-17', 'Papua New Guinea');
insert into person (person_uid, first_name, last_name, email, gender, date_of_birth, country_of_birth) values (uuid_generate_v4(), 'Morry', 'Daintier', 'mdaintier1@shop-pro.jp', 'Male', '2025-12-11', 'Dominican Republic');
insert into person (person_uid, first_name, last_name, email, gender, date_of_birth, country_of_birth) values (uuid_generate_v4(), 'Edd', 'Kennelly', 'ekennelly2@flavors.me', 'Male', '2025-10-20', 'China');
