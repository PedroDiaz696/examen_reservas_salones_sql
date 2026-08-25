-- =========================================
-- BASE DE DATOS
-- =========================================

USE reservas_salones;


-- =========================================
-- TRIGGER: ACTUALIZAR ESTADO Y CALCULAR RESERVA
-- =========================================

DROP TRIGGER IF EXISTS actualizar_estado_salon_trigger;

DELIMITER //

CREATE TRIGGER actualizar_estado_salon_trigger
BEFORE INSERT ON reservas
FOR EACH ROW
BEGIN
    DECLARE precio DECIMAL(10,2);

    -- Verificar disponibilidad del salón
    IF verificar_disponibilidad(
        NEW.salon_id,
        NEW.fecha_inicio,
        NEW.fecha_fin
    ) = 0 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El salon no esta disponible en ese horario';

    END IF;

    -- Calcular total de horas
    SET NEW.total_horas =
        TIMESTAMPDIFF(
            MINUTE,
            NEW.fecha_inicio,
            NEW.fecha_fin
        ) / 60;

    -- Obtener precio por hora
    SELECT precio_hora
    INTO precio
    FROM salones
    WHERE id = NEW.salon_id;

    -- Calcular valor total con IVA
    SET NEW.valor_total =
        calcular_total_reserva(
            precio,
            NEW.total_horas
        );

    -- Cambiar estado del salón
    UPDATE salones
    SET estado = 'Ocupado'
    WHERE id = NEW.salon_id;

END //

DELIMITER ;


-- =========================================
-- TRIGGER: LIBERAR SALÓN
-- =========================================

DROP TRIGGER IF EXISTS liberar_salon_trigger;

DELIMITER //

CREATE TRIGGER liberar_salon_trigger
AFTER DELETE ON reservas
FOR EACH ROW
BEGIN
    DECLARE reservas_activas INT;

    -- Solo libera el salón si no quedan otras reservas activas
    SELECT COUNT(*)
    INTO reservas_activas
    FROM reservas
    WHERE salon_id = OLD.salon_id
      AND estado <> 'cancelada';

    IF reservas_activas = 0 THEN
        UPDATE salones
        SET estado = 'Disponible'
        WHERE id = OLD.salon_id;
    END IF;

END //

DELIMITER ;


-- =========================================
-- TRIGGER: LIBERAR SALÓN AL CANCELAR RESERVA
-- =========================================

DROP TRIGGER IF EXISTS liberar_salon_cancelacion_trigger;

DELIMITER //

CREATE TRIGGER liberar_salon_cancelacion_trigger
AFTER UPDATE ON reservas
FOR EACH ROW
BEGIN
    DECLARE reservas_activas INT;

    -- Solo actúa cuando una reserva pasa a estado 'cancelada'
    IF OLD.estado <> 'cancelada' AND NEW.estado = 'cancelada' THEN

        SELECT COUNT(*)
        INTO reservas_activas
        FROM reservas
        WHERE salon_id = NEW.salon_id
          AND estado <> 'cancelada';

        IF reservas_activas = 0 THEN
            UPDATE salones
            SET estado = 'Disponible'
            WHERE id = NEW.salon_id;
        END IF;

    END IF;

END //

DELIMITER ;


-- =========================================
-- TRIGGER: AUDITORÍA DE PRECIOS
-- =========================================

DROP TRIGGER IF EXISTS auditoria_precios_trigger;

DELIMITER //

CREATE TRIGGER auditoria_precios_trigger
AFTER UPDATE ON salones
FOR EACH ROW
BEGIN

    IF OLD.precio_hora <> NEW.precio_hora THEN

        INSERT INTO auditoria_precios
        (
            salon_id,
            usuario,
            fecha_cambio,
            valor_anterior,
            valor_nuevo
        )
        VALUES
        (
            NEW.id,
            CURRENT_USER(),
            NOW(),
            OLD.precio_hora,
            NEW.precio_hora
        );

    END IF;

END //

DELIMITER ;


-- =========================================
-- CALCULAR RESERVAS EXISTENTES
-- =========================================

UPDATE reservas r
INNER JOIN salones s
    ON r.salon_id = s.id
SET
    r.total_horas =
        TIMESTAMPDIFF(
            MINUTE,
            r.fecha_inicio,
            r.fecha_fin
        ) / 60,

    r.valor_total =
        calcular_total_reserva(
            s.precio_hora,
            TIMESTAMPDIFF(
                MINUTE,
                r.fecha_inicio,
                r.fecha_fin
            ) / 60
        )
WHERE r.total_horas IS NULL
   OR r.valor_total IS NULL;


-- =========================================
-- VERIFICACIÓN
-- =========================================

SELECT * FROM reservas;
SELECT * FROM salones;
SELECT * FROM auditoria_precios;