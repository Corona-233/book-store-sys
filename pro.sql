/*
 Navicat Premium Data Transfer

 Source Server         : wen
 Source Server Type    : MariaDB
 Source Server Version : 120002
 Source Host           : localhost:3306
 Source Schema         : pro

 Target Server Type    : MariaDB
 Target Server Version : 120002
 File Encoding         : 65001

 Date: 23/09/2025 09:21:19
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for goods
-- ----------------------------
DROP TABLE IF EXISTS `goods`;
CREATE TABLE `goods`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '物品名',
  `storage` int(11) NOT NULL COMMENT '仓库',
  `goodsType` int(11) NOT NULL COMMENT '分类',
  `count` int(11) DEFAULT NULL COMMENT '数量',
  `remark` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of goods
-- ----------------------------
INSERT INTO `goods` VALUES (1, '纯棉基础白T恤', 1, 1, 150, 'S/M/L/XL码，百搭基础款');
INSERT INTO `goods` VALUES (2, '商务修身白衬衫', 2, 2, 80, '38-44码，免烫面料');
INSERT INTO `goods` VALUES (3, '男士经典牛仔裤', 3, 3, 120, 'W28-W38，深蓝色水洗');
INSERT INTO `goods` VALUES (4, '女士高腰A字裙', 1, 4, 65, 'S/M/L码，黑色经典款');
INSERT INTO `goods` VALUES (5, '轻薄款羽绒服', 2, 5, 45, '冬季主打款，90%白鸭绒');
INSERT INTO `goods` VALUES (6, '运动速干短袖', 3, 6, 200, '透气快干，多颜色可选');
INSERT INTO `goods` VALUES (7, '纯羊毛针织衫', 1, 7, 55, '100%羊毛，秋冬新品');
INSERT INTO `goods` VALUES (8, '蕾丝连衣裙', 2, 4, 30, '均码，宴会礼服款');
INSERT INTO `goods` VALUES (9, '儿童连帽卫衣', 3, 8, 90, '110-150码，卡通印花');
INSERT INTO `goods` VALUES (10, '男士内裤3条装', 1, 9, 300, '纯棉，L/XL码');
INSERT INTO `goods` VALUES (11, '防风雨外套', 2, 5, 75, '户外运动，防风防水');
INSERT INTO `goods` VALUES (12, '西装裤', 3, 3, 60, '商务正装，深灰色');

-- ----------------------------
-- Table structure for goodstype
-- ----------------------------
DROP TABLE IF EXISTS `goodstype`;
CREATE TABLE `goodstype`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '分类名',
  `remark` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of goodstype
-- ----------------------------
INSERT INTO `goodstype` VALUES (1, 'T恤', '基础款、印花、POLO衫等');
INSERT INTO `goodstype` VALUES (2, '衬衫', '商务衬衫、休闲衬衫、牛仔衬衫');
INSERT INTO `goodstype` VALUES (3, '毛衣', '针织衫、羊毛衫、羊绒衫');
INSERT INTO `goodstype` VALUES (4, '外套', '夹克、风衣、牛仔外套、西装外套');
INSERT INTO `goodstype` VALUES (5, '羽绒服', '长款、短款、轻薄款羽绒服');
INSERT INTO `goodstype` VALUES (6, '裤装', '牛仔裤、休闲裤、西裤、运动裤');
INSERT INTO `goodstype` VALUES (7, '裙装', '半身裙、连衣裙、长裙、短裙');
INSERT INTO `goodstype` VALUES (8, '内衣', '文胸、内裤、背心、家居服');
INSERT INTO `goodstype` VALUES (9, '运动装', '运动套装、速干衣、瑜伽服');
INSERT INTO `goodstype` VALUES (10, '礼服', '晚礼服、婚纱、小礼服等特殊场合服装');

-- ----------------------------
-- Table structure for menu
-- ----------------------------
DROP TABLE IF EXISTS `menu`;
CREATE TABLE `menu`  (
  `id` int(11) NOT NULL,
  `menuCode` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '菜单编码',
  `menuName` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '菜单名字',
  `menuLevel` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '菜单级别',
  `menuParentCode` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '菜单的父code',
  `menuClick` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '点击触发的函数',
  `menuRight` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '权限 0超级管理员，1表示管理员，2表示普通用户，可以用逗号组合使用',
  `menuComponent` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `menuIcon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of menu
-- ----------------------------
INSERT INTO `menu` VALUES (1, '001', '管理员管理', '1', NULL, 'Admin', '0', 'admin/AdminManage.vue', 'el-icon-s-custom');
INSERT INTO `menu` VALUES (2, '002', '用户管理', '1', NULL, 'User', '0,1', 'user/UserManage.vue', 'el-icon-user-solid');
INSERT INTO `menu` VALUES (3, '003', '仓库管理', '1', NULL, 'Storage', '0,1', 'storage/StorageManage.vue', 'el-icon-office-building');
INSERT INTO `menu` VALUES (4, '004', '服装分类', '1', NULL, 'Goodstype', '0,1', 'goodstype/GoodstypeManage.vue', 'el-icon-menu');
INSERT INTO `menu` VALUES (5, '005', '服装管理', '1', NULL, 'Goods', '0,1,2', 'goods/GoodsManage.vue', 'el-icon-s-management');
INSERT INTO `menu` VALUES (6, '006', '出入库管理', '1', NULL, 'Operation', '0.1.2', 'operation/OperationManage.vue', 'el-icon-s-order');

-- ----------------------------
-- Table structure for operation
-- ----------------------------
DROP TABLE IF EXISTS `operation`;
CREATE TABLE `operation`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NOT NULL COMMENT '订单号',
  `good` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NOT NULL COMMENT '商品名',
  `count` int(11) NOT NULL COMMENT '更改的数量',
  `storage` int(11) NOT NULL COMMENT '仓库',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci NOT NULL COMMENT '出库-1；入库-0',
  `goodstype` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_uca1400_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for storage
-- ----------------------------
DROP TABLE IF EXISTS `storage`;
CREATE TABLE `storage`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '仓库名',
  `remark` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of storage
-- ----------------------------
INSERT INTO `storage` VALUES (1, '天津仓库', '在天津的仓库');
INSERT INTO `storage` VALUES (2, '青岛仓库', '在青岛的仓库');
INSERT INTO `storage` VALUES (3, '济宁仓库', '在济宁的仓库');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '帐号',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名字',
  `password` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '密码',
  `age` int(11) DEFAULT NULL,
  `sex` int(11) DEFAULT NULL COMMENT '性别',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '电话',
  `role_id` varchar(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '角色 0superadm,1adm,2normal',
  `isValid` varchar(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'Y' COMMENT '有效性',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 30 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, '100001', 'Corona', '123456', 18, 1, '12345678', '0', 'Y');
INSERT INTO `user` VALUES (2, '100002', 'Shiranui', '123456', 18, 0, '87654321', '1', 'Y');
INSERT INTO `user` VALUES (3, '100003', 'Planck', '123456', 20, 1, '11111111', '1', 'Y');
INSERT INTO `user` VALUES (4, '100004', 'Lumi', '123456', 18, 0, '22222222', '1', 'Y');
INSERT INTO `user` VALUES (5, '100005', 'Shalom', '123456', 19, 0, '33333333', '1', 'Y');
INSERT INTO `user` VALUES (6, '100006', 'Warz', '100006', 18, 0, '55555555', '2', 'Y');
INSERT INTO `user` VALUES (7, '100007', 'Wangen', '100007', 18, 1, '53535353', '2', 'Y');
INSERT INTO `user` VALUES (8, '100008', 'Leef', '100008', 20, 1, '66666666', '2', 'Y');
INSERT INTO `user` VALUES (9, '100009', 'Raieqi', '100009', 20, 1, '77777777', '2', 'Y');
INSERT INTO `user` VALUES (12, '100012', 'Yerz', '100012', 18, 1, '88888888', '2', 'Y');
INSERT INTO `user` VALUES (13, '100016', 'Hamel', '100016', 20, 0, '44444444', '1', 'Y');
INSERT INTO `user` VALUES (15, '100014', 'Ber', '100014', 20, 1, '56781234', '2', 'Y');
INSERT INTO `user` VALUES (17, '100017', 'Saner', '100017', 18, 1, '87655678', '2', 'Y');
INSERT INTO `user` VALUES (18, '100018', 'Sonnet', '100018', 18, 0, '14141414', '2', 'Y');
INSERT INTO `user` VALUES (19, '100019', 'Lin', '100019', 19, 0, '13572468', '2', 'Y');
INSERT INTO `user` VALUES (20, '100020', 'Ahri', '100020', 18, 0, '55555555', '1', 'Y');
INSERT INTO `user` VALUES (22, '100022', '管理员', '100022', 22, 1, '74737271', '1', 'Y');
INSERT INTO `user` VALUES (23, '100023', 'Mainstein', '100023', 80, 1, '66663333', '1', 'Y');
INSERT INTO `user` VALUES (24, '100024', 'L', '100024', 20, 1, '77554433', '2', 'Y');
INSERT INTO `user` VALUES (25, '100025', 'Amaterasu', '100025', 20, 0, '88888888', '1', 'Y');
INSERT INTO `user` VALUES (26, '100026', '人', '100026', 20, 1, '11882277', '2', 'Y');
INSERT INTO `user` VALUES (27, '100027', '还是人', '100027', 21, 1, '22773366', '2', 'Y');
INSERT INTO `user` VALUES (28, '100028', 'Xin', '100028', 20, 0, '55228833', '2', 'Y');
INSERT INTO `user` VALUES (29, '100030', '11122', '100030', 21, 0, '12121212', '1', 'Y');

SET FOREIGN_KEY_CHECKS = 1;
