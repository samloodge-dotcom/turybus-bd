-- ==========================================================
-- FASE 3: ESQUEMA RELACIONAL, VISTAS, PROCEDIMIENTOS Y DATOS
-- Proyecto: TURYBUS | SGBD: MySQL 8.4
-- ==========================================================

DROP DATABASE IF EXISTS turybus;
CREATE DATABASE turybus CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE turybus;

-- 1. Catálogo de Rutas
CREATE TABLE ruta (
    nombre_ruta VARCHAR(100) PRIMARY KEY,
    precio DECIMAL(10,2) NOT NULL CHECK (precio > 0)
) ENGINE=InnoDB;

-- 2. Flota de Autobuses
CREATE TABLE autobus (
    matricula VARCHAR(20) PRIMARY KEY,
    fabricante VARCHAR(50) NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    caracteristicas VARCHAR(200),
    num_plazas INT NOT NULL CHECK (num_plazas > 0)
) ENGINE=InnoDB;

-- 3. Plantilla de Conductores
CREATE TABLE conductor (
    dni VARCHAR(20) PRIMARY KEY,
    apellidos_nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20) NOT NULL
) ENGINE=InnoDB;

-- 4. Lugares Turísticos
CREATE TABLE lugar (
    id_lugar INT AUTO_INCREMENT PRIMARY KEY,
    nombre_lugar VARCHAR(100) NOT NULL,
    descripcion VARCHAR(200)
) ENGINE=InnoDB;

-- 5. Servicios Diarios Programados
CREATE TABLE servicio_diario (
    id_servicio INT AUTO_INCREMENT PRIMARY KEY,
    nombre_ruta VARCHAR(100) NOT NULL,
    hora_salida TIME NOT NULL,
    hora_llegada TIME NOT NULL,
    dias_programados VARCHAR(50) NOT NULL,
    matricula VARCHAR(20) NOT NULL,
    dni_conductor VARCHAR(20) NOT NULL,
    CONSTRAINT fk_serv_ruta FOREIGN KEY (nombre_ruta) REFERENCES ruta(nombre_ruta) ON UPDATE CASCADE,
    CONSTRAINT fk_serv_bus FOREIGN KEY (matricula) REFERENCES autobus(matricula) ON UPDATE CASCADE,
    CONSTRAINT fk_serv_cond FOREIGN KEY (dni_conductor) REFERENCES conductor(dni) ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 6. Detalle de Paradas por Ruta
CREATE TABLE detalle_ruta (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    nombre_ruta VARCHAR(100) NOT NULL,
    orden INT NOT NULL,
    id_lugar INT NOT NULL,
    hora_llegada_prevista TIME NOT NULL,
    tiempo_parada DECIMAL(4,2) NOT NULL,
    actividad VARCHAR(150),
    CONSTRAINT fk_det_ruta FOREIGN KEY (nombre_ruta) REFERENCES ruta(nombre_ruta) ON DELETE CASCADE,
    CONSTRAINT fk_det_lugar FOREIGN KEY (id_lugar) REFERENCES lugar(id_lugar)
) ENGINE=InnoDB;

-- 7. Pasajeros
CREATE TABLE pasajero (
    dni VARCHAR(20) PRIMARY KEY,
    apellidos_nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20) NOT NULL
) ENGINE=InnoDB;

-- 8. Billetes Emitidos
CREATE TABLE billete (
    id_billete INT AUTO_INCREMENT PRIMARY KEY,
    dni_pasajero VARCHAR(20) NOT NULL,
    id_servicio INT NOT NULL,
    fecha DATE NOT NULL,
    importe DECIMAL(10,2) NOT NULL,
    hora_salida TIME NOT NULL,
    hora_llegada TIME NOT NULL,
    CONSTRAINT fk_bill_pasajero FOREIGN KEY (dni_pasajero) REFERENCES pasajero(dni) ON UPDATE CASCADE,
    CONSTRAINT fk_bill_servicio FOREIGN KEY (id_servicio) REFERENCES servicio_diario(id_servicio)
) ENGINE=InnoDB;

