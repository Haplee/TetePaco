# 📦 Descomprimir Último Archivo (.zip o .tar)

Este programa te permite **descomprimir con un solo clic** el archivo `.zip` o `.tar` **más reciente** de tu carpeta de **Descargas**.

Ideal para personas que no quieren lidiar con programas de compresión: ¡solo haz doble clic y listo!

---

## ✅ ¿Qué hace?

1. Busca en tu carpeta **Descargas** el archivo `.zip` o `.tar` **más reciente**.
2. Crea una carpeta nueva llamada `Contenido_de_[nombre_del_archivo]`.
3. Extrae **todos los archivos** del comprimido dentro de esa carpeta.
4. **Abre automáticamente** la carpeta con los archivos descomprimidos.
5. Muestra mensajes claros en cada paso (¡incluso con emojis! 😊).

---

## 🖥️ Requisitos

- **Windows 10 (versión 1803 o superior) o Windows 11**
  *(porque usa `tar` y `PowerShell` integrados en el sistema)*
- El archivo `.zip` o `.tar` debe estar en la carpeta **Descargas** del usuario.

> ❗ No funciona en Windows 7, 8 ni versiones antiguas de Windows 10.

---

## 🚀 Cómo usarlo (paso a paso)

1. **Descarga o copia** el archivo `DescomprimirUltimo.bat`.
2. **Guárdalo** en tu escritorio o en cualquier lugar fácil de encontrar.
3. **Ve a tu carpeta de Descargas** y asegúrate de que el archivo `.zip` o `.tar` que quieres descomprimir esté ahí.
4. **Haz doble clic** en `DescomprimirUltimo.bat`.
5. **Espera unos segundos** (aparecerá una ventana negra con mensajes).
6. **¡Listo!** Se abrirá una carpeta con todos los archivos descomprimidos.

---

## ⚠️ Posibles advertencias

- La primera vez que ejecutes un `.bat`, Windows puede mostrar:
  > *"Windows protegió tu PC"*
  **Solución**: haz clic en **"Más información"** y luego en **"Ejecutar de todas formas"**.
- Si no hay ningún `.zip` ni `.tar` en Descargas, el programa te lo dirá y se cerrará.

---

## 🛠️ ¿No funciona?

- Asegúrate de que el archivo comprimido **está en Descargas**.
- Verifica que tu Windows esté **actualizado** (especialmente si usas Windows 10 antiguo).
- Si usas un antivirus muy restrictivo, podría bloquear la ejecución. Permite el archivo si confías en él.

---

## 🔒 Seguridad

Este script **solo lee y escribe en tu carpeta de Descargas**.
**No envía datos**, **no se conecta a internet** y **no modifica nada fuera de Descargas**.

---

> 💡 **Consejo**: Puedes crear un acceso directo en el escritorio para usarlo más rápido.

Creado para usuarios que quieren simplicidad. ¡Sin complicaciones!