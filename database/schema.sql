# ************************************************************
# Sequel Ace SQL dump
# Version 20083
#
# https://sequel-ace.com/
# https://github.com/Sequel-Ace/Sequel-Ace
#
# Host: 127.0.0.1 (MySQL 8.0.19)
# Database: assetgear
# Generation Time: 2025-02-20 05:34:02 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
SET NAMES utf8mb4;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE='NO_AUTO_VALUE_ON_ZERO', SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table asset
# ------------------------------------------------------------

DROP TABLE IF EXISTS `asset`;

CREATE TABLE `asset` (
  `AssetId` int unsigned NOT NULL AUTO_INCREMENT,
  `Description` text NOT NULL,
  `A` int DEFAULT NULL,
  `AssetCategoryId` int unsigned DEFAULT NULL,
  `ReadingTypeId` tinyint unsigned DEFAULT NULL,
  `ParentAssetId` int unsigned DEFAULT NULL,
  `ItemIds` text,
  `ModelNumber` varchar(255) DEFAULT NULL,
  `SerialNumber` varchar(255) DEFAULT NULL,
  `quantity` int unsigned DEFAULT '0',
  `Maker` varchar(255) DEFAULT NULL,
  `Model` varchar(255) DEFAULT NULL,
  `Class` varchar(255) DEFAULT NULL,
  `Ownership` varchar(255) DEFAULT NULL,
  `DepartmentIds` varchar(255) DEFAULT NULL,
  `Status` varchar(255) DEFAULT 'Online',
  `Note` text,
  `OfficeLocationId` tinytext,
  `CreatedById` tinytext,
  `TagLabel` varchar(255) DEFAULT NULL,
  `Comment` varchar(255) DEFAULT NULL,
  `WorkingForId` tinyint DEFAULT '1',
  `LocationCategoryId` tinyint DEFAULT NULL,
  PRIMARY KEY (`AssetId`),
  KEY `AssetCategoryId` (`AssetCategoryId`),
  KEY `ReadingTypeId` (`ReadingTypeId`),
  KEY `ParentAssetId` (`ParentAssetId`),
  CONSTRAINT `asset_ibfk_1` FOREIGN KEY (`AssetCategoryId`) REFERENCES `asset_category` (`AssetCategoryId`),
  CONSTRAINT `asset_ibfk_2` FOREIGN KEY (`ReadingTypeId`) REFERENCES `reading_type` (`ReadingTypeId`),
  CONSTRAINT `asset_ibfk_3` FOREIGN KEY (`ParentAssetId`) REFERENCES `asset` (`AssetId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table asset_category
# ------------------------------------------------------------

DROP TABLE IF EXISTS `asset_category`;

CREATE TABLE `asset_category` (
  `AssetCategoryId` int unsigned NOT NULL AUTO_INCREMENT,
  `ParentAssetCategoryId` int unsigned DEFAULT '0',
  `Name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`AssetCategoryId`),
  KEY `ParentAssetCategoryId` (`ParentAssetCategoryId`),
  CONSTRAINT `asset_category_ibfk_1` FOREIGN KEY (`ParentAssetCategoryId`) REFERENCES `asset_category` (`AssetCategoryId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `asset_category` WRITE;
/*!40000 ALTER TABLE `asset_category` DISABLE KEYS */;

INSERT INTO `asset_category` (`AssetCategoryId`, `ParentAssetCategoryId`, `Name`)
VALUES
	(1,14,'MESS'),
	(2,1,'Furnitures & Equipments'),
	(3,14,'Lighting System'),
	(4,14,'Air Conditioning System'),
	(5,14,'Office Building'),
	(6,14,'Housing Accommodation'),
	(7,13,'Pipeline'),
	(8,13,'Oily Water Treatment'),
	(9,13,'Flare, Vent & Blow down System'),
	(10,14,'Office Furnitures '),
	(11,13,'Chemical Injection System'),
	(12,14,'Power Generation & Distribution'),
	(13,NULL,'Production'),
	(14,NULL,'Land & Building'),
	(15,62,'Vehicle'),
	(16,17,'Drilling & completion risers'),
	(17,NULL,'Drilling'),
	(18,NULL,'Safety & Facility System'),
	(19,18,'Fire & Gas detector'),
	(21,6,'Furniture & Equipment'),
	(22,17,'Riser compensator'),
	(23,17,'String motion compensator'),
	(24,17,'Choke manifold'),
	(25,17,'Diverter'),
	(26,17,'Mud treatment equipment'),
	(27,17,'Mud pumps'),
	(28,17,'Drawworks'),
	(29,17,'Top Drive'),
	(30,17,'Blowout preventer'),
	(36,NULL,'Utilities'),
	(37,17,'Cementing equipment'),
	(38,17,'Crown & travelling blocks'),
	(39,18,'Input devices'),
	(40,18,'Evacuation equipment'),
	(41,18,'Heating & Ventilation (HVAC) System'),
	(42,18,'Shut down System'),
	(43,18,'Noise Monitor'),
	(44,18,'Fire fighting equipment'),
	(45,18,'Fire pump assembly '),
	(46,18,'Emergency power system'),
	(47,18,'Emergency warning system'),
	(48,18,'Emergency lighting system'),
	(49,18,'Compressed air breathing apparatus'),
	(50,36,'Power Plant'),
	(51,50,'Torque Converter Assembly'),
	(52,50,'Mechanical power compounding system'),
	(53,50,'Motor Control System'),
	(54,50,'Electrical Power Distribution System'),
	(55,36,'Utilities System'),
	(56,50,'Electrical Power Conversion System'),
	(57,36,'Air Production/Treatment/Storage'),
	(58,36,'Data processing/Communications'),
	(59,13,'Manifolds'),
	(60,13,'Intervention tools'),
	(62,NULL,'Transport'),
	(63,13,'Well Related System'),
	(74,13,'Pumps');

/*!40000 ALTER TABLE `asset_category` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table asset_downtime
# ------------------------------------------------------------

DROP TABLE IF EXISTS `asset_downtime`;

CREATE TABLE `asset_downtime` (
  `DowntimeId` int NOT NULL AUTO_INCREMENT,
  `AssetLocationId` int DEFAULT NULL,
  `DownTimeCause` varchar(255) DEFAULT NULL,
  `StartPeriod` datetime DEFAULT NULL,
  `EndPeriod` datetime DEFAULT NULL,
  `TotalTime` decimal(6,2) DEFAULT NULL,
  `CreatedById` int DEFAULT NULL,
  `CloseById` int DEFAULT NULL,
  `CreatedDate` datetime DEFAULT NULL,
  `Remark` varchar(255) DEFAULT NULL,
  `DepartmentId` int DEFAULT NULL,
  `OfficeLocationId` int DEFAULT NULL,
  `FailureReportId` int DEFAULT NULL,
  `Status` varchar(7) DEFAULT 'Open',
  `WorkingForId` tinyint DEFAULT NULL,
  PRIMARY KEY (`DowntimeId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table asset_failure_report
# ------------------------------------------------------------

DROP TABLE IF EXISTS `asset_failure_report`;

CREATE TABLE `asset_failure_report` (
  `AssetFailureReportId` int unsigned NOT NULL AUTO_INCREMENT,
  `ReportTitle` varchar(255) DEFAULT NULL,
  `WorkOrderId` int unsigned DEFAULT NULL,
  `AssetLocationId` int unsigned DEFAULT NULL,
  `CreatedByUserId` int unsigned DEFAULT NULL,
  `SupervisorUserId` int unsigned DEFAULT NULL,
  `OfficeLocationId` int DEFAULT NULL,
  `Date` datetime NOT NULL,
  `RootCause` varchar(200) NOT NULL DEFAULT '',
  `ActionTaken` text,
  `FaultDiscovery` varchar(200) DEFAULT NULL,
  `PreventiveMeasure` varchar(200) DEFAULT NULL,
  `DownTimePeriod` varchar(200) DEFAULT NULL,
  `SupervisorComment` text,
  `WorkDone` varchar(255) DEFAULT NULL,
  `Status` varchar(12) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT 'Open',
  `SuspectedCause` text,
  `RiskLevel` char(6) DEFAULT NULL COMMENT 'High or Medium or Low',
  `Serviceprovider` varchar(255) DEFAULT NULL,
  `ServiceDescription` varchar(255) DEFAULT NULL,
  `FailureOn` varchar(100) DEFAULT NULL,
  `DescriptionOfSuspectedCause` varchar(255) DEFAULT NULL,
  `InitiatorsComment` text,
  `OtherCauses` text,
  `OtherPreventiveMeasure` text,
  `OtherActionTaken` text,
  `Recommendation` text,
  `Effect` varchar(255) DEFAULT NULL,
  `OtherRootCause` text,
  `ResolvedDate` datetime DEFAULT NULL,
  `ReasonForDelay` text,
  `DepartmentId` int DEFAULT NULL,
  `DownTimeCosting` varchar(200) DEFAULT NULL,
  `CreatedDate` datetime DEFAULT NULL,
  `ResolveTimeLine` varchar(80) DEFAULT NULL,
  `ResolveStartTime` datetime DEFAULT NULL,
  PRIMARY KEY (`AssetFailureReportId`),
  KEY `AssetLocationId` (`AssetLocationId`),
  KEY `CreatedByUserId` (`CreatedByUserId`),
  KEY `SupervisorUserId` (`SupervisorUserId`),
  KEY `WorkOrderId` (`WorkOrderId`),
  CONSTRAINT `asset_failure_report_ibfk_1` FOREIGN KEY (`AssetLocationId`) REFERENCES `asset_location` (`AssetLocationId`),
  CONSTRAINT `asset_failure_report_ibfk_2` FOREIGN KEY (`CreatedByUserId`) REFERENCES `core_user` (`UserId`),
  CONSTRAINT `asset_failure_report_ibfk_3` FOREIGN KEY (`SupervisorUserId`) REFERENCES `core_user` (`UserId`),
  CONSTRAINT `asset_failure_report_ibfk_4` FOREIGN KEY (`WorkOrderId`) REFERENCES `work_order` (`WorkOrderId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table asset_location
# ------------------------------------------------------------

DROP TABLE IF EXISTS `asset_location`;

CREATE TABLE `asset_location` (
  `AssetLocationId` int unsigned NOT NULL AUTO_INCREMENT,
  `LocationId` int unsigned DEFAULT NULL,
  `AssetId` int unsigned DEFAULT NULL,
  `LocDescription` varchar(255) DEFAULT '',
  `Quantity` int unsigned DEFAULT '1',
  `Status` varchar(255) DEFAULT 'Online',
  PRIMARY KEY (`AssetLocationId`),
  KEY `AssetId` (`AssetId`),
  KEY `LocationId` (`LocationId`),
  CONSTRAINT `asset_location_ibfk_1` FOREIGN KEY (`AssetId`) REFERENCES `asset` (`AssetId`) ON DELETE CASCADE,
  CONSTRAINT `asset_location_ibfk_2` FOREIGN KEY (`LocationId`) REFERENCES `location` (`LocationId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table asset_location_category
# ------------------------------------------------------------

DROP TABLE IF EXISTS `asset_location_category`;

CREATE TABLE `asset_location_category` (
  `LocationCategoryId` int NOT NULL AUTO_INCREMENT,
  `LocationName` varchar(100) DEFAULT NULL,
  `Description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`LocationCategoryId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table contract
# ------------------------------------------------------------

DROP TABLE IF EXISTS `contract`;

CREATE TABLE `contract` (
  `ContractId` int unsigned NOT NULL AUTO_INCREMENT,
  `WorkOrderId` int unsigned NOT NULL,
  `Contractor` varchar(255) DEFAULT NULL,
  `Description` text NOT NULL,
  `Currency` char(3) NOT NULL DEFAULT 'NGN',
  `Cost` decimal(20,2) unsigned NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`ContractId`),
  KEY `WorkOrderId` (`WorkOrderId`),
  CONSTRAINT `contract_ibfk_1` FOREIGN KEY (`WorkOrderId`) REFERENCES `work_order` (`WorkOrderId`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table core_comment
# ------------------------------------------------------------

DROP TABLE IF EXISTS `core_comment`;

CREATE TABLE `core_comment` (
  `CommentId` int NOT NULL AUTO_INCREMENT,
  `PK` int DEFAULT NULL,
  `Table` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `Comments` text CHARACTER SET latin1 COLLATE latin1_swedish_ci,
  `CommentByUserId` int DEFAULT NULL,
  PRIMARY KEY (`CommentId`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;



# Dump of table core_company
# ------------------------------------------------------------

DROP TABLE IF EXISTS `core_company`;

CREATE TABLE `core_company` (
  `CompanyId` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) DEFAULT NULL,
  `Description` varchar(255) DEFAULT NULL,
  `Address` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`CompanyId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `core_company` WRITE;
/*!40000 ALTER TABLE `core_company` DISABLE KEYS */;

INSERT INTO `core_company` (`CompanyId`, `Name`, `Description`, `Address`)
VALUES
	(2,'Officelime','Officelime Software','Lagos');

/*!40000 ALTER TABLE `core_company` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table core_delegate_role
# ------------------------------------------------------------

DROP TABLE IF EXISTS `core_delegate_role`;

CREATE TABLE `core_delegate_role` (
  `DelegateRoleId` int NOT NULL AUTO_INCREMENT,
  `Role` char(3) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `ByUserId` mediumint NOT NULL,
  `ToUserId` mediumint NOT NULL,
  `Start` date NOT NULL,
  `End` date NOT NULL,
  PRIMARY KEY (`DelegateRoleId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table core_department
# ------------------------------------------------------------

DROP TABLE IF EXISTS `core_department`;

CREATE TABLE `core_department` (
  `DepartmentId` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) DEFAULT NULL,
  `Email` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`DepartmentId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `core_department` WRITE;
/*!40000 ALTER TABLE `core_department` DISABLE KEYS */;

INSERT INTO `core_department` (`DepartmentId`, `Name`, `Email`)
VALUES
	(1,'IT',NULL),
	(2,'Account',NULL),
	(3,'HSE',''),
	(5,'Catering',NULL),
	(7,'Production',''),
	(8,'Material / Logistics',''),
	(13,'Security',NULL),
	(14,'Drilling',NULL),
	(15,'Operations',''),
	(16,'Maintenance',''),
	(17,'Admin',NULL);

/*!40000 ALTER TABLE `core_department` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table core_log
# ------------------------------------------------------------

DROP TABLE IF EXISTS `core_log`;

CREATE TABLE `core_log` (
  `UserId` smallint DEFAULT NULL,
  `URL` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `Type` enum('I','E','P') CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT 'I',
  `Title` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `IP` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `Browser` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `Description` text CHARACTER SET latin1 COLLATE latin1_swedish_ci,
  `TimeCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=ARCHIVE DEFAULT CHARSET=utf8;



# Dump of table core_login
# ------------------------------------------------------------

DROP TABLE IF EXISTS `core_login`;

CREATE TABLE `core_login` (
  `LoginId` int unsigned NOT NULL AUTO_INCREMENT,
  `UserId` int unsigned NOT NULL,
  `Role` enum('AD','UR','HT','SP','WH','FS','MS','SV','HSE','PS') NOT NULL DEFAULT 'UR',
  `PasswordKey` varchar(255) DEFAULT NULL,
  `PINKey` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`LoginId`),
  UNIQUE KEY `EmployeeId` (`UserId`),
  CONSTRAINT `core_login_ibfk_1` FOREIGN KEY (`UserId`) REFERENCES `core_user` (`UserId`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `core_login` WRITE;
/*!40000 ALTER TABLE `core_login` DISABLE KEYS */;

INSERT INTO `core_login` (`LoginId`, `UserId`, `Role`, `PasswordKey`, `PINKey`)
VALUES
	(1,1,'HT','8BB746928B672D39F687AE33E2C6364C41A0BEA6556E28D78EECF5BAE4006273A11906ECD3F604F8CC8414DF1FF6B12A699D361B1036296C588026FA8CBF77BD','E4162A58C430B2BBB44EB169B75D037174814D262BFEE94356C9FA6CEC5064F3726B4597BAB2870E4268E1D09D8D6E3F5D7E7B98F73A61B595999681F0910CF1');

/*!40000 ALTER TABLE `core_login` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table core_module
# ------------------------------------------------------------

DROP TABLE IF EXISTS `core_module`;

CREATE TABLE `core_module` (
  `ModuleId` int unsigned NOT NULL AUTO_INCREMENT,
  `Code` varchar(255) NOT NULL DEFAULT '',
  `Position` tinyint DEFAULT NULL,
  `Title` varchar(255) DEFAULT NULL,
  `Description` varchar(255) DEFAULT NULL,
  `URL` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ModuleId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `core_module` WRITE;
/*!40000 ALTER TABLE `core_module` DISABLE KEYS */;

INSERT INTO `core_module` (`ModuleId`, `Code`, `Position`, `Title`, `Description`, `URL`)
VALUES
	(2,'__ptw',3,'Permit To Work','Permit to work','modules/ptw.cfm'),
	(9,'__dev',6,'Developer','Manage the modules, Pages, Roles & Privileges','modules/dev.cfm'),
	(10,'__maintenance',2,'Operations','Maintenance System','modules/maintenance.cfm'),
	(11,'__warehouse',4,'Warehouse','Warehousing, Inventory','modules/warehouse.cfm'),
	(13,'__settings',5,'Settings','AMS setup & settings','modules/settings.cfm'),
	(14,'__help',7,'Help','Help about this application','modules/help.cfm'),
	(15,'__hse',5,'HSE','HSE module','modules/hse.cfm');

/*!40000 ALTER TABLE `core_module` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table core_notice
# ------------------------------------------------------------

DROP TABLE IF EXISTS `core_notice`;

CREATE TABLE `core_notice` (
  `NoticeId` int NOT NULL AUTO_INCREMENT,
  `SenderId` smallint DEFAULT NULL,
  `RecipientDepartmentId` tinyint NOT NULL DEFAULT '0',
  `RecipientUnitId` tinyint DEFAULT '0',
  `RecipientId` smallint DEFAULT NULL,
  `Role` char(3) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `PK` int DEFAULT NULL,
  `Module` varchar(10) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `Message` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `Status` char(1) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'o' COMMENT 'o,c',
  `Date` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`NoticeId`),
  KEY `SenderId` (`SenderId`),
  KEY `RecipientId` (`RecipientId`),
  KEY `PK` (`PK`),
  KEY `RecipientDepartmentId` (`RecipientDepartmentId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table core_page
# ------------------------------------------------------------

DROP TABLE IF EXISTS `core_page`;

CREATE TABLE `core_page` (
  `PageId` int unsigned NOT NULL AUTO_INCREMENT,
  `ModuleId` int unsigned NOT NULL,
  `Code` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `Position` tinyint DEFAULT NULL,
  `Title` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `Description` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `URL` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `IsTab` char(1) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'y',
  PRIMARY KEY (`PageId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `core_page` WRITE;
/*!40000 ALTER TABLE `core_page` DISABLE KEYS */;

INSERT INTO `core_page` (`PageId`, `ModuleId`, `Code`, `Position`, `Title`, `Description`, `URL`, `IsTab`)
VALUES
	(3,9,'__mod',NULL,'Modules','','modules/developer/module.cfm','y'),
	(4,9,'__page',NULL,'Pages','','modules/developer/page.cfm','y'),
	(5,9,'__role',3,'Roles & Privileges','','modules/developer/role.cfm','n'),
	(8,21,'__po',2,'P/W Order','Purchase/Work Order','modules/purchasing/po.cfm','y'),
	(9,10,'__workorder',1,'Work Order','Work Order','modules/maintenance/workorder.cfm','y'),
	(11,10,'__asset',2,'Assets','Equipments','modules/maintenance/asset.cfm','y'),
	(12,10,'__sparepart',3,'Spare Parts','Spare/Service Parts','modules/maintenance/spare_part.cfm','y'),
	(13,10,'__pm_task',6,'PM Task','Preventive maintenance Task','modules/maintenance/pm_task.cfm','y'),
	(14,13,'__users',1,'Users','Users/Employees','modules/settings/users.cfm','y'),
	(16,13,'__maintenance_setting',3,'Maintenance','Maintenance Settings','modules/settings/maintenance.cfm','y'),
	(17,13,'__warehouse_setting',4,'Warehouse','Warehouse Settings','modules/settings/warehouse.cfm','y'),
	(18,14,'__ams_help',1,'AMS Help','Help on how to use AMS','modules/help/ams_help.cfm','y'),
	(19,14,'__support',2,'Support','Support Service','modules/help/support.cfm','y'),
	(20,14,'__about',3,'About','About the application, creator and L','modules/help/about.cfm','y'),
	(21,11,'__material',2,'Material Inventory',NULL,'modules/warehouse/material.cfm','y'),
	(22,11,'__transaction',3,'Transactions','Transactions','modules/warehouse/transaction.cfm','y'),
	(23,11,'__db_whs',1,'Dashboard','Dashboard','modules/warehouse/dashboard.cfm','y'),
	(24,10,'__service_request',0,'Service Request','Request for Job/Service','modules/maintenance/service_request.cfm','y'),
	(25,2,'__permit',2,'Permit','Permit to work','modules/ptw/permit.cfm','y'),
	(26,2,'__jha',1,'Job Hazard Analysis','JHA','modules/ptw/jha.cfm','y'),
	(27,10,'__db_maintenance',-1,'Dashboard','Maintenance Dashboard','modules/maintenance/dashboard.cfm','y'),
	(29,2,'__db_ptw',0,'Dashboard','Permit to Work System Dashboard','modules/ptw/dashboard.cfm','y'),
	(30,15,'__incident_report',5,'Incident Report','Incident Report','modules/hse/incident_report.cfm','y'),
	(31,15,'__db_incident_report',1,'Dashboard','Incident Report','modules/hse/dashboard.cfm','y'),
	(32,11,'__drilling',4,'Project/Drilling Returns','The drilling item retured to the warehouse by the drilling department','modules/warehouse/drilling.cfm','y'),
	(33,15,'__stop_card',6,'SOP Cards','Online Stop Card','modules/hse/stop_card.cfm','y'),
	(34,15,'__medic',7,'Medical','Automate all medical issues','modules/hse/medic.cfm','y');

/*!40000 ALTER TABLE `core_page` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table core_privilege
# ------------------------------------------------------------

DROP TABLE IF EXISTS `core_privilege`;

CREATE TABLE `core_privilege` (
  `PrivilegeId` int unsigned NOT NULL AUTO_INCREMENT,
  `Role` varchar(255) NOT NULL DEFAULT '0',
  `ModuleId` int unsigned NOT NULL,
  `PageIds` varchar(255) DEFAULT '*',
  PRIMARY KEY (`PrivilegeId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `core_privilege` WRITE;
/*!40000 ALTER TABLE `core_privilege` DISABLE KEYS */;

INSERT INTO `core_privilege` (`PrivilegeId`, `Role`, `ModuleId`, `PageIds`)
VALUES
	(12,'MS',2,'*'),
	(13,'MS',10,'*'),
	(14,'MS',14,'*'),
	(15,'HT',0,'*'),
	(16,'AD',10,'*'),
	(17,'AD',13,'*'),
	(18,'AD',14,'*'),
	(19,'SV',2,'*'),
	(20,'SV',10,'*'),
	(21,'SV',14,'*'),
	(22,'UR',2,'*'),
	(23,'UR',10,'27,24,9,12'),
	(25,'WH',2,'*'),
	(26,'WH',10,'*'),
	(27,'WH',14,'*'),
	(28,'WH',11,'*'),
	(29,'PS',2,'*'),
	(30,'PS',10,'*'),
	(31,'PS',14,'*'),
	(32,'HSE',2,'*'),
	(33,'HSE',10,'*'),
	(34,'HSE',14,'*'),
	(35,'FS',2,'*'),
	(36,'FS',10,'*'),
	(37,'FS',14,'*'),
	(38,'FS',11,'23'),
	(39,'HSE',15,'*'),
	(40,'SV',15,'33'),
	(41,'FS',15,'*'),
	(42,'UR',15,'33'),
	(43,'AD',15,'33'),
	(44,'WH',15,'33'),
	(45,'PS',15,'33'),
	(46,'MS',15,'33'),
	(47,'FS',13,'14'),
	(48,'MS',13,'14'),
	(49,'HSE',13,'14'),
	(50,'SV',13,'14'),
	(51,'AD',2,'*'),
	(52,'HSE',11,'23');

/*!40000 ALTER TABLE `core_privilege` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table core_role
# ------------------------------------------------------------

DROP TABLE IF EXISTS `core_role`;

CREATE TABLE `core_role` (
  `RoleId` int unsigned NOT NULL AUTO_INCREMENT,
  `Title` varchar(255) NOT NULL DEFAULT '',
  `Description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`RoleId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `core_role` WRITE;
/*!40000 ALTER TABLE `core_role` DISABLE KEYS */;

INSERT INTO `core_role` (`RoleId`, `Title`, `Description`)
VALUES
	(1,'Host','Developer / Access to all modules and pages...'),
	(2,'Admin','Bringbox admin user'),
	(3,'POF','Procurement Officer');

/*!40000 ALTER TABLE `core_role` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table core_unit
# ------------------------------------------------------------

DROP TABLE IF EXISTS `core_unit`;

CREATE TABLE `core_unit` (
  `UnitId` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `DepartmentId` tinyint unsigned NOT NULL,
  `Name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`UnitId`),
  KEY `DepartmentId` (`DepartmentId`),
  CONSTRAINT `core_unit_ibfk_1` FOREIGN KEY (`DepartmentId`) REFERENCES `core_department` (`DepartmentId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `core_unit` WRITE;
/*!40000 ALTER TABLE `core_unit` DISABLE KEYS */;

INSERT INTO `core_unit` (`UnitId`, `DepartmentId`, `Name`)
VALUES
	(1,16,'Mechanical'),
	(2,16,'Instrumentation'),
	(3,16,'Electrical'),
	(4,16,'R & A'),
	(5,17,'Facility Maintenance'),
	(6,1,'Support');

/*!40000 ALTER TABLE `core_unit` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table core_user
# ------------------------------------------------------------

DROP TABLE IF EXISTS `core_user`;

CREATE TABLE `core_user` (
  `UserId` int unsigned NOT NULL AUTO_INCREMENT,
  `ManagerId` int unsigned DEFAULT NULL,
  `DepartmentId` tinyint unsigned DEFAULT NULL,
  `CompanyId` tinyint unsigned DEFAULT NULL,
  `RelieveUserId` int unsigned DEFAULT NULL,
  `Position` varchar(255) DEFAULT NULL,
  `PersonalEmail` varchar(255) DEFAULT NULL,
  `UnitId` tinyint unsigned DEFAULT NULL,
  `Surname` varchar(255) DEFAULT NULL,
  `OtherNames` varchar(255) DEFAULT NULL,
  `Email` varchar(255) DEFAULT NULL,
  `Approved` char(3) NOT NULL DEFAULT 'No',
  `UserStatus` varchar(10) DEFAULT 'Active' COMMENT 'Active or Disabled',
  `Location` varchar(25) DEFAULT 'Kwale',
  `OfficeLocationId` varchar(50) DEFAULT NULL,
  `CreatedByUserId` int DEFAULT NULL,
  `CreatedDate` datetime DEFAULT NULL,
  `WorkingForId` tinyint DEFAULT '1',
  PRIMARY KEY (`UserId`),
  KEY `UnitId` (`UnitId`),
  KEY `ManagerId` (`ManagerId`),
  KEY `CompanyId` (`CompanyId`),
  KEY `core_user_ibfk_2` (`DepartmentId`),
  CONSTRAINT `core_user_ibfk_1` FOREIGN KEY (`UnitId`) REFERENCES `core_unit` (`UnitId`),
  CONSTRAINT `core_user_ibfk_2` FOREIGN KEY (`DepartmentId`) REFERENCES `core_department` (`DepartmentId`),
  CONSTRAINT `core_user_ibfk_3` FOREIGN KEY (`ManagerId`) REFERENCES `core_user` (`UserId`),
  CONSTRAINT `core_user_ibfk_4` FOREIGN KEY (`CompanyId`) REFERENCES `core_company` (`CompanyId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `core_user` WRITE;
/*!40000 ALTER TABLE `core_user` DISABLE KEYS */;

INSERT INTO `core_user` (`UserId`, `ManagerId`, `DepartmentId`, `CompanyId`, `RelieveUserId`, `Position`, `PersonalEmail`, `UnitId`, `Surname`, `OtherNames`, `Email`, `Approved`, `UserStatus`, `Location`, `OfficeLocationId`, `CreatedByUserId`, `CreatedDate`, `WorkingForId`)
VALUES
	(1,NULL,16,2,NULL,'1','adexfe@live.com',1,'Arowolo','Abiodun','arowolo.abiodun@adexfe.com','Yes','Active','Kwale','1',NULL,'2050-09-15 00:00:00',1);

/*!40000 ALTER TABLE `core_user` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table custom_field
# ------------------------------------------------------------

DROP TABLE IF EXISTS `custom_field`;

CREATE TABLE `custom_field` (
  `CustomFieldId` int NOT NULL AUTO_INCREMENT,
  `Table` varchar(255) DEFAULT NULL,
  `PK` int DEFAULT NULL,
  `Field` varchar(255) DEFAULT NULL,
  `Value` text,
  PRIMARY KEY (`CustomFieldId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table drilling_return
# ------------------------------------------------------------

DROP TABLE IF EXISTS `drilling_return`;

CREATE TABLE `drilling_return` (
  `DReturnedId` int NOT NULL AUTO_INCREMENT,
  `ReturedDate` date DEFAULT NULL,
  `ReturedBy` varchar(255) DEFAULT NULL,
  `CreatedDate` date DEFAULT NULL,
  `CreatedById` int DEFAULT NULL,
  `Comment` text,
  `RecievedById` int DEFAULT NULL,
  PRIMARY KEY (`DReturnedId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table drilling_returned_item
# ------------------------------------------------------------

DROP TABLE IF EXISTS `drilling_returned_item`;

CREATE TABLE `drilling_returned_item` (
  `DReturnedItemId` int NOT NULL AUTO_INCREMENT,
  `DReturnedId` int DEFAULT NULL,
  `ItemDescription` varchar(255) DEFAULT NULL,
  `Qty` int DEFAULT NULL,
  `Status` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`DReturnedItemId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table expiration
# ------------------------------------------------------------

DROP TABLE IF EXISTS `expiration`;

CREATE TABLE `expiration` (
  `ExpirationId` int unsigned NOT NULL AUTO_INCREMENT,
  `AssetId` int unsigned NOT NULL,
  `Title` varchar(255) NOT NULL DEFAULT '',
  `Date` date NOT NULL,
  `Reminder` mediumint DEFAULT NULL,
  PRIMARY KEY (`ExpirationId`),
  KEY `AssetId` (`AssetId`),
  CONSTRAINT `expiration_ibfk_1` FOREIGN KEY (`AssetId`) REFERENCES `asset` (`AssetId`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table failure_report_integration
# ------------------------------------------------------------

DROP TABLE IF EXISTS `failure_report_integration`;

CREATE TABLE `failure_report_integration` (
  `IntegratIonId` int unsigned NOT NULL AUTO_INCREMENT,
  `AssetFailureReportId` int DEFAULT NULL,
  `PK` int DEFAULT NULL,
  `IntegrateTable` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`IntegratIonId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table file
# ------------------------------------------------------------

DROP TABLE IF EXISTS `file`;

CREATE TABLE `file` (
  `FileId` int NOT NULL AUTO_INCREMENT,
  `Table` varchar(255) DEFAULT NULL,
  `PK` int DEFAULT NULL,
  `File` varchar(255) DEFAULT NULL,
  `Size` bigint DEFAULT NULL,
  `Type` char(255) DEFAULT 'p' COMMENT 'a-attachments, p-photos',
  `CreatedByUserId` int unsigned DEFAULT NULL,
  PRIMARY KEY (`FileId`),
  KEY `CreatedByUserId` (`CreatedByUserId`),
  CONSTRAINT `file_ibfk_1` FOREIGN KEY (`CreatedByUserId`) REFERENCES `core_user` (`UserId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table frequency
# ------------------------------------------------------------

DROP TABLE IF EXISTS `frequency`;

CREATE TABLE `frequency` (
  `FrequencyId` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `Code` varchar(10) DEFAULT NULL,
  `Description` varchar(255) DEFAULT NULL,
  `Years` int unsigned DEFAULT NULL,
  `Quarters` int unsigned DEFAULT NULL,
  `Months` int unsigned DEFAULT NULL,
  `Weeks` int unsigned DEFAULT NULL,
  `Days` int unsigned DEFAULT NULL,
  `Hours` bigint unsigned DEFAULT NULL,
  `Minutes` bigint unsigned DEFAULT '0',
  `WorkingDaysOnly` char(3) DEFAULT NULL,
  PRIMARY KEY (`FrequencyId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `frequency` WRITE;
/*!40000 ALTER TABLE `frequency` DISABLE KEYS */;

INSERT INTO `frequency` (`FrequencyId`, `Code`, `Description`, `Years`, `Quarters`, `Months`, `Weeks`, `Days`, `Hours`, `Minutes`, `WorkingDaysOnly`)
VALUES
	(2,'SA','Semi Annually',0,0,6,0,0,0,0,NULL),
	(3,'Q','Quarterly',0,1,0,0,0,0,0,NULL),
	(4,'Y','Yearly',1,0,0,0,0,0,0,NULL),
	(5,'M','Monthly',0,0,1,0,0,0,0,NULL),
	(6,'5Y','Every 5 Years',5,0,0,0,0,0,0,NULL),
	(7,'4Y','Every 4 Years',4,0,0,0,0,0,0,NULL),
	(8,'3Y','Every 3 Years',3,0,0,0,0,0,0,NULL),
	(9,'2Y','Every 2 Years',2,0,0,0,0,0,0,NULL),
	(17,'D','Daily',0,0,0,0,1,0,0,NULL),
	(22,'W','Weekly',0,0,0,1,0,0,0,NULL),
	(23,'2M','Every 2 Months',0,0,2,0,0,0,0,NULL),
	(39,'3M','Every 3 Months',0,0,3,0,0,0,0,NULL),
	(40,'2W','Every 2 Weeks',0,0,0,2,0,0,0,NULL),
	(41,'1M2W','1 Month 2 Weeks',0,0,1,2,0,0,0,NULL),
	(42,'46D','Every 46 Days',0,0,0,0,46,0,0,'yes');

/*!40000 ALTER TABLE `frequency` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table incident_corrective_action
# ------------------------------------------------------------

DROP TABLE IF EXISTS `incident_corrective_action`;

CREATE TABLE `incident_corrective_action` (
  `CorrectiveId` int NOT NULL AUTO_INCREMENT,
  `IncidentId` int DEFAULT NULL,
  `ActionItemDescription` varchar(255) DEFAULT NULL,
  `PersonelResponsibleId` int DEFAULT NULL,
  `CompletionDate` date DEFAULT NULL,
  `Status` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`CorrectiveId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table incident_injury_details
# ------------------------------------------------------------

DROP TABLE IF EXISTS `incident_injury_details`;

CREATE TABLE `incident_injury_details` (
  `InjuryId` int NOT NULL AUTO_INCREMENT,
  `IncidentId` int DEFAULT NULL,
  `InjuredNames` varchar(255) DEFAULT NULL,
  `ResidentAddress` varchar(255) DEFAULT NULL,
  `Gender` varchar(6) DEFAULT NULL,
  `Occupation` varchar(255) DEFAULT NULL,
  `DOB` date DEFAULT NULL,
  `DateHired` date DEFAULT NULL,
  `NotificationDate` date DEFAULT NULL,
  `EmployementCategory` varchar(255) DEFAULT NULL,
  `JobDuration` varchar(200) DEFAULT NULL,
  `EmployeeProject` varchar(255) DEFAULT NULL,
  `EmployeeHomeOffice` varchar(255) DEFAULT NULL,
  `InjuryType` varchar(255) DEFAULT NULL,
  `NatureofInjury` varchar(255) DEFAULT NULL,
  `InjuredBodyPart` varchar(255) DEFAULT NULL,
  `ActivityBeforeInjury` varchar(255) DEFAULT NULL,
  `InjuryEvent` varchar(255) DEFAULT NULL,
  `InjuryObject` varchar(255) DEFAULT NULL,
  `TreatmentLocation` varchar(255) DEFAULT NULL,
  `TreatmentProvider` varchar(255) DEFAULT NULL,
  `TreatmentGiven` varchar(255) DEFAULT NULL,
  `ReturnToWork` varchar(200) DEFAULT NULL,
  `ReturnComment` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`InjuryId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table incident_investigation_team
# ------------------------------------------------------------

DROP TABLE IF EXISTS `incident_investigation_team`;

CREATE TABLE `incident_investigation_team` (
  `TeamId` int NOT NULL AUTO_INCREMENT,
  `IncidentId` int NOT NULL,
  `InvestigatorId` int NOT NULL,
  PRIMARY KEY (`TeamId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table incident_report
# ------------------------------------------------------------

DROP TABLE IF EXISTS `incident_report`;

CREATE TABLE `incident_report` (
  `IncidentId` int NOT NULL AUTO_INCREMENT,
  `ReportTime` datetime DEFAULT NULL,
  `Title` varchar(255) DEFAULT NULL,
  `Description` text,
  `ActionTaken` text,
  `NotifyMng` varchar(100) DEFAULT NULL,
  `NotifyGov` varchar(100) DEFAULT NULL,
  `NotificationSpecify` varchar(255) DEFAULT NULL,
  `IsWorkRelated` varchar(9) DEFAULT NULL,
  `IfNo` varchar(255) DEFAULT NULL,
  `InjustDetailApplicable` varchar(15) DEFAULT NULL,
  `IncidentType` varchar(100) DEFAULT NULL,
  `OccurredLocation` varchar(255) DEFAULT NULL,
  `OccurredAddress` varchar(255) DEFAULT NULL,
  `AffectedParty` varchar(255) DEFAULT NULL,
  `AffectedPersonel` varchar(255) DEFAULT NULL,
  `OtherAffectedPersonel` varchar(255) DEFAULT NULL,
  `IncidentAgent` varchar(255) DEFAULT NULL,
  `OtherAgents` varchar(255) DEFAULT NULL,
  `ReportingPersonelId` int DEFAULT NULL,
  `InjustDetails` varchar(255) DEFAULT NULL,
  `ASeverityPeople` varchar(255) DEFAULT NULL,
  `ASeverityEnvironment` varchar(255) DEFAULT NULL,
  `ASeverityAsset` varchar(255) DEFAULT NULL,
  `ASeverityReputation` varchar(255) DEFAULT NULL,
  `PSeverityPeople` varchar(255) DEFAULT NULL,
  `PSeverityEnvironment` varchar(255) DEFAULT NULL,
  `PSeverityAsset` varchar(255) DEFAULT NULL,
  `PSeverityReputation` varchar(255) DEFAULT NULL,
  `PhysicalInvestigation` varchar(255) DEFAULT NULL,
  `Witnesses` varchar(255) DEFAULT NULL,
  `Paper` varchar(255) DEFAULT NULL,
  `MajorCauses` varchar(255) DEFAULT NULL,
  `Policy` varchar(255) DEFAULT NULL,
  `Communication` varchar(255) DEFAULT NULL,
  `Hazard` varchar(255) DEFAULT NULL,
  `Reputation` varchar(255) DEFAULT NULL,
  `BloodBorne` varchar(255) DEFAULT NULL,
  `ProductivityFactors` varchar(255) DEFAULT NULL,
  `WorkBehaviour` varchar(255) DEFAULT NULL,
  `Training` varchar(255) DEFAULT NULL,
  `Environment` varchar(255) DEFAULT NULL,
  `PPE` varchar(255) DEFAULT NULL,
  `Facility` varchar(255) DEFAULT NULL,
  `RootCauseStatement` varchar(255) DEFAULT NULL,
  `ElementInvolved` varchar(255) DEFAULT NULL,
  `PerformingAuthorityId` int DEFAULT NULL,
  `PerformingAuthorityComment` varchar(255) DEFAULT NULL,
  `AuthorizedDate` date DEFAULT NULL,
  `PADate` date DEFAULT NULL,
  `FSAuthorityId` int DEFAULT NULL,
  `FSComment` varchar(255) DEFAULT NULL,
  `CreatedById` int DEFAULT NULL,
  `CreatedDate` datetime DEFAULT NULL,
  `ReportingPartyDetails` text,
  PRIMARY KEY (`IncidentId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table job_class
# ------------------------------------------------------------

DROP TABLE IF EXISTS `job_class`;

CREATE TABLE `job_class` (
  `JobClassId` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `Code` varchar(3) DEFAULT NULL,
  `Class` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`JobClassId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `job_class` WRITE;
/*!40000 ALTER TABLE `job_class` DISABLE KEYS */;

INSERT INTO `job_class` (`JobClassId`, `Code`, `Class`)
VALUES
	(1,'ST','Shutdown Task'),
	(3,'CM','Corrective Maintenance'),
	(4,'Co','Construction'),
	(5,'FT','Testing'),
	(6,'IN','Inspection'),
	(7,'Mo','Modification'),
	(10,'PM','Preventive Maintenance'),
	(12,'RQ','Requisition'),
	(13,'IS','Installation'),
	(14,'RL','Relocation'),
	(15,'RC','Recertification'),
	(16,'DC','Decommissioning'),
	(17,'PR','Predictive Maintenance'),
	(18,'Po','Programming');

/*!40000 ALTER TABLE `job_class` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table labour
# ------------------------------------------------------------

DROP TABLE IF EXISTS `labour`;

CREATE TABLE `labour` (
  `LabourId` int unsigned NOT NULL AUTO_INCREMENT,
  `WorkOrderId` int unsigned NOT NULL,
  `UserId` int unsigned NOT NULL,
  `Hours` decimal(6,2) unsigned NOT NULL DEFAULT '0.00',
  `Rate` float unsigned NOT NULL DEFAULT '50',
  `Function` varchar(255) DEFAULT NULL COMMENT 'Work to do',
  PRIMARY KEY (`LabourId`),
  KEY `WorkOrderId` (`WorkOrderId`),
  KEY `UserId` (`UserId`),
  CONSTRAINT `labour_ibfk_1` FOREIGN KEY (`WorkOrderId`) REFERENCES `work_order` (`WorkOrderId`) ON DELETE CASCADE,
  CONSTRAINT `labour_ibfk_2` FOREIGN KEY (`UserId`) REFERENCES `core_user` (`UserId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table location
# ------------------------------------------------------------

DROP TABLE IF EXISTS `location`;

CREATE TABLE `location` (
  `LocationId` int unsigned NOT NULL AUTO_INCREMENT,
  `ParentLocationId` int unsigned DEFAULT NULL,
  `Name` varchar(255) DEFAULT NULL,
  `OfficeLocationId` int DEFAULT '1',
  PRIMARY KEY (`LocationId`),
  KEY `ParentLocationId` (`ParentLocationId`),
  CONSTRAINT `location_ibfk_1` FOREIGN KEY (`ParentLocationId`) REFERENCES `location` (`LocationId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `location` WRITE;
/*!40000 ALTER TABLE `location` DISABLE KEYS */;

INSERT INTO `location` (`LocationId`, `ParentLocationId`, `Name`, `OfficeLocationId`)
VALUES
	(3,NULL,'Camp Site',1),
	(364,NULL,'Conference Room',1),
	(365,NULL,'Remote Gas Processing Plant',1),
	(366,365,'Offshore Rig 12',1);

/*!40000 ALTER TABLE `location` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table meter_reading
# ------------------------------------------------------------

DROP TABLE IF EXISTS `meter_reading`;

CREATE TABLE `meter_reading` (
  `MeterReadingId` int unsigned NOT NULL AUTO_INCREMENT,
  `AssetLocationId` int unsigned DEFAULT NULL,
  `CurrentReading` decimal(20,2) DEFAULT NULL,
  `Comment` varchar(255) DEFAULT NULL,
  `TimeModified` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`MeterReadingId`),
  KEY `AssetLocationId` (`AssetLocationId`),
  CONSTRAINT `meter_reading_ibfk_1` FOREIGN KEY (`AssetLocationId`) REFERENCES `asset_location` (`AssetLocationId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table office_location
# ------------------------------------------------------------

DROP TABLE IF EXISTS `office_location`;

CREATE TABLE `office_location` (
  `OfficeLocationId` int NOT NULL AUTO_INCREMENT,
  `LocationName` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`OfficeLocationId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table period
# ------------------------------------------------------------

DROP TABLE IF EXISTS `period`;

CREATE TABLE `period` (
  `PeriodId` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`PeriodId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `period` WRITE;
/*!40000 ALTER TABLE `period` DISABLE KEYS */;

INSERT INTO `period` (`PeriodId`, `Name`)
VALUES
	(1,'Within A Day'),
	(2,'1 Day'),
	(3,'2 Days'),
	(4,'3 Days'),
	(5,'4 Days'),
	(6,'5 Days'),
	(7,'6 Days'),
	(8,'7 Days'),
	(9,'1 Week'),
	(10,'2 Weeks'),
	(11,'3 Weeks'),
	(12,'1 Month'),
	(13,'2 Months'),
	(14,'3  Months'),
	(15,'4 Months'),
	(16,'5  Months'),
	(17,'6 Months'),
	(18,'7 Months'),
	(19,'8 Months'),
	(20,'9 Months'),
	(21,'10 Months'),
	(22,'11 Months'),
	(23,'1 Year'),
	(24,'2 Years'),
	(25,'3 Years');

/*!40000 ALTER TABLE `period` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table pm_milestone
# ------------------------------------------------------------

DROP TABLE IF EXISTS `pm_milestone`;

CREATE TABLE `pm_milestone` (
  `MilestoneId` int unsigned NOT NULL AUTO_INCREMENT,
  `PMTaskId` int unsigned NOT NULL,
  `AssetLocationId` int unsigned DEFAULT NULL,
  `Reading` decimal(20,2) NOT NULL DEFAULT '0.00' COMMENT 'cummulative current reading',
  PRIMARY KEY (`MilestoneId`),
  UNIQUE KEY `PMTaskId` (`PMTaskId`),
  KEY `AssetLocationId` (`AssetLocationId`),
  CONSTRAINT `pm_milestone_ibfk_1` FOREIGN KEY (`PMTaskId`) REFERENCES `pm_task` (`PMTaskId`),
  CONSTRAINT `pm_milestone_ibfk_2` FOREIGN KEY (`AssetLocationId`) REFERENCES `asset_location` (`AssetLocationId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table pm_task
# ------------------------------------------------------------

DROP TABLE IF EXISTS `pm_task`;

CREATE TABLE `pm_task` (
  `PMTaskId` int unsigned NOT NULL AUTO_INCREMENT,
  `AssetLocationId` varchar(255) DEFAULT NULL,
  `DepartmentId` tinyint unsigned DEFAULT NULL,
  `UnitId` tinyint unsigned DEFAULT NULL,
  `ManHours` float DEFAULT NULL,
  `Description` varchar(255) DEFAULT NULL,
  `TaskDetails` longtext,
  `Resources` text,
  `TaskFlag` varchar(255) DEFAULT NULL,
  `FrequencyId` tinyint unsigned DEFAULT NULL,
  `StartTime` datetime DEFAULT NULL,
  `IsActive` char(3) NOT NULL DEFAULT 'Yes',
  `ReadingTypeId` tinyint unsigned DEFAULT NULL,
  `Milestone` decimal(18,2) DEFAULT '0.00',
  `NotifyBefore` decimal(18,2) DEFAULT '0.00',
  `Type` char(1) NOT NULL DEFAULT 'd' COMMENT 'd for days, m for milestone',
  `Note` text,
  `RequireShutdown` char(3) NOT NULL DEFAULT 'No' COMMENT 'yes or no',
  PRIMARY KEY (`PMTaskId`),
  KEY `DepartmentId` (`DepartmentId`),
  KEY `UnitId` (`UnitId`),
  KEY `FrequencyId` (`FrequencyId`),
  CONSTRAINT `pm_task_ibfk_1` FOREIGN KEY (`DepartmentId`) REFERENCES `core_department` (`DepartmentId`),
  CONSTRAINT `pm_task_ibfk_2` FOREIGN KEY (`UnitId`) REFERENCES `core_unit` (`UnitId`),
  CONSTRAINT `pm_task_ibfk_3` FOREIGN KEY (`FrequencyId`) REFERENCES `frequency` (`FrequencyId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `pm_task` WRITE;
/*!40000 ALTER TABLE `pm_task` DISABLE KEYS */;

INSERT INTO `pm_task` (`PMTaskId`, `AssetLocationId`, `DepartmentId`, `UnitId`, `ManHours`, `Description`, `TaskDetails`, `Resources`, `TaskFlag`, `FrequencyId`, `StartTime`, `IsActive`, `ReadingTypeId`, `Milestone`, `NotifyBefore`, `Type`, `Note`, `RequireShutdown`)
VALUES
	(3444,'1581',16,2,NULL,'yfgdf','dfg fgdfsd',NULL,NULL,17,'2024-11-13 00:00:00','Yes',NULL,NULL,0.00,'d','','No');

/*!40000 ALTER TABLE `pm_task` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table ptw_gas_test
# ------------------------------------------------------------

DROP TABLE IF EXISTS `ptw_gas_test`;

CREATE TABLE `ptw_gas_test` (
  `GasTestId` int NOT NULL AUTO_INCREMENT,
  `PermitId` int DEFAULT NULL,
  `Date` datetime DEFAULT NULL,
  `Gas` varchar(50) DEFAULT NULL,
  `O2` varchar(50) DEFAULT NULL COMMENT 'Oxygen',
  `H2o` varchar(50) DEFAULT NULL COMMENT 'Water',
  PRIMARY KEY (`GasTestId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table ptw_jha
# ------------------------------------------------------------

DROP TABLE IF EXISTS `ptw_jha`;

CREATE TABLE `ptw_jha` (
  `JHAId` int unsigned NOT NULL AUTO_INCREMENT,
  `WorkOrderId` int unsigned NOT NULL,
  `Date` date DEFAULT NULL,
  `PreparedByUserId` int unsigned DEFAULT NULL,
  `ReviewedByUserId` int unsigned DEFAULT NULL,
  `EquipmentToUse` varchar(255) DEFAULT NULL,
  `Status` char(1) DEFAULT 'o',
  PRIMARY KEY (`JHAId`),
  KEY `WorkOrderId` (`WorkOrderId`),
  KEY `PreparedByUserId` (`PreparedByUserId`),
  KEY `ReviewedByUserId` (`ReviewedByUserId`),
  CONSTRAINT `ptw_jha_ibfk_1` FOREIGN KEY (`WorkOrderId`) REFERENCES `work_order` (`WorkOrderId`),
  CONSTRAINT `ptw_jha_ibfk_2` FOREIGN KEY (`PreparedByUserId`) REFERENCES `core_user` (`UserId`),
  CONSTRAINT `ptw_jha_ibfk_3` FOREIGN KEY (`ReviewedByUserId`) REFERENCES `core_user` (`UserId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table ptw_jha_list
# ------------------------------------------------------------

DROP TABLE IF EXISTS `ptw_jha_list`;

CREATE TABLE `ptw_jha_list` (
  `JHAListId` int unsigned NOT NULL AUTO_INCREMENT,
  `JHAId` int unsigned DEFAULT NULL,
  `JobSequence` text,
  `Hazard` text,
  `Target` varchar(10) DEFAULT NULL COMMENT 'P=Probability(L=Low, M=Medium, H=High); S=Serverity(L=Low, M=Medium, H=High); C= Criticality(C=Low, M=Medium, H=High)',
  `Risk` varchar(10) DEFAULT NULL COMMENT 'P=Personnel; E=Environment; A = Asset; R=Reputation',
  `Consequences` text,
  `ControlMeasure` text,
  `ResponsibleParty` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`JHAListId`),
  KEY `JHAId` (`JHAId`),
  CONSTRAINT `ptw_jha_list_ibfk_1` FOREIGN KEY (`JHAId`) REFERENCES `ptw_jha` (`JHAId`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table ptw_permit
# ------------------------------------------------------------

DROP TABLE IF EXISTS `ptw_permit`;

CREATE TABLE `ptw_permit` (
  `PermitId` int unsigned NOT NULL AUTO_INCREMENT,
  `Revalidate` char(1) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL DEFAULT 'n',
  `JHAId` int unsigned NOT NULL,
  `Tools` varchar(255) DEFAULT NULL,
  `Date` date NOT NULL,
  `StartTime` datetime DEFAULT NULL,
  `EndTime` datetime DEFAULT NULL,
  `WorkType` varchar(255) DEFAULT NULL,
  `Contractor` varchar(255) DEFAULT NULL,
  `NumberOfWorkers` tinyint unsigned NOT NULL DEFAULT '0',
  `SafetyRequirement1` text COMMENT 'Safety precautions to be taken',
  `SafetyRequirement2` text COMMENT 'facilities to be isolated',
  `SafetyRequirement3` text COMMENT 'facilities to be prepared',
  `SafetyRequirement4` text COMMENT 'work area to be prepared',
  `AdditionalPrecaution` text,
  `PPE` text COMMENT 'personal/PPE',
  `SafetyRequirement` varchar(255) DEFAULT NULL COMMENT 'additional precautions',
  `Certificate` text,
  `HotWork` text,
  `Custom1` varchar(255) DEFAULT NULL COMMENT 'gas test at intervals of ...',
  `Custom2` varchar(255) DEFAULT NULL COMMENT 'special precaution',
  `ConfinedSpace` text,
  `Precaution` text,
  `Custom3` varchar(255) DEFAULT NULL COMMENT 'specify (confine space)',
  `Custom4` float DEFAULT NULL COMMENT 'Continious gas test evey .... hours',
  `GasTestApprovedByUserId` int unsigned DEFAULT NULL,
  `GasTestApprovedDate` datetime DEFAULT NULL,
  `GasFree` char(3) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT '' COMMENT 'yes or no',
  `PAApprovedByUserId` int unsigned DEFAULT NULL COMMENT 'performing authority by?',
  `PAApprovedDate` datetime DEFAULT NULL COMMENT 'performing authority approved date',
  `FSApprovedByUserId` int unsigned DEFAULT '0' COMMENT 'Field supervisor',
  `FSApprovedDate` datetime DEFAULT NULL,
  `SVApprovedByUserId` int unsigned DEFAULT '0' COMMENT 'HSE Supervisor',
  `SVApprovedDate` datetime DEFAULT NULL,
  `LSApprovedByUserId` int unsigned DEFAULT NULL COMMENT 'Location suspervisor',
  `LSApprovedDate` datetime DEFAULT NULL,
  `PACloseByUserId` int unsigned DEFAULT NULL,
  `PACloseDate` datetime DEFAULT NULL,
  `Completed` char(3) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT NULL,
  `SVCloseByUserId` int unsigned DEFAULT NULL,
  `SVCloseDate` datetime DEFAULT NULL,
  `Status` enum('STPSTA','WFPSTA','Active','WFHTS','WFFSTA','FSA','SFR','PSR','C','STPSTC') CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT 'STPSTA' COMMENT 'Close, Active',
  PRIMARY KEY (`PermitId`),
  KEY `JHAId` (`JHAId`),
  KEY `PAApprovedByUserId` (`PAApprovedByUserId`),
  CONSTRAINT `ptw_permit_ibfk_1` FOREIGN KEY (`JHAId`) REFERENCES `ptw_jha` (`JHAId`),
  CONSTRAINT `ptw_permit_ibfk_2` FOREIGN KEY (`PAApprovedByUserId`) REFERENCES `core_user` (`UserId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AVG_ROW_LENGTH=5423;



# Dump of table ptw_permit_revalidated
# ------------------------------------------------------------

DROP TABLE IF EXISTS `ptw_permit_revalidated`;

CREATE TABLE `ptw_permit_revalidated` (
  `PermitRevalidateId` int unsigned NOT NULL AUTO_INCREMENT,
  `PermitId` int unsigned NOT NULL,
  `ValidatedByUserId` int unsigned NOT NULL,
  `Date` date NOT NULL,
  `StartTime` time NOT NULL,
  `EndTime` time NOT NULL,
  PRIMARY KEY (`PermitRevalidateId`),
  KEY `PermitId` (`PermitId`),
  KEY `ValidatedByUserId` (`ValidatedByUserId`),
  CONSTRAINT `ptw_permit_revalidated_ibfk_1` FOREIGN KEY (`PermitId`) REFERENCES `ptw_permit` (`PermitId`),
  CONSTRAINT `ptw_permit_revalidated_ibfk_2` FOREIGN KEY (`ValidatedByUserId`) REFERENCES `core_user` (`UserId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table reading_history
# ------------------------------------------------------------

DROP TABLE IF EXISTS `reading_history`;

CREATE TABLE `reading_history` (
  `RadingHistoryId` int unsigned NOT NULL AUTO_INCREMENT,
  `AssetIdx` int unsigned DEFAULT NULL,
  `AssetLocationId` int unsigned DEFAULT NULL,
  `ReadingByUserId` int unsigned DEFAULT NULL,
  `CurrentReading` decimal(20,2) NOT NULL DEFAULT '0.00' COMMENT 'the cummulative reading',
  `EntryDate` datetime NOT NULL,
  `Comment` varchar(255) DEFAULT NULL COMMENT 'Comment or Remark',
  PRIMARY KEY (`RadingHistoryId`),
  KEY `AssetId` (`AssetIdx`),
  KEY `ReadingByUserId` (`ReadingByUserId`),
  KEY `AssetLocationId` (`AssetLocationId`),
  CONSTRAINT `reading_history_ibfk_1` FOREIGN KEY (`ReadingByUserId`) REFERENCES `core_user` (`UserId`),
  CONSTRAINT `reading_history_ibfk_2` FOREIGN KEY (`AssetLocationId`) REFERENCES `asset_location` (`AssetLocationId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table reading_type
# ------------------------------------------------------------

DROP TABLE IF EXISTS `reading_type`;

CREATE TABLE `reading_type` (
  `ReadingTypeId` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `Code` char(10) DEFAULT NULL,
  `Type` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`ReadingTypeId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `reading_type` WRITE;
/*!40000 ALTER TABLE `reading_type` DISABLE KEYS */;

INSERT INTO `reading_type` (`ReadingTypeId`, `Code`, `Type`)
VALUES
	(1,'hrs','Hours'),
	(2,'Km','Kilometers'),
	(3,'mi','Miles'),
	(4,'Ro','Rotation'),
	(13,'Km/h','Kilometer per hour'),
	(17,'lt','Liter'),
	(18,'m','Meters'),
	(19,'mph','Miles per hour'),
	(24,'%','Percent'),
	(27,'r','Revolution');

/*!40000 ALTER TABLE `reading_type` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table relief_user
# ------------------------------------------------------------

DROP TABLE IF EXISTS `relief_user`;

CREATE TABLE `relief_user` (
  `ReliefUserId` int NOT NULL AUTO_INCREMENT,
  `UserId` int DEFAULT NULL,
  `BackToBackId` int DEFAULT NULL,
  PRIMARY KEY (`ReliefUserId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table report_to
# ------------------------------------------------------------

DROP TABLE IF EXISTS `report_to`;

CREATE TABLE `report_to` (
  `ReportToId` int NOT NULL AUTO_INCREMENT,
  `UserId` int DEFAULT NULL,
  `HeadId` int DEFAULT NULL,
  `Position` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ReportToId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table ser_syn
# ------------------------------------------------------------

DROP TABLE IF EXISTS `ser_syn`;

CREATE TABLE `ser_syn` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `FieldId` int NOT NULL,
  `Table` varchar(255) NOT NULL,
  `Type` enum('U','I','D') DEFAULT 'U',
  `Date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `FieldId` (`FieldId`,`Table`,`Type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table service_request
# ------------------------------------------------------------

DROP TABLE IF EXISTS `service_request`;

CREATE TABLE `service_request` (
  `ServiceRequestId` int unsigned NOT NULL AUTO_INCREMENT,
  `AssetId` int unsigned DEFAULT NULL,
  `ServiceType` char(2) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT NULL COMMENT 'mr,jr',
  `Category` char(1) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT NULL,
  `Date` date NOT NULL,
  `DateNeeded` date DEFAULT NULL,
  `LocationIds` varchar(255) DEFAULT NULL,
  `RequestByUserId` int unsigned NOT NULL,
  `ApprovedByUserId` int unsigned DEFAULT NULL,
  `Description` text,
  `ReasonforRequest` text,
  `Priority` char(1) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT 'm' COMMENT 'h=high, m=meduim,l=low',
  `ClosedByUserId` int DEFAULT NULL,
  `ClosedDate` date DEFAULT NULL,
  `Status` varchar(30) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT 'Open' COMMENT 'open,close,part onhold',
  PRIMARY KEY (`ServiceRequestId`),
  KEY `AssetId` (`AssetId`),
  KEY `RequestByUserId` (`RequestByUserId`),
  CONSTRAINT `service_request_ibfk_1` FOREIGN KEY (`AssetId`) REFERENCES `asset` (`AssetId`),
  CONSTRAINT `service_request_ibfk_2` FOREIGN KEY (`RequestByUserId`) REFERENCES `core_user` (`UserId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table service_request_item
# ------------------------------------------------------------

DROP TABLE IF EXISTS `service_request_item`;

CREATE TABLE `service_request_item` (
  `ServiceRequestItemId` int unsigned NOT NULL AUTO_INCREMENT,
  `ServiceRequestId` int unsigned NOT NULL,
  `Description` varchar(255) NOT NULL DEFAULT '',
  `Quantity` int unsigned NOT NULL DEFAULT '0',
  `UnitPrice` decimal(20,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`ServiceRequestItemId`),
  KEY `ServiceRequestId` (`ServiceRequestId`),
  CONSTRAINT `service_request_item_ibfk_1` FOREIGN KEY (`ServiceRequestId`) REFERENCES `service_request` (`ServiceRequestId`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table shelf_location
# ------------------------------------------------------------

DROP TABLE IF EXISTS `shelf_location`;

CREATE TABLE `shelf_location` (
  `ShelfLocationId` int unsigned NOT NULL AUTO_INCREMENT,
  `Code` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ShelfLocationId`),
  UNIQUE KEY `Code` (`Code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table shipment_mode
# ------------------------------------------------------------

DROP TABLE IF EXISTS `shipment_mode`;

CREATE TABLE `shipment_mode` (
  `ShipmentModeId` int unsigned NOT NULL AUTO_INCREMENT,
  `Mode` varchar(255) NOT NULL DEFAULT '',
  `Days` int unsigned DEFAULT NULL,
  PRIMARY KEY (`ShipmentModeId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `shipment_mode` WRITE;
/*!40000 ALTER TABLE `shipment_mode` DISABLE KEYS */;

INSERT INTO `shipment_mode` (`ShipmentModeId`, `Mode`, `Days`)
VALUES
	(1,'Air',30),
	(2,'Consolidated Air',45),
	(3,'Emergency Ocean',30),
	(4,'Consolidated Emergency Ocean',30),
	(5,'Emergency Truck',7),
	(6,'Hand Carry',7),
	(8,'None',15),
	(9,'Ocean',90),
	(11,'Special',30),
	(12,'Truck',14),
	(13,'Ugent Air',15);

/*!40000 ALTER TABLE `shipment_mode` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table signature
# ------------------------------------------------------------

DROP TABLE IF EXISTS `signature`;

CREATE TABLE `signature` (
  `UserId` int unsigned NOT NULL,
  `Height` varchar(5) NOT NULL DEFAULT '',
  `Width` varchar(5) NOT NULL DEFAULT '',
  PRIMARY KEY (`UserId`)
) ENGINE=InnoDB DEFAULT CHARSET=ascii;



# Dump of table sop_act
# ------------------------------------------------------------

DROP TABLE IF EXISTS `sop_act`;

CREATE TABLE `sop_act` (
  `SOPActId` tinyint NOT NULL AUTO_INCREMENT,
  `ActName` varchar(200) DEFAULT NULL,
  `Category` tinyint DEFAULT NULL,
  PRIMARY KEY (`SOPActId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `sop_act` WRITE;
/*!40000 ALTER TABLE `sop_act` DISABLE KEYS */;

INSERT INTO `sop_act` (`SOPActId`, `ActName`, `Category`)
VALUES
	(1,'Correct use of Tools/Equipment',1),
	(2,'Good procedure',1),
	(3,'Good behaviour/responsible actions',1),
	(4,'HSE milestones',1),
	(5,'Improper use of tools/equipment',2),
	(6,'Improper lifting/stacking/loading',2),
	(7,'Improper position or posture',2),
	(8,'Failure to use safe system of work/PTW',2),
	(9,'Failure to use safety devices',2),
	(10,'Failure to report incidents',2),
	(11,'Failure to use the right PPE',2),
	(12,'Rendering PPE ineffective',2),
	(13,'Rendering equipment defective',2),
	(14,'Houseplay',2),
	(15,'Operating without authorization',2),
	(16,'Operating at unsafe speed',2),
	(17,'Under the influence of alcohol or drugs',2),
	(18,'Unguarded mechinery',3),
	(19,'Unsafe floor/working surfaces',3),
	(20,'Fire or explosion hazards',3),
	(21,'Inadequate housekeeping',3),
	(22,'Workplace Congestion',3),
	(23,'Hazardous environment conditions',3),
	(24,'Spillage',3),
	(25,'Poor or ecessive illumination',3),
	(26,'Temperature extremes',3),
	(27,'Excessive noise',3),
	(28,'Broken chairs/damaged/faulty equipment',3);

/*!40000 ALTER TABLE `sop_act` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table sop_card
# ------------------------------------------------------------

DROP TABLE IF EXISTS `sop_card`;

CREATE TABLE `sop_card` (
  `SOPId` bigint unsigned NOT NULL AUTO_INCREMENT,
  `Acts` varchar(18) DEFAULT NULL,
  `ActDetails` text,
  `Observation` text,
  `ImmediateAction` varchar(255) DEFAULT NULL,
  `FurtherCorrection` varchar(255) DEFAULT NULL,
  `ObserverFirstName` varchar(120) DEFAULT NULL,
  `ObserverSurnameName` varchar(120) DEFAULT NULL,
  `Location` varchar(30) DEFAULT NULL,
  `SOPDate` date DEFAULT NULL,
  `CreatedByUserId` tinyint DEFAULT NULL,
  `DepartmentId` int unsigned DEFAULT NULL,
  `Priority` varchar(15) DEFAULT 'Low',
  `Site` varchar(10) DEFAULT 'Kwale',
  PRIMARY KEY (`SOPId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table spare_part
# ------------------------------------------------------------

DROP TABLE IF EXISTS `spare_part`;

CREATE TABLE `spare_part` (
  `SparePartId` int unsigned NOT NULL AUTO_INCREMENT,
  `AssetId` int unsigned NOT NULL,
  `ItemId` int unsigned NOT NULL,
  PRIMARY KEY (`SparePartId`),
  UNIQUE KEY `AssetId` (`AssetId`,`ItemId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table temp_data
# ------------------------------------------------------------

DROP TABLE IF EXISTS `temp_data`;

CREATE TABLE `temp_data` (
  `TempDataId` int NOT NULL AUTO_INCREMENT,
  `Session` varchar(255) NOT NULL DEFAULT '',
  `PK` int DEFAULT NULL COMMENT 'For editing purpose',
  `Flag` char(1) DEFAULT NULL COMMENT 'd -delete, n-new, u-updated',
  `Int0` int DEFAULT NULL,
  `Int1` int DEFAULT NULL,
  `Int2` int DEFAULT NULL,
  `Int3` int DEFAULT NULL,
  `float0` float DEFAULT NULL,
  `float1` float DEFAULT NULL,
  `float2` float DEFAULT NULL,
  `Text0` text,
  `Text1` text,
  `Text2` text,
  `Text3` text,
  `Text4` text,
  `Text5` text,
  `Text6` text,
  `Text7` text,
  `Date0` date DEFAULT NULL,
  `TimeCreated` date DEFAULT NULL,
  PRIMARY KEY (`TempDataId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `temp_data` WRITE;
/*!40000 ALTER TABLE `temp_data` DISABLE KEYS */;

INSERT INTO `temp_data` (`TempDataId`, `Session`, `PK`, `Flag`, `Int0`, `Int1`, `Int2`, `Int3`, `float0`, `float1`, `float2`, `Text0`, `Text1`, `Text2`, `Text3`, `Text4`, `Text5`, `Text6`, `Text7`, `Date0`, `TimeCreated`)
VALUES
	(3,'681F4F93-868E-47BE-91C43732522C5A40',1581,'',3,1,NULL,NULL,NULL,NULL,NULL,'-','Online',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2024-11-12'),
	(5,'D8992DD5-1B22-4ED7-AEFDDB259D694ED7',1581,'',3,1,NULL,NULL,NULL,NULL,NULL,'-','Online',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2024-11-12'),
	(8,'1BEF46A9-F60E-4219-93D7990BF758AE6F',1581,'',3,1,NULL,NULL,NULL,NULL,NULL,'-','Online',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2024-11-13'),
	(10,'460EDCD7-2308-45AF-BC2D5B445952757C',1581,'',3,1,NULL,NULL,NULL,NULL,NULL,'-','Online',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2024-11-13'),
	(12,'F0A50B0D-D84F-47DA-AE611B36FAAC69EF',NULL,'n',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'sdgdsvs','sdfds','dd','d','dfsdf','sdfsd',NULL,NULL,NULL,'2024-11-13'),
	(13,'2B59478D-F70D-4BA3-9B3639336F95FE28',NULL,'n',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'sdgdsvs','sdfds','dd','d','dfsdf','sdfsd',NULL,NULL,NULL,'2024-11-13'),
	(16,'527B9CAF-5A48-4986-8FCECC41297D9F80',NULL,'n',5,NULL,NULL,NULL,56,NULL,NULL,'yhetrhytrrt',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2024-11-13');

/*!40000 ALTER TABLE `temp_data` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table um
# ------------------------------------------------------------

DROP TABLE IF EXISTS `um`;

CREATE TABLE `um` (
  `UMId` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `Code` varchar(4) DEFAULT NULL,
  `Title` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`UMId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `um` WRITE;
/*!40000 ALTER TABLE `um` DISABLE KEYS */;

INSERT INTO `um` (`UMId`, `Code`, `Title`)
VALUES
	(1,'BX','Box'),
	(2,'CM','Centimeter'),
	(3,'DZ','Dozen'),
	(4,'FT','Foot'),
	(5,'GL','Gallon'),
	(6,'IN','Inch'),
	(7,'JB','Job'),
	(8,'JT','Joint'),
	(9,'KG','Kilogram'),
	(10,'LB','Pound'),
	(11,'MR','Meter'),
	(12,'MT','Metric Ton'),
	(13,'OZ','Ounce'),
	(14,'PK','Packet'),
	(15,'PR','Pair'),
	(16,'RL','Roll'),
	(17,'SG','Square Root'),
	(18,'ST','Set'),
	(19,'LT','Liter'),
	(20,'EA','Each'),
	(21,'DM','Drum'),
	(22,'BG','Bag');

/*!40000 ALTER TABLE `um` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table whs_dn
# ------------------------------------------------------------

DROP TABLE IF EXISTS `whs_dn`;

CREATE TABLE `whs_dn` (
  `DeliveryNoteId` int unsigned NOT NULL AUTO_INCREMENT,
  `MRId` int unsigned DEFAULT NULL,
  `DeliverToUserId` int unsigned DEFAULT NULL,
  `CreatedByUserId` int unsigned DEFAULT NULL,
  `Date` date DEFAULT NULL,
  `Reference` varchar(255) DEFAULT NULL,
  `Remark` text,
  PRIMARY KEY (`DeliveryNoteId`),
  KEY `MRId` (`MRId`),
  KEY `DeliverToUserId` (`DeliverToUserId`),
  KEY `CreatedByUserId` (`CreatedByUserId`),
  CONSTRAINT `whs_dn_ibfk_1` FOREIGN KEY (`MRId`) REFERENCES `whs_mr` (`MRId`),
  CONSTRAINT `whs_dn_ibfk_2` FOREIGN KEY (`DeliverToUserId`) REFERENCES `core_user` (`UserId`),
  CONSTRAINT `whs_dn_ibfk_3` FOREIGN KEY (`CreatedByUserId`) REFERENCES `core_user` (`UserId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table whs_dn_item
# ------------------------------------------------------------

DROP TABLE IF EXISTS `whs_dn_item`;

CREATE TABLE `whs_dn_item` (
  `DNItemId` int unsigned NOT NULL AUTO_INCREMENT,
  `DeliveryNoteId` int unsigned DEFAULT NULL,
  `MRItemId` int unsigned DEFAULT NULL,
  `Description` text,
  `Quantity` int unsigned DEFAULT NULL,
  `UnitPrice` decimal(20,2) DEFAULT NULL,
  `Status` varchar(10) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT 'Open',
  PRIMARY KEY (`DNItemId`),
  KEY `DeliveryNoteId` (`DeliveryNoteId`),
  KEY `DeliveryNoteId_2` (`DeliveryNoteId`),
  KEY `MRItemId` (`MRItemId`),
  KEY `MRItemId_2` (`MRItemId`),
  CONSTRAINT `whs_dn_item_ibfk_1` FOREIGN KEY (`DeliveryNoteId`) REFERENCES `whs_dn` (`DeliveryNoteId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table whs_inventory_adjustment
# ------------------------------------------------------------

DROP TABLE IF EXISTS `whs_inventory_adjustment`;

CREATE TABLE `whs_inventory_adjustment` (
  `InventoryAdjustmentId` int unsigned NOT NULL AUTO_INCREMENT,
  `ItemId` int unsigned NOT NULL,
  `AdjustedByUserId` int unsigned NOT NULL,
  `Reason` varchar(255) DEFAULT NULL,
  `Date` date NOT NULL,
  `Currency` char(3) DEFAULT NULL,
  `UnitPrice` decimal(20,2) DEFAULT NULL,
  `QOH` decimal(10,2) DEFAULT NULL,
  `QOR` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`InventoryAdjustmentId`),
  KEY `ItemId` (`ItemId`),
  KEY `AdjustedByUserId` (`AdjustedByUserId`),
  CONSTRAINT `whs_inventory_adjustment_ibfk_1` FOREIGN KEY (`ItemId`) REFERENCES `whs_item` (`ItemId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `whs_inventory_adjustment_ibfk_2` FOREIGN KEY (`AdjustedByUserId`) REFERENCES `core_user` (`UserId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table whs_issue
# ------------------------------------------------------------

DROP TABLE IF EXISTS `whs_issue`;

CREATE TABLE `whs_issue` (
  `IssueId` int unsigned NOT NULL AUTO_INCREMENT,
  `MRId` int unsigned DEFAULT NULL,
  `WorkOrderId` int unsigned DEFAULT NULL,
  `DepartmentId` tinyint unsigned DEFAULT NULL,
  `Date` date DEFAULT NULL,
  `IssuedByUserId` int unsigned DEFAULT NULL,
  `IssuedToUserId` int unsigned DEFAULT NULL,
  `DateIssued` date DEFAULT NULL,
  `Remark` varchar(255) DEFAULT NULL,
  `Ref` varchar(255) DEFAULT NULL,
  `USDTotal` decimal(20,2) NOT NULL DEFAULT '0.00',
  `NGNTotal` decimal(20,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`IssueId`),
  KEY `MRId` (`MRId`),
  KEY `WorkOrderId` (`WorkOrderId`),
  KEY `DepartmentId` (`DepartmentId`),
  KEY `IssuedToUserId` (`IssuedToUserId`),
  KEY `IssuedByUserId` (`IssuedByUserId`),
  KEY `IssuedByUserId_2` (`IssuedByUserId`),
  CONSTRAINT `whs_issue_ibfk_1` FOREIGN KEY (`MRId`) REFERENCES `whs_mr` (`MRId`),
  CONSTRAINT `whs_issue_ibfk_2` FOREIGN KEY (`WorkOrderId`) REFERENCES `work_order` (`WorkOrderId`),
  CONSTRAINT `whs_issue_ibfk_3` FOREIGN KEY (`DepartmentId`) REFERENCES `core_department` (`DepartmentId`),
  CONSTRAINT `whs_issue_ibfk_4` FOREIGN KEY (`IssuedByUserId`) REFERENCES `core_user` (`UserId`),
  CONSTRAINT `whs_issue_ibfk_5` FOREIGN KEY (`IssuedToUserId`) REFERENCES `core_user` (`UserId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table whs_issue_item
# ------------------------------------------------------------

DROP TABLE IF EXISTS `whs_issue_item`;

CREATE TABLE `whs_issue_item` (
  `ItemIssueId` int unsigned NOT NULL AUTO_INCREMENT,
  `IssueId` int unsigned NOT NULL,
  `ItemId` int unsigned DEFAULT NULL,
  `VPN` text,
  `Quantity` int unsigned NOT NULL,
  `UnitPrice` decimal(20,2) NOT NULL DEFAULT '0.00',
  `Currency` char(3) DEFAULT NULL,
  `Status` varchar(10) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT 'Open' COMMENT 'open, close',
  PRIMARY KEY (`ItemIssueId`),
  KEY `IssueId` (`IssueId`),
  KEY `ItemId` (`ItemId`),
  CONSTRAINT `whs_issue_item_ibfk_2` FOREIGN KEY (`ItemId`) REFERENCES `whs_item` (`ItemId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table whs_item
# ------------------------------------------------------------

DROP TABLE IF EXISTS `whs_item`;

CREATE TABLE `whs_item` (
  `ItemId` int unsigned NOT NULL AUTO_INCREMENT,
  `Code` varchar(11) DEFAULT NULL,
  `AssetCategoryId` int unsigned DEFAULT NULL,
  `AssetIds` text,
  `UMId` tinyint unsigned DEFAULT NULL,
  `ShelfLocationId` mediumint unsigned DEFAULT NULL,
  `Description` text,
  `VPN` varchar(255) DEFAULT NULL,
  `Reference` text,
  `DepartmentIds` varchar(255) DEFAULT NULL,
  `QOR` decimal(10,2) NOT NULL DEFAULT '0.00',
  `QOO` int DEFAULT '0',
  `QOH` decimal(10,2) DEFAULT '0.00',
  `Currency` char(3) DEFAULT NULL,
  `UnitPrice` decimal(20,2) DEFAULT NULL,
  `MinimumInStore` int unsigned DEFAULT '0',
  `MaximumInStore` int unsigned DEFAULT '0',
  `DateAdded` datetime DEFAULT NULL,
  `CountDue` date DEFAULT NULL,
  `IsCounted` varchar(3) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL DEFAULT 'No',
  `Obsolete` varchar(3) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT 'No',
  `Status` varchar(10) DEFAULT 'Online',
  PRIMARY KEY (`ItemId`),
  KEY `AssetCategoryId` (`AssetCategoryId`),
  KEY `UMId` (`UMId`),
  CONSTRAINT `whs_item_ibfk_1` FOREIGN KEY (`UMId`) REFERENCES `um` (`UMId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table whs_material_received
# ------------------------------------------------------------

DROP TABLE IF EXISTS `whs_material_received`;

CREATE TABLE `whs_material_received` (
  `MaterialReceivedId` int unsigned NOT NULL AUTO_INCREMENT,
  `MRId` int unsigned DEFAULT NULL,
  `Reference` varchar(255) DEFAULT NULL,
  `ReceivedByUserId` int unsigned NOT NULL,
  `NGNTotal` decimal(20,2) NOT NULL DEFAULT '0.00',
  `USDTotal` decimal(20,2) NOT NULL DEFAULT '0.00',
  `Date` date NOT NULL,
  PRIMARY KEY (`MaterialReceivedId`),
  KEY `MRId` (`MRId`),
  KEY `ReceivedByUserId` (`ReceivedByUserId`) USING BTREE,
  CONSTRAINT `whs_material_received_ibfk_1` FOREIGN KEY (`MRId`) REFERENCES `whs_mr` (`MRId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table whs_material_received_item
# ------------------------------------------------------------

DROP TABLE IF EXISTS `whs_material_received_item`;

CREATE TABLE `whs_material_received_item` (
  `MaterialReceivedItemId` int unsigned NOT NULL AUTO_INCREMENT,
  `MaterialReceivedId` int unsigned NOT NULL,
  `ItemId` int unsigned NOT NULL,
  `Quantity` int unsigned NOT NULL,
  `UnitPrice` decimal(18,2) NOT NULL DEFAULT '0.00',
  `Currency` char(3) NOT NULL DEFAULT 'NGN' COMMENT 'NGN, USD',
  `Reference` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`MaterialReceivedItemId`),
  KEY `MaterialReceivedId` (`MaterialReceivedId`),
  KEY `ItemId` (`ItemId`),
  CONSTRAINT `whs_material_received_item_ibfk_1` FOREIGN KEY (`MaterialReceivedId`) REFERENCES `whs_material_received` (`MaterialReceivedId`) ON DELETE CASCADE,
  CONSTRAINT `whs_material_received_item_ibfk_2` FOREIGN KEY (`ItemId`) REFERENCES `whs_item` (`ItemId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table whs_mdn
# ------------------------------------------------------------

DROP TABLE IF EXISTS `whs_mdn`;

CREATE TABLE `whs_mdn` (
  `DeliveryNoteId` int unsigned NOT NULL AUTO_INCREMENT,
  `MRId` int unsigned DEFAULT NULL,
  `RequestedBy` varchar(200) DEFAULT NULL,
  `DeliverToUser` varchar(200) DEFAULT NULL,
  `Destination` varchar(255) DEFAULT NULL,
  `Attn` varchar(255) DEFAULT NULL,
  `ItemFrom` varchar(255) DEFAULT NULL,
  `Requisition` varchar(255) DEFAULT NULL,
  `CreatedByUserId` mediumint unsigned DEFAULT NULL,
  `Date` date DEFAULT NULL,
  `Reference` varchar(255) DEFAULT NULL,
  `Remark` text,
  `HauledBy` varchar(255) DEFAULT NULL,
  `LoadedBy` varchar(255) DEFAULT NULL,
  `VehicleNo` varchar(50) DEFAULT NULL,
  `LoadedDate` datetime DEFAULT NULL,
  PRIMARY KEY (`DeliveryNoteId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table whs_mdn_item
# ------------------------------------------------------------

DROP TABLE IF EXISTS `whs_mdn_item`;

CREATE TABLE `whs_mdn_item` (
  `DNItemId` int unsigned NOT NULL AUTO_INCREMENT,
  `DeliveryNoteId` int unsigned DEFAULT '0',
  `MRItemId` int unsigned DEFAULT NULL,
  `Description` text,
  `Quantity` decimal(10,2) unsigned DEFAULT NULL,
  `Unit` varchar(20) DEFAULT NULL,
  `Status` varchar(10) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT 'Open',
  PRIMARY KEY (`DNItemId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table whs_month_end
# ------------------------------------------------------------

DROP TABLE IF EXISTS `whs_month_end`;

CREATE TABLE `whs_month_end` (
  `MonthEndId` int NOT NULL AUTO_INCREMENT,
  `OpeningBalance` decimal(20,2) DEFAULT NULL,
  `ClosingBalance` decimal(20,2) DEFAULT NULL,
  `Date` date DEFAULT NULL,
  PRIMARY KEY (`MonthEndId`),
  UNIQUE KEY `Date` (`Date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table whs_mr
# ------------------------------------------------------------

DROP TABLE IF EXISTS `whs_mr`;

CREATE TABLE `whs_mr` (
  `MRId` int unsigned NOT NULL AUTO_INCREMENT,
  `DepartmentId` tinyint unsigned DEFAULT NULL,
  `Date` date DEFAULT NULL,
  `DateRequired` date DEFAULT NULL,
  `DateIssued` date DEFAULT NULL,
  `Status` varchar(9) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT 'Open' COMMENT 'o-open, c-close',
  `Note` text,
  `Category` char(1) DEFAULT NULL,
  `WorkOrderId` int unsigned DEFAULT NULL,
  `ServiceRequestId` int unsigned DEFAULT NULL,
  `CreatedByUserId` int unsigned DEFAULT NULL,
  `Currency` char(3) DEFAULT NULL COMMENT 'NGN,USD',
  `TotalValue` decimal(20,2) unsigned DEFAULT NULL,
  `IsAcknowledge` char(1) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT 'n' COMMENT 'y-yes,n-no',
  `IsApproved` char(1) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL DEFAULT 'n' COMMENT 'y-yes, n-no',
  `DateApproved` datetime DEFAULT NULL,
  `DateAcknowledge` datetime DEFAULT NULL,
  `OrderType` char(1) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL DEFAULT 'l' COMMENT 'l-local, i-international',
  `Type` char(2) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT 'SI' COMMENT 'SI - Stock Item, NI - Non Stock Item',
  PRIMARY KEY (`MRId`),
  KEY `DepartmentId` (`DepartmentId`),
  KEY `CreatedByUserId` (`CreatedByUserId`),
  CONSTRAINT `whs_mr_ibfk_1` FOREIGN KEY (`DepartmentId`) REFERENCES `core_department` (`DepartmentId`),
  CONSTRAINT `whs_mr_ibfk_3` FOREIGN KEY (`CreatedByUserId`) REFERENCES `core_user` (`UserId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table whs_mr_item
# ------------------------------------------------------------

DROP TABLE IF EXISTS `whs_mr_item`;

CREATE TABLE `whs_mr_item` (
  `MRItemId` int unsigned NOT NULL AUTO_INCREMENT,
  `MRId` int unsigned NOT NULL,
  `ItemId` int unsigned DEFAULT NULL,
  `VPN` text,
  `Quantity` decimal(20,2) unsigned DEFAULT NULL,
  `UnitPrice` decimal(20,2) unsigned DEFAULT NULL,
  `Status` varchar(10) DEFAULT 'Open',
  PRIMARY KEY (`MRItemId`),
  KEY `MRId` (`MRId`),
  KEY `ItemId` (`ItemId`),
  KEY `ItemId_2` (`ItemId`),
  CONSTRAINT `whs_mr_item_ibfk_1` FOREIGN KEY (`MRId`) REFERENCES `whs_mr` (`MRId`) ON DELETE CASCADE,
  CONSTRAINT `whs_mr_item_ibfk_2` FOREIGN KEY (`ItemId`) REFERENCES `whs_item` (`ItemId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table whs_return
# ------------------------------------------------------------

DROP TABLE IF EXISTS `whs_return`;

CREATE TABLE `whs_return` (
  `ReturnId` int unsigned NOT NULL AUTO_INCREMENT,
  `IssueId` int unsigned DEFAULT NULL,
  `Date` date DEFAULT NULL,
  `ReturnedByUserId` int unsigned DEFAULT NULL,
  `ReturnedToUserId` int unsigned DEFAULT NULL,
  `DateReturned` date DEFAULT NULL,
  `Note` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ReturnId`),
  KEY `ReturnedByUserId` (`ReturnedByUserId`),
  KEY `ReturnedToUserId` (`ReturnedToUserId`),
  KEY `whs_return_ibfk_1` (`IssueId`),
  CONSTRAINT `whs_return_ibfk_1` FOREIGN KEY (`IssueId`) REFERENCES `whs_issue` (`IssueId`),
  CONSTRAINT `whs_return_ibfk_2` FOREIGN KEY (`ReturnedByUserId`) REFERENCES `core_user` (`UserId`),
  CONSTRAINT `whs_return_ibfk_3` FOREIGN KEY (`ReturnedToUserId`) REFERENCES `core_user` (`UserId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table whs_return_item
# ------------------------------------------------------------

DROP TABLE IF EXISTS `whs_return_item`;

CREATE TABLE `whs_return_item` (
  `ItemreturnId` int unsigned NOT NULL AUTO_INCREMENT,
  `ReturnId` int unsigned NOT NULL,
  `ItemId` int unsigned DEFAULT NULL,
  `VPN` text,
  `Quantity` int unsigned DEFAULT NULL,
  `UnitPrice` decimal(20,2) DEFAULT NULL,
  `Status` varchar(10) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT 'Open',
  PRIMARY KEY (`ItemreturnId`),
  KEY `ReturnId` (`ReturnId`),
  KEY `ItemId` (`ItemId`),
  CONSTRAINT `whs_return_item_ibfk_1` FOREIGN KEY (`ReturnId`) REFERENCES `whs_return` (`ReturnId`) ON DELETE CASCADE,
  CONSTRAINT `whs_return_item_ibfk_2` FOREIGN KEY (`ItemId`) REFERENCES `whs_item` (`ItemId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table work_order
# ------------------------------------------------------------

DROP TABLE IF EXISTS `work_order`;

CREATE TABLE `work_order` (
  `WorkOrderId` int unsigned NOT NULL AUTO_INCREMENT,
  `ServiceRequestId` int unsigned DEFAULT NULL,
  `AssetFailureReportId` int unsigned DEFAULT NULL,
  `MRId` int unsigned DEFAULT NULL,
  `PMTaskId` int unsigned DEFAULT NULL,
  `AssetId` int unsigned DEFAULT NULL,
  `AssetLocationIds` varchar(255) DEFAULT NULL,
  `DepartmentId` tinyint unsigned DEFAULT NULL,
  `UnitId` tinyint unsigned DEFAULT NULL COMMENT '0',
  `CreatedByUserId` int unsigned DEFAULT NULL,
  `DateOpened` date DEFAULT NULL,
  `DateDue` date DEFAULT NULL,
  `Status` varchar(20) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT NULL,
  `EstimateManHours` float NOT NULL DEFAULT '0',
  `Description` tinytext,
  `WorkDetails` text,
  `SafetyRequirement` text,
  `WorkClassId` tinyint unsigned DEFAULT NULL,
  `DateClosed` date DEFAULT NULL,
  `SupervisedByUserId` int unsigned DEFAULT NULL,
  `WorkDone` text,
  `ClosedByUserId` int unsigned DEFAULT NULL,
  `ManHours` float unsigned DEFAULT NULL,
  `TotalCost` decimal(20,2) unsigned NOT NULL DEFAULT '0.00',
  `JobFlag` varchar(100) DEFAULT '1',
  `WorkingForId` tinyint DEFAULT '1',
  `SupervisedApprovedDate` datetime DEFAULT NULL,
  `Status2` varchar(50) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT NULL,
  `SentToUserId` int unsigned DEFAULT NULL,
  `WHApprovedDate` datetime DEFAULT NULL,
  `WHUserId` int unsigned DEFAULT NULL,
  `FSApprovedDate` datetime DEFAULT NULL,
  `FSUserId` int unsigned DEFAULT NULL,
  PRIMARY KEY (`WorkOrderId`),
  KEY `ServiceRequestId` (`ServiceRequestId`),
  KEY `MRId` (`MRId`),
  KEY `PMTaskId` (`PMTaskId`),
  KEY `AssetId` (`AssetId`),
  KEY `DepartmentId` (`DepartmentId`),
  KEY `WorkClassId` (`WorkClassId`),
  KEY `SupervisedByUserId` (`SupervisedByUserId`),
  KEY `ClosedByUserId` (`ClosedByUserId`),
  KEY `UnitId` (`UnitId`),
  KEY `CreatedByUserId` (`CreatedByUserId`),
  CONSTRAINT `work_order_ibfk_1` FOREIGN KEY (`WorkClassId`) REFERENCES `job_class` (`JobClassId`),
  CONSTRAINT `work_order_ibfk_10` FOREIGN KEY (`ServiceRequestId`) REFERENCES `service_request` (`ServiceRequestId`),
  CONSTRAINT `work_order_ibfk_2` FOREIGN KEY (`AssetId`) REFERENCES `asset` (`AssetId`),
  CONSTRAINT `work_order_ibfk_3` FOREIGN KEY (`DepartmentId`) REFERENCES `core_department` (`DepartmentId`),
  CONSTRAINT `work_order_ibfk_5` FOREIGN KEY (`MRId`) REFERENCES `whs_mr` (`MRId`),
  CONSTRAINT `work_order_ibfk_6` FOREIGN KEY (`PMTaskId`) REFERENCES `pm_task` (`PMTaskId`),
  CONSTRAINT `work_order_ibfk_7` FOREIGN KEY (`UnitId`) REFERENCES `core_unit` (`UnitId`),
  CONSTRAINT `work_order_ibfk_8` FOREIGN KEY (`CreatedByUserId`) REFERENCES `core_user` (`UserId`),
  CONSTRAINT `work_order_ibfk_9` FOREIGN KEY (`ClosedByUserId`) REFERENCES `core_user` (`UserId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table work_order_item
# ------------------------------------------------------------

DROP TABLE IF EXISTS `work_order_item`;

CREATE TABLE `work_order_item` (
  `WorkOrderItemId` int unsigned NOT NULL AUTO_INCREMENT,
  `WorkOrderId` int unsigned DEFAULT NULL,
  `ItemId` int unsigned DEFAULT NULL,
  `Description` text,
  `Purpose` varchar(255) DEFAULT NULL COMMENT 'For what?',
  `UnitPrice` decimal(20,2) DEFAULT '0.00',
  `Quantity` decimal(20,2) DEFAULT NULL,
  `Currency` char(3) NOT NULL DEFAULT 'NGN',
  `Status` varchar(10) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT 'Open' COMMENT 'open, close',
  PRIMARY KEY (`WorkOrderItemId`),
  KEY `WorkOrderId` (`WorkOrderId`),
  KEY `ItemId` (`ItemId`),
  CONSTRAINT `work_order_item_ibfk_1` FOREIGN KEY (`WorkOrderId`) REFERENCES `work_order` (`WorkOrderId`) ON DELETE CASCADE,
  CONSTRAINT `work_order_item_ibfk_2` FOREIGN KEY (`ItemId`) REFERENCES `whs_item` (`ItemId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;




/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
