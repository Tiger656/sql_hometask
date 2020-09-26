/*Средняя оценка по математике по каждой группе*/
/*v3*/
SELECT 
  cls.name group_name
  , std.id student_id
  , first_name student_name
  , last_name student_surname
  , dscp.name discipline_name
  , stdr.rating
  , AVG(stdr.rating) OVER (PARTITION BY cls.id) AS AVG_BY_GROUP
FROM
	student std
JOIN student_result stdr ON stdr.student_id = std.id 
JOIN discipline dscp ON dscp.id = stdr.discipline_id /*filter by discipline_name*/
JOIN class cls ON cls.id = std.class_id /*get group name. Not neccessary*/
WHERE 
  dscp.name = "Math"
