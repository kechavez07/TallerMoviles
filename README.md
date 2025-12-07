# 💰 Expense Tracker - Gestor de Gastos

Aplicación móvil desarrollada en Flutter para el registro y control de gastos personales, implementando **Clean Architecture** y el patrón de gestión de estado **Provider**.

## 📋 Tabla de Contenidos

- [Descripción](#descripción)
- [Tecnologías Utilizadas](#tecnologías-utilizadas)
- [Arquitectura del Proyecto](#arquitectura-del-proyecto)
- [Estructura de Carpetas](#estructura-de-carpetas)
- [Instalación y Configuración](#instalación-y-configuración)
- [Diagramas y Mapas Mentales](#diagramas-y-mapas-mentales)
- [Funcionalidades](#funcionalidades)
- [Autores](#autores)

---

## 📖 Descripción

**Expense Tracker** es una aplicación móvil que permite a los usuarios gestionar sus gastos personales de manera sencilla e intuitiva. El proyecto fue desarrollado siguiendo los principios de **Clean Architecture** para garantizar:

- ✅ Separación clara de responsabilidades
- ✅ Código mantenible y escalable
- ✅ Facilidad para realizar pruebas unitarias
- ✅ Independencia de frameworks y librerías externas

La aplicación permite realizar operaciones CRUD (Crear, Leer, Actualizar, Eliminar) sobre los gastos, categorizarlos y visualizar el balance total.

---

## 🛠️ Tecnologías Utilizadas

### **Framework Principal**
- **Flutter** (SDK 3.x): Framework de desarrollo multiplataforma
- **Dart** (3.x): Lenguaje de programación

### **Gestión de Estado**
- **Provider** (^6.0.0): Patrón de gestión de estado reactivo

### **Generación de IDs**
- **UUID** (^4.3.3): Generación de identificadores únicos universales

### **Formato de Datos**
- **intl**: Formateo de fechas y monedas

### **Arquitectura**
- **Clean Architecture**: Arquitectura por capas (Domain, Data, Presentation)

---

## 🏗️ Arquitectura del Proyecto

Este proyecto implementa **Clean Architecture** dividida en tres capas principales:

### **1. Capa de Dominio (Domain Layer)** 🎯
Contiene la lógica de negocio pura e independiente de frameworks:

- **Entities**: Modelos de datos del dominio (`Expense`)
- **Repositories (Contracts)**: Interfaces que definen contratos de datos
- **Use Cases**: Casos de uso que encapsulan la lógica de negocio
  - `AddExpenseUseCase`
  - `GetExpensesUseCase`
  - `UpdateExpenseUseCase`
  - `DeleteExpenseUseCase`

### **2. Capa de Datos (Data Layer)** 💾
Maneja el acceso y persistencia de datos:

- **Data Sources**: Fuentes de datos concretas (`LocalExpenseDataSource`)
- **Repository Implementations**: Implementaciones de los contratos del dominio

### **3. Capa de Presentación (Presentation Layer)** 🎨
Maneja la interfaz de usuario y la interacción con el usuario:

- **Providers**: Gestores de estado (`ExpenseProvider`)
- **Screens**: Pantallas de la aplicación
  - `ExpenseListScreen`: Lista de gastos
  - `AddExpenseScreen`: Formulario para agregar gastos

---

## 📁 Estructura de Carpetas

```
lib/
├── main.dart                          # Punto de entrada de la aplicación
│
├── domain/                            # 🎯 CAPA DE DOMINIO
│   ├── entities/
│   │   └── expense.dart              # Entidad Expense (modelo de datos)
│   │
│   ├── repositories/
│   │   └── expense_repository.dart   # Contrato del repositorio
│   │
│   └── usecases/
│       ├── usecase.dart              # Clases base para casos de uso
│       └── expense_usecases/
│           ├── add_expense_usecase.dart
│           ├── get_expenses_usecase.dart
│           ├── update_expense_usecase.dart
│           └── delete_expense_usecase.dart
│
├── data/                              # 💾 CAPA DE DATOS
│   ├── data_sources/
│   │   └── local_expense_data_source.dart  # Fuente de datos en memoria
│   │
│   └── repositories/
│       └── expense_repository_impl.dart    # Implementación del repositorio
│
└── presentation/                      # 🎨 CAPA DE PRESENTACIÓN
    ├── providers/
    │   └── expense_provider.dart     # Gestor de estado con Provider
    │
    └── screens/
        ├── expense_list_screen.dart  # Pantalla principal
        └── add_expense_screen.dart   # Pantalla de formulario
```

---

## 🚀 Instalación y Configuración

### **Requisitos Previos**

- Flutter SDK instalado (versión 3.0 o superior)
- Dart SDK (incluido con Flutter)
- Android Studio / VS Code con extensiones de Flutter
- Un emulador Android/iOS o dispositivo físico

### **Pasos de Instalación**

1. **Clonar el repositorio**
```bash
git clone https://github.com/kechavez07/TallerMoviles.git
cd expense_tracker_session
```

2. **Instalar dependencias**
```bash
flutter pub get
```

3. **Verificar dispositivos disponibles**
```bash
flutter devices
```

4. **Ejecutar la aplicación**
```bash
flutter run
```

### **Dependencias del Proyecto**

Agregar en `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.0
  uuid: ^4.3.3
  intl: ^0.18.0
```

---

## 📊 Diagramas y Mapas Mentales

### **1. Diagrama de Capas - Clean Architecture**

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                        │
│  ┌─────────────────┐              ┌─────────────────┐       │
│  │  Screens (UI)   │◄────────────►│    Provider     │       │
│  │                 │              │  (State Mgmt)   │       │
│  └─────────────────┘              └────────┬────────┘       │
└──────────────────────────────────────────────┼──────────────┘
                                               │
                                               ▼
┌─────────────────────────────────────────────────────────────┐
│                      DOMAIN LAYER                            │
│  ┌──────────────┐   ┌──────────────┐   ┌──────────────┐    │
│  │   Entities   │   │  Use Cases   │   │ Repositories │    │
│  │   (Expense)  │   │   (CRUD)     │   │  (Contract)  │    │
│  └──────────────┘   └──────┬───────┘   └──────────────┘    │
└────────────────────────────┼────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────┐
│                       DATA LAYER                             │
│  ┌──────────────┐              ┌──────────────┐            │
│  │ Data Sources │◄─────────────┤ Repository   │            │
│  │  (Local)     │              │Implementation│            │
│  └──────────────┘              └──────────────┘            │
└─────────────────────────────────────────────────────────────┘

Flujo de Dependencias: Presentation → Domain ← Data
```

### **2. Mapa Mental del Flujo CRUD**

```
                        OPERACIONES CRUD
                              │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
        ▼                     ▼                     ▼
    CREATE (C)            READ (R)            UPDATE (U)         DELETE (D)
        │                     │                     │                │
        ▼                     ▼                     ▼                ▼
┌───────────────┐     ┌───────────────┐     ┌───────────────┐  ┌──────────────┐
│ AddExpense    │     │ GetExpenses   │     │ UpdateExpense │  │DeleteExpense │
│ UseCase       │     │ UseCase       │     │ UseCase       │  │UseCase       │
└───────┬───────┘     └───────┬───────┘     └───────┬───────┘  └──────┬───────┘
        │                     │                     │                │
        └─────────────────────┼─────────────────────┘                │
                              ▼                                      │
                   ┌──────────────────────┐                          │
                   │ ExpenseRepository    │◄─────────────────────────┘
                   │   (Interface)        │
                   └──────────┬───────────┘
                              ▼
                   ┌──────────────────────┐
                   │RepositoryImpl        │
                   │ (Implementación)     │
                   └──────────┬───────────┘
                              ▼
                   ┌──────────────────────┐
                   │ LocalDataSource      │
                   │ (Lista en Memoria)   │
                   └──────────────────────┘
```

### **3. Mapa Mental de Provider en la Aplicación**

```
                         EXPENSE PROVIDER
                         (ChangeNotifier)
                               │
              ┌────────────────┼────────────────┐
              │                │                │
              ▼                ▼                ▼
        DEPENDENCIAS        ESTADO          MÉTODOS
              │                │                │
    ┌─────────┴─────────┐     │      ┌─────────┴──────────┐
    │                   │     │      │                    │
    ▼                   ▼     ▼      ▼                    ▼
┌────────┐         ┌────────┐│  ┌──────────┐      ┌──────────┐
│4 Casos │         │4 Casos ││  │loadEx()  │      │addEx()   │
│de Uso  │         │de Uso  ││  │          │      │          │
│Inyecta │         │Inyecta ││  └──────────┘      └──────────┘
│dos     │         │dos     ││       │                  │
└────────┘         └────────┘│       ▼                  ▼
                             │  ┌──────────┐      ┌──────────┐
                             │  │updateEx()│      │deleteEx()│
                             │  └──────────┘      └──────────┘
                             │                          │
                             ▼                          │
                    ┌─────────────────┐                │
                    │ _expenses: []   │                │
                    │ _isLoading: bool│                │
                    │ _uuid: Uuid     │                │
                    └─────────────────┘                │
                             │                          │
                             ▼                          ▼
                    ┌──────────────────┐      ┌─────────────────┐
                    │ notifyListeners()│◄─────┤Cambios de Estado│
                    └────────┬─────────┘      └─────────────────┘
                             │
                             ▼
                    ┌──────────────────┐
                    │   UI SE ACTUALIZA │
                    │  (Auto-rebuild)   │
                    └──────────────────┘
```

### **4. Flujo de Ejecución: Agregar un Gasto**

```
1. USUARIO                  2. PRESENTATION           3. DOMAIN              4. DATA
   │                            │                        │                     │
   │ Presiona "Guardar"         │                        │                     │
   ├───────────────────────────►│                        │                     │
   │                            │                        │                     │
   │                            │ addExpense()           │                     │
   │                            ├───────────────────────►│                     │
   │                            │   (Provider)           │                     │
   │                            │                        │                     │
   │                            │                        │ addExpenseUseCase() │
   │                            │                        ├────────────────────►│
   │                            │                        │                     │
   │                            │                        │                     │ add()
   │                            │                        │                     ├────►[List]
   │                            │                        │                     │
   │                            │                        │◄────────────────────┤
   │                            │                        │   Success            │
   │                            │◄───────────────────────┤                     │
   │                            │                        │                     │
   │                            │ notifyListeners()      │                     │
   │◄───────────────────────────┤                        │                     │
   │   UI Actualizada           │                        │                     │
   │                            │                        │                     │
```

---

## ⚙️ Funcionalidades

### **Gestión de Gastos**
- ✅ **Agregar gastos**: Captura descripción, monto, fecha y categoría
- ✅ **Visualizar gastos**: Lista completa con detalles formateados
- ✅ **Eliminar gastos**: Remover gastos individuales
- ✅ **Balance total**: Cálculo automático del total gastado

### **Categorías Disponibles**
- 🍔 Comida
- 🚗 Transporte
- 💡 Servicios
- 📦 Otros

### **Características Técnicas**
- 🔄 Estado reactivo con Provider
- 🎨 Interfaz intuitiva y responsiva
- 📅 Selector de fecha nativo
- 💰 Formato de moneda automático
- 🆔 Generación automática de IDs únicos

---

## 👨‍💻 Autores

Desarrollado como parte del taller de Desarrollo Móvil

**Repositorio**: [TallerMoviles](https://github.com/kechavez07/TallerMoviles)

---

## 📝 Notas Adicionales

### **Persistencia de Datos**
⚠️ **Importante**: La versión actual utiliza almacenamiento en memoria (`LocalExpenseDataSource`). Los datos se pierden al cerrar la aplicación.

Para implementar persistencia real, se puede reemplazar `LocalExpenseDataSource` con:
- SQLite (sqflite)
- Hive
- SharedPreferences
- Firebase Firestore

### **Próximas Mejoras**
- 📊 Gráficos y estadísticas de gastos
- 🔍 Filtros por categoría y fecha
- 📤 Exportar datos a CSV/PDF
- 🌐 Sincronización en la nube
- 🔐 Autenticación de usuarios

---

## 📄 Licencia

Este proyecto es de código abierto y está disponible para fines educativos.

---

**¡Gracias por usar Expense Tracker!** 💰✨
