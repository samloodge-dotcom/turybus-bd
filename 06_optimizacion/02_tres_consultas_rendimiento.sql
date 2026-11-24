USE turybus;

-- Consulta 1: Ventas por fecha (usa idx_billete_fecha)
EXPLAIN ANALYZE SELECT id_billete, dni_pasajero, importe FROM billete WHERE fecha = '2026-11-23';

-- Consulta 2: Servicios por autobús (usa idx_servicio_matricula)
EXPLAIN ANALYZE SELECT s.id_servicio, s.nombre_ruta, b.importe
FROM servicio_diario s JOIN billete b ON s.id_servicio = b.id_servicio
WHERE s.matricula = 'COAH-101-A';

-- Consulta 3: Itinerarios y paradas por destino (antes y después de índice en lugar)
EXPLAIN ANALYZE SELECT d.nombre_ruta, d.orden, l.nombre_lugar, d.actividad
FROM detalle_ruta d JOIN lugar l ON d.id_lugar = l.id_lugar
WHERE l.nombre_lugar = 'Museo del Desierto (MUDE)';

CREATE INDEX idx_lugar_nombre ON lugar(nombre_lugar);

EXPLAIN ANALYZE SELECT d.nombre_ruta, d.orden, l.nombre_lugar, d.actividad
FROM detalle_ruta d JOIN lugar l ON d.id_lugar = l.id_lugar
WHERE l.nombre_lugar = 'Museo del Desierto (MUDE)';
