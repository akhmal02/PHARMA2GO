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
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer` (
  `custID` int NOT NULL AUTO_INCREMENT,
  `custName` varchar(100) NOT NULL,
  `custPhone` varchar(20) NOT NULL,
  `custEmail` varchar(50) NOT NULL,
  `custAddress` varchar(255) DEFAULT NULL,
  `custPostcode` varchar(10) DEFAULT NULL,
  `custState` varchar(40) DEFAULT NULL,
  `password` varchar(20) NOT NULL,
  PRIMARY KEY (`custID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES (1,'MUHAMMAD AIMAN BIN MUHAMMAD FUZI','012-3456789','aiman@gmail.com','15, Jalan Melati 3, Taman Mawar','43000','Selangor','pass123'),(2,'MUHAMMAD AZMI BIN AHMAD FANZURRY','019-8765432','azmi@gmail.com','88, Lorong Bintang, Georgetown','10200','Penang','pass123'),(3,'RAVI A/L SUBRAMANIAM','017-4561234','ravi@gmail.com','12, Jalan Tun Sambanthan, Brickfields','50470','Kuala Lumpur','pass123'),(4,'NURUL IZZAH BINTI AHMAD','013-9876543','nurul@gmail.com','45, Persiaran Hijau, Shah Alam','40000','Selangor','pass123'),(5,'LEE CHONG WEI','016-5551212','chongwei@gmail.com','No. 7, Jalan 14/22, Petaling Jaya','46100','Selangor','pass123'),(6,'MUTHU KUMAR','012-2223333','muthu@gmail.com','23, Jalan Seremban, Port Dickson','71000','Negeri Sembilan','pass123'),(7,'WONG SIEW LAN','014-7778888','siewlan@gmail.com','B-12-5, Kondominium Indah, Cheras','56000','Kuala Lumpur','pass123'),(8,'FARID BIN ZAKARIA','011-12345678','farid@gmail.com','Lot 55, Kampung Baru','50300','Kuala Lumpur','pass123'),(9,'ANAND RAJ','018-9990000','anand@gmail.com','5, Jalan Skudai, Johor Bahru','81300','Johor','pass123'),(10,'LIM PEI YEE','017-3334444','peiyee@gmail.com','101, Jalan Gurney, Melaka Tengah','75000','Melaka','pass123');
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
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
