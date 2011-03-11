CREATE VIEW A1 AS (
select followers , count(username) AS up from followers group by followers
);

CREATE VIEW A2 AS (
select username , count(followers) AS down from followers group by username
);

CREATE VIEW R AS (
select username AS use , (up - down) AS pop from A1, A2 WHERE username=followers
);

select username, name, location,pop from profile, R WHERE use = username;
