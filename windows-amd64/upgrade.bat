:: Node Upgrade Script 

@echo off
if not exist %userprofile%\node-pem-backup mkdir %userprofile%\node-pem-backup
if not exist %userprofile%\node-pem-backup\db_backup mkdir %userprofile%\node-pem-backup\db_backup

cd %GOPATH%\src\github.com\ElrondNetwork\elrond-go\cmd\node\config

::backup your keys
copy /Y initialBalancesSk.pem %userprofile%\node-pem-backup
copy /Y initialNodesSk.pem %userprofile%\node-pem-backup
:: Backup your database
robocopy /E %GOPATH%\src\github.com\ElrondNetwork\elrond-go\cmd\node\db %userprofile%\node-pem-backup\db_backup

cd %GOPATH%\src\github.com\ElrondNetwork

:: Delete previously cloned repos

@RD /S /Q "%GOPATH%\src\github.com\ElrondNetwork\elrond-go"
if exist "%GOPATH%\src\github.com\ElrondNetwork\elrond-go" @RD /S /Q "%GOPATH%\src\github.com\ElrondNetwork\elrond-go"
@RD /S /Q "%GOPATH%\src\github.com\ElrondNetwork\elrond-config"
if exist "%GOPATH%\src\github.com\ElrondNetwork\elrond-config" @RD /S /Q "%GOPATH%\src\github.com\ElrondNetwork\elrond-config"
timeout 15
if exist "%GOPATH%\src\github.com\ElrondNetwork\elrond-go" @RD /S /Q "%GOPATH%\src\github.com\ElrondNetwork\elrond-go"
if exist "%GOPATH%\src\github.com\ElrondNetwork\elrond-config" @RD /S /Q "%GOPATH%\src\github.com\ElrondNetwork\elrond-config"

cd %userprofile%
SET BINTAG=v1.0.24
SET CONFTAG=BoN-ph1-w1-p1
cd %GOPATH%\src\github.com\ElrondNetwork

:: Clone elrond-go & elrond-config repos
git clone --branch %BINTAG% https://github.com/ElrondNetwork/elrond-go
git clone --branch %CONFTAG% https://github.com/ElrondNetwork/elrond-config

if not exist "%GOPATH%\src\github.com\ElrondNetwork" mkdir %GOPATH%\src\github.com\ElrondNetwork
cd %GOPATH%\src\github.com\ElrondNetwork
cd %GOPATH%\src\github.com\ElrondNetwork\elrond-config
copy /Y *.* %GOPATH%\src\github.com\ElrondNetwork\elrond-go\cmd\node\config

:: Build the node executable
cd %GOPATH%\pkg\mod\cache
del /s *.lock
cd %GOPATH%\src\github.com\ElrondNetwork\elrond-go\cmd\node

@echo on
SET GO111MODULE=on
go mod vendor
go build -i -v -ldflags="-X main.appVersion=%BINTAG%"
@echo off

:: restore your keys
cd %userprofile%\node-pem-backup
copy /Y initialBalancesSk.pem %GOPATH%\src\github.com\ElrondNetwork\elrond-go\cmd\node\config
copy /Y initialNodesSk.pem %GOPATH%\src\github.com\ElrondNetwork\elrond-go\cmd\node\config

:: restore your db
robocopy /E %userprofile%\node-pem-backup\db_backup %GOPATH%\src\github.com\ElrondNetwork\elrond-go\cmd\node\db 
@RD /S /Q "%userprofile%\node-pem-backup\db_backup"

cd %GOPATH%\src\github.com\ElrondNetwork\elrond-go\cmd\node
node.exe