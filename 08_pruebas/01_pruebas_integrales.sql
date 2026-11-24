USE turybus;

-- 1. Verificar el billete recién emitido desde la aplicación web
SELECT * FROM vw_resumen_ventas ORDER BY folio DESC LIMIT 5;

-- 2. Validar integridad referencial (intentar insertar billete con pasajero inexistente debe fallar o validarse)
SELECT 
    b.id_billete AS folio,
    p.apellidos_nombre AS pasajero,
    s.nombre_ruta AS ruta,
    a.matricula AS autobus,
    c.apellidos_nombre AS conductor,
    b.importe
FROM billete b
JOIN pasajero p ON b.dni_pasajero = p.dni
JOIN servicio_diario s ON b.id_servicio = s.id_servicio
JOIN autobus a ON s.matricula = a.matricula
JOIN conductor c ON s.dni_conductor = c.dni
ORDER BY b.id_billete DESC;

-- 3. Monitoreo de conexiones y procesos activos en el servidor MySQL
SHOW PROCESSLIST;
