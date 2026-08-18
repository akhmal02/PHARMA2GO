-- ======================================================
-- Combined Database Dump: PHARMA DB (pharma2go)
-- Server version: MySQL 8.0.20 / Distrib 8.0.44
-- ======================================================

CREATE DATABASE IF NOT EXISTS `pharma2go` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */;
USE `pharma2go`;

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
INSERT INTO `customer` VALUES 
(1,'MUHAMMAD AIMAN BIN MUHAMMAD FUZI','012-3456789','aiman@gmail.com','15, Jalan Melati 3, Taman Mawar','43000','Selangor','pass123'),
(2,'MUHAMMAD AZMI BIN AHMAD FANZURRY','019-8765432','azmi@gmail.com','88, Lorong Bintang, Georgetown','10200','Penang','pass123'),
(3,'RAVI A/L SUBRAMANIAM','017-4561234','ravi@gmail.com','12, Jalan Tun Sambanthan, Brickfields','50470','Kuala Lumpur','pass123'),
(4,'NURUL IZZAH BINTI AHMAD','013-9876543','nurul@gmail.com','45, Persiaran Hijau, Shah Alam','40000','Selangor','pass123'),
(5,'LEE CHONG WEI','016-5551212','chongwei@gmail.com','No. 7, Jalan 14/22, Petaling Jaya','46100','Selangor','pass123'),
(6,'MUTHU KUMAR','012-2223333','muthu@gmail.com','23, Jalan Seremban, Port Dickson','71000','Negeri Sembilan','pass123'),
(7,'WONG SIEW LAN','014-7778888','siewlan@gmail.com','B-12-5, Kondominium Indah, Cheras','56000','Kuala Lumpur','pass123'),
(8,'FARID BIN ZAKARIA','011-12345678','farid@gmail.com','Lot 55, Kampung Baru','50300','Kuala Lumpur','pass123'),
(9,'ANAND RAJ','018-9990000','anand@gmail.com','5, Jalan Skudai, Johor Bahru','81300','Johor','pass123'),
(10,'LIM PEI YEE','017-3334444','peiyee@gmail.com','101, Jalan Gurney, Melaka Tengah','75000','Melaka','pass123');
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee`
--

DROP TABLE IF EXISTS `employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee` (
  `empID` int NOT NULL AUTO_INCREMENT,
  `empName` varchar(100) NOT NULL,
  `empIC` varchar(20) NOT NULL,
  `empPhone` varchar(20) DEFAULT NULL,
  `empEmail` varchar(50) NOT NULL,
  `empAddress` varchar(255) DEFAULT NULL,
  `empHireDate` date NOT NULL,
  `supervisorID` int DEFAULT NULL,
  `password` varchar(20) NOT NULL,
  PRIMARY KEY (`empID`),
  KEY `supervisorID` (`supervisorID`),
  CONSTRAINT `employee_ibfk_1` FOREIGN KEY (`supervisorID`) REFERENCES `employee` (`empID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee`
--

LOCK TABLES `employee` WRITE;
/*!40000 ALTER TABLE `employee` DISABLE KEYS */;
INSERT INTO `employee` VALUES 
(1,'MUHAMMAD AKHMAL BIN MOHAMAD HUSSIN','850101145533','012-3456789','akhmal@pharma2go.com','No 1, Jalan Melati, KL','2023-01-10',NULL,'akhmal123'),
(2,'DANISH HAZIM BIN MOHD ZAHIRUL FAIZA','920512106677','013-9876543','danish@pharma2go.com','No 5, Taman Bunga, Shah Alam','2023-05-15',1,'danish123'),
(3,'MUHAMMAD IMRAN AUFA BIN ABDUL RASHID','980303081122','014-1231234','imran@pharma2go.com','12-A, Apartment Ria, Puchong','2024-02-01',1,'imran123');
/*!40000 ALTER TABLE `employee` ENABLE KEYS */;
UNLOCK TABLES;

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
INSERT INTO `supplier` VALUES 
(1,'Pharmaniaga Berhad','03-33429999','contact@pharmaniaga.com','7, Lorong Keluli 1B, Shah Alam, Selangor','LOCAL'),
(2,'Duopharma Biotech','03-89243000','info@duopharma.com.my','Lot 2599, Jalan Seruhl, Klang, Selangor','LOCAL'),
(3,'Hovid Berhad','05-5205555','sales@hovid.com','121, Jalan Tunku Abdul Rahman, Ipoh, Perak','LOCAL'),
(4,'Pfizer International','+1-212-733-2323','global@pfizer.com','235 East 42nd Street, New York, USA','INTERNATIONAL'),
(5,'Bayer Global','+49-214-30-1','contact@bayer.com','Kaiser-Wilhelm-Allee 1, Leverkusen, Germany','INTERNATIONAL');
/*!40000 ALTER TABLE `supplier` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `international`
--

DROP TABLE IF EXISTS `international`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `international` (
  `supID` int NOT NULL,
  `country` varchar(40) DEFAULT NULL,
  `importLicenseNum` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`supID`),
  CONSTRAINT `international_ibfk_1` FOREIGN KEY (`supID`) REFERENCES `supplier` (`supID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `international`
