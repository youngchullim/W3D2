PRAGMA foreign_keys = ON;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  author_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
FOREIGN KEY (author_id) REFERENCES users(id),
FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  author_id INTEGER NOT NULL,
  parent_id INTEGER, 
  body TEXT NOT NULL,
FOREIGN KEY (author_id) REFERENCES users(id),
FOREIGN KEY (question_id) REFERENCES questions(id),
FOREIGN KEY (parent_id) REFERENCES replies(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  author_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
FOREIGN KEY (author_id) REFERENCES users(id),
FOREIGN KEY (question_id) REFERENCES questions(id)
);


INSERT INTO
  users(fname, lname)
VALUES
  ('Eric', 'Tso'),
  ('Young', 'Lim');

INSERT INTO
  questions(title, body, author_id)
VALUES
  ('I need help', 'hello i need some help please', (SELECT id FROM users WHERE fname = 'Eric')),
  ('help', 'hello, help please', (SELECT id FROM users WHERE fname = 'Young'));

INSERT INTO
  question_follows(author_id, question_id)
VALUES
  ((SELECT id FROM users WHERE fname = 'Young'), 
  (SELECT id from questions WHERE title = 'I need help' ));




INSERT INTO
replies(question_id,author_id,parent_id,body)
VALUES
((SELECT id FROM questions WHERE title = 'I need help'), 
  (SELECT id FROM users  WHERE fname = 'Eric'),
  NULL,
  ('this is the bodywfawbjkpia'));

  -- ((SELECT id FROM questions WHERE title = 'I need help'), 
  -- (SELECT id FROM users  WHERE fname = 'Eric'),
  -- (SELECT id FROM replies WHERE body = 'this is the bodywfawbjkpia'),
  -- ('reply to reply') 
-- );

INSERT INTO
replies(question_id,author_id,parent_id,body)
VALUES
  ((SELECT id FROM questions WHERE title = 'I need help'), 
  (SELECT id FROM users  WHERE fname = 'Eric'),
  (SELECT id FROM replies WHERE body = 'this is the bodywfawbjkpia'),
  ('reply to reply') 
);



INSERT INTO
  question_likes(author_id, question_id)
VALUES
  ((SELECT id FROM users WHERE fname = 'Young'),
   (SELECT id from questions WHERE title = 'I need help' ));
