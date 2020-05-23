@echo off
net stop MSSQL$SQLEXPRESS
del "C:\Program Files\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQL\DATA\ProcessTree.mdf"
del "C:\Program Files\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQL\DATA\ProcessTree_log.ldf"
copy "C:\Users\khaledi\Desktop\E-Constitution\ProcessTree\ProcessTree.mdf" "C:\Program Files\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQL\DATA\ProcessTree.mdf"
copy "C:\Users\khaledi\Desktop\E-Constitution\ProcessTree\ProcessTree_log.LDF" "C:\Program Files\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQL\DATA\ProcessTree_log.ldf"
net start MSSQL$SQLEXPRESS
