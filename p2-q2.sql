CREATE VIEW A1 AS(
 (SELECT username FROM followers WHERE followers='gvwilson') INTERSECT (SELECT username FROM followers WHERE followers='diane-lynnhorton')
);
CREATE VIEW A2 AS(
 (SELECT followers AS username FROM followers WHERE username='gvwilson') INTERSECT (SELECT followers FROM followers WHERE username='diane-lynnhorton')
);

CREATE VIEW R AS(
 (SELECT username FROM A1, A2)
);

SELECT name , username FROM R a, profile b WHERE a.username=b.username ;
