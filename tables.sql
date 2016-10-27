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

  FOREIGN KEY(house_id) REFERENCES house(id)
);

CREATE TABLE houses (
  id INTEGER PRIMARY KEY,
  address VARCHAR(255) NOT NULL,
  neighborhood_id INTEGER,

  FOREIGN KEY(neighborhood_id) REFERENCES neighborhood(id)
);

CREATE TABLE neighborhoods (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

INSERT INTO
  neighborhoods (id, name)
VALUES
  (1, "Bushwick"),
  (2, "East Village"),
  (3, "West Village"),
  (4, "Harlem"),
  (5, "SoHo");

INSERT INTO
  houses (id, address, neighborhood_id)
VALUES
  (1, "10000 Penn Ave", 5),
  (2, "543 Main st.", 4),
  (3, "600 Washington st.", 3),
  (4, "6346 Neiman Way", 2),
  (5, "600 Tristan Pl.", 1),
  (6, "600 Cullary Rd.", 1),
  (7, "600 Broadway Ave.", 5);


INSERT INTO
  humans (id, fname, lname, house_id)
VALUES
  (1, "Devin", "Starks", 1),
  (2, "Dan", "Wilson", 1),
  (3, "Tyler", "Cratcha", 2),
  (4, "Conrad", "Reeves", 3),
  (5, "Mike", "Stephenson", 4),
  (6, "Marc", "Carroll", 4),
  (7, "Gabe", "Kuzava", 7);

INSERT INTO
  turtles (id, name, owner_id)
VALUES
  (1, "Gulper", 1),
  (2, "Earl", 2),
  (3, "Tina", 3),
  (4, "Tuna", 3),
  (5, "Gina", 4),
  (6, "Choco", 6),
  (7, "Reed", 7),
  (8, "Scooter", 5),
  (9, "Stray turtle", NULL);
