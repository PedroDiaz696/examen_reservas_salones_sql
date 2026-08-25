USE reservas_salones;

SELECT
    c.nombre_completo AS nombre_cliente,
    s.nombre AS nombre_salon,
    SUM(p.monto) AS total_pagado
FROM pagos p
INNER JOIN reservas r
    ON p.reserva_id = r.id
INNER JOIN clientes c
    ON r.cliente_id = c.id
INNER JOIN salones s
    ON r.salon_id = s.id
WHERE p.metodo_pago = 'transferencia'
GROUP BY
    c.id,
    c.nombre_completo,
    s.id,
    s.nombre
ORDER BY total_pagado DESC;
