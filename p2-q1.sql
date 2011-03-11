CREATE VIEW AX AS(
 SELECT * FROM followers
);
SELECT j.username, k.username 
FROM followers j, AX k 
WHERE j.followers = k.username AND k.followers <> j.username ;
