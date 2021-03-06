/* Welcome to the SQL mini project. You will carry out this project partly in
the PHPMyAdmin interface, and partly in Jupyter via a Python connection.

This is Tier 2 of the case study, which means that there'll be less guidance for you about how to setup
your local SQLite connection in PART 2 of the case study. This will make the case study more challenging for you: 
you might need to do some digging, aand revise the Working with Relational Databases in Python chapter in the previous resource.

Otherwise, the questions in the case study are exactly the same as with Tier 1. 

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
select name 
from Facilities 
where membercost = 0
;


/* Q2: How many facilities do not charge a fee to members? */
4

select count(distinct name)
from Facilities 
where membercost = 0
;


/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */
select 
facid,
name as facility_name,
membercost,
monthlymaintenance
from Facilities 
where membercost != 0
and membercost < (.2*monthlymaintenance)
;


/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */
select *
from Facilities
where facid in (1,5)
;

/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. */
select 
name,
monthlymaintenance,
case when monthlymaintenance > 100 then 'expensive'
	else 'cheap' end as label
from Facilities
;


/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */
SELECT 
firstname, 
surname 
FROM Members
where joindate in
	(SELECT max(joindate)FROM Members)
;


/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */
select 
	b.name as facility_name, 
	concat(c.firstname," ",c.surname) as member_name
from Bookings as a
left join Facilities as b
	on a.facid = b.facid
left join Members as c
	on a.memid = c.memid
where a.facid in (0,1)
group by 
	facility_name,
	member_name
order by
	member_name
;


/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */
select
c.name as facility,
concat(b.firstname," ",b.surname) as name,
case when a.memid = 0 then c.guestcost
	else c.membercost end as cost
from Bookings a
left join Members b
	on a.memid = b.memid
left join Facilities c
	on a.facid = c.facid
where 
	left(starttime,10) = '2012-09-14'
group by
	c.name,
	cost
order by 
	cost desc
;
/* Q9: This time, produce the same result as in Q8, but using a subquery. */
select
a.name as facility,
concat(a.firstname," ",a.surname) as name,
case when a.memid = 0 then a.guestcost
	else a.membercost end as cost
from
	(select 
     c.name, 
     a.memid,
     b.firstname,
     b.surname,
     c.guestcost,
     c.membercost
	from Bookings a
	left join Members b
		on a.memid = b.memid
	left join Facilities c
		on a.facid = c.facid
	where 
		left(starttime,10) = '2012-09-14'
     ) a
group by
	a.name,
	cost
order by 
	cost desc
;

/* PART 2: SQLite

Export the country club data from PHPMyAdmin, and connect to a local SQLite instance from Jupyter notebook 
for the following questions.  

QUESTIONS:
/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */
	name	revenue
0	Table Tennis	90.0
1	Snooker Table	115.0
2	Pool Table	265.0
3	Badminton Court	604.5
/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */

name	recommendedby_name
0	GUEST GUEST	None
1	Darren Smith	None
2	Tracy Smith	None
3	Tim Rownam	None
4	Janice Joplette	Darren Smith
5	Gerald Butters	Darren Smith
6	Burton Tracy	None
7	Nancy Dare	Janice Joplette
8	Tim Boothe	Tim Rownam
9	Ponder Stibbons	Burton Tracy
10	Charles Owen	Darren Smith
11	David Jones	Janice Joplette
12	Anne Baker	Ponder Stibbons
13	Jemima Farrell	None
14	Jack Smith	Darren Smith
15	Florence Bader	Ponder Stibbons
16	Timothy Baker	Jemima Farrell
17	David Pinker	Jemima Farrell
18	Matthew Genting	Gerald Butters
19	Anna Mackenzie	Darren Smith
20	Joan Coplin	Timothy Baker
21	Ramnaresh Sarwin	Florence Bader
22	Douglas Jones	David Jones
23	Henrietta Rumney	Matthew Genting
24	David Farrell	None
25	Henry Worthington-Smyth	Tracy Smith
26	Millicent Purview	Tracy Smith
27	Hyacinth Tupperware	None
28	John Hunt	Millicent Purview
29	Erica Crumpet	Tracy Smith
30	Darren Smith	None

/* Q12: Find the facilities with their usage by member, but not guests */

name	members
0	Badminton Court	24
1	Massage Room 1	24
2	Massage Room 2	12
3	Pool Table	27
4	Snooker Table	22
5	Squash Court	24
6	Table Tennis	25
7	Tennis Court 1	23
8	Tennis Court 2	21

/* Q13: Find the facilities usage by month, but not guests */
	name	month	members
0	Badminton Court	07	51
1	Badminton Court	08	132
2	Badminton Court	09	161
3	Massage Room 1	07	77
4	Massage Room 1	08	153
5	Massage Room 1	09	191
6	Massage Room 2	07	4
7	Massage Room 2	08	9
8	Massage Room 2	09	14
9	Pool Table	07	103
10	Pool Table	08	272
11	Pool Table	09	408
12	Snooker Table	07	68
13	Snooker Table	08	154
14	Snooker Table	09	199
15	Squash Court	07	23
16	Squash Court	08	85
17	Squash Court	09	87
18	Table Tennis	07	48
19	Table Tennis	08	143
20	Table Tennis	09	194
21	Tennis Court 1	07	65
22	Tennis Court 1	08	111
23	Tennis Court 1	09	132
24	Tennis Court 2	07	41
25	Tennis Court 2	08	109
26	Tennis Court 2	09	126

