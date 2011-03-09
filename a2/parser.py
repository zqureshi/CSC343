#!/usr/bin/env python

if __name__ == '__main__':
  twitter = [x.replace("'", "''") for x in open('twitter-scrape.txt')]
  users = []
  follows = []

  try:
    i = iter(twitter)
    while i:
      username = i.next().rstrip()
      name = i.next().rstrip()
      location = i.next().rstrip()
      url = i.next().rstrip()
      bio = ''

      line = i.next()
      while line.strip() != 'ENDBIO':
        bio += line
        line = i.next()
      bio = bio.rstrip()

      users.append('INSERT INTO profile VALUES (\'{0}\', \'{1}\', \'{2}\', \'{3}\', \'{4}\')'.format(username, name, location, url, bio))

      line = i.next()
      while line.strip() != 'END':
        follows.append('INSERT INTO follows VALUES (\'{0}\', \'{1}\')'.format(username, line.rstrip()))
        line = i.next()
  except StopIteration:
    pass

  print '''
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
'''

  for user in users:
    print user

  for follower in follows:
    print follower