import pyodbc
from sqlalchemy import create_engine
colour_list=["orange", "green",'Maroon', "blue", "purple",'Salmon',
             'indigo','Olive','Turquoise', "red",'thistle',
             'springgreen','yellow']
def init_connect():
    
    DRIVER = "ODBC Driver 17 for SQL Server"
    USERNAME = "sa"
    PSSWD = "12345"
    SERVERNAME = "LAPTOP-KT3VMVC6"
    INSTANCENAME = "\SQLEXPRESS"
    DB = "AdventureWorks2019"

    conn= create_engine(
    f"mssql+pyodbc://{USERNAME}:{PSSWD}@{SERVERNAME}{INSTANCENAME}/{DB}?driver={DRIVER}", 
    fast_executemany=True
    )
    return conn
    