--

LOCK TABLES `international` WRITE;
/*!40000 ALTER TABLE `international` DISABLE KEYS */;
INSERT INTO `international` VALUES 
(4,'USA','IMP-US-9982'),
(5,'Germany','IMP-DE-1123');
/*!40000 ALTER TABLE `international` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `local`
--

DROP TABLE IF EXISTS `local`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `local` (
  `supID` int NOT NULL,
  `taxTIN` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`supID`),
  CONSTRAINT `local_ibfk_1` FOREIGN KEY (`supID`) REFERENCES `supplier` (`supID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `local`
--

LOCK TABLES `local` WRITE;
/*!40000 ALTER TABLE `local` DISABLE KEYS */;
INSERT INTO `local` VALUES 
(1,'TIN-483920'),
(2,'TIN-593029'),
(3,'TIN-102938');
/*!40000 ALTER TABLE `local` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `prodID` int NOT NULL AUTO_INCREMENT,
  `prodName` varchar(100) NOT NULL,
  `prodBrand` varchar(50) NOT NULL,
  `prodDesc` varchar(255) DEFAULT NULL,
  `prodPrice` decimal(10,2) NOT NULL,
  `prodCategory` varchar(50) DEFAULT NULL,
  `prodStock` int NOT NULL DEFAULT '0',
  `prodExpDate` date DEFAULT NULL,
  `prodPicture` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`prodID`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES 
(1,'Panadol Actifast','Panadol','Fast acting pain relief caplets for headache fever',12.50,'Pain Relief',95,'2027-12-31','panadol.png'),
(2,'Minyak Cap Kapak','Axe Brand','Medicated oil for relief of headaches and cold',8.90,'Traditional',47,'2028-06-30','capkapak.png'),
(3,'Ubat Batuk Cap Ibu dan Anak','Nin Jiom','Natural herbal cough syrup for sore throat relief',24.50,'Cough & Cold',78,'2027-05-15','ninjiom.png'),
(4,'Gaviscon Double Action','Gaviscon','Double action liquid sachet for heartburn and indigestion',35.00,'Digestive',60,'2026-11-20','gaviscon.png'),
(5,'Eno Fruit Salt Lemon','Eno','Effervescent powder for fast relief of stomach indigestion',4.50,'Digestive',4,'2028-01-15','eno.png'),
(6,'Vicks VapoRub','Vicks','Menthol rub for relief of cold and congestion',14.20,'Cough & Cold',70,'2027-08-10','vicks.png'),
(7,'Hurixs 600 Flu Cough','Hurixs','Traditional herbal formula for flu and cough relief',18.00,'Traditional',90,'2026-12-05','hurixs.png'),
(8,'Salonpas Patch','Salonpas','Pain relief patch for muscle aches and pains',7.50,'Pain Relief',200,'2028-03-25','salonpas.png'),
(9,'Eye Mo Regular','Eye Mo','Sterile eye drops for minor eye irritation relief',9.90,'Eye Care',15,'2026-09-15','eyemo.png'),
(10,'Tiger Balm Red','Tiger Balm','Traditional ointment for relief of muscle aches pain',6.80,'Traditional',120,'2029-01-01','tigerbalm.png'),
(11,'Difflam Lozenges Honey Lemon','Difflam','Anti-inflammatory lozenges for sore throat pain relief',13.50,'Throat',85,'2027-07-20','difflam.png'),
(12,'Scott Emulsion Orange','Scotts','Cod liver oil supplement rich in vitamins',28.00,'Vitamins',45,'2026-10-30','scotts.png'),
(13,'Zambuk Ointment','Zambuk','Herbal ointment for insect bites and minor cuts',5.50,'Skin Care',110,'2028-05-12','zambuk.png'),
(14,'Flavettes Vitamin C','Flavettes','Effervescent Vitamin C for immune system support daily',22.00,'Vitamins',130,'2027-04-18','flavettes.png'),
(15,'Bonjel Gel','Bonjel','Gel for relief of mouth ulcers and sores',11.00,'Oral Care',60,'2026-12-25','bonjel.png'),
(16,'Bisolvon Solution','Bisolvon','Bromhexine solution to clear chest congestion and cough',16.50,'Cough & Cold',55,'2027-02-14','bisolvon.png'),
(17,'Dettol Antiseptic Liquid','Dettol','Antiseptic liquid for first aid and personal hygiene',25.90,'First Aid',100,'2028-11-30','dettol.png'),
(18,'Betadine Wound Ointment','Betadine','Povidone iodine ointment for cuts and wound care',14.90,'First Aid',65,'2027-09-09','betadine.png'),
(19,'Woodwards Gripe Water','Woodwards','Relief for wind and griping pain in babies',19.50,'Baby Care',40,'2026-08-08','woodwards.png'),
(20,'Strepsils Original','Strepsils','Soothing lozenges for sore throat and mouth infection',8.50,'Throat',150,'2028-12-12','strepsils.png');
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_supplier`
--

DROP TABLE IF EXISTS `product_supplier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_supplier` (
  `prodID` int NOT NULL,
  `supID` int NOT NULL,
  PRIMARY KEY (`prodID`,`supID`),
  KEY `supID` (`supID`),
  CONSTRAINT `product_supplier_ibfk_1` FOREIGN KEY (`prodID`) REFERENCES `product` (`prodID`),
  CONSTRAINT `product_supplier_ibfk_2` FOREIGN KEY (`supID`) REFERENCES `supplier` (`supID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_supplier`
--

LOCK TABLES `product_supplier` WRITE;
/*!40000 ALTER TABLE `product_supplier` DISABLE KEYS */;
INSERT INTO `product_supplier` VALUES 
(2,1),(10,1),
(7,2),(14,2),
(3,3),(19,3),
(1,4),(5,4),(6,4),(9,4),(12,4),(15,4),(17,4),(20,4),
(4,5),(8,5),(11,5),(13,5),(16,5),(18,5);
/*!40000 ALTER TABLE `product_supplier` ENABLE KEYS */;
UNLOCK TABLES;

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
INSERT INTO `receipt` VALUES 
(1,'2025-12-20 01:30:00',41.40,'Delivered','Credit card','4111222233334444','15, Jalan Melati 3, Taman Mawar','43000','Selangor',1,1),
(2,'2025-12-21 06:15:00',20.00,'Delivered','Qr Duitnow',NULL,'88, Lorong Bintang, Georgetown','10200','Penang',2,2),
(3,'2025-12-22 02:00:00',32.00,'Delivered','Debit card','5555666677778888','12, Jalan Tun Sambanthan','50470','Kuala Lumpur',3,3),
(4,'2025-12-23 08:45:00',56.70,'Delivered','Credit card','4222333344445555','45, Persiaran Hijau','40000','Selangor',1,4),
(5,'2025-12-24 03:20:00',16.40,'Delivered','Tng ewallet',NULL,'No. 7, Jalan 14/22','46100','Selangor',2,5),
(6,'2025-12-24 05:00:00',107.50,'Delivered','Credit card','4555666677778888','23, Jalan Seremban','71000','Negeri Sembilan',3,6),
(7,'2025-12-24 10:30:00',21.00,'Delivered','Qr Duitnow',NULL,'B-12-5, Kondominium Indah','56000','Kuala Lumpur',1,7),
(8,'2025-12-25 00:45:00',29.50,'Delivered','Debit card','4666777788889999','Lot 55, Kampung Baru','50300','Kuala Lumpur',2,8),
(9,'2025-12-26 04:15:00',17.40,'Delivered','Tng ewallet',NULL,'5, Jalan Skudai','81300','Johor',3,9),
(10,'2025-12-27 07:00:00',60.50,'Delivered','Credit card','5111222233334444','101, Jalan Gurney','75000','Melaka',1,10),
(11,'2025-12-28 01:10:00',20.00,'Delivered','Qr Duitnow',NULL,'15, Jalan Melati 3','43000','Selangor',2,1),
(12,'2025-12-29 03:30:00',42.50,'Delivered','Credit card','4888999900001111','88, Lorong Bintang','10200','Penang',3,2),
(13,'2025-12-30 06:20:00',12.00,'Delivered','Tng ewallet',NULL,'12, Jalan Tun Sambanthan','50470','Kuala Lumpur',1,3),
(14,'2025-12-31 02:00:00',67.50,'Delivered','Credit card','4999000011112222','45, Persiaran Hijau','40000','Selangor',2,4),
(15,'2025-12-31 11:45:00',15.00,'Delivered','Qr Duitnow',NULL,'No. 7, Jalan 14/22','46100','Selangor',3,5),
(16,'2026-01-01 02:15:00',25.50,'Delivered','Debit card','5222333344445555','23, Jalan Seremban','71000','Negeri Sembilan',1,6),
(17,'2026-01-02 06:30:00',35.50,'Delivered','Credit card','4777888899990000','B-12-5, Kondominium Indah','56000','Kuala Lumpur',2,7),
(18,'2026-01-03 01:00:00',21.70,'Delivered','Tng ewallet',NULL,'Lot 55, Kampung Baru','50300','Kuala Lumpur',3,8),
(19,'2026-01-03 08:20:00',16.40,'Delivered','Qr Duitnow',NULL,'5, Jalan Skudai','81300','Johor',1,9),
(20,'2026-01-04 03:45:00',51.50,'Delivered','Credit card','5333444455556666','101, Jalan Gurney','75000','Melaka',2,10),
(21,'2026-01-05 05:00:00',20.00,'Delivered','Tng ewallet',NULL,'15, Jalan Melati 3','43000','Selangor',3,1),
(22,'2026-01-05 07:30:00',40.80,'Delivered','Debit card','4444555566667777','88, Lorong Bintang','10200','Penang',1,2),
(23,'2026-01-06 01:50:00',32.00,'Delivered','Credit card','5444555566667777','12, Jalan Tun Sambanthan','50470','Kuala Lumpur',2,3),
(24,'2026-01-06 04:10:00',42.50,'Delivered','Qr Duitnow',NULL,'45, Persiaran Hijau','40000','Selangor',3,4),
(25,'2026-01-07 09:00:00',13.00,'Delivered','Tng ewallet',NULL,'No. 7, Jalan 14/22','46100','Selangor',1,5),
(26,'2026-01-07 02:00:00',21.00,'Delivered','Qr Duitnow',NULL,'23, Jalan Seremban','71000','Negeri Sembilan',2,6),
(27,'2026-01-07 06:00:00',14.30,'Delivered','Qr Duitnow',NULL,'B-12-5, Kondominium Indah','56000','Kuala Lumpur',3,7),
(28,'2026-01-08 01:30:00',29.50,'Delivered','Debit card','4000111122223333','Lot 55, Kampung Baru','50300','Kuala Lumpur',1,8),
(29,'2026-01-08 08:45:00',17.40,'Delivered','Tng ewallet',NULL,'5, Jalan Skudai','81300','Johor',2,9),
(30,'2026-01-09 03:15:00',18.50,'Delivered','Tng ewallet',NULL,'101, Jalan Gurney','75000','Melaka',3,10),
(31,'2026-01-09 02:30:00',57.50,'Delivered','Credit card','4123412341234123','15, Jalan Melati 3','43000','Selangor',1,1),
(32,'2026-01-10 04:45:00',32.50,'Delivered','Debit card','5999888877776666','88, Lorong Bintang','10200','Penang',2,2),
(33,'2026-01-10 01:15:00',20.00,'Delivered','Qr Duitnow',NULL,'12, Jalan Tun Sambanthan','50470','Kuala Lumpur',3,3),
(34,'2026-01-11 07:00:00',16.40,'Delivered','Tng ewallet',NULL,'45, Persiaran Hijau','40000','Selangor',1,4),
(35,'2026-01-11 03:30:00',42.50,'Delivered','Credit card','4555444433332222','No. 7, Jalan 14/22','46100','Selangor',2,5),
(36,'2026-01-12 06:10:00',25.50,'Delayed','Debit card','5666777788889999','23, Jalan Seremban','71000','Negeri Sembilan',3,6),
(37,'2026-01-12 08:50:00',15.00,'Delayed','Qr Duitnow',NULL,'B-12-5, Kondominium Indah','56000','Kuala Lumpur',1,7),
(38,'2026-01-13 01:40:00',29.50,'In shipment','Credit card','4111999922228888','Lot 55, Kampung Baru','50300','Kuala Lumpur',2,8),
(39,'2026-01-13 05:20:00',12.00,'In shipment','Tng ewallet',NULL,'5, Jalan Skudai','81300','Johor',3,9),
(40,'2026-01-14 02:00:00',53.40,'In shipment','Debit card','5000400030002000','101, Jalan Gurney','75000','Melaka',1,10),
(41,'2026-01-14 07:30:00',55.90,'Delayed','Qr Duitnow',NULL,'15, Jalan Melati 3','43000','Selangor',2,1),
(42,'2026-01-14 01:00:00',65.60,'Delayed','Qr Duitnow',NULL,'88, Lorong Bintang','10200','Penang',3,2),
(43,'2026-01-15 03:45:00',31.70,'In shipment','Credit card','4222888833337777','12, Jalan Tun Sambanthan','50470','Kuala Lumpur',1,3),
(44,'2026-01-15 06:30:00',54.50,'New','Debit card','5111333355557777','45, Persiaran Hijau','40000','Selangor',NULL,4),
(45,'2026-01-15 09:15:00',50.40,'New','Tng ewallet',NULL,'No. 7, Jalan 14/22','46100','Selangor',NULL,5),
(46,'2026-01-15 10:00:00',62.40,'New','Qr Duitnow',NULL,'23, Jalan Seremban','71000','Negeri Sembilan',NULL,6),
(47,'2026-01-15 11:30:00',56.80,'New','Credit card','4999111188882222','B-12-5, Kondominium Indah','56000','Kuala Lumpur',NULL,7),
(48,'2026-01-15 12:00:00',45.00,'Delivered','Qr Duitnow',NULL,'Lot 55, Kampung Baru','50300','Kuala Lumpur',2,8),
(49,'2026-01-15 12:45:00',45.40,'Delivered','Debit card','5888222299993333','5, Jalan Skudai','81300','Johor',3,9),
(50,'2026-01-15 13:15:00',55.50,'Delivered','Tng ewallet',NULL,'101, Jalan Gurney','75000','Melaka',1,10),
(51,'2026-02-09 10:07:30',56.50,'New','E-Wallet',NULL,'101, Jalan Gurney','81300','Selangor',NULL,1),
(52,'2026-02-09 10:08:15',96.70,'New','Online Banking','1213141516','No. 7, Jalan 14/22','15000','Selangor',NULL,1);
/*!40000 ALTER TABLE `receipt` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `receipt_product`
--

DROP TABLE IF EXISTS `receipt_product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `receipt_product` (
  `recProdID` int NOT NULL AUTO_INCREMENT,
  `receiptID` int NOT NULL,
  `prodID` int NOT NULL,
  `qty` int NOT NULL,
  `price` decimal(10,2) NOT NULL,
  PRIMARY KEY (`recProdID`),
  KEY `receiptID` (`receiptID`),
  KEY `prodID` (`prodID`),
  CONSTRAINT `receipt_product_ibfk_1` FOREIGN KEY (`receiptID`) REFERENCES `receipt` (`receiptID`),
  CONSTRAINT `receipt_product_ibfk_2` FOREIGN KEY (`prodID`) REFERENCES `product` (`prodID`)
) ENGINE=InnoDB AUTO_INCREMENT=83 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `receipt_product`
--

LOCK TABLES `receipt_product` WRITE;
/*!40000 ALTER TABLE `receipt_product` DISABLE KEYS */;
INSERT INTO `receipt_product` VALUES 
(1,1,1,2,12.50),(2,1,2,1,8.90),(3,2,1,1,12.50),(4,3,3,1,24.50),(5,4,4,1,35.00),
(6,4,6,1,14.20),(7,5,2,1,8.90),(8,6,12,2,28.00),(9,6,14,2,22.00),(10,7,11,1,13.50),
(11,8,14,1,22.00),(12,9,9,1,9.90),(13,10,4,1,35.00),(14,10,7,1,18.00),(15,11,1,1,12.50),
(16,12,4,1,35.00),(17,13,5,1,4.50),(18,14,3,2,24.50),(19,14,15,1,11.00),(20,15,8,1,7.50),
(21,16,7,1,18.00),(22,17,12,1,28.00),(23,18,6,1,14.20),(24,19,2,1,8.90),(25,20,14,2,22.00),
(26,21,1,1,12.50),(27,22,11,1,13.50),(28,22,9,2,9.90),(29,23,3,1,24.50),(30,24,4,1,35.00),
(31,25,13,1,5.50),(32,26,11,1,13.50),(33,27,10,1,6.80),(34,28,14,1,22.00),(35,29,9,1,9.90),
(36,30,15,1,11.00),(37,31,12,1,28.00),(38,31,14,1,22.00),(39,32,1,2,12.50),(40,33,1,1,12.50),
(41,34,2,1,8.90),(42,35,4,1,35.00),(43,36,7,1,18.00),(44,37,8,1,7.50),(45,38,14,1,22.00),
(46,39,5,1,4.50),(47,40,1,1,12.50),(48,40,2,1,8.90),(49,40,3,1,24.50),(50,41,4,1,35.00),
(51,41,5,1,4.50),(52,41,2,1,8.90),(53,42,6,1,14.20),(54,42,7,1,18.00),(55,42,17,1,25.90),
(56,43,8,1,7.50),(57,43,9,1,9.90),(58,43,10,1,6.80),(59,44,11,1,13.50),(60,44,12,1,28.00),
(61,44,13,1,5.50),(62,45,14,1,22.00),(63,45,15,1,11.00),(64,45,9,1,9.90),(65,46,16,1,16.50),
(66,46,17,1,25.90),(67,46,1,1,12.50),(68,47,18,1,14.90),(69,47,19,1,19.50),(70,47,18,1,14.90),
(71,48,20,1,8.50),(72,48,1,1,12.50),(73,48,16,1,16.50),(74,49,2,1,8.90),(75,49,5,1,4.50),
(76,49,3,1,24.50),(77,50,4,1,35.00),(78,50,8,1,7.50),(79,50,13,1,5.50),(80,51,3,2,24.50),
(81,52,1,5,12.50),(82,52,2,3,8.90);
/*!40000 ALTER TABLE `receipt_product` ENABLE KEYS */;
UNLOCK TABLES;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
