#!/usr/bin/env python
# -*- coding:utf-8, indent=tab, tabstop=4 -*-
#
# See 'LICENSE'  for copying
#
"""
Class rss_mysql
"""

import rss_srv_config as cfg
import pymysql
import logging
from os import system
import os
import json
#


class Rss_Mysql():
    """ The MySQL Class"""

    def __init__(self):     #, db_host, db_name, db_user, db_paswd):
        self.sqlVect = []                           # String vector for an ordered sequence of SQL statement to be executed
        self.check_database_connection()
        self.verify_database_structure_update()

    def check_database_connection(self):
        try:
            self.dbconn = pymysql.connect(host=cfg.DB_HOST, user=cfg.DB_USER, passwd=cfg.DB_PASS, db=cfg.DB_DNAME)
        except:
            logging.debug("Error while accessing database")
        finally:
            self.dbconn.close()

    def verify_database_structure_update(self):
        baseName = './mysql/rss_dbupdate_'
        logging.debug('Checking for MySQL Update files. Please wait...')
        for f in range(0,999):        #for f in range(0,99999):
            fileName = baseName + "%05d" % f
            #logging.debug('Checking file: + [' + fileName + ']')
            if os.path.isfile(fileName):
                command = """mysql -u %s -p"%s" --host %s --port %s %s < %s""" % (cfg.DB_USER, cfg.DB_PASS, cfg.DB_HOST, int(cfg.DB_PORT), cfg.DB_DNAME, fileName)
                logging.debug('Executing MySQL file: [' + fileName + ']')
                system(command)

    def exec_sql_file (self, fn):
        try:
            conn = pymysql.connect(host=cfg.DB_HOST, user=cfg.DB_USER, passwd=cfg.DB_PASS, db=cfg.DB_DNAME)
        except:
            logging.debug("Error while accessing database")

        # execute SQL file against the DB

    def splash_data_to_db(self, rData):
        """Parses received raw data (rData) and loads as json dictionary.
        Then build the appropriated SQL Statement to stick data into the DB"""
        jData = json.loads(rData.decode("utf-8"))           # Load JSON

        self.sqlVect = []                        # Array containing all SQL statements to be executed for received message
        #logging.debug("step 1" + str(jData["cmd"]))

        if jData['cmd'] == 'CHM':       # Client Hallo Message
            #logging.debug("step 2")
            # If not already present, insert new device i(lost CHM or any other previous message from this client?).
            # Otherwise, only update the status
            self.sqlVect.append("INSERT INTO devices (client_id, device_type, last_heartbit, status) VALUES ('"
                                + str(jData['client_id'])   + "', '"
                                + str(jData['device_type']) + "', '"
                                + str(jData['timestamp'])   + "', 1) "
                                + "ON DUPLICATE KEY UPDATE status = 1"
                                )

            # Insert this new event in the 'events' table
            self.sqlVect.append("INSERT INTO events (time_stamp, client_id, event_type, event_note) VALUES ('"
                                + str(jData['timestamp'])   +  "', '"
                                + str(jData['client_id'])   + "', '"
                                + 'CHM'                     + "', '"
                                + 'RSS Client Connected'    + ")"
                                )

            #logging.debug("step 3")
        if jData['cmd'] == 'CHB':       # Client Hearth Bit
            self.sqlVect.append("UPDATE devices SET device_last_heartbit = '"
                                + jData['timestamp']
                                + "' WHERE device_serial ='"
                                + jData['clid'] + "'")

        if jData['cmd'] == 'CCA':       # Client Config Affirm
            # To be implemented soon
            self.sqlVect.append('')

        if jData['cmd'] == 'CZM':       # Client Zap Messagge
            self.sqlVect.append('UPDATE devices SET status = - WHERE client_id = "' + str(jData['client_id'])   + "'")
            self.sqlVect.append("INSERT INTO events (time_stamp, client_id, event_type, event_note) VALUES ('"
                                + str(jData['timestamp'])   +  "', '"
                                + str(jData['client_id'])   + "', '"
                                + 'CHM'                     + "', '"
                                + 'RSS Client Disconnected'    + ")"
                                )


        logging.debug("Connecting to the database")
        self.dbconn = pymysql.connect(host=cfg.DB_HOST, user=cfg.DB_USER, passwd=cfg.DB_PASS, db=cfg.DB_DNAME, cursorclass=pymysql.cursors.DictCursor)
        for sqlStmt in self.sqlVect:
            try:
                with self.dbconn.cursor() as cursor:
                    logging.debug("Executing SQL Statement: " + sqlStmt)
                    self.dbconn.cursor().execute(sqlStmt)
            except Exception as e:
                logging.debug('Error while executing SQL statement: [' + str(e) +']')
            #finally:
            #    if sqlStmt.find('INSERT') or sqlStmt.find('DELETE') or sqlStmt.find('UPDATE'):

        logging.debug('Committing db statement')
        self.dbconn.commit()
        logging.debug('Committing db statement')
        self.dbconn.close()
        return
