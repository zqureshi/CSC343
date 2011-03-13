DROP SCHEMA IF EXISTS Twitter CASCADE; 
CREATE SCHEMA Twitter;
SET SEARCH_PATH TO Twitter;

-- Creating Tables 

CREATE TABLE profile (
  username TEXT NOT NULL, 
  name TEXT, 
  location TEXT, 
  website TEXT, 
  bio TEXT, 
  PRIMARY KEY (username) 
);

CREATE TABLE followers (
  username TEXT NOT NULL, 
  followers TEXT, 
  PRIMARY KEY (username,followers),
  FOREIGN KEY (username) REFERENCES profile(username)
);
