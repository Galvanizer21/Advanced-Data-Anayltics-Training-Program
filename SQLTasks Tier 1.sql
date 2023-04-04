/* Welcome to the SQL mini project. You will carry out this project partly in
the PHPMyAdmin interface, and partly in Jupyter via a Python connection.

This is Tier 1 of the case study, which means that there'll be more guidance for you about how to 
setup your local SQLite connection in PART 2 of the case study. 

The questions in the case study are exactly the same as with Tier 2. 

PART 1: PHPMyAdmin
You will complete questions 1-9 below in the PHPMyAdmin interface. 
Log in by pasting the following URL into your browser, and
using the following Username and Password:

URL: https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

In this case study, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */


/* QUESTIONS 
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */

SELECT name
FROM Facilities
WHERE membercost > 0;


/* Q2: How many facilities do not charge a fee to members? */

SELECT COUNT(*)
FROM Facilities
WHERE membercost = 0;


4

/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */


SSELECT facid, name, membercost, monthlymaintenance
FROM Facilities
WHERE membercost > 0 AND membercost < (0.2 * monthlymaintenance);

(0, 'Tennis Court 1', 5, 200)
(1, 'Tennis Court 2', 5, 200)
(4, 'Massage Room 1', 9.9, 3000)
(5, 'Massage Room 2', 9.9, 3000)
(6, 'Squash Court', 3.5, 80)



/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */

SELECT *
FROM Facilities
WHERE facid IN (1, 5);

(1, 'Tennis Court 2', 5, 25, 8000, 200)
(5, 'Massage Room 2', 9.9, 80, 4000, 3000)


/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. */

SELECT name, monthlymaintenance,
       CASE
           WHEN monthlymaintenance > 100 THEN 'expensive'
           ELSE 'cheap'
       END AS cost_label
FROM Facilities;

('Tennis Court 1', 200, 'expensive')
('Tennis Court 2', 200, 'expensive')
('Badminton Court', 50, 'cheap')
('Table Tennis', 10, 'cheap')
('Massage Room 1', 3000, 'expensive')
('Massage Room 2', 3000, 'expensive')
('Squash Court', 80, 'cheap')
('Snooker Table', 15, 'cheap')
('Pool Table', 15, 'cheap')


/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */

SELECT firstname, surname
FROM Members
WHERE joindate = (SELECT MAX(joindate) FROM Members);


/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT DISTINCT
       f.name || ', ' || m.firstname || ' ' || m.surname AS court_and_member
FROM Bookings b
JOIN Facilities f ON b.facid = f.facid
JOIN Members m ON b.memid = m.memid
WHERE f.name LIKE 'Tennis Court%'
ORDER BY m.firstname, m.surname;


Tennis Court 1, Anne Baker
Tennis Court 2, Anne Baker
Tennis Court 2, Burton Tracy
Tennis Court 1, Burton Tracy
Tennis Court 1, Charles Owen
Tennis Court 2, Charles Owen
Tennis Court 2, Darren Smith
Tennis Court 1, David Farrell
Tennis Court 2, David Farrell
Tennis Court 2, David Jones
Tennis Court 1, David Jones
Tennis Court 1, David Pinker
Tennis Court 1, Douglas Jones
Tennis Court 1, Erica Crumpet
Tennis Court 2, Florence Bader
Tennis Court 1, Florence Bader
Tennis Court 2, GUEST GUEST
Tennis Court 1, GUEST GUEST
Tennis Court 1, Gerald Butters
Tennis Court 2, Gerald Butters
Tennis Court 2, Henrietta Rumney
Tennis Court 1, Jack Smith
Tennis Court 2, Jack Smith
Tennis Court 1, Janice Joplette
Tennis Court 2, Janice Joplette
Tennis Court 2, Jemima Farrell
Tennis Court 1, Jemima Farrell
Tennis Court 1, Joan Coplin
Tennis Court 1, John Hunt
Tennis Court 2, John Hunt
Tennis Court 1, Matthew Genting
Tennis Court 2, Millicent Purview
Tennis Court 2, Nancy Dare
Tennis Court 1, Nancy Dare
Tennis Court 2, Ponder Stibbons
Tennis Court 1, Ponder Stibbons
Tennis Court 2, Ramnaresh Sarwin
Tennis Court 1, Ramnaresh Sarwin
Tennis Court 2, Tim Boothe
Tennis Court 1, Tim Boothe
Tennis Court 2, Tim Rownam
Tennis Court 1, Tim Rownam
Tennis Court 2, Timothy Baker
Tennis Court 1, Timothy Baker
Tennis Court 1, Tracy Smith
Tennis Court 2, Tracy Smith


