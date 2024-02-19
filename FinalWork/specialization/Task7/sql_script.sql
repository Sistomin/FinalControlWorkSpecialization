-- создаем базу данных Human_Friends
create database Human_Friends;
-- используем базу Human_Friends
USE Human_Friends;

-- создаем таблицу класссов животных animal_class (вьючные и домашние), заполняем значениями
CREATE TABLE animal_class (ID int auto_increment primary key, class_name varchar(15));
INSERT INTO animal_class (class_name)
VALUES ('pack'),
       ('home');

-- создаем таблицу вьючных животных и заполняем значениями       
CREATE TABLE animal_pack (ID INT auto_increment primary key,  type varchar(15), id_class int, 
   foreign key (id_class) references animal_class (ID) ON DELETE CASCADE ON UPDATE CASCADE);   
INSERT INTO animal_pack (type, id_class)
value ('Horse', 1),
      ('Donkey', 1), 
      ('Camel', 1);
      
-- создаем таблицу домашних животных и заполняем значениями       
CREATE TABLE animal_home (ID INT auto_increment primary key,  type varchar(15), id_class int, 
   foreign key (id_class) references animal_class (ID) ON DELETE CASCADE ON UPDATE CASCADE);   
INSERT INTO animal_home (type, id_class)
value ('Cat', 2),
      ('Dog', 2), 
      ('Hamster', 2);      
      
-- создаем таблицу cats и заполняем значениями
CREATE TABLE cats
  (ID int AUTO_INCREMENT PRIMARY KEY, name varchar(15), birthday date, commands varchar(30), type int,
   FOREIGN KEY (type) REFERENCES animal_home (ID) ON DELETE CASCADE ON UPDATE CASCADE);
INSERT INTO cats (name, birthday, commands, type)
VALUES ('Whiskers', '2022-05-15', 'Sit, Pounce', 2),
       ('Smudge', '2020-02-20', "Sit, Pounce, Scratch", 2),
       ('Oliver', '2021-06-30', "Meow, Scratch, Jump", 2);

-- создаем таблицу dogs и заполняем значениями
CREATE TABLE dogs
  (ID int AUTO_INCREMENT PRIMARY KEY, name varchar(15), birthday date, commands varchar(30), type int,
   FOREIGN KEY (type) REFERENCES animal_home (ID) ON DELETE CASCADE ON UPDATE CASCADE);
INSERT INTO dogs (name, birthday, commands, type)
VALUES ('Fido', '2020-01-01', 'Sit, Stay, Fetch', 2),
       ('Buddy', '2018-12-10', "Sit, Paw, Bark", 2),
       ('Bella', '2023-11-11', "Sit, Stay, Roll", 2);
       
-- создаем таблицу hamsters и заполняем значениями
CREATE TABLE hamsters
  (ID int AUTO_INCREMENT PRIMARY KEY, name varchar(15), birthday date, commands varchar(30), type int,
   FOREIGN KEY (type) REFERENCES animal_home (ID) ON DELETE CASCADE ON UPDATE CASCADE);
INSERT INTO hamsters (name, birthday, commands, type)
VALUES ('Peanut', '2024-01-01', 'Roll, Spin', 2),
       ('Hammy', '2021-03-10', "Roll, Hide", 2);       

-- создаем таблицу horses и заполняем значениями
CREATE TABLE horses
  (ID int AUTO_INCREMENT PRIMARY KEY, name varchar(15), birthday date, commands varchar(30), type int,
   FOREIGN KEY (type) REFERENCES animal_pack (ID) ON DELETE CASCADE ON UPDATE CASCADE);
INSERT INTO horses (name, birthday, commands, type)
VALUES ('Thunder', '2015-07-21', 'Trot, Canter, Gallop', 1),
       ('Storm', '2014-05-05', "Trot, Canter", 1),
       ('Blaze', '2016-02-29', "Trot, Jump, Gallop", 1);
       
-- создаем таблицу camels и заполняем значениями
CREATE TABLE camels
  (ID int AUTO_INCREMENT PRIMARY KEY, name varchar(15), birthday date, commands varchar(30), type int,
   FOREIGN KEY (type) REFERENCES animal_pack (ID) ON DELETE CASCADE ON UPDATE CASCADE);
INSERT INTO camels (name, birthday, commands, type)
VALUES ('Sandy', '2016-11-03', 'Walk, Carry Load', 1),
       ('Dune', '2018-12-12', "Walk, Sit", 1),
       ('Sahara', '2015-08-14', "Walk, Run", 1);    
       
-- создаем таблицу donkeys и заполняем значениями
CREATE TABLE donkeys
  (ID int AUTO_INCREMENT PRIMARY KEY, name varchar(15), birthday date, commands varchar(30), type int,
   FOREIGN KEY (type) REFERENCES animal_pack (ID) ON DELETE CASCADE ON UPDATE CASCADE);
INSERT INTO donkeys (name, birthday, commands, type)
VALUES ('Burro', '2019-01-23', 'Walk, Bray, Kick', 1),
       ('Eeyore', '2022-12-12', "Walk, Sit", 1);   
       
-- удалить запись о верблюдахa
TRUNCATE TABLE camels;
SELECT * FROM camels; -- проверяем

-- объединить таблицы лошадей и ослов      
SELECT id, name, birthday, commands, type FROM horses
UNION
SELECT id, name, birthday, commands, type FROM donkeys;

-- Создать новую таблицу для животных в возрасте от 1 до 3 лет и вычислить их возраст с точностью до месяца
CREATE
TEMPORARY TABLE animals AS
SELECT *, 'Horse' AS type_animal FROM horses
UNION
SELECT *, 'Donkey' AS type_animal FROM donkeys
UNION
SELECT *, 'Dog' AS type_animal FROM dogs
UNION
SELECT *, 'Cat' AS type_animal FROM cats
UNION
SELECT *, 'Hamster' AS type_animal FROM hamsters;

CREATE TABLE yang_animal AS
SELECT name, birthday, commands, type,
       timestampdiff(MONTH, birthday, CURDATE()) AS age_in_month
FROM animals
WHERE birthday BETWEEN ADDDATE(curdate(), interval -3 YEAR) AND ADDDATE(CURDATE(), interval -1 YEAR);

SELECT * FROM yang_animal;

-- Объединить все созданные таблицы в одну, сохраняя информацию о принадлежности к исходным таблицам
SELECT h.name, h.birthday, h.commands, pa.type, ya.age_in_month FROM horses h
LEFT JOIN yang_animal ya ON ya.name = h.name
LEFT JOIN animal_pack pa ON pa.ID = h.type
UNION
SELECT d.name, d.birthday, d.commands, pa.type, ya.age_in_month FROM donkeys d
LEFT JOIN yang_animal ya ON ya.name = d.name
LEFT JOIN animal_pack pa ON pa.ID = d.type
UNION
SELECT c.name, c.birthday, c.commands, ha.type, ya.age_in_month FROM cats c
LEFT JOIN yang_animal ya ON ya.name = c.name
LEFT JOIN animal_home ha ON ha.ID = c.type
UNION
SELECT d.name, d.birthday, d.commands, ha.type, ya.age_in_month FROM dogs d
LEFT JOIN yang_animal ya ON ya.name = d.name
LEFT JOIN animal_home ha ON ha.ID = d.type
UNION
SELECT hm.Name, hm.birthday, hm.commands, ha.type, ya.age_in_month FROM hamsters hm
LEFT JOIN yang_animal ya ON ya.name = hm.name
LEFT JOIN animal_home ha ON ha.ID = hm.type;






      
