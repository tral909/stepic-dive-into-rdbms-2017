-- здесь можно создавать индексы, если угодно 
-- CREATE INDEX idx1 ON Commander(name);

-- Вспомогательная функция, считающая количество пассажиров, летевших 
-- на планету _planet_id в звездолете класса _class

CREATE OR REPLACE FUNCTION GetPaxCount(_planet_id INT, _class INT) RETURNS BIGINT AS $$
SELECT COUNT(Pax.id)
FROM Planet P 
JOIN Flight F     ON P.id=F.planet_id
JOIN Booking B    ON B.flight_id = F.id
JOIN Spacecraft S ON F.spacecraft_id = S.id
JOIN Pax          ON B.pax_id = Pax.id
WHERE S.class = _class AND P.id = _planet_id;
$$ LANGUAGE SQL;

---- Запрос, нуждающийся в ускорении. 
-- Названия и типы возвращаемых столбцов:
-- TABLE(planet_id INT, spacecraft_class INT, takings BIGINT)
explain analyze
SELECT Price.planet_id, 
       Price.spacecraft_class, 
       Price.price * GetPaxCount(Price.planet_id, Price.spacecraft_class) AS takings FROM Price;
	   
-- SOLUTION: rewrite function with joins and group by
SELECT Price.planet_id, 
       Price.spacecraft_class,
       Price.price * COUNT(Pax.id) AS takings
FROM Price,
Planet P
JOIN Flight F     ON P.id=F.planet_id
JOIN Booking B    ON B.flight_id = F.id
JOIN Spacecraft S ON F.spacecraft_id = S.id
JOIN Pax          ON B.pax_id = Pax.id
WHERE S.class = Price.spacecraft_class AND P.id = Price.planet_id
GROUP BY Price.planet_id, Price.spacecraft_class, Price.price;