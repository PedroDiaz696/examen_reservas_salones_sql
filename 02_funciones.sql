-- =========================================
-- BASE DE DATOS
-- =========================================

USE reservas_salones;


-- =========================================
-- FUNCIÓN: CALCULAR TOTAL DE RESERVA
-- =========================================

DELIMITER //

CREATE FUNCTION calcular_total_reserva(
    p_precio_hora DECIMAL(10,2),
    p_horas DECIMAL(10,2)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN p_precio_hora * p_horas * 1.19;
END //

DELIMITER ;


-- DOMINIO PROYECTO
USE reservas_salones;


DELIMITER //

CREATE FUNCTION calcular_total_reserva (
    p_precio_hora DECIMAL(10,2),
    p_total_horas DECIMAL(10,2)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN p_precio_hora * p_total_horas * 1.19;
END //
DELIMITER ;

SELECT calcular_total_reserva(150000, 4);

-- =========================================
-- FUNCIÓN: VERIFICAR DISPONIBILIDAD
-- =========================================

DELIMITER //

CREATE FUNCTION verificar_disponibilidad(
    p_salon_id INT,
    p_fecha_inicio DATETIME,
    p_fecha_fin DATETIME
)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE cantidad INT;

    SELECT COUNT(*)
    INTO cantidad
    FROM reservas
    WHERE salon_id = p_salon_id
      AND estado <> 'cancelada'
      AND p_fecha_inicio < fecha_fin
      AND p_fecha_fin > fecha_inicio;

    IF cantidad = 0 THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
END //

DELIMITER ;


-- =========================================
-- PRUEBAS
-- =========================================

SELECT calcular_total_reserva(150000, 4) AS valor_total;

SELECT verificar_disponibilidad(
    1,
    '2026-08-20 10:00:00',
    '2026-08-20 14:00:00'
) AS disponible;