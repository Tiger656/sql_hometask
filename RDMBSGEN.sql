/*
1.	Отобрать имена и фамилии студентов, успешно сдавших экзамен по предмету ”RDBMS” 
для группы студентов №1, упорядоченных по результату экзамена (отличники первые в результате)
*/


SELECT 
	first_name,
    last_name
FROM
	student std
JOIN class cls ON cls.id = std.class_id
JOIN exam_result er ON std.id = er.student_id
JOIN exam e ON e.id = er.exam_id
JOIN discipline dscp ON dscp.id = e.discipline_id
WHERE dscp.name = 'RDBMS' 
	AND cls.name = '1'
    AND er.rating >= 4
ORDER BY er.rating DESC;


-- 2.	Посчитать количество студентов группы №2, успешно сдавших экзамен по предмету “Mathematical Physics” на 4 и 5

SELECT 
	count(std.id)
FROM
	student std
JOIN class cls ON cls.id = std.class_id
JOIN exam_result er ON std.id = er.student_id
JOIN exam e ON e.id = er.exam_id
JOIN discipline dscp ON dscp.id = e.discipline_id
WHERE dscp.name = 'Mathematical Physics' 
	AND cls.name = '2'
    AND (er.rating = 4 OR er.rating = 5)

-- 3.	Вывести имена и фамилии 5 студентов с максимальными оценками вне зависимости от предмета и группы
SELECT 
	first_name,
    last_name
FROM
	student_result sr
JOIN student s ON s.id = sr.student_id
ORDER BY rating DESC
LIMIT 5

-- 4.	Отобрать имена и фамилии студентов, средний балл которых выше среднего балла по университету вне зависимости от группы

SELECT 
	first_name,
    last_name
FROM
	student std
JOIN exam_result er ON std.id = er.student_id
GROUP BY first_name
		, last_name
HAVING AVG(er.rating) > (SELECT
							AVG(rating)
						FROM
							exam_result) 
                            
-- 5.	Отобрать  количество преподавателей, читающих лекции больше чем по одному предмету в 2020 году
SELECT 
	COUNT(*)
FROM (
	SELECT
		teacher_id
	FROM
		teacher_discipline
	WHERE YEAR(begin_date) = 2020
	GROUP BY teacher_id
	HAVING COUNT(discipline_id) > 1 
) a
	 
 -- 6.	Вывести успеваемость студентов по годам по предмету “Math”, начиная с 2015 года
 
 SELECT
	
	 AVG(rating) avg_mark
    , YEAR(e.date) ryear
FROM
	student std
JOIN exam_result er ON std.id = er.student_id
JOIN exam e ON e.id = er.exam_id
JOIN discipline dscp ON dscp.id = e.discipline_id
WHERE dscp.name = 'Math' 
	AND YEAR(e.date) > 2015
GROUP BY ryear

-- 7.	Отобрать 2 специальности, наиболее популярные среди девушек вне зависимости от периода обучения
SELECT
	dscp.name,
	COUNT(std.id) cnt
FROM
	student std
JOIN exam_result er ON std.id = er.student_id
JOIN exam e ON e.id = er.exam_id
JOIN discipline dscp ON dscp.id = e.discipline_id
WHERE gender = 'famale'
GROUP BY dscp.name 
ORDER BY cnt DESC
LIMIT 2

--  8.	Вывести фамилии и должности трех преподавателей, у которых наилучшие результаты по его предметам за последние три года
SELECT
	last_name
    , name
FROM 
(
	SELECT 
		t.last_name
		, td.name
		, AVG(er.rating) rating
		
	FROM
		student std
	JOIN exam_result er ON std.id = er.student_id
	JOIN exam e ON e.id = er.exam_id
	JOIN class cls ON cls.id = std.class_id
	JOIN class_discipline clsd ON clsd.class_id = e.class_id AND clsd.discipline_id = e.discipline_id
	JOIN teacher t ON t.id = clsd.teacher_id
	JOIN teacher_degree td ON t.id = td.id
	WHERE er.date > YEAR(CURDATE()) - 3
	GROUP BY t.last_name, clsd.discipline_id
    ORDER BY rating DESC
) a
LIMIT 3

-- 9.	В каком году была наивысшая средняя успеваемость по предмету “Culture”

SELECT
	MAX(dt) as Date
FROM
(
SELECT
	YEAR(er.date) dt
    , AVG(rating)
FROM 
	exam_result er
JOIN exam e ON e.id = er.exam_id
JOIN discipline dscp ON dscp.id = e.discipline_id
WHERE dscp.name = 'Culture'
GROUP BY dt
) qr


-- 10.	Отобрать фамилии студентов, пересдававших хотя-бы один экзамен
SELECT 
	DISTINCT(first_name)
FROM
	student std
JOIN exam_result er ON std.id = er.student_id
WHERE rating < 4
























