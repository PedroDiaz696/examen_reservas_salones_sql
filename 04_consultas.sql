-- =========================================
-- BASE DE DATOS
-- =========================================

USE reservas_salones;


-- =========================================
-- VISTA: RESUMEN DE RESERVAS
-- =========================================

CREATE VIEW vista_resumen_reservas AS
SELECT
    c.nombre_completo AS cliente,
    s.nombre AS salon,
    r.fecha_inicio,
    r.fecha_fin,
    r.valor_total AS total,
    r.estado
FROM reservas r
INNER JOIN clientes c
    ON r.cliente_id = c.id
INNER JOIN salones s
    ON r.salon_id = s.id;


-- =========================================
-- CONSULTA 1:
-- RESERVAS EN UN RANGO DE FECHAS
-- =========================================

SELECT *
FROM reservas
WHERE fecha_inicio BETWEEN '2026-08-20 00:00:00'
                       AND '2026-08-27 23:59:59';


-- =========================================
-- CONSULTA 2:
-- SALONES CON CAPACIDAD MAYOR A X
-- Y DISPONIBLES
-- =========================================

SELECT *
FROM salones
WHERE capacidad > 100
  AND estado = 'Disponible';


-- =========================================
-- CONSULTA 3:
-- CLIENTES CORPORATIVOS CON MÁS DE 3 RESERVAS
-- =========================================

SELECT
    c.id,
    c.nombre_completo,
    COUNT(r.id) AS cantidad_reservas
FROM clientes c
INNER JOIN reservas r
    ON c.id = r.cliente_id
WHERE c.tipo_cliente = 'Corporativo'
GROUP BY c.id, c.nombre_completo
HAVING COUNT(r.id) > 3;


-- =========================================
-- CONSULTA DE LA VISTA
-- =========================================

SELECT *
FROM vista_resumen_reservas;