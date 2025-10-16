@echo off
setlocal enabledelayedexpansion

:: Create a dummy zip file
echo "dummy content" > test_file.ZIP

:: Run the script
cmd /c DescomprimirUltimo.bat

:: Check if the folder was created
if exist "Contenido_de_test_file" (
    echo "Test passed"
) else (
    echo "Test failed"
)

:: Cleanup
del test_file.ZIP
rmdir /s /q "Contenido_de_test_file"
endlocal