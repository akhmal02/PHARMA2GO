-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: pharma2go
-- ------------------------------------------------------
-- Server version	8.0.20

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `receipt`
--

DROP TABLE IF EXISTS `receipt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `receipt` (
  `receiptID` int NOT NULL AUTO_INCREMENT,
  `receiptDate` timestamp NOT NULL,
  `totalAmount` decimal(10,2) NOT NULL,
  `status` varchar(50) NOT NULL,
  `payMethod` varchar(50) DEFAULT NULL,
  `cardNo` varchar(20) DEFAULT NULL,
  `shipmentAddress` varchar(255) NOT NULL,
  `shipmentPostcode` varchar(10) NOT NULL,
  `shipmentState` varchar(45) NOT NULL,
  `empID` int DEFAULT NULL,
  `custID` int NOT NULL,
  PRIMARY KEY (`receiptID`),
  KEY `empID` (`empID`),
  KEY `custID` (`custID`),
  CONSTRAINT `receipt_ibfk_1` FOREIGN KEY (`empID`) REFERENCES `employee` (`empID`),
  CONSTRAINT `receipt_ibfk_2` FOREIGN KEY (`custID`) REFERENCES `customer` (`custID`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `receipt`
--

LOCK TABLES `receipt` WRITE;
/*!40000 ALTER TABLE `receipt` DISABLE KEYS */;
INSERT INTO `receipt` VALUES (1,'2025-12-20 01:30:00',41.40,'Delivered','Credit card','4111222233334444','15, Jalan Melati 3, Taman Mawar','43000','Selangor',1,1),(2,'2025-12-21 06:15:00',20.00,'Delivered','Qr Duitnow',NULL,'88, Lorong Bintang, Georgetown','10200','Penang',2,2),(3,'2025-12-22 02:00:00',32.00,'Delivered','Debit card','5555666677778888','12, Jalan Tun Sambanthan','50470','Kuala Lumpur',3,3),(4,'2025-12-23 08:45:00',56.70,'Delivered','Credit card','4222333344445555','45, Persiaran Hijau','40000','Selangor',1,4),(5,'2025-12-24 03:20:00',16.40,'Delivered','Tng ewallet',NULL,'No. 7, Jalan 14/22','46100','Selangor',2,5),(6,'2025-12-24 05:00:00',107.50,'Delivered','Credit card','4555666677778888','23, Jalan Seremban','71000','Negeri Sembilan',3,6),(7,'2025-12-24 10:30:00',21.00,'Delivered','Qr Duitnow',NULL,'B-12-5, Kondominium Indah','56000','Kuala Lumpur',1,7),(8,'2025-12-25 00:45:00',29.50,'Delivered','Debit card','4666777788889999','Lot 55, Kampung Baru','50300','Kuala Lumpur',2,8),(9,'2025-12-26 04:15:00',17.40,'Delivered','Tng ewallet',NULL,'5, Jalan Skudai','81300','Johor',3,9),(10,'2025-12-27 07:00:00',60.50,'Delivered','Credit card','5111222233334444','101, Jalan Gurney','75000','Melaka',1,10),(11,'2025-12-28 01:10:00',20.00,'Delivered','Qr Duitnow',NULL,'15, Jalan Melati 3','43000','Selangor',2,1),(12,'2025-12-29 03:30:00',42.50,'Delivered','Credit card','4888999900001111','88, Lorong Bintang','10200','Penang',3,2),(13,'2025-12-30 06:20:00',12.00,'Delivered','Tng ewallet',NULL,'12, Jalan Tun Sambanthan','50470','Kuala Lumpur',1,3),(14,'2025-12-31 02:00:00',67.50,'Delivered','Credit card','4999000011112222','45, Persiaran Hijau','40000','Selangor',2,4),(15,'2025-12-31 11:45:00',15.00,'Delivered','Qr Duitnow',NULL,'No. 7, Jalan 14/22','46100','Selangor',3,5),(16,'2026-01-01 02:15:00',25.50,'Delivered','Debit card','5222333344445555','23, Jalan Seremban','71000','Negeri Sembilan',1,6),(17,'2026-01-02 06:30:00',35.50,'Delivered','Credit card','4777888899990000','B-12-5, Kondominium Indah','56000','Kuala Lumpur',2,7),(18,'2026-01-03 01:00:00',21.70,'Delivered','Tng ewallet',NULL,'Lot 55, Kampung Baru','50300','Kuala Lumpur',3,8),(19,'2026-01-03 08:20:00',16.40,'Delivered','Qr Duitnow',NULL,'5, Jalan Skudai','81300','Johor',1,9),(20,'2026-01-04 03:45:00',51.50,'Delivered','Credit card','5333444455556666','101, Jalan Gurney','75000','Melaka',2,10),(21,'2026-01-05 05:00:00',20.00,'Delivered','Tng ewallet',NULL,'15, Jalan Melati 3','43000','Selangor',3,1),(22,'2026-01-05 07:30:00',40.80,'Delivered','Debit card','4444555566667777','88, Lorong Bintang','10200','Penang',1,2),(23,'2026-01-06 01:50:00',32.00,'Delivered','Credit card','5444555566667777','12, Jalan Tun Sambanthan','50470','Kuala Lumpur',2,3),(24,'2026-01-06 04:10:00',42.50,'Delivered','Qr Duitnow',NULL,'45, Persiaran Hijau','40000','Selangor',3,4),(25,'2026-01-07 09:00:00',13.00,'Delivered','Tng ewallet',NULL,'No. 7, Jalan 14/22','46100','Selangor',1,5),(26,'2026-01-07 02:00:00',21.00,'Delivered','Qr Duitnow',NULL,'23, Jalan Seremban','71000','Negeri Sembilan',2,6),(27,'2026-01-07 06:00:00',14.30,'Delivered','Qr Duitnow',NULL,'B-12-5, Kondominium Indah','56000','Kuala Lumpur',3,7),(28,'2026-01-08 01:30:00',29.50,'Delivered','Debit card','4000111122223333','Lot 55, Kampung Baru','50300','Kuala Lumpur',1,8),(29,'2026-01-08 08:45:00',17.40,'Delivered','Tng ewallet',NULL,'5, Jalan Skudai','81300','Johor',2,9),(30,'2026-01-09 03:15:00',18.50,'Delivered','Tng ewallet',NULL,'101, Jalan Gurney','75000','Melaka',3,10),(31,'2026-01-09 02:30:00',57.50,'Delivered','Credit card','4123412341234123','15, Jalan Melati 3','43000','Selangor',1,1),(32,'2026-01-10 04:45:00',32.50,'Delivered','Debit card','5999888877776666','88, Lorong Bintang','10200','Penang',2,2),(33,'2026-01-10 01:15:00',20.00,'Delivered','Qr Duitnow',NULL,'12, Jalan Tun Sambanthan','50470','Kuala Lumpur',3,3),(34,'2026-01-11 07:00:00',16.40,'Delivered','Tng ewallet',NULL,'45, Persiaran Hijau','40000','Selangor',1,4),(35,'2026-01-11 03:30:00',42.50,'Delivered','Credit card','4555444433332222','No. 7, Jalan 14/22','46100','Selangor',2,5),(36,'2026-01-12 06:10:00',25.50,'Delayed','Debit card','5666777788889999','23, Jalan Seremban','71000','Negeri Sembilan',3,6),(37,'2026-01-12 08:50:00',15.00,'Delayed','Qr Duitnow',NULL,'B-12-5, Kondominium Indah','56000','Kuala Lumpur',1,7),(38,'2026-01-13 01:40:00',29.50,'In shipment','Credit card','4111999922228888','Lot 55, Kampung Baru','50300','Kuala Lumpur',2,8),(39,'2026-01-13 05:20:00',12.00,'In shipment','Tng ewallet',NULL,'5, Jalan Skudai','81300','Johor',3,9),(40,'2026-01-14 02:00:00',53.40,'In shipment','Debit card','5000400030002000','101, Jalan Gurney','75000','Melaka',1,10),(41,'2026-01-14 07:30:00',55.90,'Delayed','Qr Duitnow',NULL,'15, Jalan Melati 3','43000','Selangor',2,1),(42,'2026-01-14 01:00:00',65.60,'Delayed','Qr Duitnow',NULL,'88, Lorong Bintang','10200','Penang',3,2),(43,'2026-01-15 03:45:00',31.70,'In shipment','Credit card','4222888833337777','12, Jalan Tun Sambanthan','50470','Kuala Lumpur',1,3),(44,'2026-01-15 06:30:00',54.50,'New','Debit card','5111333355557777','45, Persiaran Hijau','40000','Selangor',NULL,4),(45,'2026-01-15 09:15:00',50.40,'New','Tng ewallet',NULL,'No. 7, Jalan 14/22','46100','Selangor',NULL,5),(46,'2026-01-15 10:00:00',62.40,'New','Qr Duitnow',NULL,'23, Jalan Seremban','71000','Negeri Sembilan',NULL,6),(47,'2026-01-15 11:30:00',56.80,'New','Credit card','4999111188882222','B-12-5, Kondominium Indah','56000','Kuala Lumpur',NULL,7),(48,'2026-01-15 12:00:00',45.00,'Delivered','Qr Duitnow',NULL,'Lot 55, Kampung Baru','50300','Kuala Lumpur',2,8),(49,'2026-01-15 12:45:00',45.40,'Delivered','Debit card','5888222299993333','5, Jalan Skudai','81300','Johor',3,9),(50,'2026-01-15 13:15:00',55.50,'Delivered','Tng ewallet',NULL,'101, Jalan Gurney','75000','Melaka',1,10),(51,'2026-02-09 10:07:30',56.50,'New','E-Wallet',NULL,'101, Jalan Gurney','81300','Selangor',NULL,1),(52,'2026-02-09 10:08:15',96.70,'New','Online Banking','1213141516','No. 7, Jalan 14/22','15000','Selangor',NULL,1);
/*!40000 ALTER TABLE `receipt` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-02-09 18:11:05
