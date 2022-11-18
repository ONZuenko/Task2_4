a.     Попробуйте вывести не просто самую высокую зарплату во всей команде, а вывести именно фамилию сотрудника с самой высокой зарплатой.

SELECT fio, salary FROM employers WHERE salary=(SELECT MAX(salary) FROM employers);

b.     Попробуйте вывести фамилии сотрудников в алфавитном порядке

SELECT fio FROM employers ORDER BY fio;

c.     Рассчитайте средний стаж для каждого уровня сотрудников

SELECT AVG(age(CURRENT_DATE, StartDate)) FROM employers GROUP BY emrate;

d.     Выведите фамилию сотрудника и название отдела, в котором он работает

SELECT employers.fio, sectors.sectorname FROM employers, sectors WHERE employers.sectorid=sectors.id;

e.     Выведите название отдела и фамилию сотрудника с самой высокой зарплатой в данном отделе и саму зарплату также.

SELECT a.fio, a.salary, b.sectorname FROM  employers a, sectors b WHERE  a.salary=(SELECT MAX(salary) from employers a WHERE a.sectorid = b.id);

f.      *Выведите название отдела, сотрудники которого получат наибольшую премию по итогам года. Как рассчитать премию можно узнать в последнем задании предыдущей домашней работы

WITH bonus AS(
	SELECT sectorname, SUM(koef) FROM (
		SELECT sectors.sectorname, estimates.koef FROM employers 
		JOIN estimates ON estimates.id=employers.id 
		JOIN sectors ON sectors.id=employers.sectorid) AS ttt GROUP BY sectorname ORDER BY sum DESC)
SELECT sectorname FROM bonus LIMIT 1;		

g.    *Проиндексируйте зарплаты сотрудников с учетом коэффициента премии. Для сотрудников с коэффициентом премии больше 1.2 – размер индексации составит 20%, для сотрудников с коэффициентом премии от 1 до 1.2 размер индексации составит 10%. Для всех остальных сотрудников индексация не предусмотрена.

ALTER TABLE employers ADD COLUMN new_sal FLOAT;
UPDATE employers SET new_sal=salary WHERE new_sal IS NULL;
UPDATE employers SET new_sal = salary*koef
  FROM estimates WHERE employers.id = estimates.id AND estimates.koef>1;

h.    ***По итогам индексации отдел финансов хочет получить следующий отчет: вам необходимо на уровень каждого отдела вывести следующую информацию:

i.     Название отдела ????????????????

ii.     Фамилию руководителя

SELECT sectors.sectorname, employers.fio FROM employers, sectors WHERE employers.id=sectors.head;

iii.     Количество сотрудников ??????????????

SELECT sectorname, emnumber FROM sectors;

iv.     Средний стаж

SELECT AVG(st), sectorname FROM(
SELECT age(CURRENT_DATE, StartDate) AS st, sectorname FROM employers 
JOIN sectors ON employers.sectorid=sectors.id) AS t1 GROUP BY sectorname;

v.     Средний уровень зарплаты

SELECT AVG(new_sal), sectorname FROM employers 
JOIN sectors ON employers.sectorid=sectors.id GROUP BY sectorname;

vi.     Количество сотрудников уровня junior
vii.     Количество сотрудников уровня middle
viii.     Количество сотрудников уровня senior
ix.     Количество сотрудников уровня lead

WITH rate_count as(
SELECT sectorid, emrate, COUNT(emrate) FROM employers e  
GROUP BY sectorid, emrate ORDER BY sectorid, emrate)
SELECT s.sectorname, rc.* FROM rate_count rc LEFT JOIN sectors s ON rc.sectorid=s.id;

x.     Общий размер оплаты труда всех сотрудников до индексации

SELECT SUM(salary), sectorname FROM employers 
JOIN sectors ON employers.sectorid=sectors.id GROUP BY sectorname;

xi.     Общий размер оплаты труда всех сотрудников после индексации

SELECT SUM(new_sal), sectorname FROM employers 
JOIN sectors ON employers.sectorid=sectors.id GROUP BY sectorname;

