/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-11.6.2-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: pro
-- ------------------------------------------------------
-- Server version	11.6.2-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Table structure for table `goods`
--

DROP TABLE IF EXISTS `goods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `goods` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT '物品名',
  `storage` varchar(10) NOT NULL COMMENT '仓库',
  `goodsType` int(11) NOT NULL COMMENT '分类',
  `count` int(11) DEFAULT NULL COMMENT '数量',
  `remark` varchar(1000) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `goods`
--

LOCK TABLES `goods` WRITE;
/*!40000 ALTER TABLE `goods` DISABLE KEYS */;
INSERT INTO `goods` VALUES
(1,'商务修身白衬衫','1',1,880,NULL),
(2,'纯棉基础白T恤','1',2,1000,NULL),
(3,'运动速干短袖','1',6,200,NULL),
(4,'纯羊毛针织衫','1',3,2000,NULL),
(5,'男士经典牛仔裤','2',4,1000,NULL),
(7,'蕾丝连衣裙','3',5,1000,NULL),
(8,'运动休闲裤','2',4,1000,NULL),
(9,'工装裤','2',4,1000,NULL),
(10,'休闲西装','4',9,1000,NULL),
(11,'xx牌冲锋衣','1',7,1000,NULL),
(12,'丝质衬衫','1',1,500,NULL),
(13,'雪纺碎花裙','3',5,1000,NULL),
(14,'xx牌皮夹克','1',7,500,NULL),
(15,'篮球运动服','1',6,1000,NULL),
(16,'百褶裙','3',5,400,NULL),
(17,'职场包臀裙','3',5,1000,NULL);
/*!40000 ALTER TABLE `goods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `goodstype`
--

DROP TABLE IF EXISTS `goodstype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `goodstype` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT '分类名',
  `remark` varchar(1000) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `goodstype`
--

LOCK TABLES `goodstype` WRITE;
/*!40000 ALTER TABLE `goodstype` DISABLE KEYS */;
INSERT INTO `goodstype` VALUES
(1,'衬衫','商务衬衫、休闲衬衫、牛仔衬衫'),
(2,'T恤','基础款、印花、POLO衫等'),
(3,'毛衣','针织衫、羊毛衫、羊绒衫'),
(4,'裤装','牛仔裤、休闲裤、西裤、运动裤'),
(5,'裙装','半身裙、连衣裙、长裙、短裙'),
(6,'运动装','运动套装、速干衣、瑜伽服'),
(7,'外套','夹克、风衣、牛仔外套、西装外套'),
(8,'羽绒服','长款、短款、轻薄款羽绒服'),
(9,'礼服','晚礼服、婚纱、小礼服等特殊场合服装');
/*!40000 ALTER TABLE `goodstype` ENABLE KEYS */;
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
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menu`
--

