-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema rss_data
-- -----------------------------------------------------
-- The RSS Server Database
DROP SCHEMA IF EXISTS `rss_data` ;

-- -----------------------------------------------------
-- Schema rss_data
--
-- The RSS Server Database
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `rss_data` DEFAULT CHARACTER SET utf8 ;
USE `rss_data` ;

-- -----------------------------------------------------
-- Table `rss_data`.`devices`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rss_data`.`devices` ;

CREATE TABLE IF NOT EXISTS `rss_data`.`devices` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `client_id` VARCHAR(45) NULL,
  `ip` CHAR(20) NULL,
  `status` INT NOT NULL DEFAULT 0 COMMENT 'Device Status: 0=Offline, 1=online',
  `geo_latitude` REAL NULL DEFAULT NULL,
  `geo_longitude` REAL NULL DEFAULT NULL,
  `geo_altitude` REAL NULL DEFAULT NULL,
  `device_type` VARCHAR(60) NULL DEFAULT 'UNKNOWN' COMMENT 'Device Type: RPI1, RPI2A, RPI2B ',
  `last_heartbit` DATETIME NULL COMMENT 'Last heartbit received',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COMMENT = 'Device Table. Contains all RSS Devies';


-- -----------------------------------------------------
-- Table `rss_data`.`device_config`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rss_data`.`device_config` ;

CREATE TABLE IF NOT EXISTS `rss_data`.`device_config` (
  `id` BIGINT NOT NULL COMMENT '    ',
  `json` VARCHAR(255) NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COMMENT = 'contains all configuration parameter of all devices';


-- -----------------------------------------------------
-- Table `rss_data`.`devices_status`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rss_data`.`devices_status` ;

CREATE TABLE IF NOT EXISTS `rss_data`.`devices_status` (
  `devices_status_id` BIGINT NOT NULL,
  `devices_status_name` VARCHAR(45) NOT NULL,
  `devices_status_desciption` VARCHAR(45) NULL,
  PRIMARY KEY (`devices_status_id`))
ENGINE = InnoDB
COMMENT = 'Static status values';


-- -----------------------------------------------------
-- Table `rss_data`.`motion_data`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rss_data`.`motion_data` ;

CREATE TABLE IF NOT EXISTS `rss_data`.`motion_data` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `device_id` BIGINT NOT NULL,
  `data_x` BIGINT NOT NULL DEFAULT -1,
  `data_y` BIGINT NOT NULL DEFAULT -1,
  `data_z` BIGINT NOT NULL DEFAULT -1,
  PRIMARY KEY (`id`),
  INDEX `fk_motion_data_device_idx` (`device_id` ASC),
  CONSTRAINT `fk_motion_data_device`
    FOREIGN KEY (`device_id`)
    REFERENCES `rss_data`.`devices` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Contains all motion data for a given device';


-- -----------------------------------------------------
-- Table `rss_data`.`environment data`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rss_data`.`environment data` ;

CREATE TABLE IF NOT EXISTS `rss_data`.`environment data` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `device_id` BIGINT NOT NULL,
  `update_timestamp` DATETIME NOT NULL,
  `temperature` DOUBLE NULL DEFAULT -1,
  `humidity` DOUBLE NULL DEFAULT -1,
  `pressure` DOUBLE NULL DEFAULT -1,
  `altitude` DOUBLE NULL DEFAULT -1,
  PRIMARY KEY (`id`),
  INDEX `fk_environment device_idx` (`device_id` ASC),
  CONSTRAINT `fk_environment device`
    FOREIGN KEY (`device_id`)
    REFERENCES `rss_data`.`devices` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Contains all environmental data for any gived device (for future release)';


-- -----------------------------------------------------
-- Table `rss_data`.`device_status_hist`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rss_data`.`device_status_hist` ;

CREATE TABLE IF NOT EXISTS `rss_data`.`device_status_hist` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `device_id` BIGINT NOT NULL COMMENT 'the device id',
  `timestamp` DATETIME NULL COMMENT 'tmestamp when the status changed',
  `current` INT NULL COMMENT 'current tatus at the time of timestamp',
  PRIMARY KEY (`id`),
  INDEX `fk_device_status_hist_1_idx` (`device_id` ASC),
  CONSTRAINT `fk_device_status_hist_1`
    FOREIGN KEY (`device_id`)
    REFERENCES `rss_data`.`devices` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Device status history is recorded here for any status changedevice_st_hist_timestamp';


-- -----------------------------------------------------
-- Table `rss_data`.`events`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `rss_data`.`events` ;

CREATE TABLE IF NOT EXISTS `rss_data`.`events` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `timestamp` DATETIME NULL COMMENT 'The timestamp as received by the cliet',
  `client_id` VARCHAR(45) NULL COMMENT 'The client ID that triggered this event',
  `type` VARCHAR(45) NULL COMMENT 'Type of event',
  `event_note` VARCHAR(45) NULL COMMENT 'A string describing the event in details',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COMMENT = 'The event table. This is where all events are recorded';


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

