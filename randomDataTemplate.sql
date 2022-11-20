-- Random timestamp between 20XX and 20YY
timestamp '20XX-12-29 20:00:00' +
random() * ( timestamp '20YY-12-29 20:00:00' -
timestamp '20XX-12-29 20:00:00')

-- Random string
left(md5(idx::text), SIZE)
left(md5(random()::text), SIZE)

-- Random number
random() * (MAX - MIN) + MIN
(random() * (MAX - MIN) + MIN)::INTEGER


-- Insert random data
INSERT INTO tablename(
  col1, col2, col3
)
SELECT * FROM(
SELECT
  left(md5(idx::text), SIZE) as col1,
  left(md5(idx::text), SIZE) as col2,
  left(md5(idx::text), SIZE) as col3
FROM generate_series(1, rowCount) AS idx
) as data;