LOCK TABLES `menu` WRITE;
/*!40000 ALTER TABLE `menu` DISABLE KEYS */;
INSERT INTO `menu` VALUES
(1,'001','管理员管理','1',NULL,'Admin','0','admin/AdminManage.vue','el-icon-s-custom'),
(2,'002','用户管理','1',NULL,'User','0,1','user/UserManage.vue','el-icon-user-solid'),
(3,'003','仓库管理','1',NULL,'Storage','0,1','storage/StorageManage.vue','el-icon-office-building'),
(4,'004','服装分类','1',NULL,'Goodstype','0,1','goodstype/GoodstypeManage.vue','el-icon-menu'),
(5,'005','服装管理','1',NULL,'Goods','0,1,2','goods/GoodsManage.vue','el-icon-s-management'),
(6,'006','出入库管理','1',NULL,'Operation','0.1.2','operation/OperationManage.vue','el-icon-s-order');
/*!40000 ALTER TABLE `menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `operation`
--

DROP TABLE IF EXISTS `operation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `operation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `no` varchar(255) NOT NULL COMMENT '订单号',
  `good` varchar(255) NOT NULL COMMENT '商品名',
  `count` int(11) NOT NULL COMMENT '更改的数量',
  `storage` int(11) NOT NULL COMMENT '仓库',
  `type` varchar(255) NOT NULL COMMENT '出库-1；入库-0',
  `goodstype` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `operation`
--

LOCK TABLES `operation` WRITE;
/*!40000 ALTER TABLE `operation` DISABLE KEYS */;
INSERT INTO `operation` VALUES
(1,'20250925090418925','商务修身白衬衫',1000,1,'0',1),
(2,'20250925090504081','纯棉基础白T恤',1000,1,'0',2),
(3,'20250925090724916','运动速干短袖',200,1,'0',6),
(4,'20250925091223096','纯羊毛针织衫',2000,1,'0',3),
(5,'20250925091306476','商务修身白衬衫',500,1,'1',1),
(6,'20250925091434099','商务修身白衬衫',500,1,'1',1),
(7,'20250925091532410','男士经典牛仔裤',1000,2,'0',4),
(8,'20250925092537753','蕾丝连衣裙',1000,3,'0',5),
(9,'20250925092828618','运动休闲裤',1000,2,'0',4),
(10,'20250925092828618','工装裤',1000,2,'0',4),
(11,'20250925092828618','休闲西装',1000,4,'0',9),
(12,'20250925092928370','xx牌冲锋衣',1000,1,'0',7),
(13,'20250925092928370','丝质衬衫',1000,1,'0',1),
(14,'20250925092928370','雪纺碎花裙',1000,3,'0',5),
(15,'20250925093053338','xx牌皮夹克',500,1,'0',7),
(16,'20250925093053338','篮球运动服',1000,1,'0',6),
(17,'20250925093136769','百褶裙',1000,3,'0',5),
(18,'20250925093228737','丝质衬衫',500,1,'1',1),
(19,'20250925093351328','职场包臀裙',1000,3,'0',5),
(20,'20250925093351328','百褶裙',600,3,'1',5),
(21,'20250925093351328','商务修身白衬衫',1000,1,'0',1),
(22,'20250925093351328','商务修身白衬衫',120,1,'1',1);
/*!40000 ALTER TABLE `operation` ENABLE KEYS */;
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
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `storage`
--

LOCK TABLES `storage` WRITE;
/*!40000 ALTER TABLE `storage` DISABLE KEYS */;
INSERT INTO `storage` VALUES
(1,'上身衣装仓库','存放各种上身衣物'),
(2,'下身衣装仓库','裤子等下身衣装'),
(3,'裙类衣装仓库',''),
(4,'礼服衣装仓库','西服等礼服');
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
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES
(1,'100001','Corona','123456',18,1,'12345678','0','Y'),
(2,'100002','Shiranui','123456',18,0,'87654321','1','Y'),
(3,'100003','Planck','123456',20,1,'11111111','1','Y'),
(4,'100004','Lumi','123456',18,0,'22222222','1','Y'),
(5,'100005','Shalom','123456',19,0,'33333333','1','Y'),
(6,'100006','Warz','100006',18,0,'55555555','2','Y'),
(7,'100007','Wangen','100007',18,1,'53535353','2','Y'),
(8,'100008','Leef','100008',20,1,'66666666','2','Y'),
(9,'100009','Raieqi','100009',20,1,'77777777','2','Y'),
(12,'100012','Yerz','100012',18,1,'88888888','2','Y'),
(13,'100016','Hamel','100016',20,0,'44444444','1','Y'),
(15,'100014','Ber','100014',20,1,'56781234','2','Y'),
(17,'100017','Saner','100017',18,1,'87655678','2','Y'),
(18,'100018','Sonnet','100018',18,0,'14141414','2','Y'),
(19,'100019','Lin','100019',19,0,'13572468','2','Y'),
(20,'100020','Ahri','100020',18,0,'55555555','1','Y'),
(23,'100023','Mainstein','100023',80,1,'66663333','1','Y'),
(24,'100024','L','100024',20,1,'77554433','2','Y'),
(25,'100025','Amaterasu','100025',20,0,'88888888','1','Y'),
(26,'100026','人','100026',20,1,'11882277','2','Y'),
(27,'100027','还是人','100027',21,1,'22773366','2','Y'),
(28,'100028','Xin','100028',20,0,'55228833','2','Y');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2025-09-25 10:22:02
