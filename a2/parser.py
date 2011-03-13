#!/usr/bin/env python

if __name__ == '__main__':
  twitter = [x.replace("'", "''").rstrip() for x in open('twitter-scrape.txt')]
  users = []
  follows = []

  try:
    i = iter(twitter)
    while i:
      username = i.next()
      name = i.next()
      location = i.next()
      url = i.next()
      bio = ''

      line = i.next()
      while line.strip() != 'ENDBIO':
        bio += line + '\n'
        line = i.next()
      bio = bio.rstrip()

      users.append('INSERT INTO profile VALUES (\'{0}\', \'{1}\', \'{2}\', \'{3}\', \'{4}\');'.format(username, name, location, url, bio))

      line = i.next()
      while line.strip() != 'END':
        follows.append('INSERT INTO followers VALUES (\'{0}\', \'{1}\');'.format(username, line))
        line = i.next()
  except StopIteration:
    pass

  print '-- Add profiles'
  for user in users:
    print user

  print '-- Add followers'
  for follower in follows:
    print follower
