import mysql.connector
db = mysql.connector.connect(
    host="localhost",
    user="root",
    passwd="1234",
    database = 'pythonDB')
cursor = db.cursor()
cursor.execute("CREATE DATABASE IF NOT EXISTS pythonDB")