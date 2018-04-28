/*
File:   mysql/create-user.sql
        -*- coding:utf-8, indent=tab, tabstop=4 -*-
See 'LICENSE'  for copying
NOTES:
    This is a SQL script that will be user do create the proper MySQL user for the RssSrv to access the database. 
    It ust be run manually right after the database creation.

EXECUTION
    # mysql -u root -p<root-password>  < mysql/create-user.sql


*/

-- Enter SQL statements here below.

DROP USER rss@'localhost';
CREATE USER rss@'localhost' IDENTIFIED BY 'rss';
GRANT ALL ON rss_data.* TO rss@'localhost';
FLUSH PRIVILEGES;
