@echo off
setlocal enabledelayedexpansion

:: ==============================================================================
:: 📥 Descomprimir Último Archivo - Especial para Paco Mateo
:: ==============================================================================
:: Función: Busca el archivo comprimido más reciente en "Descargas", lo
::          descomprime en una carpeta nueva y la abre automáticamente.
:: ==============================================================================

:: Configurar codificación UTF-8 para soportar acentos y emojis
chcp 65001 >nul 2>&1

:: --- CONFIGURACIÓN ---
set "DOWNLOADS_FOLDER=%USERPROFILE%\Downloads"
set "SCRIPT_NAME=Descomprimir Último Archivo"
set "VERSION=1.1"

:: --- INICIO ---
title %SCRIPT_NAME% v%VERSION% 📦
color 0F
cls

echo.
echo   ╔══════════════════════════════════════════════════════╗
echo   ║         📦 DESCOMPRIMIR ÚLTIMO ARCHIVO               ║
echo   ║           (Especial para Paco Mateo)                 ║
echo   ╚══════════════════════════════════════════════════════╝
echo.
echo   🔍 Buscando el archivo más reciente en:
echo      "%DOWNLOADS_FOLDER%"
echo.

:: 1. Verificar que la carpeta de Descargas exista
if not exist "%DOWNLOADS_FOLDER%" (
    echo   ❌ [ERROR] No se encuentra la carpeta de Descargas.
    echo      Ruta buscada: "%DOWNLOADS_FOLDER%"
    goto :final_error
)

:: 2. Cambiar al directorio de Descargas
pushd "%DOWNLOADS_FOLDER%" || (
    echo   ❌ [ERROR] No se pudo acceder a la carpeta de Descargas.
    goto :final_error
)

:: 3. Buscar el archivo comprimido más reciente (.zip, .tar, .tgz, .tar.gz)
set "LATEST_FILE="
for /f "delims=" %%F in ('dir /b /o-d /a-d *.zip *.tar *.tgz *.gz 2^>nul') do (
    :: Filtro manual para asegurar que es un archivo comprimido válido
    set "TEMP_FILE=%%F"
    if "!TEMP_FILE:~-4!"==".zip" set "LATEST_FILE=%%F" & goto :found_file
    if "!TEMP_FILE:~-4!"==".tar" set "LATEST_FILE=%%F" & goto :found_file
    if "!TEMP_FILE:~-4!"==".tgz" set "LATEST_FILE=%%F" & goto :found_file
    if "!TEMP_FILE:~-7!"==".tar.gz" set "LATEST_FILE=%%F" & goto :found_file
)

echo   ⚠️ No se encontraron archivos .zip o .tar en "Descargas".
echo   Asegúrate de que el archivo que quieres abrir esté allí.
goto :final_normal

:found_file
echo   ✅ ¡Encontrado!: "!LATEST_FILE!"
echo.

:: 4. Preparar nombre de la carpeta de destino
for %%A in ("!LATEST_FILE!") do (
    set "BASE_NAME=%%~nA"
    set "FILE_EXT=%%~xA"
)

:: Caso especial para .tar.gz (quita el .tar si existe)
if /i "!FILE_EXT!"==".gz" (
    set "BASE_NAME=!BASE_NAME:.tar=!"
)

set "DEST_FOLDER=Contenido_de_!BASE_NAME!"
:: Limpiar caracteres extraños del nombre de la carpeta si los hubiera
set "DEST_FOLDER=!DEST_FOLDER::=!"
set "DEST_FOLDER=!DEST_FOLDER:/=!"

echo   📁 Se extraerá en: "!DEST_FOLDER!"

:: 5. Gestionar carpeta de destino existente
if exist "!DEST_FOLDER!\" (
    echo   🗑️  Limpiando carpeta anterior...
    rd /s /q "!DEST_FOLDER!" 2>nul
)

mkdir "!DEST_FOLDER!" 2>nul
if not exist "!DEST_FOLDER!\" (
    echo   ❌ [ERROR] No se pudo crear la carpeta de destino.
    goto :final_error
)

:: 6. Proceso de descompresión
echo   ⚙️  Descomprimiendo archivos... por favor espera...

:: Usamos PowerShell por ser lo más robusto en Windows 10/11
if /i "!FILE_EXT!"==".zip" (
    powershell -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; try { [System.IO.Compression.ZipFile]::ExtractToDirectory('!LATEST_FILE!', '!DEST_FOLDER!') } catch { Expand-Archive -Path '!LATEST_FILE!' -DestinationPath '!DEST_FOLDER!' -Force } }" >nul 2>&1
) else (
    :: Para .tar, .tgz, .tar.gz usamos el comando 'tar' de Windows
    tar -xf "!LATEST_FILE!" -C "!DEST_FOLDER!" >nul 2>&1
)

if errorlevel 1 (
    echo   ❌ [ERROR] Falló la descompresión.
    echo      - Comprueba si el archivo está corrupto.
    echo      - Comprueba si el archivo está abierto en otro programa.
    goto :final_error
)

:: 7. Finalización exitosa
echo   ✨ ¡TODO LISTO, PACO!
echo.
echo   🪟 Abriendo la carpeta con tus archivos...
explorer "!DEST_FOLDER!"

:: Sonido de notificación simple (opcional, Paco lo agradecerá)
powershell -c "[console]::beep(1000, 200)" >nul 2>&1

timeout /t 3 /nobreak >nul
goto :end

:final_error
echo.
echo   ❌ Ha ocurrido un problema. 
echo   Repasa los avisos de arriba.
echo.
echo   Presiona cualquier tecla para cerrar...
pause >nul
goto :end

:final_normal
echo.
echo   Presiona cualquier tecla para salir...
pause >nul

:end
popd >nul 2>&1
endlocal
exit /b
