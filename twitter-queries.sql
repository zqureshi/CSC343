-- 1

CCREATE VIEW AX AS(
 SELECT * FROM followers
);
SELECT DISTINCT j.username AS A, k.username AS B
FROM followers j, AX k 
WHERE j.followers = k.username AND k.followers <> j.username ;

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
