:start
@echo off
title MSGER
color 02
cd %appdata%
IF exist "msger.data\*.*" goto :startdata
IF NOT exist "msger.data\*.*" goto :menu

:startdata
set /p callbackstatus=<callback.txt
if /i "%callbackstatus%"=="true" do set "callback=/W"
if /i "%callbackstatus%"=="false" do set "callback="
pause
goto :menu

:menu
title MSGER
color 02
cd /d %~dp0
cls
echo Vous voulez ?
echo.
echo [1] Obtenir le nom de la machine ? 
echo [2] Envoyer un msg un autre PC ?
echo [3] Creer les fichiers data. 
echo [4] Sauvegarder les donnees actuelle (Utilisateur et PC cible). MARCHE UNIQUEMENT SI LES FICHIERS DATA ONT ETE CREER ! 
echo [5] Supprimer les fichier de data.
echo [6] Envoyer un message au pc enregistrer.
echo.
set /p choix1= " > "
if /i "%choix1%"=="1" goto :hostname
if /i "%choix1%"=="2" goto :msg
if /i "%choix1%"=="3" goto :cdata
if /i "%choix1%"=="4" goto :sdata
if /i "%choix1%"=="5" goto :ddata
if /i "%choix1%"=="6" goto :rdata
if /i "%choix1%"=="7" goto :callback
if /i "%choix1%"=="DEBUG" goto :debug
pause
exit

:hostname
cls
title MSGER - HOSTNAME DISPLAY
echo LE NOM DE VOTRE MACHINE EST:
echo.
hostname
echo.
echo.
echo.
echo CONTINUER EFFACERA CECI !
echo.
echo.
echo.
pause
goto :menu

:msg
title MSGER - MESSAGE SEND
cls
echo Quelle est l'utilisateur cible ? * definie tout les utilisateur conneter au meme PC.
echo.
set /p user= " > "
echo.
echo Quelle est le nom de la machine cible ?
echo.
set /p target= " > "
goto msgsender

:msgsender
cls
msg %user% /SERVER:%target% /V %callback%
pause
goto :menu

:cdata
cls
title MSGER - Create Data Files
cd %appdata%
IF exist "msger.data\*.*" goto :cdataexist
IF NOT exist "msger.data\*.*" goto :cdatanext

:cdatanext
mkdir msger.data
cd msger.data
type nul > datauser.txt
type nul > datacomputer.txt
type nul > callback.txt
echo LISTE DES ORDINATEURS ENREGISTRER:  >> datacomputer.txt
echo LISTE DES UTILISATEURS ENREGISTRER: >> datauser.txt
echo false >> callback.txt
echo Succes !
echo.
cd /d %~dp0
pause
goto :menu

:cdataexist
Color 4
title MSGER - ERROR
echo Les fichiers de data existe deja !
echo Supprimer les avant de les recreer !
echo.
echo Appuyez sur une touche pour retourner au menu....
pause>nul
goto :menu

:sdata
cls
title MSGER - Data Save
cd %appdata%
IF exist "msger.data\*.*" goto :sdatanext
IF NOT exist "msger.data\*.*" goto :datafilesfalse

:sdatanext
cd msger.data
cls
echo %target% >> datacomputer.txt
echo %user% >> datauser.txt
set %data% true
echo.
echo Succes !
cd /d %~dp0
pause
goto :menu

:ddata
set %data% false
cls
cd %appdata%
title MSGER - Data Delete
IF exist "msger.data\*.*" goto :ddatanext
IF NOT exist "msger.data\*.*" goto :datafilesfalse

:ddatanext
Color 04
echo Vous sur de vouloir supprimer toute la data ? Il faudra recreer les fichiers !
del msger.data
rmdir msger.data
echo.
echo Succes
pause
goto :menu

:rdata
set "datauser="
set "datacomputer="
title MSGER - [DATA SYSTEM - INDEV FUNCTION]
cls
cd %appdata%
IF exist "msger.data\*.*" goto :rdatanext
IF NOT exist "msger.data\*.*" goto :datafilesfalse

:rdatanext
cd msger.data
echo.
echo  Quelle l'utilisateur a qui envoyer le message ?
echo.
type datauser.txt
echo.
Set /P "NumLine= > "
set /a N=%NumLine%
for /F "skip=%N% delims=" %%i in ('Type "datauser.txt"') do set "datauser=%%i" & goto :datacomputer

:datacomputer
cls
echo  Quelle est le pc enregister ou envoyer le message ?
echo.
type datacomputer.txt
echo.
Set /P "NumLine= > "
set /a N=%NumLine%
for /F "skip=%N% delims=" %%i in ('Type "datacomputer.txt"') do set "datacomputer=%%i" & goto :datamsg

:datamsg
cls
msg %datauser% /SERVER:%datacomputer% /V %callback%
pause
goto :menu

:rdataerror
Color 4
echo Aucune donnee n'a ete trouve !
echo.
echo Appuyez sur une touche pour retourner au Menu.
pause>nul
goto :menu

:datafilesfalse
Color 4
title MSGER - ERROR
echo Les fichiers de data n'ont pas ete trouve !
echo Assure vous de les avoirs creer !
echo.
echo Appuyez sur une touche pour retourner au menu....
pause>nul
goto :menu

:callback
cls
title MSGER - [INDEV FUNCTION - Callback Settings]
echo Verification des fichiers data....
IF exist "msger.data\*.*" goto :callbacknext
IF NOT exist "msger.data\*.*" goto :callbackdatafilesfalse

:callbacknext
echo Les fichier de data sont bien present !
pause
cls
echo Vous souhaitez activer l'accuse reception de vos message ?
echo [1] Oui
echo [2] Non
echo.
Set /P callback= " > "
if /i "%callback%"=="1" goto :callbackon
if /i "%callback%"=="2" goto :callbackoff

:callbackon
cd msger.data
echo true >> callback.txt
set "callbackstatus=true"
set "callback=/V"
echo L'accuse reception a bien ete active !
pause
goto :menu

:callbackoff
cd msger.data
echo false >> callback.txt
set "callbacstatus=false"
set "callback="
echo L'accuse reception a bien ete desactive !
pause
goto :menu

:callbackdatafilesfalse
Color 04
echo.
echo Les fichiers data n'ont pas ete trouve or ils sont requis
echo au fonctionnement de ce syteme.
pause

:debug
title MSGER - DEBUG MODE
cls
echo DEBUG MODE
echo.
echo Vous avez active le mode DEBUG de MSGER !
echo.
echo Que souhaitez vous faire ?
echo [1] Aller au menu principal
echo [2] Activer / Desactiver le DEBUG d'action
echo.
set /p debug= " > "
if /i %debug%=="1" goto :menu
if /i %debug%=="2" goto :debugtoogle

:debugtoogle
cls
echo Vous souhaitez ?
echo [1] Activer le DEBUG ACTION
echo [2] Desactivez le DEBUG ACTION
echo.
set /p debugtoogle= " > "
if /i %debugtoogle%=="1" goto :debugactionon
if /i %debugtoogle%=="2" goto :debugactionoff

:debugactionon
@echo on
echo DEBUG ACTION ON !
pause
goto :menu

:debugactionoff
@echo off
echo DEBUG ACTION OFF !
pause
goto :menu
