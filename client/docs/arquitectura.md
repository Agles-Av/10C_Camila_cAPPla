# 🏗️ Arquitectura y Estructura del Proyecto

Este proyecto sigue el patrón **MVVM (Model–View–ViewModel)** para asegurar una separación clara de responsabilidades, facilitar la escalabilidad y mantener un código limpio y mantenible.  

---

## 📐 Arquitectura MVVM

### **Model**
- Define las entidades, estructuras de datos y lógica de negocio.  
- Contiene validaciones y transformaciones de datos.  
- Ubicación: `features/*/data/models`.

### **View**
- Representa la interfaz de usuario (pantallas y widgets).  
- Se encarga únicamente de mostrar datos y recibir interacciones.  
- Ubicación:  
  - `features/*/presentation/screens` (pantallas principales).  
  - `features/*/presentation/widgets` (componentes reutilizables).  
  - `shared/widgets` (widgets generales compartidos).

### **ViewModel**
- Maneja el estado de la interfaz y la lógica de presentación.  
- Actúa como puente entre la vista y el modelo/servicios.  
- Implementado con `provider` para gestión de estado.  
- Ubicación: `features/*/presentation/provider`.

### **Servicios**
- Gestionan la comunicación con APIs, almacenamiento en la nube o local y fuentes externas.  
- Incluyen manejo de errores, autenticación y peticiones HTTP.  
- Ubicación: `features/*/data/service`.

---

## 📂 Estructura de Carpetas

La estructura principal del proyecto es la siguiente:  

lib/
├── core/ # Adaptadores, utilidades y configuración global
├── config/ # Configuración del proyecto
├── features/ # Funcionalidades divididas en módulos
│ ├── demand/
│ ├── directory/
│ ├── home/
│ ├── news/
│ └── tips/
│ ├── data/ # Modelos y servicios
│ │ ├── models/
│ │ └── service/
│ └── presentation/ # Lógica de UI
│ ├── provider/ # ViewModels
│ ├── screens/ # Pantallas (Views)
│ └── widgets/ # Widgets específicos del módulo
├── navigation/ # Configuración de rutas y navegación
├── shared/ # Recursos compartidos
│ └── widgets/
└── main.dart # Punto de entrada

markdown
Copiar código

---

## 📁 Otras Carpetas Requeridas

Además de `lib/`, se incluyen las siguientes carpetas para cumplir con la estructura base:  

- `test/` → Contiene pruebas unitarias y de widgets.  
- `docs/` → Documentación técnica (`arquitectura.md`, diagramas, ADRs).  
- `scripts/` *(opcional)* → Scripts de automatización o generación de código.  
- `ci/` *(opcional)* → Archivos de configuración para integración continua.  

---

## ✅ Convenciones

- **Ramas Git:**  
  - `main`: estable.  
  - `develop`: desarrollo activo.  
  - `feature/*`: nuevas funcionalidades.  
  - `fix/*`: correcciones de bugs.  

- **Commits:** estilo `tipo: descripción breve`  
  - `feat: agrega pantalla de login`  
  - `fix: corrige validación en registro`  
  - `docs: actualiza README con arquitectura`