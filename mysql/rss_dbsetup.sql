/*
File:   MySQL Initial database initial setup
    -*- coding:utf-8, indent=tab, tabstop=4 -*-

See 'LICENSE'  for copying

This file is the initial database setup or RSS Server and it is executed only at the installation time.

Although, for any subsequent database structure modification, there can be other files named 'rss_dbupdate_nnnnn.sql',
where 'nnnn' is a number from 00000 to 99999, which will contain all the SQL statements.

It is important here to highlight that all the database update script files 'rss_dbupdate_nnnnn.sql' will be
executed in alphbetical order.
*/

-- Uncomment the following line if you wanna drop all RSS database objects
DROP DATABASE IF EXISTS rss_data;
DROP USER `rss@localhost`;
DROP USER `admin@localhost`;
DROP USER `rss`@`%`;

-- Uncomment the following lines il you want to allow rss admin username from a remote client
GRANT ALL PRIVILEGES ON rss_data.* TO `rss`@`%` identified by 'rsspwd';


CREATE DATABASE IF NOT EXISTS rss_data;
CREATE USER `rss@localhost` identified by 'rsspwd';
GRANT USAGE,INSERT,SELECT,UPDATE ON rss_data.* TO `rss@localhost`;
CREATE USER `admin@localhost` identified by 'admin';
GRANT ALL ON rss_data.* TO `admin@localhost`;

/*
-- Begin RSS object creation
*/
USE rss_data;

-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema rss_data
-- -----------------------------------------------------
-- The RSS Server Database

-- -----------------------------------------------------
-- Schema rss_data
--
-- The RSS Server Database
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `rss_data` DEFAULT CHARACTER SET utf8 ;
USE `rss_data` ;

-- -----------------------------------------------------
-- Table `rss_data`.`devices_status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `rss_data`.`devices_status` (
  `devices_status_id` BIGINT NOT NULL,
  `devices_status_name` VARCHAR(45) NOT NULL,
  `devices_status_desciption` VARCHAR(45) NULL,
  PRIMARY KEY (`devices_status_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `rss_data`.`device_config`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `rss_data`.`device_config` (
  `device_config_id` BIGINT NOT NULL COMMENT '  ',
  `device_config_json` VARCHAR(255) NULL,
  `device_config_description` TEXT NULL,
  PRIMARY KEY (`device_config_id`))
ENGINE = InnoDB
COMMENT = 'contains all configuration parameter of all devices';


-- -----------------------------------------------------
-- Table `rss_data`.`devices`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `rss_data`.`devices` (
  `device_id` BIGINT NOT NULL AUTO_INCREMENT,
  `device_serial` VARCHAR(45) NULL,
  `device_ip` CHAR(20) NOT NULL,
  `device_status` INT NOT NULL DEFAULT 0,
  `device_geo_lat` REAL NULL,
  `device_geo_lon` REAL NULL,
  `device_geo_alt` REAL NULL,
  `device_type` REAL NOT NULL,
  PRIMARY KEY (`device_id`),
  CONSTRAINT `fk_devices_status`
    FOREIGN KEY (`device_id`)
    REFERENCES `rss_data`.`devices_status` (`devices_status_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_devices_serial`
    FOREIGN KEY (`device_id`)
    REFERENCES `rss_data`.`device_config` (`device_config_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Device Table. Contains all RSS Devies';


-- -----------------------------------------------------
-- Table `rss_data`.`motion_data`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `rss_data`.`motion_data` (
  `motion_id` BIGINT NOT NULL AUTO_INCREMENT,
  `motion_device_id` BIGINT NOT NULL,
  `motion_data_x` BIGINT NOT NULL DEFAULT -1,
  `motion_data_y` BIGINT NOT NULL DEFAULT -1,
  `motion_data_z` BIGINT NOT NULL DEFAULT -1,
  PRIMARY KEY (`motion_id`),
  INDEX `fk_motion_data_device_idx` (`motion_device_id` ASC),
  CONSTRAINT `fk_motion_data_device`
    FOREIGN KEY (`motion_device_id`)
    REFERENCES `rss_data`.`devices` (`device_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Contains all motion data for a given device';


-- -----------------------------------------------------
-- Table `rss_data`.`environment data`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `rss_data`.`environment data` (
  `environ_id` BIGINT NOT NULL AUTO_INCREMENT,
  `environ_device_id` BIGINT NOT NULL,
  `environ timestamp` DATETIME NOT NULL,
  `environ temperature` DOUBLE NULL DEFAULT -1,
  `environ humidity` DOUBLE NULL DEFAULT -1,
  `environ_pressure` DOUBLE NULL DEFAULT -1,
  `environ_altitude` DOUBLE NULL DEFAULT -1,
  PRIMARY KEY (`environ_id`),
  INDEX `fk_environment device_idx` (`environ_device_id` ASC),
  CONSTRAINT `fk_environment device`
    FOREIGN KEY (`environ_device_id`)
    REFERENCES `rss_data`.`devices` (`device_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Contains all environmental data for any gived device (for future release)';


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


