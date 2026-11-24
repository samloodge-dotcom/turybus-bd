-- ==========================================================
-- FASE 4: ROLES, PERFILES DE USUARIO Y PRIVILEGIOS MÍNIMOS
-- ==========================================================

USE turybus;

-- Eliminar usuario temporal de pruebas de Fase 2
DROP USER IF EXISTS 'prueba_red'@'%';
DROP USER IF EXISTS 'prueba_red'@'localhost';

-- Eliminar roles/usuarios previos si se re-ejecuta el script
DROP ROLE IF EXISTS 'rol_admin_bd', 'rol_taquilla', 'rol_taller', 'rol_auditor';
DROP USER IF EXISTS 'usr_admin'@'%', 'usr_taquilla'@'%', 'usr_taller'@'%', 'usr_auditor'@'%';

-- 1. Crear Roles
CREATE ROLE 'rol_admin_bd', 'rol_taquilla', 'rol_taller', 'rol_auditor';

-- 2. Asignar Privilegios por Rol (Principio de Mínimo Privilegio)
-- Rol Administrador: control total sobre la BD turybus
GRANT ALL PRIVILEGES ON turybus.* TO 'rol_admin_bd' WITH GRANT OPTION;

-- Rol Taquilla (Ventas): lectura de rutas/servicios y gestión de pasajeros/billetes
GRANT SELECT ON turybus.ruta TO 'rol_taquilla';
GRANT SELECT ON turybus.servicio_diario TO 'rol_taquilla';
GRANT SELECT ON turybus.lugar TO 'rol_taquilla';
GRANT SELECT ON turybus.detalle_ruta TO 'rol_taquilla';
GRANT SELECT ON turybus.vw_resumen_ventas TO 'rol_taquilla';
GRANT SELECT, INSERT, UPDATE ON turybus.pasajero TO 'rol_taquilla';
GRANT SELECT, INSERT ON turybus.billete TO 'rol_taquilla';
GRANT EXECUTE ON PROCEDURE turybus.sp_emitir_billete TO 'rol_taquilla';

-- Rol Taller y Flota: gestión de autobuses, conductores, revisiones y reparaciones
GRANT SELECT, INSERT, UPDATE ON turybus.autobus TO 'rol_taller';
GRANT SELECT, INSERT, UPDATE ON turybus.conductor TO 'rol_taller';
GRANT SELECT, INSERT, UPDATE ON turybus.revision TO 'rol_taller';
GRANT SELECT, INSERT, UPDATE ON turybus.reparacion TO 'rol_taller';

-- Rol Auditor / Consulta: únicamente lectura en toda la base de datos
GRANT SELECT ON turybus.* TO 'rol_auditor';

-- 3. Crear los 4 Perfiles de Usuario y Vincular sus Roles
CREATE USER 'usr_admin'@'%' IDENTIFIED BY 'AdminTury2026';
CREATE USER 'usr_taquilla'@'%' IDENTIFIED BY 'Taquilla2026';
CREATE USER 'usr_taller'@'%' IDENTIFIED BY 'Taller2026';
CREATE USER 'usr_auditor'@'%' IDENTIFIED BY 'Auditor2026';

GRANT 'rol_admin_bd' TO 'usr_admin'@'%';
GRANT 'rol_taquilla' TO 'usr_taquilla'@'%';
GRANT 'rol_taller' TO 'usr_taller'@'%';
GRANT 'rol_auditor' TO 'usr_auditor'@'%';

SET DEFAULT ROLE ALL TO 'usr_admin'@'%', 'usr_taquilla'@'%', 'usr_taller'@'%', 'usr_auditor'@'%';
FLUSH PRIVILEGES;
