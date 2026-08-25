-- =========================================
-- BASE DE DATOS
-- =========================================

CREATE DATABASE IF NOT EXISTS reservas_salones;


USE reservas_salones;


-- =========================================
-- TABLA: CLIENTES
-- =========================================

CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_completo VARCHAR(150) NOT NULL,
    identificacion VARCHAR(50) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    correo VARCHAR(100) UNIQUE,
    tipo_cliente ENUM(
        'Individual',
        'Corporativo'
    )
);


-- =========================================
-- TABLA: SALONES
-- =========================================

CREATE TABLE salones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    capacidad INT,
    precio_hora DECIMAL(10,2),
    estado ENUM(
        'Disponible',
        'Ocupado',
        'En mantenimiento'
    ) DEFAULT 'Disponible',
    encargado VARCHAR(100)
);


-- =========================================
-- TABLA: RESERVAS
-- =========================================

CREATE TABLE reservas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fecha_inicio DATETIME NOT NULL,
    fecha_fin DATETIME NOT NULL,
    cliente_id INT NOT NULL,
    salon_id INT NOT NULL,
    total_horas DECIMAL(10,2),
    valor_total DECIMAL(10,2),
    estado ENUM(
        'pendiente',
        'confirmada',
        'cancelada',
        'finalizada'
    ) DEFAULT 'pendiente',

    CONSTRAINT fk_reservas_cliente
        FOREIGN KEY (cliente_id)
        REFERENCES clientes(id),

    CONSTRAINT fk_reservas_salon
        FOREIGN KEY (salon_id)
        REFERENCES salones(id)
);


-- =========================================
-- TABLA: PAGOS
-- =========================================

CREATE TABLE pagos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    reserva_id INT NOT NULL,
    fecha_pago DATE,
    monto DECIMAL(10,2),
    metodo_pago ENUM(
        'efectivo',
        'tarjeta',
        'transferencia'
    ),

    CONSTRAINT fk_pagos_reserva
        FOREIGN KEY (reserva_id)
        REFERENCES reservas(id)
);


-- =========================================
-- TABLA: AUDITORIA_PRECIOS
-- =========================================

CREATE TABLE auditoria_precios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    salon_id INT NOT NULL,
    usuario VARCHAR(100),
    fecha_cambio DATETIME,
    valor_anterior DECIMAL(10,2),
    valor_nuevo DECIMAL(10,2),

    CONSTRAINT fk_auditoria_salon
        FOREIGN KEY (salon_id)
        REFERENCES salones(id)
);


-- =========================================
-- DATOS: CLIENTES
-- =========================================

INSERT INTO clientes
(nombre_completo, identificacion, telefono, correo, tipo_cliente)
VALUES
('Juan Perez', '1001001001', '3001112233', 'juan@gmail.com', 'Individual'),
('Maria Gomez', '1001001002', '3002223344', 'maria@gmail.com', 'Individual'),
('Empresa ABC S.A.S.', '9001001001', '3103334455', 'contacto@abc.com', 'Corporativo'),
('Corporacion Eventos S.A.S.', '9001001002', '3104445566', 'eventos@corporacion.com', 'Corporativo'),
('Carlos Rodriguez', '1001001003', '3005556677', 'carlos@gmail.com', 'Individual'),
('Empresa Tecnologia S.A.S.', '9001001003', '3106667788', 'contacto@tecnologia.com', 'Corporativo');


-- =========================================
-- DATOS: SALONES
-- =========================================

INSERT INTO salones
(nombre, capacidad, precio_hora, estado, encargado)
VALUES
('Salon Imperial', 100, 150000.00, 'Disponible', 'Andres Torres'),
('Salon Real', 200, 250000.00, 'Disponible', 'Laura Martinez'),
('Salon Ejecutivo', 50, 100000.00, 'Disponible', 'Carlos Diaz'),
('Salon Campestre', 300, 350000.00, 'Disponible', 'Sofia Ramirez'),
('Salon Corporativo', 150, 200000.00, 'Disponible', 'Miguel Hernandez');


-- =========================================
-- DATOS: RESERVAS
-- =========================================

INSERT INTO reservas
(fecha_inicio, fecha_fin, cliente_id, salon_id, total_horas, valor_total, estado)
VALUES
('2026-08-20 10:00:00', '2026-08-20 14:00:00', 1, 1, NULL, NULL, 'confirmada'),
('2026-08-21 09:00:00', '2026-08-21 13:00:00', 3, 2, NULL, NULL, 'confirmada'),
('2026-08-22 15:00:00', '2026-08-22 18:00:00', 4, 3, NULL, NULL, 'confirmada'),
('2026-08-25 08:00:00', '2026-08-25 12:00:00', 3, 4, NULL, NULL, 'pendiente'),
('2026-08-26 14:00:00', '2026-08-26 18:00:00', 3, 5, NULL, NULL, 'confirmada'),
('2026-08-27 10:00:00', '2026-08-27 12:00:00', 4, 1, NULL, NULL, 'confirmada'),
('2026-08-28 16:00:00', '2026-08-28 20:00:00', 3, 3, NULL, NULL, 'confirmada'),
('2026-08-29 09:00:00', '2026-08-29 11:00:00', 4, 5, NULL, NULL, 'confirmada');


-- =========================================
-- DATOS: PAGOS
-- =========================================

INSERT INTO pagos
(reserva_id, fecha_pago, monto, metodo_pago)
VALUES
(1, '2026-08-18', 714000.00, 'transferencia'),
(2, '2026-08-19', 1190000.00, 'tarjeta'),
(3, '2026-08-20', 357000.00, 'efectivo'),
(4, '2026-08-21', 1666000.00, 'transferencia'),
(5, '2026-08-22', 952000.00, 'tarjeta'),
(6, '2026-08-23', 357000.00, 'efectivo'),
(7, '2026-08-24', 476000.00, 'transferencia'),
(8, '2026-08-25', 476000.00, 'tarjeta');


-- =========================================
-- VERIFICACION
-- =========================================

SELECT * FROM clientes;
SELECT * FROM salones;
SELECT * FROM reservas;
SELECT * FROM pagos;
SELECT * FROM auditoria_precios;

SHOW TABLES;