/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT 
    f.name AS facility_name,
    m.firstname || ' ' || m.surname AS member_name,
    CASE
        WHEN b.memid = 0 THEN f.guestcost * b.slots
        ELSE f.membercost * b.slots
    END AS cost
FROM Bookings b
JOIN Facilities f ON b.facid = f.facid
JOIN Members m ON b.memid = m.memid
WHERE b.starttime >= '2012-09-14 00:00:00'
  AND b.starttime < '2012-09-15 00:00:00'
  AND (
    (b.memid = 0 AND f.guestcost * b.slots > 30) OR
    (b.memid != 0 AND f.membercost * b.slots > 30)
  )
ORDER BY cost DESC;


('Massage Room 2', 'GUEST GUEST', 320)
('Massage Room 1', 'GUEST GUEST', 160)
('Massage Room 1', 'GUEST GUEST', 160)
('Massage Room 1', 'GUEST GUEST', 160)
('Tennis Court 2', 'GUEST GUEST', 150)
('Tennis Court 1', 'GUEST GUEST', 75)
('Tennis Court 1', 'GUEST GUEST', 75)
('Tennis Court 2', 'GUEST GUEST', 75)
('Squash Court', 'GUEST GUEST', 70.0)
('Massage Room 1', 'Jemima Farrell', 39.6)
('Squash Court', 'GUEST GUEST', 35.0)
('Squash Court', 'GUEST GUEST', 35.0)


/* Q9: This time, produce the same result as in Q8, but using a subquery. */

SELECT facility_name, member_name, cost
FROM (
    SELECT 
        f.name AS facility_name,
        m.firstname || ' ' || m.surname AS member_name,
        CASE
            WHEN b.memid = 0 THEN f.guestcost * b.slots
            ELSE f.membercost * b.slots
        END AS cost,
        b.starttime
    FROM Bookings b
    JOIN Facilities f ON b.facid = f.facid
    JOIN Members m ON b.memid = m.memid
) AS subquery
WHERE starttime >= '2012-09-14 00:00:00'
  AND starttime < '2012-09-15 00:00:00'
  AND cost > 30
ORDER BY cost DESC;

('Massage Room 2', 'GUEST GUEST', 320)
('Massage Room 1', 'GUEST GUEST', 160)
('Massage Room 1', 'GUEST GUEST', 160)
('Massage Room 1', 'GUEST GUEST', 160)
('Tennis Court 2', 'GUEST GUEST', 150)
('Tennis Court 1', 'GUEST GUEST', 75)
('Tennis Court 1', 'GUEST GUEST', 75)
('Tennis Court 2', 'GUEST GUEST', 75)
('Squash Court', 'GUEST GUEST', 70.0)
('Massage Room 1', 'Jemima Farrell', 39.6)
('Squash Court', 'GUEST GUEST', 35.0)
('Squash Court', 'GUEST GUEST', 35.0)


/* PART 2: SQLite
/* We now want you to jump over to a local instance of the database on your machine. 

Copy and paste the LocalSQLConnection.py script into an empty Jupyter notebook, and run it. 

Make sure that the SQLFiles folder containing thes files is in your working directory, and
that you haven't changed the name of the .db file from 'sqlite\db\pythonsqlite'.

You should see the output from the initial query 'SELECT * FROM FACILITIES'.

Complete the remaining tasks in the Jupyter interface. If you struggle, feel free to go back
to the PHPMyAdmin interface as and when you need to. 

You'll need to paste your query into value of the 'query1' variable and run the code block again to get an output.
 
QUESTIONS:
/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

SELECT 
    f.name AS facility_name,
    SUM(CASE
        WHEN b.memid = 0 THEN f.guestcost * b.slots
        ELSE f.membercost * b.slots
    END) AS total_revenue
FROM Bookings b
JOIN Facilities f ON b.facid = f.facid
GROUP BY f.name
HAVING total_revenue < 1000
ORDER BY total_revenue;

2.6.0
2. Query all tasks
('Table Tennis', 180)
('Snooker Table', 240)
('Pool Table', 270)

/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */

