@echo off
setlocal enabledelayedexpansion

:: Configurar codificación UTF-8 para soportar acentos y emojis (requiere consola moderna)
chcp 65001 >nul 2>&1

:: --- CONFIGURACIÓN ---
set "DOWNLOADS_FOLDER=%USERPROFILE%\Downloads"
set "SCRIPT_NAME=Descomprimir Último Archivo"

:: --- INICIO ---
title %SCRIPT_NAME% 📦
cls
echo.
echo 📥 %SCRIPT_NAME%
echo =============================================
echo Buscando el archivo .zip, .ZIP, .tar o .TAR mas reciente en:
echo "%DOWNLOADS_FOLDER%"
echo.

:: Verificar que la carpeta de Descargas exista
if not exist "%DOWNLOADS_FOLDER%" (
    echo ❌ ERROR: No se encuentra la carpeta de Descargas.
    echo    Ruta: "%DOWNLOADS_FOLDER%"
    goto :final_error
)

:: Cambiar al directorio de Descargas
pushd "%DOWNLOADS_FOLDER%" || (
    echo ❌ ERROR: No se pudo acceder a la carpeta de Descargas.
    goto :final_error
)

:: Buscar el archivo comprimido más reciente (.zip o .tar, en cualquier combinación de mayúsculas)
set "LATEST_FILE="
for /f "delims=" %%F in ('dir /b /o-d /a-d *.zip *.ZIP *.tar *.TAR 2^>nul') do (
    set "LATEST_FILE=%%F"
    goto :found_file
)

echo ⚠️ No se encontraron archivos .zip ni .tar en tu carpeta de Descargas.
echo    Asegúrate de que el archivo esté en:
echo    "%DOWNLOADS_FOLDER%"
goto :final_normal

:found_file
echo ✅ ¡Archivo encontrado!: "!LATEST_FILE!"

:: --- Determinar extensión real (últimos 3 o 4 caracteres) ---
set "FILE_NAME=!LATEST_FILE!"
set "FILE_EXT="

:: Extraer extensión de forma segura (soporta nombres con puntos)
for %%A in ("!LATEST_FILE!") do (
    set "FILE_NAME=%%~nA"
    set "FILE_EXT=%%~xA"
)

:: Normalizar extensión a minúsculas
set "FILE_EXT=!FILE_EXT:~1!" &:: Quita el punto inicial
set "FILE_EXT_LOW=!FILE_EXT!" &:: Fallback en caso de que PowerShell falle
for /f "delims=" %%L in ('powershell -nologo -noprofile -command "''!FILE_EXT!''.ToLower()" 2^>nul') do set "FILE_EXT_LOW=%%L"

:: Soporte básico para .tar.gz (trata como .tar)
if /i "!FILE_EXT!"=="gz" (
    :: Verificar si el nombre termina en .tar.gz
    echo !LATEST_FILE! | findstr /i /r "\.tar\.gz$" >nul && (
        set "FILE_EXT_LOW=tar"
        set "FILE_NAME=!FILE_NAME:~0,-4!" &:: Quita ".tar" del nombre base
    )
)

:: Validar extensión soportada
if /i not "!FILE_EXT_LOW!"=="zip" if /i not "!FILE_EXT_LOW!"=="tar" (
    echo ❌ ERROR: Extensión no soportada: ".!FILE_EXT!"
    echo    Solo se admiten .zip y .tar (incluyendo .tar.gz).
    goto :final_error
)

:: --- Carpeta de destino ---
set "DEST_FOLDER=Contenido_de_!FILE_NAME!"
if "!DEST_FOLDER:~-1!"=="." set "DEST_FOLDER=!DEST_FOLDER:~0,-1!"

echo 📁 Carpeta de destino: "!DEST_FOLDER!"

:: Eliminar carpeta anterior si existe
if exist "!DEST_FOLDER!\" (
    echo 🗑️ Eliminando carpeta anterior para evitar archivos mezclados...
    rd /s /q "!DEST_FOLDER!" 2>nul
    if exist "!DEST_FOLDER!\" (
        echo ❌ ERROR: No se pudo eliminar la carpeta anterior.
        goto :final_error
    )
)

:: Crear nueva carpeta
mkdir "!DEST_FOLDER!" 2>nul
if not exist "!DEST_FOLDER!\" (
    echo ❌ ERROR: No se pudo crear la carpeta de destino.
    goto :final_error
)

:: --- Descomprimir ---
echo ⚙️ Descomprimiendo...
if /i "!FILE_EXT_LOW!"=="zip" (
    powershell -nologo -noprofile -command "try { Expand-Archive -Path '!LATEST_FILE!' -DestinationPath '!DEST_FOLDER!' -Force -ErrorAction Stop } catch { exit 1 }"
) else if /i "!FILE_EXT_LOW!"=="tar" (
    tar -xf "!LATEST_FILE!" -C "!DEST_FOLDER!" 2>nul
)

if errorlevel 1 (
    echo ❌ ERROR: Falló la descompresión.
    echo    - El archivo podría estar dañado.
    echo    - Podría estar en uso por otro programa.
    echo    - O no tienes permisos suficientes.
    goto :final_error
)

:: Verificar que la carpeta no esté vacía
dir /a /b "!DEST_FOLDER!" >nul 2>&1
if errorlevel 1 (
    echo ⚠️ AVISO: El archivo se descomprimió, pero no contiene nada visible.
)

:: --- Éxito ---
echo.
echo ✨ ¡Todo listo! Tus archivos están en:
echo "!DEST_FOLDER!"
echo.
echo 🪟 Abriendo carpeta...
explorer "!DEST_FOLDER!"
timeout /t 3 /nobreak >nul
goto :end

:final_error
echo.
echo Presiona cualquier tecla para cerrar...
pause >nul
goto :end

:final_normal
echo.
echo Presiona cualquier tecla para cerrar...
pause >nul

:end
popd >nul 2>&1
endlocal
exit /b
