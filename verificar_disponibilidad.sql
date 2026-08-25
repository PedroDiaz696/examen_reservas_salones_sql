USE reservas_salones;

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

    SELECT COUNT(*)     -- para contar las reservas que se cruzan con el horario solicitado
    INTO cantidad
    FROM reservas
    WHERE salon_id = p_salon_id
      AND estado <> 'cancelada'
      AND p_fecha_inicio < fecha_fin
      AND p_fecha_fin > fecha_inicio;

    IF cantidad = 0 THEN     -- si no existe ninguna reserva, el salon esta disponible
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;

END //

DELIMITER ;

SELECT verificar_disponibilidad(
    1,
    '2026-08-27 10:30:00',
    '2026-08-27 12:30:00'
) AS disponible;