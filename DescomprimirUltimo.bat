@echo off
setlocal enabledelayedexpansion

:: Cambiar la página de códigos a UTF-8 para soportar acentos y emojis
chcp 65001 > nul

:: --- CONFIGURACIÓN ---
set "DOWNLOADS_FOLDER=%UserProfile%\Downloads"

:: --- INICIO DEL SCRIPT ---
title 📦 Descomprimiendo el archivo más reciente...
echo.
echo  buscando el archivo .zip o .tar mas reciente en Descargas...

:: Ir a la carpeta de Descargas
cd /d "%DOWNLOADS_FOLDER%"
if errorlevel 1 (
    echo ❌ ERROR: No se pudo encontrar la carpeta de Descargas: "%DOWNLOADS_FOLDER%"
    goto end_script
)

:: Buscar el archivo .zip o .tar más reciente
set "LATEST_FILE="
for /f "delims=" %%i in ('dir /b /o-d /a-d *.zip *.tar') do (
    set "LATEST_FILE=%%i"
    goto found_file
)

:not_found
echo ⚠️ No se encontraron archivos .zip o .tar en tu carpeta de Descargas.
echo    El programa se cerrara.
goto end_script

:found_file
echo ✅ ¡Encontrado!: !LATEST_FILE!

:: --- PREPARACIÓN DE LA CARPETA DE DESTINO ---
set "FILENAME_NO_EXT=!LATEST_FILE:~0,-4!"
set "DEST_FOLDER=Contenido_de_!FILENAME_NO_EXT!"

echo 📁 Creando carpeta de destino: "!DEST_FOLDER!"

:: Si la carpeta de destino ya existe, la eliminamos para evitar mezclar archivos
if exist "!DEST_FOLDER!" (
    echo 🗑️ La carpeta de destino ya existe. Eliminandola para una extraccion limpia...
    rd /s /q "!DEST_FOLDER!"
)

:: Creamos la nueva carpeta
mkdir "!DEST_FOLDER!"
if errorlevel 1 (
    echo ❌ ERROR: No se pudo crear la carpeta de destino.
    echo    Verifica los permisos o si hay un archivo con el mismo nombre.
    goto end_script
)

:: --- DESCOMPRESIÓN ---
echo ⚙️ Descomprimiendo "!LATEST_FILE!"...
set "FILE_EXT=!LATEST_FILE:~-3!"

if /i "!FILE_EXT!"=="zip" (
    :: Usar PowerShell para archivos .zip (nativo en Windows 10/11)
    powershell -nologo -noprofile -command "Expand-Archive -Path '!LATEST_FILE!' -DestinationPath '!DEST_FOLDER!' -Force"
) else if /i "!FILE_EXT!"=="tar" (
    :: Usar tar para archivos .tar (nativo en Windows 10/11)
    tar -xf "!LATEST_FILE!" -C "!DEST_FOLDER!"
) else (
    echo ❌ ERROR: Extension de archivo no soportada: .!FILE_EXT!
    goto end_script
)

:: Verificar si la descompresión fue exitosa
if errorlevel 1 (
    echo ❌ ERROR: Hubo un problema al descomprimir el archivo.
    echo    Puede que el archivo este corrupto o protegido.
    goto end_script
)

:: --- FINALIZACIÓN ---
echo.
echo ✨ ¡Listo! Archivos extraidos con exito.
echo 📂 Abriendo la carpeta de destino...
explorer "!DEST_FOLDER!"

goto cleanup

:end_script
echo.
echo Presiona cualquier tecla para salir...
pause > nul

:cleanup
endlocal
exit /b