import os


class Config(object):
    MYSQL_HOST = os.environ['MYSQL_HOST']
    MYSQL_DBNAME = os.environ['MYSQL_DBNAME']
    MYSQL_USER = os.environ['MYSQL_USER']
    MYSQL_PASSWORD = os.environ['MYSQL_PASSWORD']
