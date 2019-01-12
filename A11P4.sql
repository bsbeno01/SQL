--1 List the names of pilots who have flown the most miles.
SELECT	EMP_FNAME, EMP_LNAME
FROM	FACT_TABLE F INNER JOIN PILOTDIM P ON F.PILOT_ID = P.PILOT_ID
WHERE	F.DISTANCE = (SELECT MAX (DISTANCE) FROM FACT_TABLE)

--2 List the revenue by model and month in ascending order.
SELECT	A.MOD_CODE, A.AC_NUMBER, MONTH(TD.CHAR_DATE) AS MONTH, ROUND(SUM(REVENUE), 2) AS REVENUE
FROM	FACT_TABLE F INNER JOIN AIRCRAFTDIM A ON F.AIRCRAFT_ID = A.AIRCRAFT_ID
		INNER JOIN TIMEDIM TD ON F.TIME_ID = TD.TIME_ID
GROUP	BY MOD_CODE, AC_NUMBER, MONTH(TD.CHAR_DATE)
ORDER	BY SUM(REVENUE) ASC