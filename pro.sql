/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.5.26-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: pro
-- ------------------------------------------------------
-- Server version	10.5.26-MariaDB-0+deb11u2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `pro`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `pro` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;

USE `pro`;

--
-- Table structure for table `goods`
--

DROP TABLE IF EXISTS `goods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `goods` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT '物品名',
  `storage` int(11) NOT NULL COMMENT '仓库',
  `goodsType` int(11) NOT NULL COMMENT '分类',
  `count` int(11) DEFAULT NULL COMMENT '数量',
  `remark` varchar(1000) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `goods`
--

LOCK TABLES `goods` WRITE;
/*!40000 ALTER TABLE `goods` DISABLE KEYS */;
INSERT INTO `goods` VALUES (1,'Sonnet',1,3,2,'十四行诗'),(2,'阴阳师',3,2,8,'这里是应声虫的世界！'),(3,'史记',1,3,10,'史家之绝唱，无韵之《离骚》'),(4,'高等数学',2,4,100,'没有高数的大学是不完整的......'),(5,'碧蓝航线',3,2,7,'还得是咱小黄鸡'),(6,'无期迷途',3,2,99,'绝对的第九艺术！'),(7,'数据库！',2,4,50,'数据库何尝不是一种哲学'),(8,'Javaaaaaaa',2,4,50,'听说程序员都喜欢喝'),(9,'理想国',1,1,9,'我们一直寻找的，却是自己原本早已拥有的；我们总是东张西望，却唯独漏了自己想要的......'),(10,'荷马史诗',1,3,4,'希腊神系yyds'),(12,'11',1,3,100,'123456');
/*!40000 ALTER TABLE `goods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `goodsType`
--

DROP TABLE IF EXISTS `goodsType`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `goodsType` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT '分类名',
  `remark` varchar(1000) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `goodsType`
--

LOCK TABLES `goodsType` WRITE;
/*!40000 ALTER TABLE `goodsType` DISABLE KEYS */;
INSERT INTO `goodsType` VALUES (1,'哲学类','哲学类'),(2,'艺术类','万象皆为艺术'),(3,'文学类','底蕴'),(4,'抽象类','');
/*!40000 ALTER TABLE `goodsType` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `menu`
--

DROP TABLE IF EXISTS `menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `menu` (
  `id` int(11) NOT NULL,
  `menuCode` varchar(8) DEFAULT NULL COMMENT '菜单编码',
  `menuName` varchar(16) DEFAULT NULL COMMENT '菜单名字',
  `menuLevel` varchar(2) DEFAULT NULL COMMENT '菜单级别',
  `menuParentCode` varchar(8) DEFAULT NULL COMMENT '菜单的父code',
  `menuClick` varchar(16) DEFAULT NULL COMMENT '点击触发的函数',
  `menuRight` varchar(8) DEFAULT NULL COMMENT '权限 0超级管理员，1表示管理员，2表示普通用户，可以用逗号组合使用',
  `menuComponent` varchar(200) DEFAULT NULL,
  `menuIcon` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menu`
--

LOCK TABLES `menu` WRITE;
/*!40000 ALTER TABLE `menu` DISABLE KEYS */;
INSERT INTO `menu` VALUES (1,'001','管理员管理','1',NULL,'Admin','0','admin/AdminManage.vue','el-icon-s-custom'),(2,'002','用户管理','1',NULL,'User','0,1','user/UserManage.vue','el-icon-user-solid'),(3,'003','书库管理','1',NULL,'Storage','0,1','storage/StorageManage.vue','el-icon-office-building'),(4,'004','书籍分类','1',NULL,'Goodstype','0,1','goodstype/GoodstypeManage.vue','el-icon-menu'),(5,'005','书籍管理','1',NULL,'Goods','0,1,2','goods/GoodsManage.vue','el-icon-s-management');
/*!40000 ALTER TABLE `menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `storage`
--

DROP TABLE IF EXISTS `storage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `storage` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT '仓库名',
  `remark` varchar(1000) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `storage`
--

LOCK TABLES `storage` WRITE;
/*!40000 ALTER TABLE `storage` DISABLE KEYS */;
INSERT INTO `storage` VALUES (1,'Storage1','这是一个测试!!!!!!'),(2,'Storage2','这依然是一个测试！'),(3,'Storage3','这还是测试！');
/*!40000 ALTER TABLE `storage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `no` varchar(20) DEFAULT NULL COMMENT '帐号',
  `name` varchar(100) NOT NULL COMMENT '名字',
  `password` varchar(20) NOT NULL COMMENT '密码',
  `age` int(11) DEFAULT NULL,
  `sex` int(11) DEFAULT NULL COMMENT '性别',
  `phone` varchar(20) DEFAULT NULL COMMENT '电话',
  `role_id` varchar(4) DEFAULT NULL COMMENT '角色 0superadm,1adm,2normal',
  `isValid` varchar(4) DEFAULT 'Y' COMMENT '有效性',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'100001','Corona','123456',18,1,'12345678','0','Y'),(2,'100002','Shiranui','123456',18,0,'87654321','1','Y'),(3,'100003','Planck','123456',20,1,'11111111','1','Y'),(4,'100004','Lumi','123456',18,0,'22222222','1','Y'),(5,'100005','Shalom','123456',19,0,'33333333','1','Y'),(6,'100006','Warz','100006',18,0,'55555555','2','Y'),(7,'100007','Wangen','100007',18,1,'53535353','2','Y'),(8,'100008','Leef','100008',20,1,'66666666','2','Y'),(9,'100009','Raieqi','100009',20,1,'77777777','2','Y'),(12,'100012','Yerz','100012',18,1,'88888888','2','Y'),(13,'100016','Hamel','100016',20,0,'44444444','1','Y'),(15,'100014','Ber','100014',20,1,'56781234','2','Y'),(17,'100017','Saner','100017',18,1,'87655678','2','Y'),(18,'100018','Sonnet','100018',18,0,'14141414','2','Y'),(19,'100019','Lin','100019',19,0,'13572468','2','Y'),(20,'100020','Ahri','100020',18,0,'55555555','1','Y'),(22,'100022','管理员','100022',22,1,'74737271','1','Y'),(23,'100023','Mainstein','100023',80,1,'66663333','1','Y'),(24,'100024','L','100024',20,1,'77554433','2','Y'),(25,'100025','Amaterasu','100025',20,0,'88888888','1','Y'),(26,'100026','人','100026',20,1,'11882277','2','Y'),(27,'100027','还是人','100027',21,1,'22773366','2','Y'),(28,'100028','Xin','100028',20,0,'55228833','2','Y'),(29,'100030','11122','100030',21,0,'12121212','1','Y');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-12-02  7:27:16
