USE reservas_salones;

CREATE VIEW vista_resumen_pagos AS
SELECT
    c.nombre_completo AS nombre_cliente,
    s.nombre AS nombre_salon,
    p.metodo_pago AS metodo_pago,
    p.fecha_pago AS fecha_pago,
    p.monto AS monto_pagado
    FROM pagos p
INNER JOIN reservas r
    ON p.reserva_id = r.id
INNER JOIN clientes c
    ON r.cliente_id = c.id
INNER JOIN salones s
    ON r.salon_id = s.id;

SELECT * FROM vista_resumen_pagos