-- Здесь можно сделать что-нибудь до начала теста
-- CREATE INDEX idx1 ON Commander(name);

-------- Запрос, нуждающийся в оптимизации
-- 
-- Запрос будет получать параметры commander_name и pax_count
-- Названия и типы возвращаемых столбцов:
-- TABLE(flight_id INT, commander_name TEXT, pax_count INT)
SELECT id AS flight_id, name AS commander_name, pax_count FROM (
    SELECT F.id, C.name
    FROM Commander C
    JOIN Flight F ON F.commander_id=C.id
    WHERE F.date BETWEEN '2084-04-01' AND '2084-05-01'
    AND C.name = _commander_name
) R
JOIN (
    SELECT F.id, COUNT(P.id)::INT AS pax_count
    FROM Flight F
    JOIN Booking B ON B.flight_id = F.id
    JOIN Pax P ON B.pax_id=P.id
    WHERE P.race='Men'
    GROUP BY F.id
) T USING(id) WHERE T.pax_count > _pax_count;

-- SOLUTION: 2 HEAVY JOINS UNION IN ONE AND ADD INDEX ON 200K TABLE

CREATE INDEX idx ON Booking(flight_id);
-- DROP INDEX idx
--explain analyze
SELECT id AS flight_id, name AS commander_name, pax_count FROM (
    SELECT F.id, C.name, COUNT(P.id)::INT AS pax_count
    FROM Commander C
    JOIN Flight F ON F.commander_id = C.id
	JOIN Booking B ON B.flight_id = F.id
	JOIN Pax P ON B.pax_id=P.id
	WHERE P.race='Men' AND
    F.date BETWEEN '2084-04-01' AND '2084-05-01'
    AND C.name = _commander_name
	GROUP BY F.id, C.name
) AS Foo
WHERE pax_count > _pax_count;