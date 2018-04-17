#!/usr/bin/env python
# -*- coding:utf-8, indent=tab, tabstop=4 -*-
#
# See 'LICENSE'  for copying
#
"""Simple code example for RSS Server for a Raspberry Pi client equipped with Adafruit MMA8452 3-axis Accelerometer
This experimental code is intended for running a server which can receive all data sent by RSS Client (RSS Device)
Ad store in a MySQL Database for later data analysis and graph representation
"""

__author__ = 'Massimo Di Primio'
__copyright__ = 'Copyright 2016, dpmiictc'
__credits__ = ['Massimo Di Primio']
__license__ = 'GNU GENERAL PUBLIC LICENSE Version 3'
__version__ = '0.0.1'
__deprecated__ = 'None so far'
__date__ = '2017-01-03'
__maintainer__ = 'Massimo Di Primio'
__email__ = 'massimo@diprimio.com'
__status__ = 'Testing'

import sys
import socket
import threading
import logging
import rss_srv_config as cfg
import rss_srv_mysql
#import os
#import os.error
#import errno

import time
import json

# Threaded Server Class
class ThreadedServer(object):
    def __init__(self, host, port):
        self.host = host
        self.port = port
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.sock.bind((self.host, self.port))
        self.sock.setblocking(1)
        self.db = rss_srv_mysql.Rss_Mysql()

    def listen(self):
        logging.debug('Waiting or client connection...')
        self.sock.listen(1)
        while True:
            client, address = self.sock.accept()
            logging.debug('New connection from' + " address " + str(address))
            try:
                # Make a new thread
                logging.debug('Starting new thread...')
                threading.Thread(target = self.threadReceiveFromClient, name = str(address), args=(client, address)).start()
                logging.debug('Current Number of threads: ' + str(threading.active_count()))
            except:
                logging.debug('Unknown error on socket:' + str(address))

    def threadReceiveFromClient(self, client, address):
        while True:
            #self.sock.settimeout(0)   #self.sock.settimeout(cfg.TCP_TIMEOUT)
            try:
                data = client.recv(cfg.TCP_RECVBUFF)
                if data:
                    logging.debug('Data Received from: ' + str(address))
                    ##response = data
                    ##client.send(response)   # whant to echo received data ?
                    logging.debug("Received data:" + data +"\n")
                    #dData = data.decode("utf-8")
                    #logging.debug("Received dData:" + dData + "\n")
                    #jData = json.loads(data.decode("utf-8"))
                    #logging.debug("unknown error:" + jData)
                    self.db.splash_data_to_db(data)
                else:
                    logging.debug('empty data from client')
                    break
            except Exception as e:
                logging.debug('TypeError:' + str(e))
            except Exception as e: # self.sock.error as e:
                logging.debug('Exception: '+ str(e))
                #break       #return False
        logging.debug('Thread terminating')
        self.sock.close()
        return False


if __name__ == "__main__":

    # Setup Logger
    logFormat = '[%(asctime)s.%(levelname)s] (%(name)s.%(threadName)-10s) : %(message)s'
    logger = logging.getLogger()
    logger.setLevel(logging.DEBUG)
    # create console handler and set level to debug
    ch = logging.StreamHandler()
    # Set logging level with ch.setLevel(logging.<level>)
    if cfg.LOG_LEVEL == 'DEBUG':    ch.setLevel(logging.DEBUG)
    if cfg.LOG_LEVEL == 'INFO':     ch.setLevel(logging.INFO)
    if cfg.LOG_LEVEL == 'WARNING':  ch.setLevel(logging.WARNING)
    if cfg.LOG_LEVEL == 'ERROR':    ch.setLevel(logging.ERROR)
    if cfg.LOG_LEVEL == 'CRITICAL': ch.setLevel(logging.CRITICAL)
    # create formatter
    formatter = logging.Formatter(logFormat)
    # add formatter to ch
    ch.setFormatter(formatter)
    # add ch to logger
    logger.addHandler(ch)

    # Initialize Database
    import rss_srv_mysql
    db = rss_srv_mysql.Rss_Mysql()


    # Start accepting connections
    ThreadedServer(cfg.TCP_SERVER_ADDRESS, int(cfg.TCP_SERVER_PORT)).listen()
    logging.debug('Server exit')
    sys.exit()
