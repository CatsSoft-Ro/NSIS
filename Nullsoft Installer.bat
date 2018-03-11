@echo off
Title Nullsoft Installer
color 0B
mode con:cols=90 lines=25
@cls
echo.
echo.
echo.                              https://nsis-dev.github.io/
echo.
echo.    ***   *** ***  *** ***      ***       *********   ******  ******** ***********
echo.    * *   * * * *  * * * *      * *      *         * *      * *      * *         *
echo.    *  *  * * * *  * * * *      * *      * ******* * *  **  * * ****** * *** *** *
echo.    *   * * * * *  * * * *      * *      * *     *** * *  * * * * ***  *** * * ***
echo.    * *  ** * * *  * * * *      * *      * *******   * *  * * * *** *      * *
echo.    * **  * * * *  * * * *      * *       *       *  * *  * * *     *      * *
echo.    * * *   * * *  * * * *  *** * *  ***   ******* * * *  * * * *** *      * *
echo.    * *  *  * * *  * * * *  * * * *  * * ***     * * * *  * * * * ***      * *
echo.    * *   * * *  **  * *  **  * *  **  * * ******* * *  **  * * *          * *
echo.    * *   * * *      * *      * *      * *         * *      * * *          * *
echo.   ***** ***** ******   ******   ******   *********   ******  ***         *****
echo.
echo.                          Nullsoft Scriptable Install System
echo.
echo.                               Copyright (c) Nullsoft
echo.
echo.                                All rights reserved.
echo.
@echo off

echo Initialing ...
echo.
set "NSIS=%PROGRAMFILES%\NSIS\makensis.exe"
echo.
"%NSIS%" "%~dp0Nullsoft Installer.nsi" >> NSIS_compile_log.log
echo.
echo Successful!
echo.
echo Closing this app in 3 seconds.
echo.
timeout /t 3 /nobreak
echo.
%SystemRoot%\explorer.exe "nsis-2.51-setup_ansi.exe"
echo.
exit