-- 9. Revisiones Mecánicas
CREATE TABLE revision (
    id_revision INT AUTO_INCREMENT PRIMARY KEY,
    matricula VARCHAR(20) NOT NULL,
    fecha_revision DATE NOT NULL,
    diagnostico VARCHAR(255) NOT NULL,
    CONSTRAINT fk_rev_bus FOREIGN KEY (matricula) REFERENCES autobus(matricula) ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 10. Reparaciones de Taller
CREATE TABLE reparacion (
    codigo_reparacion VARCHAR(20) PRIMARY KEY,
    id_revision INT NOT NULL,
    descripcion VARCHAR(200) NOT NULL,
    tiempo_empleado DECIMAL(5,2) NOT NULL,
    CONSTRAINT fk_rep_rev FOREIGN KEY (id_revision) REFERENCES revision(id_revision) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ==========================================================
-- VISTAS Y PROCEDIMIENTOS ALMACENADOS
-- ==========================================================

CREATE VIEW vw_resumen_ventas AS
SELECT 
    b.id_billete AS folio,
    p.dni AS dni_pasajero,
    p.apellidos_nombre AS pasajero,
    s.nombre_ruta AS ruta,
    b.fecha,
    b.importe
FROM billete b
JOIN pasajero p ON b.dni_pasajero = p.dni
JOIN servicio_diario s ON b.id_servicio = s.id_servicio;

CREATE VIEW vw_itinerarios_completos AS
SELECT 
    d.nombre_ruta,
    d.orden,
    l.nombre_lugar,
    d.hora_llegada_prevista,
    d.tiempo_parada,
    d.actividad
FROM detalle_ruta d
JOIN lugar l ON d.id_lugar = l.id_lugar
ORDER BY d.nombre_ruta, d.orden;

DELIMITER //
CREATE PROCEDURE sp_emitir_billete(
    IN p_dni VARCHAR(20),
    IN p_nombre VARCHAR(100),
    IN p_telefono VARCHAR(20),
    IN p_id_servicio INT,
    IN p_fecha DATE
)
BEGIN
    DECLARE v_precio DECIMAL(10,2);
    DECLARE v_salida TIME;
    DECLARE v_llegada TIME;

    SELECT r.precio, s.hora_salida, s.hora_llegada
    INTO v_precio, v_salida, v_llegada
    FROM servicio_diario s
    JOIN ruta r ON s.nombre_ruta = r.nombre_ruta
    WHERE s.id_servicio = p_id_servicio;

    INSERT INTO pasajero (dni, apellidos_nombre, telefono)
    VALUES (p_dni, p_nombre, p_telefono)
    ON DUPLICATE KEY UPDATE apellidos_nombre = p_nombre, telefono = p_telefono;

    INSERT INTO billete (dni_pasajero, id_servicio, fecha, importe, hora_salida, hora_llegada)
    VALUES (p_dni, p_id_servicio, p_fecha, v_precio, v_salida, v_llegada);
END //
DELIMITER ;

-- ==========================================================
-- INSERCIÓN DE DATOS INICIALES (POBLADO DE TABLAS)
-- ==========================================================

INSERT INTO ruta (nombre_ruta, precio) VALUES
('Ruta Centro Histórico y Museos', 250.00),
('Ruta Pueblos Mágicos - Arteaga', 420.00),
('Ruta Viñedos y Desierto Parras', 680.00);

INSERT INTO autobus (matricula, fabricante, modelo, caracteristicas, num_plazas) VALUES
('COAH-101-A', 'Mercedes-Benz', 'Tourismo RHD', 'A/C, Wi-Fi, Pantallas HD, Baño', 44),
('COAH-202-B', 'Volvo', '9800 DD', 'Doble Piso, Panorámico, USB', 52),
('COAH-303-C', 'Irizar', 'i6S Integral', 'Climatizador, Asientos Reclinables', 40);

INSERT INTO conductor (dni, apellidos_nombre, telefono) VALUES
('COND-01', 'Mendoza Ramírez Carlos', '8441102233'),
('COND-02', 'Garza Trevino Laura', '8442203344'),
('COND-03', 'Salazar Ortiz Roberto', '8443304455');

INSERT INTO lugar (nombre_lugar, descripcion) VALUES
('Museo del Desierto (MUDE)', 'Historia natural y paleontología de Coahuila'),
('Catedral de Santiago Apóstol', 'Arquitectura barroca en el corazón de Saltillo'),
('Bosques de Monterreal', 'Cabañas y mirador alpino en Arteaga'),
('Cascada El Salto', 'Paraje natural ecoturístico en la sierra'),
('Casa Madero', 'Vitivinícola más antigua de América en Parras'),
('Estanque de la Luz', 'Balneario histórico y paseo turístico');

INSERT INTO servicio_diario (nombre_ruta, hora_salida, hora_llegada, dias_programados, matricula, dni_conductor) VALUES
('Ruta Centro Histórico y Museos', '09:00:00', '14:00:00', 'Lunes a Domingo', 'COAH-101-A', 'COND-01'),
('Ruta Pueblos Mágicos - Arteaga', '08:30:00', '16:30:00', 'Viernes a Domingo', 'COAH-202-B', 'COND-02'),
('Ruta Viñedos y Desierto Parras', '07:30:00', '19:30:00', 'Sábado y Domingo', 'COAH-303-C', 'COND-03');

INSERT INTO detalle_ruta (nombre_ruta, orden, id_lugar, hora_llegada_prevista, tiempo_parada, actividad) VALUES
('Ruta Centro Histórico y Museos', 1, 1, '09:30:00', 2.00, 'Recorrido guiado paleontología'),
('Ruta Centro Histórico y Museos', 2, 2, '12:00:00', 1.50, 'Visita arquitectónica y plaza'),
('Ruta Pueblos Mágicos - Arteaga', 1, 3, '10:00:00', 3.00, 'Senderismo y mirador'),
('Ruta Pueblos Mágicos - Arteaga', 2, 4, '13:30:00', 2.00, 'Comida típica y fotografía'),
('Ruta Viñedos y Desierto Parras', 1, 5, '10:00:00', 3.50, 'Cata de vinos y recorrido viñedo'),
('Ruta Viñedos y Desierto Parras', 2, 6, '14:30:00', 2.50, 'Paseo recreativo en estanque');

INSERT INTO pasajero (dni, apellidos_nombre, telefono) VALUES
('PAS-01', 'Ramos Bustos Diego Samuel', '8441234567'),
('PAS-02', 'López Fernández María', '8442345678'),
('PAS-03', 'Pérez García Joanna Carolina', '8443456789'),
('PAS-04', 'Martínez Ruiz Karla', '8444567890'),
('PAS-05', 'Sánchez Díaz Marlis', '8445678901');

INSERT INTO billete (dni_pasajero, id_servicio, fecha, importe, hora_salida, hora_llegada) VALUES
('PAS-01', 1, '2026-11-20', 250.00, '09:00:00', '14:00:00'),
('PAS-02', 2, '2026-11-21', 420.00, '08:30:00', '16:30:00'),
('PAS-03', 3, '2026-11-21', 680.00, '07:30:00', '19:30:00'),
('PAS-04', 1, '2026-11-22', 250.00, '09:00:00', '14:00:00'),
('PAS-05', 2, '2026-11-22', 420.00, '08:30:00', '16:30:00'),
('PAS-01', 3, '2026-11-23', 680.00, '07:30:00', '19:30:00'),
('PAS-02', 1, '2026-11-23', 250.00, '09:00:00', '14:00:00'),
('PAS-03', 2, '2026-11-23', 420.00, '08:30:00', '16:30:00');

INSERT INTO revision (matricula, fecha_revision, diagnostico) VALUES
('COAH-101-A', '2026-11-10', 'Cambio preventivo de balatas delanteras y alineación'),
('COAH-202-B', '2026-11-15', 'Mantenimiento de sistema neumático y filtros de aire'),
('COAH-303-C', '2026-11-18', 'Revisión de compresor de aire acondicionado y batería');

INSERT INTO reparacion (codigo_reparacion, id_revision, descripcion, tiempo_empleado) VALUES
('REP-101', 1, 'Sustitución de juego de balatas cerámicas eje delantero', 2.50),
('REP-102', 2, 'Purga de líneas neumáticas y reemplazo de filtros', 1.75),
('REP-103', 3, 'Recarga de gas refrigerante y ajuste de banda', 3.00);
