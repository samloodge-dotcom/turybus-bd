USE turybus;

-- 1. Plan de ejecución ANTES de los índices secundarios
EXPLAIN SELECT id_billete, dni_pasajero, importe
FROM billete
WHERE fecha = '2026-11-23';

EXPLAIN SELECT s.id_servicio, s.nombre_ruta, b.importe
FROM servicio_diario s
JOIN billete b ON s.id_servicio = b.id_servicio
WHERE s.matricula = 'COAH-101-A';

-- 2. Creación de índices estratégicos
CREATE INDEX idx_billete_fecha ON billete(fecha);
CREATE INDEX idx_servicio_matricula ON servicio_diario(matricula);
CREATE INDEX idx_detalle_ruta_lugar ON detalle_ruta(id_lugar);

-- 3. Plan de ejecución DESPUÉS de crear los índices
EXPLAIN SELECT id_billete, dni_pasajero, importe
FROM billete
WHERE fecha = '2026-11-23';

EXPLAIN SELECT s.id_servicio, s.nombre_ruta, b.importe
FROM servicio_diario s
JOIN billete b ON s.id_servicio = b.id_servicio
WHERE s.matricula = 'COAH-101-A';

-- 4. Verificación de índices activos en la tabla billete
SHOW INDEX FROM billete;