SELECT 
    m1.surname || ', ' || m1.firstname AS member_name,
    m2.surname || ', ' || m2.firstname AS recommender_name
FROM Members m1
LEFT JOIN Members m2 ON m1.recommendedby = m2.memid
WHERE m1.recommendedby IS NOT NULL
ORDER BY m1.surname, m1.firstname;

('Bader, Florence', 'Stibbons, Ponder')
('Baker, Anne', 'Stibbons, Ponder')
('Baker, Timothy', 'Farrell, Jemima')
('Boothe, Tim', 'Rownam, Tim')
('Butters, Gerald', 'Smith, Darren')
('Coplin, Joan', 'Baker, Timothy')
('Crumpet, Erica', 'Smith, Tracy')
('Dare, Nancy', 'Joplette, Janice')
('Farrell, David', None)
('Farrell, Jemima', None)
('GUEST, GUEST', None)
('Genting, Matthew', 'Butters, Gerald')
('Hunt, John', 'Purview, Millicent')
('Jones, David', 'Joplette, Janice')
('Jones, Douglas', 'Jones, David')
('Joplette, Janice', 'Smith, Darren')
('Mackenzie, Anna', 'Smith, Darren')
('Owen, Charles', 'Smith, Darren')
('Pinker, David', 'Farrell, Jemima')
('Purview, Millicent', 'Smith, Tracy')
('Rownam, Tim', None)
('Rumney, Henrietta', 'Genting, Matthew')
('Sarwin, Ramnaresh', 'Bader, Florence')
('Smith, Darren', None)
('Smith, Darren', None)
('Smith, Jack', 'Smith, Darren')
('Smith, Tracy', None)
('Stibbons, Ponder', 'Tracy, Burton')
('Tracy, Burton', None)
('Tupperware, Hyacinth', None)
('Worthington-Smyth, Henry', 'Smith, Tracy')



/* Q12: Find the facilities with their usage by member, but not guests */

SELECT 
    f.name AS facility_name,
    COUNT(b.bookid) AS member_usage
FROM Bookings b
JOIN Facilities f ON b.facid = f.facid
WHERE b.memid != 0
GROUP BY f.name
ORDER BY f.name;

('Badminton Court', 344)
('Massage Room 1', 421)
('Massage Room 2', 27)
('Pool Table', 783)
('Snooker Table', 421)
('Squash Court', 195)
('Table Tennis', 385)
('Tennis Court 1', 308)
('Tennis Court 2', 276)


/* Q13: Find the facilities usage by month, but not guests */

SELECT 
    f.name AS facility_name,
    strftime('%Y-%m', b.starttime) AS month,
    COUNT(b.bookid) AS member_usage
FROM Bookings b
JOIN Facilities f ON b.facid = f.facid
WHERE b.memid != 0
GROUP BY f.name, month
ORDER BY f.name, month;

('Badminton Court', '2012-07', 51)
('Badminton Court', '2012-08', 132)
('Badminton Court', '2012-09', 161)
('Massage Room 1', '2012-07', 77)
('Massage Room 1', '2012-08', 153)
('Massage Room 1', '2012-09', 191)
('Massage Room 2', '2012-07', 4)
('Massage Room 2', '2012-08', 9)
('Massage Room 2', '2012-09', 14)
('Pool Table', '2012-07', 103)
('Pool Table', '2012-08', 272)
('Pool Table', '2012-09', 408)
('Snooker Table', '2012-07', 68)
('Snooker Table', '2012-08', 154)
('Snooker Table', '2012-09', 199)
('Squash Court', '2012-07', 23)
('Squash Court', '2012-08', 85)
('Squash Court', '2012-09', 87)
('Table Tennis', '2012-07', 48)
('Table Tennis', '2012-08', 143)
('Table Tennis', '2012-09', 194)
('Tennis Court 1', '2012-07', 65)
('Tennis Court 1', '2012-08', 111)
('Tennis Court 1', '2012-09', 132)
('Tennis Court 2', '2012-07', 41)
('Tennis Court 2', '2012-08', 109)
('Tennis Court 2', '2012-09', 126)

