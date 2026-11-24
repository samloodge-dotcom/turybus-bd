USE turybus;

DROP TABLE IF EXISTS bitacora_auditoria;
CREATE TABLE bitacora_auditoria (
    id_evento INT AUTO_INCREMENT PRIMARY KEY,
    fecha_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    usuario_evento VARCHAR(60) NOT NULL,
    accion VARCHAR(40) NOT NULL,
    detalle VARCHAR(255) NOT NULL
) ENGINE=InnoDB;

DROP TABLE IF EXISTS usuarios_app;
CREATE TABLE usuarios_app (
    username VARCHAR(40) PRIMARY KEY,
    nombre_completo VARCHAR(100) NOT NULL,
    rol ENUM('DBA', 'Gerente', 'Vendedor', 'Operador') NOT NULL,
    password_hash CHAR(64) NOT NULL,
    activo BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB;

-- Contraseñas almacenadas con SHA-256 (nunca en texto plano) -> clave: Turybus2026
INSERT INTO usuarios_app (username, nombre_completo, rol, password_hash) VALUES
('admin_dba', 'Ramos Bustos Diego Samuel', 'DBA', SHA2('Turybus2026', 256)),
('gerente_maria', 'De León Pérez María Fernanda', 'Gerente', SHA2('Turybus2026', 256)),
('vendedor_caro', 'Chacón López Joanna Carolina', 'Vendedor', SHA2('Turybus2026', 256)),
('vendedor_marlis', 'Torres Aguirre Marlis Ireli', 'Vendedor', SHA2('Turybus2026', 256)),
('operador_karla', 'Castro Santiago Karla Ivon', 'Operador', SHA2('Turybus2026', 256));

-- Trigger justificado: audita automáticamente cada emisión de billete
DROP TRIGGER IF EXISTS trg_auditoria_billete;
DELIMITER //
CREATE TRIGGER trg_auditoria_billete
AFTER INSERT ON billete
FOR EACH ROW
BEGIN
    INSERT INTO bitacora_auditoria (usuario_evento, accion, detalle)
    VALUES (CURRENT_USER(), 'EMISION_BILLETE',
            CONCAT('Folio #', NEW.id_billete, ' | Pasajero: ', NEW.dni_pasajero, ' | Importe: $', NEW.importe));
END //
DELIMITER ;

GRANT SELECT, INSERT ON turybus.bitacora_auditoria TO 'rol_auditor';
GRANT SELECT ON turybus.usuarios_app TO 'rol_auditor';
GRANT INSERT, UPDATE ON turybus.usuarios_app TO 'rol_admin_bd';
FLUSH PRIVILEGES;

SELECT username, nombre_completo, rol, LEFT(password_hash, 16) AS hash_sha256 FROM usuarios_app;
SHOW TRIGGERS FROM turybus;
