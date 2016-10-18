CREATE TABLE turtles (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  owner_id INTEGER,

  FOREIGN KEY(owner_id) REFERENCES human(id)
);

CREATE TABLE humans (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  house_id INTEGER,

  FOREIGN KEY(house_id) REFERENCES human(id)
);

CREATE TABLE houses (
  id INTEGER PRIMARY KEY,
  address VARCHAR(255) NOT NULL
);

INSERT INTO
  houses (id, address)
VALUES
  (1, "10000 Penn Ave"),
  (2, "543 Main st."),
  (3, "600 Wahington st.");


INSERT INTO
  humans (id, fname, lname, house_id)
VALUES
  (1, "Devin", "Starks", 1),
  (2, "Dan", "Wilson", 1),
  (3, "Tyler", "Cratcha", 2),
  (4, "Conrad", "Reeves", NULL);

INSERT INTO
  turtles (id, name, owner_id)
VALUES
  (1, "Gulper", 1),
  (2, "Earl", 2),
  (3, "Tina", 3),
  (4, "Peter", 3),
  (5, "Stray turtle", NULL);
