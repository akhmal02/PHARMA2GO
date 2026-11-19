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
INSERT INTO `product` VALUES (1,'Panadol Actifast','Panadol','Fast acting pain relief caplets for headache fever',12.50,'Pain Relief',95,'2027-12-31','panadol.png'),(2,'Minyak Cap Kapak','Axe Brand','Medicated oil for relief of headaches and cold',8.90,'Traditional',47,'2028-06-30','capkapak.png'),(3,'Ubat Batuk Cap Ibu dan Anak','Nin Jiom','Natural herbal cough syrup for sore throat relief',24.50,'Cough & Cold',78,'2027-05-15','ninjiom.png'),(4,'Gaviscon Double Action','Gaviscon','Double action liquid sachet for heartburn and indigestion',35.00,'Digestive',60,'2026-11-20','gaviscon.png'),(5,'Eno Fruit Salt Lemon','Eno','Effervescent powder for fast relief of stomach indigestion',4.50,'Digestive',4,'2028-01-15','eno.png'),(6,'Vicks VapoRub','Vicks','Menthol rub for relief of cold and congestion',14.20,'Cough & Cold',70,'2027-08-10','vicks.png'),(7,'Hurixs 600 Flu Cough','Hurixs','Traditional herbal formula for flu and cough relief',18.00,'Traditional',90,'2026-12-05','hurixs.png'),(8,'Salonpas Patch','Salonpas','Pain relief patch for muscle aches and pains',7.50,'Pain Relief',200,'2028-03-25','salonpas.png'),(9,'Eye Mo Regular','Eye Mo','Sterile eye drops for minor eye irritation relief',9.90,'Eye Care',15,'2026-09-15','eyemo.png'),(10,'Tiger Balm Red','Tiger Balm','Traditional ointment for relief of muscle aches pain',6.80,'Traditional',120,'2029-01-01','tigerbalm.png'),(11,'Difflam Lozenges Honey Lemon','Difflam','Anti-inflammatory lozenges for sore throat pain relief',13.50,'Throat',85,'2027-07-20','difflam.png'),(12,'Scott Emulsion Orange','Scotts','Cod liver oil supplement rich in vitamins',28.00,'Vitamins',45,'2026-10-30','scotts.png'),(13,'Zambuk Ointment','Zambuk','Herbal ointment for insect bites and minor cuts',5.50,'Skin Care',110,'2028-05-12','zambuk.png'),(14,'Flavettes Vitamin C','Flavettes','Effervescent Vitamin C for immune system support daily',22.00,'Vitamins',130,'2027-04-18','flavettes.png'),(15,'Bonjel Gel','Bonjel','Gel for relief of mouth ulcers and sores',11.00,'Oral Care',60,'2026-12-25','bonjel.png'),(16,'Bisolvon Solution','Bisolvon','Bromhexine solution to clear chest congestion and cough',16.50,'Cough & Cold',55,'2027-02-14','bisolvon.png'),(17,'Dettol Antiseptic Liquid','Dettol','Antiseptic liquid for first aid and personal hygiene',25.90,'First Aid',100,'2028-11-30','dettol.png'),(18,'Betadine Wound Ointment','Betadine','Povidone iodine ointment for cuts and wound care',14.90,'First Aid',65,'2027-09-09','betadine.png'),(19,'Woodwards Gripe Water','Woodwards','Relief for wind and griping pain in babies',19.50,'Baby Care',40,'2026-08-08','woodwards.png'),(20,'Strepsils Original','Strepsils','Soothing lozenges for sore throat and mouth infection',8.50,'Throat',150,'2028-12-12','strepsils.png');
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
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
