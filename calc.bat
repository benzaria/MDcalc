@echo off

:: ==============================================
::  Programme : Module Note Calculator
::  Auteur    : Benzaria
::  Version   : 1.0
::  Date      : 11-03-2025
::  Description :
::     - Ce programme permet de calculer la note d'un module
::       en fonction du nombre total de questions et des 
::       questions correctes.
::     - Il prend en compte la présence d'un TP (Travaux Pratiques).
::     - Calcul basé sur une pondération 80% théorie / 20% TP.
::     - Il affiche un résumé avec la note obtenue et un message 
::       indiquant si le module est validé ou non.
::     - L'utilisateur peut réessayer ou quitter à la fin.
::
::  Instructions :
::     1. Répondez "O" ou "N" à la question sur le TP.
::     2. Entrez le nombre total de questions.
::     3. Si TP : spécifiez le nombre de questions TP.
::     4. Entrez le nombre de réponses correctes.
::     5. La note est calculée et affichée.
::     6. Choisissez de réessayer ou quitter.
::
::  Dépendances :
::     - Windows 7 ou plus.
:: ==============================================

:start
setlocal enabledelayedexpansion
title Module Note Calculator
chcp 65001
rem for /f "tokens=2 delims=:" %%i in ('mode con ^| findstr "Columns"') do set /a width=%%i
set /a mid = 10 & rem (width / 2) - 20
set "clear=cls&echo [%mid%G[94m[0;1;104mModule Note Calculator[0;106;94m[0;1;30;106mby Benzaria[0;96m[0m"

:reset
%clear%
set hasTP=false
set /a mdQ=50
set /a tpQ=10
echo.
:: Demander si le module a un TP
choice /c ON /n /m "Le module a-t-il un TP ? (Oui/Non) "
if %errorlevel% equ 1 set hasTP=true

:: Demander le nombre de questions
set /p ttlQ="Combien y a-t-il de questions dans l'examen ? "
if "%hasTP%"=="true" ( 
    set /p tpQ="Combien de questions sont dédiées au TP ? "
) else set tpQ=0

if defined ttlQ set /a mdQ=ttlQ - tpQ

%clear%
:calc
:: Demander les Qs vrai
set /a tp=0
set /a md=0
set "valid=[91"
set "__TP="
echo [H
echo.
if "%hasTP%"=="true" (
    set /p md="Entrez le Nombre de questions [32;1mvrai [1;4;91msans[0m TP : [K"
    set /p tp="Entrez le Nombre de question [32;1mvrai[0m du TP : [K"
    set "__TP=echo [96m│ [0mNombre de questions TP : [K!tp!/!tpQ![96m[40G│"
) else set /p md="Entrez le Nombre de questions [32;1mvrai[0m du module : [K"

:: Calculer la note
if "%hasTP%"=="true" (
    for /f %%i in ('powershell -nologo -noprofile -command "[math]::Round((0.8*(20/(%mdQ%))*%md%) + (0.2*(20/%tpQ%)*%tp%), 2)"') do set note=%%i
) else for /f %%i in ('powershell -nologo -noprofile -command "[math]::Round((20/(%mdQ%))*%md%, 2)"') do set note=%%i

:: Afficher le résumé
for /f "delims=." %%i in ("%note%") do if %%i geq 10 set "valid=[92"
echo.
echo [96m╭[30;1;106mRésultat[0;96m────────────────────────────╮
echo [96m│ [0mNombre de questions module : [K!md!/!mdQ![96m[40G│
%__TP%
echo [96m│ [0;4;1mNote du module[0m : [K!valid!;1m!note![0;96m[40G│
echo [96m╰──────────────────────────────────────╯[0m

:: Réessayer, Changer ou Quitter
echo.
echo.
echo - Réessayer le calcule
echo - Changer le module
echo - Quitter!
choice /c RCQ /n /m "[4FQue voulez-vous faire ? (Réessayer/Quitter/Changer)[K"
if %errorlevel% equ 1 goto calc
if %errorlevel% equ 2 goto reset

:end
echo [J
<nul set /p="[94;1m^!Byby^! Send Thanks to Benzaria[0m"
timeout /t 2 >nul
endlocal & exit /b 0
