# -*- coding:utf-8, indent=tab, tabstop=4 -*-
#
# See 'LICENSE'  for copying
#
# Basic configuration file for RSS Server
#
# [Database]
DB_TYPE  = 'mysql'
DB_DNAME = 'rss_data'
DB_HOST  = 'localhost'
DB_USER  = 'rss'
DB_PASS  = 'rsspwd'
DB_PORT  = 3306

# [Network]
#TCP_SERVER_ADDRESS  = '127.0.0.1'  # the IP address to listen on (0.0.0.0 means all addresses)
TCP_SERVER_ADDRESS  = '0.0.0.0'     # the IP address to listen on (0.0.0.0 means all addresses)
TCP_SERVER_PROTOCOL = 'tcp'         # Protocol UDP or TCP
TCP_SERVER_PORT     = 15000         # The TCP/UDP port to linten
TCP_TIMEOUT         = 60            # Client timeout. Disconnect after this seconds of client inactivity
TCP_RECVBUFF        = 4096          # The size of receive buffer in bytes

# [Logging]
LOG_FILENAME = './rss_svr.log'      # Log file name, or 'None' for tty output only
LOG_LEVEL = 'DEBUG'                 # Debug Level. One of: 'CRITICAL', 'ERROR', 'WARNING', 'INFO' or 'DEBUG'