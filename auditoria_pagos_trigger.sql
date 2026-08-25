USE reservas_salones;


CREATE TABLE IF NOT EXISTS auditoria_pagos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_pago INT NOT NULL,
    fecha DATETIME NOT NULL,
    usuario VARCHAR(100) NOT NULL,
    valor_pagado DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_auditoria_pago
        FOREIGN KEY (id_pago)
        REFERENCES pagos(id)
);



DELIMITER //

CREATE TRIGGER auditoria_pagos_trigger
AFTER INSERT ON pagos
FOR EACH ROW
BEGIN

    INSERT INTO auditoria_pagos
    (
        id_pago,
        fecha,
        usuario,
        valor_pagado
    )
    VALUES
    (
        NEW.id,
        NOW(),
        'admin',
        NEW.monto
    );

END //

DELIMITER ;