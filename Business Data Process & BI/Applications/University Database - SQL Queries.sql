-- Q1) How many total courses are offered so far?

select count(distinct(course_id)) from course;

-- Q2) Which 3 semesters had most number of courses offered? Note: section table holds information about semester and courses.

select semester, year, count(course_id) total_courses from section
group by semester, year
order by total_courses desc
offset 0 rows
fetch next 3 rows only;

-- Q3) Which 3 rooms have the largest capacity?

select room_number, sum(capacity) total_capacity from classroom
group by room_number
order by total_capacity desc
offset 0 rows
fetch next 3 rows only;

-- Q4) What is the total budget for all the buildings?

select building, sum(budget) total_budget from department
group by building;

-- Q5) Which department has the lowest budget?

select dept_name, sum(budget) total_budget from department
group by dept_name order by total_budget
offset 0 rows
fetch next 1 rows only;

-- Q6) Which course has been the most popular looking at total number of students who took the course.
-- Note: takes table hold the information about student and course when it was enrolled.

select course_id, count(course_id) total_students from takes
group by course_id order by total_students
offset 0 rows
fetch next 1 rows only; 

-- Q7) Are there any students who never been supervised by an instructor?
-- If Yes, Write an SQL to retrieve a list of students who never took any supervision. - Please note advisor table holds supervision details

select * from student s
left join advisor a on s.id = a.s_id where a.i_id is null;

-- Q8) Are there any students who never took a single course? 
-- If yes, Write an SQL to retrieve list of those students.

select * from student s 
left join takes t on s.id=t.id where t.id is null;

-- Q9) Write an SQL to retrieve top 3 instructors with respect to number of courses they taught.
-- Note: teaches table holds information about teachers and course relation.

select id, count(*) total_courses from teaches
group by id order by total_courses desc 
offset 0 rows 
fetch next 3 rows only;


-- Q10) Are there any instructors who never taught a course? If yes, Write an SQL to retrieve list of those instructors.

select * from instructor i
left join teaches t on i.id=t.id where t.id is null;
