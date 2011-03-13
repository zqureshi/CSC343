-- 1
DROP VIEW IF EXISTS A1 CASCADE;
DROP VIEW IF EXISTS A1 , A2 CASCADE;
DROP TABLE IF EXISTS query1 CASCADE;

CREATE TABLE query1(
    A TEXT NOT NULL,
    B TEXT NOT NULL
);

-- A follows B and B follows A
CREATE VIEW A1 AS(
    SELECT f1.username AS A, f2.username AS B
    FROM followers f1, followers f2 
    WHERE f1.followers = f2.username AND f2.followers = f1.username 
);

-- A follows B

CREATE VIEW A2 AS(
    SELECT j.username AS A, k.username AS B
    FROM followers j, followers k 
    WHERE j.followers = k.username
);

-- A follows B and B NOT follows A
INSERT INTO query1(
    (SELECT * FROM A2)
    EXCEPT
    (SELECT * FROM A1)
);



-- 2
DROP VIEW IF EXISTS A1 , A2, R CASCADE;
DROP TABLE IF EXISTS query2 CASCADE;

CREATE TABLE query2(
    name TEXT NOT NULL,
    username TEXT NOT NULL
);

CREATE VIEW A1 AS(
    (SELECT username AS use 
        FROM followers 
        WHERE followers='gvwilson')
    INTERSECT
    (SELECT username AS use 
        FROM followers 
        WHERE followers='dianelynnhorton')
);
CREATE VIEW A2 AS(
    (SELECT followers AS use 
        FROM followers 
        WHERE username='gvwilson')
    INTERSECT 
    (SELECT followers AS use 
        FROM followers 
        WHERE username='dianelynnhorton')
);

CREATE VIEW R AS(
    (SELECT use 
        FROM A1)
    UNION
    (SELECT use 
        FROM A2)
);

INSERT INTO query2(
    SELECT name , username 
    FROM profile, R 
    WHERE use=username
);

-- 3
DROP VIEW IF EXISTS A3 , A4, R1 CASCADE;
DROP TABLE IF EXISTS query3 CASCADE;

CREATE TABLE query3(
    username TEXT NOT NULL,
    name TEXT NOT NULL,
    location TEXT NOT NULL,
    pop INT NOT NULL
);
CREATE VIEW A3 AS (
    SELECT followers , count(username) AS up 
    FROM followers 
    GROUP BY followers
);

CREATE VIEW A4 AS (
    SELECT username , count(followers) AS down 
    FROM followers 
    GROUP BY username
);

CREATE VIEW R1 AS (
    SELECT username AS use , (up - down) AS pop 
    FROM A3, A4 
    WHERE username=followers
);
INSERT INTO query3(
    SELECT username, name, location,pop 
    FROM profile, R1 
    WHERE use = username 
    ORDER BY pop DESC
);

-- 4
DROP TABLE IF EXISTS query4 CASCADE;

CREATE TABLE query4(
    username TEXT NOT NULL,
    num_of_diff_users INT NOT NULL
);

DROP VIEW IF EXISTS A1 cascade;
INSERT INTO query4 (
    SELECT a.username AS username , count(DISTINCT c.followers) AS num_of_diff_users
    FROM followers a ,followers b, followers c
    WHERE a.followers = b.username AND b.followers = c.username 
    GROUP BY a.username 
    ORDER BY num_of_diff_users DESC
);
