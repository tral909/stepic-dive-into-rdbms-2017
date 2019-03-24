-- Здесь можно сделать что-нибудь до начала теста
-- CREATE INDEX idx1 ON Commander(name);

-- SOLUTION: add 2 indexes
CREATE INDEX idx_flight_id on Booking(flight_id);
CREATE INDEX idx_spacecraft_id on Flight(spacecraft_id);

---------------------------------------------------------- 
-- Запрос будет получать параметры _planet_name и _capacity
SELECT COUNT(1)
FROM Flight F JOIN Spacecraft S ON F.spacecraft_id = S.id
JOIN Planet P ON F.planet_id = P.id
JOIN Booking B ON F.id = B.flight_id
WHERE S.capacity<_capacity AND S.class=1
AND P.name=_planet_name;