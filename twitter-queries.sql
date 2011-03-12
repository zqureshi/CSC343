-- 1
-- A<---->B
DROP VIEW IF EXISTS A1 , A2 , A3 cascade;

CREATE VIEW A1 AS(
 SELECT j.username AS A, k.username AS B
FROM followers j, followers k 
WHERE j.followers = k.username AND k.followers = j.username 
);

-- A---->B

CREATE VIEW A2 AS(
SELECT j.username AS A, k.username AS B
FROM followers j, followers k 
WHERE j.followers = k.username
);

-- A<--/-->B
CREATE VIEW A3 AS(
SELECT * FROM A2 EXCEPT SELECT * FROM A1
);



-- 2
CREATE VIEW A1 AS(
 (SELECT username AS use FROM followers WHERE followers='gvwilson') INTERSECT (SELECT username AS use FROM followers WHERE followers='dianelynnhorton')
);
CREATE VIEW A2 AS(
 (SELECT followers AS use FROM followers WHERE username='gvwilson') INTERSECT (SELECT followers AS use FROM followers WHERE username='dianelynnhorton')
);

CREATE VIEW R AS(
 (SELECT use FROM A1) UNION (SELECT use FROM A2)
);

SELECT name , username FROM profile, R WHERE use=username ;

-- 3
CREATE VIEW A3 AS (
select followers , count(username) AS up from followers group by followers
);

CREATE VIEW A4 AS (
select username , count(followers) AS down from followers group by username
);

CREATE VIEW R1 AS (
select username AS use , (up - down) AS pop from A3, A4 WHERE username=followers
);

select username, name, location,pop from profile, R1 WHERE use = username ORDER BY pop DESC;

-- 4

DROP VIEW IF EXISTS A1 cascade;
CREATE VIEW A1 AS (
SELECT a.username , count(DISTINCT c.followers) AS num_of_diff_users FROM followers a ,followers b, followers c WHERE a.followers = b.username AND b.followers = c.username GROUP BY a.username ORDER BY num_of_diff_users DESC
);

