# Rss_Server - for experimental Accel software

Simple code example for a RSS Server which can receive and store data sent by a RSS Device.

This is a very basic collection of codesneeded to setup a server which is capabe of receive acceleration data and to store in a MySQL database.

## Depencency and related readings:
1. README.md of the mma8451 - Accel experimental software at https://github.com/massixone/mma8451/blob/master/README.md
2. MySQL 5.5 Reference Manual at  https://dev.mysql.com/doc/refman/5.5/en/
3. MySQL Workbench at https://dev.mysql.com/doc/workbench/en/

# Initial Preparation
## RSS Server Software preparation
1. Install all needed software in the Raspberry Pi candidate server
```
    sudo apt-get update && sudo apt-get upgrade
    sudo apt-get install build-essential python-dev
    sudo apt-get install mysql-server mysql-client
    sudo apt-get install libmysqlclient-dev python-mysqldb
```
2. Install Python Mysql Client
```
    sudo pip install mysqlclient
```
  or
```  
    sudo pip install pymysql
```

3. Install the RSS Server Python software
```
    git clone https://github.com/massixone/Rss_Server
```
## Rss Database Initialization
In order to initialize the database, you can execute the file ```./sql/rss_dbsetup.sql``` by running mysql as follows:

```
    $ mysql -u root -p<root_password> < ./mysql/rss_dbsetup.sql
```    


## Rss Server Basic Configuration File
The server configuration file is named ```rss_srv_config.py``` and can be found in the application root directory.
The very basic configuration required for the server is shown here below.
Please nothe that the sample Server configuration refers to a Single-Machine architecture (see Notes below).
```
# [Database]
DB_TYPE  = 'mysql'              # Databas type (only 'mysql' is supported so far)
DB_DNAME = 'rsssrvdb'           # Database Name
DB_HOST  = 'localhost'          # Hostname or IP Address of the machine hosting MySQL
DB_USER  = 'rssdb'              # Database username
DB_PASS  = 'rssdbpwd'           # Database password

# [Network]
SRV_ADDRESS  = '127.0.0.1'    # the IP address to listen on (0.0.0.0 means all addresses)
SRV_PROTOCOL = 'tcp'          # Protocol UDP or TCP
SRV_PORT     = '15000'        # The TCP/UDP port to linten
```
# Startup task sequence
When ready, follow the startup sequence here below.

1. Have the RSS Device up and running (Please refer to  mma8451 - Accel experimental software at https://github.com/massixone/mma8451/blob/master/README.md)

2. Configure the RSS Device to communicate with RSS Server
3. Start the RSS Server software
4. Start the Rss Device sorfware (the client)

# Notes
If you have 2 Raspberry Pi you can implement a Two-Machines architcture, like dpicted in the diagram below.
```
     +--------------+             +--------------+
     | Raspberry Pi |   Network   | Raspberry Pi |
     | Rss Device   |<----------> | Rss Server   |
     +--------------+             +--------------+
```

Although, for testing purposes, a Single-Machine architecture, in which the same Raspberry can act as a server and as a client at the same time.


 -- TO BE COMPLETED --

