--ATTENZIONE A NON CANCELLARE INDICI UNIVOCI!
--Per ogni indice sono visualizzate solo le prime cinque colonne ordinate
--Non sono presenti le colonne "incluse", ma solo l'indicazione se sono presenti
WITH CTE AS (
SELECT 
	SCHEMA_NAME(o.schema_id) as schema_n,
    o.name as tabella,
	i.name as indice,
	I.type_desc,
	i.is_primary_key,
	i.is_unique,
	i.is_unique_constraint,
	c.name as colonna,
	ic.key_ordinal as posizione,
	ic.is_descending_key,
	ic.is_included_column
FROM CorsoSQL_2.sys.indexes AS i 
INNER JOIN CorsoSQL_2.sys.objects AS o 
    ON i.OBJECT_ID = o.OBJECT_ID
INNER JOIN CorsoSQL_2.sys.index_columns AS ic
	ON i.index_id = ic.index_id
	AND i.object_id = ic.object_id
INNER JOIN CorsoSQL_2.sys.columns AS c
    ON ic.object_id = c.object_id
	AND ic.column_id = c.column_id
WHERE o.type='U'
)
SELECT  
	 schema_n,
	 tabella,
	 indice,
	 type_desc,
	 is_primary_key,
	 is_unique,
	 is_unique_constraint,
	MAX(CASE WHEN posizione = 1 
	     THEN colonna
		 ELSE NULL
    END) AS Col1,
	MAX(CASE WHEN posizione = 2 
	     THEN colonna
		 ELSE NULL
    END) AS Col2,
	MAX(CASE WHEN posizione = 3
	     THEN colonna
		 ELSE NULL
    END) AS Col3,
	MAX(CASE WHEN posizione = 4
	     THEN colonna
		 ELSE NULL
    END) AS Col4,
	MAX(CASE WHEN posizione = 5
	     THEN colonna
		 ELSE NULL
    END) AS Col5,
	SUM(CASE WHEN is_included_column = 1 
				THEN 1
	         ELSE 0
		END) AS NumeroColonneIncluse,
	SUM(CASE WHEN is_descending_key = 1 
				THEN 1
	         ELSE 0
		END) AS NumeroColonneDecrescenti
FROM Cte
GROUP BY 
	 schema_n,
	 tabella,
	 indice,
	 type_desc,
	 is_primary_key,
	 is_unique,
	 is_unique_constraint
ORDER BY schema_n,tabella, type_desc, Col1 desc, Col2 desc, Col3 desc,Col4 desc, Col5 desc, Indice;

