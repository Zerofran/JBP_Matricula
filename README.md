# 🎓 Sistema de Generación de Matrículas (Tipitapa)

Este proyecto es una herramienta de escritorio construida con Godot Engine, diseñada para la gestión de datos de estudiantes y la generación automatizada de hojas de matrícula. Es una solución todo en uno para el registro y la documentación de estudiantes, ideal para instituciones educativas.

## 🌟 Características Principales

* **Gestión de Datos:** Un panel intuitivo que permite realizar operaciones CRUD (Crear, Leer, Actualizar, Borrar) en una base de datos local de estudiantes.
* **Generador de Formularios:** Crea dinámicamente hojas de matrícula completas y listas para imprimir, adaptándose a los datos de cada estudiante.
* **Campo de Firma Digital:** Un componente interactivo que permite a padres o tutores firmar digitalmente el formulario directamente en la pantalla.
* **Funcionalidad de Exportación:** Genera una imagen PNG de alta calidad de la hoja de matrícula completa, ideal para guardar o imprimir.
* **Interfaz de Usuario (UI):** Una interfaz de usuario limpia y funcional que organiza la gestión de datos y la vista previa del formulario en un solo lugar.

## 🛠️ Tecnologías Utilizadas

* **Godot Engine 4.4.1:** El motor principal del proyecto.
* **GDScript:** El lenguaje de programación utilizado para toda la lógica del sistema.

## 🚀 Cómo Funciona

El programa se inicia con la interfaz principal dividida en dos secciones:

1.  **Panel de Datos (Izquierda):** Aquí puedes gestionar la información de los estudiantes.
2.  **Vista Previa de la Matrícula (Derecha):** Esta sección muestra el formulario dinámico que se crea con la información de los estudiantes.

La funcionalidad de captura de pantalla es manejada por un `SubViewport` que se redimensiona al tamaño completo del formulario, asegurando que toda la hoja de matrícula sea capturada correctamente en un solo archivo PNG.

## 📄 Licencia

Este proyecto está licenciado bajo la **Creative Commons Atribución-NoComercial-SinDerivadas 4.0 Internacional (CC BY-NC-ND 4.0)**.

**Restricciones Clave:**
* **No se permite la modificación (Sin Derivadas):** Usted no puede remezclar, transformar o crear a partir de este material.
* **No se permite el uso comercial (No Comercial):** El proyecto no puede ser utilizado con fines de lucro.
* **No se permite la redistribución de código modificado.**

El código fuente está disponible para su revisión y estudio, con el objetivo de comprender la implementación técnica del sistema.
