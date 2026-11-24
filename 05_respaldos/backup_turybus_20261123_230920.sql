-- MySQL dump 10.13  Distrib 8.4.13, for Linux (x86_64)
--
-- Host: localhost    Database: turybus
-- ------------------------------------------------------
-- Server version	8.4.13-0ubuntu0.26.04.2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `autobus`
--

DROP TABLE IF EXISTS `autobus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `autobus` (
  `matricula` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `fabricante` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `modelo` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `caracteristicas` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `num_plazas` int NOT NULL,
  PRIMARY KEY (`matricula`),
  CONSTRAINT `autobus_chk_1` CHECK ((`num_plazas` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `autobus`
--

LOCK TABLES `autobus` WRITE;
/*!40000 ALTER TABLE `autobus` DISABLE KEYS */;
INSERT INTO `autobus` VALUES ('COAH-101-A','Mercedes-Benz','Tourismo RHD','A/C, Wi-Fi, Pantallas HD, Baño',44),('COAH-202-B','Volvo','9800 DD','Doble Piso, Panorámico, USB',52),('COAH-303-C','Irizar','i6S Integral','Climatizador, Asientos Reclinables',40);
/*!40000 ALTER TABLE `autobus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `billete`
--

DROP TABLE IF EXISTS `billete`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `billete` (
  `id_billete` int NOT NULL AUTO_INCREMENT,
  `dni_pasajero` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_servicio` int NOT NULL,
  `fecha` date NOT NULL,
  `importe` decimal(10,2) NOT NULL,
  `hora_salida` time NOT NULL,
  `hora_llegada` time NOT NULL,
  PRIMARY KEY (`id_billete`),
  KEY `fk_bill_pasajero` (`dni_pasajero`),
  KEY `fk_bill_servicio` (`id_servicio`),
  CONSTRAINT `fk_bill_pasajero` FOREIGN KEY (`dni_pasajero`) REFERENCES `pasajero` (`dni`) ON UPDATE CASCADE,
  CONSTRAINT `fk_bill_servicio` FOREIGN KEY (`id_servicio`) REFERENCES `servicio_diario` (`id_servicio`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `billete`
--

LOCK TABLES `billete` WRITE;
/*!40000 ALTER TABLE `billete` DISABLE KEYS */;
INSERT INTO `billete` VALUES (1,'PAS-01',1,'2026-11-20',250.00,'09:00:00','14:00:00'),(2,'PAS-02',2,'2026-11-21',420.00,'08:30:00','16:30:00'),(3,'PAS-03',3,'2026-11-21',680.00,'07:30:00','19:30:00'),(4,'PAS-04',1,'2026-11-22',250.00,'09:00:00','14:00:00'),(5,'PAS-05',2,'2026-11-22',420.00,'08:30:00','16:30:00'),(6,'PAS-01',3,'2026-11-23',680.00,'07:30:00','19:30:00'),(7,'PAS-02',1,'2026-11-23',250.00,'09:00:00','14:00:00'),(8,'PAS-03',2,'2026-11-23',420.00,'08:30:00','16:30:00');
/*!40000 ALTER TABLE `billete` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `conductor`
--

DROP TABLE IF EXISTS `conductor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `conductor` (
  `dni` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `apellidos_nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `telefono` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`dni`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `conductor`
--

LOCK TABLES `conductor` WRITE;
/*!40000 ALTER TABLE `conductor` DISABLE KEYS */;
INSERT INTO `conductor` VALUES ('COND-01','Mendoza Ramírez Carlos','8441102233'),('COND-02','Garza Trevino Laura','8442203344'),('COND-03','Salazar Ortiz Roberto','8443304455');
/*!40000 ALTER TABLE `conductor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `detalle_ruta`
--

DROP TABLE IF EXISTS `detalle_ruta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `detalle_ruta` (
  `id_detalle` int NOT NULL AUTO_INCREMENT,
  `nombre_ruta` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `orden` int NOT NULL,
  `id_lugar` int NOT NULL,
  `hora_llegada_prevista` time NOT NULL,
  `tiempo_parada` decimal(4,2) NOT NULL,
  `actividad` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_detalle`),
  KEY `fk_det_ruta` (`nombre_ruta`),
  KEY `fk_det_lugar` (`id_lugar`),
  CONSTRAINT `fk_det_lugar` FOREIGN KEY (`id_lugar`) REFERENCES `lugar` (`id_lugar`),
  CONSTRAINT `fk_det_ruta` FOREIGN KEY (`nombre_ruta`) REFERENCES `ruta` (`nombre_ruta`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `detalle_ruta`
--

LOCK TABLES `detalle_ruta` WRITE;
/*!40000 ALTER TABLE `detalle_ruta` DISABLE KEYS */;
INSERT INTO `detalle_ruta` VALUES (1,'Ruta Centro Histórico y Museos',1,1,'09:30:00',2.00,'Recorrido guiado paleontología'),(2,'Ruta Centro Histórico y Museos',2,2,'12:00:00',1.50,'Visita arquitectónica y plaza'),(3,'Ruta Pueblos Mágicos - Arteaga',1,3,'10:00:00',3.00,'Senderismo y mirador'),(4,'Ruta Pueblos Mágicos - Arteaga',2,4,'13:30:00',2.00,'Comida típica y fotografía'),(5,'Ruta Viñedos y Desierto Parras',1,5,'10:00:00',3.50,'Cata de vinos y recorrido viñedo'),(6,'Ruta Viñedos y Desierto Parras',2,6,'14:30:00',2.50,'Paseo recreativo en estanque');
/*!40000 ALTER TABLE `detalle_ruta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lugar`
--

DROP TABLE IF EXISTS `lugar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lugar` (
  `id_lugar` int NOT NULL AUTO_INCREMENT,
  `nombre_lugar` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_lugar`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lugar`
--

LOCK TABLES `lugar` WRITE;
/*!40000 ALTER TABLE `lugar` DISABLE KEYS */;
INSERT INTO `lugar` VALUES (1,'Museo del Desierto (MUDE)','Historia natural y paleontología de Coahuila'),(2,'Catedral de Santiago Apóstol','Arquitectura barroca en el corazón de Saltillo'),(3,'Bosques de Monterreal','Cabañas y mirador alpino en Arteaga'),(4,'Cascada El Salto','Paraje natural ecoturístico en la sierra'),(5,'Casa Madero','Vitivinícola más antigua de América en Parras'),(6,'Estanque de la Luz','Balneario histórico y paseo turístico');
/*!40000 ALTER TABLE `lugar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pasajero`
--

DROP TABLE IF EXISTS `pasajero`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pasajero` (
  `dni` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `apellidos_nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `telefono` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`dni`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pasajero`
--

LOCK TABLES `pasajero` WRITE;
/*!40000 ALTER TABLE `pasajero` DISABLE KEYS */;
INSERT INTO `pasajero` VALUES ('PAS-01','Ramos Bustos Diego Samuel','8441234567'),('PAS-02','López Fernández María','8442345678'),('PAS-03','Pérez García Joanna Carolina','8443456789'),('PAS-04','Martínez Ruiz Karla','8444567890'),('PAS-05','Sánchez Díaz Marlis','8445678901');
/*!40000 ALTER TABLE `pasajero` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reparacion`
--

DROP TABLE IF EXISTS `reparacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reparacion` (
  `codigo_reparacion` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_revision` int NOT NULL,
  `descripcion` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tiempo_empleado` decimal(5,2) NOT NULL,
  PRIMARY KEY (`codigo_reparacion`),
  KEY `fk_rep_rev` (`id_revision`),
  CONSTRAINT `fk_rep_rev` FOREIGN KEY (`id_revision`) REFERENCES `revision` (`id_revision`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reparacion`
--

LOCK TABLES `reparacion` WRITE;
/*!40000 ALTER TABLE `reparacion` DISABLE KEYS */;
INSERT INTO `reparacion` VALUES ('REP-101',1,'Sustitución de juego de balatas cerámicas eje delantero',2.50),('REP-102',2,'Purga de líneas neumáticas y reemplazo de filtros',1.75),('REP-103',3,'Recarga de gas refrigerante y ajuste de banda',3.00);
/*!40000 ALTER TABLE `reparacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `revision`
--

DROP TABLE IF EXISTS `revision`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `revision` (
  `id_revision` int NOT NULL AUTO_INCREMENT,
  `matricula` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_revision` date NOT NULL,
  `diagnostico` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_revision`),
  KEY `fk_rev_bus` (`matricula`),
  CONSTRAINT `fk_rev_bus` FOREIGN KEY (`matricula`) REFERENCES `autobus` (`matricula`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `revision`
--

LOCK TABLES `revision` WRITE;
/*!40000 ALTER TABLE `revision` DISABLE KEYS */;
INSERT INTO `revision` VALUES (1,'COAH-101-A','2026-11-10','Cambio preventivo de balatas delanteras y alineación'),(2,'COAH-202-B','2026-11-15','Mantenimiento de sistema neumático y filtros de aire'),(3,'COAH-303-C','2026-11-18','Revisión de compresor de aire acondicionado y batería');
/*!40000 ALTER TABLE `revision` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ruta`
--

DROP TABLE IF EXISTS `ruta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ruta` (
  `nombre_ruta` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  PRIMARY KEY (`nombre_ruta`),
  CONSTRAINT `ruta_chk_1` CHECK ((`precio` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ruta`
--

LOCK TABLES `ruta` WRITE;
/*!40000 ALTER TABLE `ruta` DISABLE KEYS */;
INSERT INTO `ruta` VALUES ('Ruta Centro Histórico y Museos',250.00),('Ruta Pueblos Mágicos - Arteaga',420.00),('Ruta Viñedos y Desierto Parras',680.00);
/*!40000 ALTER TABLE `ruta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `servicio_diario`
--

DROP TABLE IF EXISTS `servicio_diario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `servicio_diario` (
  `id_servicio` int NOT NULL AUTO_INCREMENT,
  `nombre_ruta` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `hora_salida` time NOT NULL,
  `hora_llegada` time NOT NULL,
  `dias_programados` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `matricula` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `dni_conductor` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_servicio`),
  KEY `fk_serv_ruta` (`nombre_ruta`),
  KEY `fk_serv_bus` (`matricula`),
  KEY `fk_serv_cond` (`dni_conductor`),
  CONSTRAINT `fk_serv_bus` FOREIGN KEY (`matricula`) REFERENCES `autobus` (`matricula`) ON UPDATE CASCADE,
  CONSTRAINT `fk_serv_cond` FOREIGN KEY (`dni_conductor`) REFERENCES `conductor` (`dni`) ON UPDATE CASCADE,
  CONSTRAINT `fk_serv_ruta` FOREIGN KEY (`nombre_ruta`) REFERENCES `ruta` (`nombre_ruta`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `servicio_diario`
--

LOCK TABLES `servicio_diario` WRITE;
/*!40000 ALTER TABLE `servicio_diario` DISABLE KEYS */;
INSERT INTO `servicio_diario` VALUES (1,'Ruta Centro Histórico y Museos','09:00:00','14:00:00','Lunes a Domingo','COAH-101-A','COND-01'),(2,'Ruta Pueblos Mágicos - Arteaga','08:30:00','16:30:00','Viernes a Domingo','COAH-202-B','COND-02'),(3,'Ruta Viñedos y Desierto Parras','07:30:00','19:30:00','Sábado y Domingo','COAH-303-C','COND-03');
/*!40000 ALTER TABLE `servicio_diario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `vw_itinerarios_completos`
--

DROP TABLE IF EXISTS `vw_itinerarios_completos`;
/*!50001 DROP VIEW IF EXISTS `vw_itinerarios_completos`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_itinerarios_completos` AS SELECT 
 1 AS `nombre_ruta`,
 1 AS `orden`,
 1 AS `nombre_lugar`,
 1 AS `hora_llegada_prevista`,
 1 AS `tiempo_parada`,
 1 AS `actividad`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_resumen_ventas`
--

DROP TABLE IF EXISTS `vw_resumen_ventas`;
/*!50001 DROP VIEW IF EXISTS `vw_resumen_ventas`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_resumen_ventas` AS SELECT 
 1 AS `folio`,
 1 AS `dni_pasajero`,
 1 AS `pasajero`,
 1 AS `ruta`,
 1 AS `fecha`,
 1 AS `importe`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping routines for database 'turybus'
--
/*!50003 DROP PROCEDURE IF EXISTS `sp_emitir_billete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_emitir_billete`(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `vw_itinerarios_completos`
--

/*!50001 DROP VIEW IF EXISTS `vw_itinerarios_completos`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_itinerarios_completos` AS select `d`.`nombre_ruta` AS `nombre_ruta`,`d`.`orden` AS `orden`,`l`.`nombre_lugar` AS `nombre_lugar`,`d`.`hora_llegada_prevista` AS `hora_llegada_prevista`,`d`.`tiempo_parada` AS `tiempo_parada`,`d`.`actividad` AS `actividad` from (`detalle_ruta` `d` join `lugar` `l` on((`d`.`id_lugar` = `l`.`id_lugar`))) order by `d`.`nombre_ruta`,`d`.`orden` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_resumen_ventas`
--

/*!50001 DROP VIEW IF EXISTS `vw_resumen_ventas`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_resumen_ventas` AS select `b`.`id_billete` AS `folio`,`p`.`dni` AS `dni_pasajero`,`p`.`apellidos_nombre` AS `pasajero`,`s`.`nombre_ruta` AS `ruta`,`b`.`fecha` AS `fecha`,`b`.`importe` AS `importe` from ((`billete` `b` join `pasajero` `p` on((`b`.`dni_pasajero` = `p`.`dni`))) join `servicio_diario` `s` on((`b`.`id_servicio` = `s`.`id_servicio`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-23 23:09:20
