CREATE TABLE parents AS
  SELECT "abraham" AS parent, "barack" AS child UNION
  SELECT "abraham"          , "clinton"         UNION
  SELECT "delano"           , "herbert"         UNION
  SELECT "fillmore"         , "abraham"         UNION
  SELECT "fillmore"         , "delano"          UNION
  SELECT "fillmore"         , "grover"          UNION
  SELECT "eisenhower"       , "fillmore";

CREATE TABLE dogs AS
  SELECT "abraham" AS name, "long" AS fur, 26 AS height UNION
  SELECT "barack"         , "short"      , 52           UNION
  SELECT "clinton"        , "long"       , 47           UNION
  SELECT "delano"         , "long"       , 46           UNION
  SELECT "eisenhower"     , "short"      , 35           UNION
  SELECT "fillmore"       , "curly"      , 32           UNION
  SELECT "grover"         , "short"      , 28           UNION
  SELECT "herbert"        , "curly"      , 31;

CREATE TABLE sizes AS
  SELECT "toy" AS size, 24 AS min, 28 AS max UNION
  SELECT "mini"       , 28       , 35        UNION
  SELECT "medium"     , 35       , 45        UNION
  SELECT "standard"   , 45       , 60;


-- All dogs with parents ordered by decreasing height of their parent
CREATE TABLE by_parent_height AS
  SELECT child
  FROM parents, dogs
  WHERE parent = dogs.name
  ORDER BY dogs.height DESC;


-- The size of each dog
CREATE TABLE size_of_dogs AS
  SELECT name, size
  FROM dogs, sizes
  WHERE height > sizes.min and height <= sizes.max;


-- Filling out this helper table is optional
CREATE TABLE siblings AS
  SELECT parent, name, size
  FROM dogs INNER JOIN parents ON parents.child = dogs.name
            INNER JOIN sizes ON dogs.height > sizes.min and dogs.height <= sizes.max;

-- Sentences about siblings that are the same size
CREATE TABLE sentences AS
  SELECT "The two siblings, " || MIN(name) || " and " || MAX(name) || ", have the same size: "|| size
  FROM siblings
  GROUP BY parent, size
  HAVING COUNT(name) > 1;


-- Height range for each fur type where all of the heights differ by no more than 30% from the average height
CREATE TABLE low_variance AS
  SELECT dogs.fur, MAX(height) - MIN(height)
  FROM dogs, (
    SELECT fur, COUNT(name) AS cnt
    FROM dogs
    GROUP BY fur
    HAVING height >= 0.7 * AVG(height) and height <= 1.3 * AVG(height)
  ) AS t
  GROUP BY dogs.fur
  HAVING COUNT(height) = t.cnt AND t.fur = dogs.fur;

