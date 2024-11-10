1. Combine Two Tables
-- Person table:
-- +----------+----------+-----------+
-- | personId | lastName | firstName |
-- +----------+----------+-----------+
-- | 1        | Wang     | Allen     |
-- | 2        | Alice    | Bob       |
-- +----------+----------+-----------+
-- Address table:
-- +-----------+----------+---------------+------------+
-- | addressId | personId | city          | state      |
-- +-----------+----------+---------------+------------+
-- | 1         | 2        | New York City | New York   |
-- | 2         | 3        | Leetcode      | California |
-- +-----------+----------+---------------+------------+
-- Expected Output:
-- +-----------+----------+---------------+----------+
-- | firstName | lastName | city          | state     |
-- +-----------+----------+---------------+----------+
-- | Allen     | Wang     | Null          | Null      |
-- | Bob       | Alice    | New York City | New York  |
-- +-----------+----------+---------------+----------+

-- Solution 1: Using LEFT JOIN
SELECT p.firstname, p.lastname, a.city, a.state
FROM Person p
LEFT JOIN Address a ON p.personId = a.personId;

-- Solution 2: Using LEFT JOIN with USING keyword
SELECT P.firstName, P.lastName, A.city, A.state
FROM Person P
LEFT JOIN Address A USING (personId);


2. Employees Earning More Than Their Managers
-- Employee table:
-- +----+-------+--------+-----------+
-- | id | name  | salary | managerId |
-- +----+-------+--------+-----------+
-- | 1  | Joe   | 70000  | 3         |
-- | 2  | Henry | 80000  | 4         |
-- | 3  | Sam   | 60000  | Null      |
-- | 4  | Max   | 90000  | Null      |
-- +----+-------+--------+-----------+
-- Expected Output:
-- +----------+
-- | Employee |
-- +----------+
-- | Joe      |
-- +----------+

-- Solution 1: Using LEFT JOIN
SELECT e.name AS Employee
FROM Employee e
LEFT JOIN Employee m ON e.managerId = m.id
WHERE e.salary > m.salary;

-- Solution 2: Using subquery
SELECT name AS Employee FROM Employee 
WHERE salary > (SELECT salary FROM Employee WHERE id = managerId);


3. Duplicate Emails
-- Person table:
-- +----+---------+
-- | id | email   |
-- +----+---------+
-- | 1  | a@b.com |
-- | 2  | c@d.com |
-- | 3  | a@b.com |
-- +----+---------+
-- Expected Output:
-- +---------+
-- | Email   |
-- +---------+
-- | a@b.com |
-- +---------+

-- Solution 1: Using GROUP BY and HAVING
SELECT email AS Email
FROM Person
GROUP BY email
HAVING Count(email) > 1;

-- Solution 2: Using self-join
SELECT DISTINCT(p1.email) from Person p1, Person p2
where p1.id <> p2.id AND p1.email = p2.email;


4. Customer who never order
-- Customers table:
-- +----+-------+
-- | id | name  |
-- +----+-------+
-- | 1  | Joe   |
-- | 2  | Henry |
-- | 3  | Sam   |
-- | 4  | Max   |
-- +----+-------+
-- Orders table:
-- +----+------------+
-- | id | customerId |
-- +----+------------+
-- | 1  | 3          |
-- | 2  | 1          |
-- +----+------------+
-- Expected Output:
-- +-----------+
-- | Customers |
-- +-----------+
-- | Henry     |
-- | Max       |
-- +-----------+

-- Solution 1: Using LEFT JOIN and IS NULL
SELECT c.name AS Customers
FROM Customers c
LEFT JOIN Orders o ON c.id = o.customerId
WHERE o.id IS NULL;

-- Solution 2: Using subquery with NOT IN
SELECT name as Customers
from Customers
where id not in (
    select customerId
    from Orders
);


5. Delete duplicate emails
-- Person table:
-- +----+------------------+
-- | id | email            |
-- +----+------------------+
-- | 1  | john@example.com |
-- | 2  | bob@example.com  |
-- | 3  | john@example.com |
-- +----+------------------+
-- Expected Output:
-- +----+------------------+
-- | id | email            |
-- +----+------------------+
-- | 1  | john@example.com |
-- | 2  | bob@example.com  |
-- +----+------------------+

-- Solution 1: Using DELETE with subquery and ROW_NUMBER()
DELETE FROM Person WHERE id IN (
    SELECT a.id FROM (
        SELECT id, email, ROW_NUMBER() OVER (PARTITION BY email ORDER BY id) AS rn
        FROM Person
    ) a WHERE a.rn > 1
);

-- Solution 2: Using DELETE with self-join
delete p1 from person p1, person p2 
where p1.email = p2.email and p1.id > p2.id;