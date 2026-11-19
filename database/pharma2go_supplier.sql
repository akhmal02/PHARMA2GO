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
-- Table structure for table `supplier`
--

DROP TABLE IF EXISTS `supplier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `supplier` (
  `supID` int NOT NULL AUTO_INCREMENT,
  `supName` varchar(100) NOT NULL,
  `supPhone` varchar(20) DEFAULT NULL,
  `supEmail` varchar(100) DEFAULT NULL,
  `supAddress` varchar(255) DEFAULT NULL,
  `supType` varchar(20) NOT NULL,
  PRIMARY KEY (`supID`),
  CONSTRAINT `supplier_chk_1` CHECK ((`supType` in (_utf8mb4'LOCAL',_utf8mb4'INTERNATIONAL')))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `supplier`
--

LOCK TABLES `supplier` WRITE;
/*!40000 ALTER TABLE `supplier` DISABLE KEYS */;
INSERT INTO `supplier` VALUES (1,'Pharmaniaga Berhad','03-33429999','contact@pharmaniaga.com','7, Lorong Keluli 1B, Shah Alam, Selangor','LOCAL'),(2,'Duopharma Biotech','03-89243000','info@duopharma.com.my','Lot 2599, Jalan Seruhl, Klang, Selangor','LOCAL'),(3,'Hovid Berhad','05-5205555','sales@hovid.com','121, Jalan Tunku Abdul Rahman, Ipoh, Perak','LOCAL'),(4,'Pfizer International','+1-212-733-2323','global@pfizer.com','235 East 42nd Street, New York, USA','INTERNATIONAL'),(5,'Bayer Global','+49-214-30-1','contact@bayer.com','Kaiser-Wilhelm-Allee 1, Leverkusen, Germany','INTERNATIONAL');
/*!40000 ALTER TABLE `supplier` ENABLE KEYS */;
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
