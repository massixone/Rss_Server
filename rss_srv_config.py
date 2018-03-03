# -*- coding:utf-8, indent=tab, tabstop=4 -*-
#
# See 'LICENSE'  for copying
#
# Basic configuration file for RSS Server
#
# [Database]
DB_TYPE  = mysql
DB_DNAME = rsssrvdb
DB_HOST  = localhost
DB_USER  = rssdb
DB_PASS  = rssdbpwd

# [Network]
SRV_ADDRESS  = 127.0.0.1    # the IP address to listen on (0.0.0.0 means all addresses)
SRV_PROTOCOL = tcp          # Protocol UDP or TCP
SRV_PORT     = 15000        # The TCP/UDP port to linten

