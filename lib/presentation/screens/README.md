# Estructura Organizada de Pantallas

## 📁 Estructura de Carpetas

```
lib/presentation/screens/
├── auth/                           # 🔐 Módulo de Autenticación
│   ├── login_screen.dart          # Pantalla de inicio de sesión
│   └── home_dispatcher_screen.dart # Dispatcher para roles
├── patient/                        # 👩‍⚕️ Módulo de Pacientes
│   ├── patient_home_screen.dart   # Pantalla principal del paciente
│   ├── patient_dashboard_screen.dart # Dashboard principal
│   ├── patient_registration_screen.dart # Registro de paciente
│   └── gamification/              # 🎮 Módulo de Gamificación
│       ├── achievements_screen.dart # Logros y badges
│       ├── pregnancy_timeline_screen.dart # Timeline del embarazo
│       ├── progress_stats_screen.dart # Estadísticas de progreso
│       ├── notifications_screen.dart # Centro de notificaciones
│       └── education_screen.dart   # Contenido educativo
├── personnel/                      # 👨‍⚕️ Módulo de Personal de Salud
│   └── personnel_home_screen.dart # Pantalla principal del personal
└── appointments/                   # 📅 Módulo de Citas
    ├── create_appointment_screen.dart # Crear nueva cita
    ├── edit_appointment_screen.dart # Editar cita existente
    ├── appointment_detail_screen.dart # Detalle de cita
    ├── mockup_citas_screen.dart    # Mockup de citas
    └── crear_cita_mockup.dart      # Mockup de crear cita
```

## 🎯 Beneficios de esta Organización

### 1. **Separación por Roles**
- **Auth**: Manejo de autenticación y autorización
- **Patient**: Funcionalidades específicas para pacientes
- **Personnel**: Funcionalidades para personal de salud
- **Appointments**: Gestión de citas médicas

### 2. **Módulos Funcionales**
- **Gamification**: Agrupado dentro de patient (solo pacientes usan gamificación)
- **Appointments**: Módulo independiente (usado por pacientes y personal)

### 3. **Escalabilidad**
- Fácil agregar nuevas pantallas en el módulo correspondiente
- Estructura clara para nuevos desarrolladores
- Separación de responsabilidades

### 4. **Mantenimiento**
- Encontrar archivos más fácilmente
- Imports más organizados
- Código más legible

## 📋 Archivos Movidos

### ✅ Auth Module
- `login_screen.dart` → `auth/login_screen.dart`
- `home_dispatcher_screen.dart` → `auth/home_dispatcher_screen.dart`

### ✅ Patient Module
- `patient_home_screen.dart` → `patient/patient_home_screen.dart`
- `patient_dashboard_screen.dart` → `patient/patient_dashboard_screen.dart`
- `patient_registration_screen.dart` → `patient/patient_registration_screen.dart`

### ✅ Gamification Module
- `achievements_screen.dart` → `patient/gamification/achievements_screen.dart`
- `pregnancy_timeline_screen.dart` → `patient/gamification/pregnancy_timeline_screen.dart`
- `progress_stats_screen.dart` → `patient/gamification/progress_stats_screen.dart`
- `notifications_screen.dart` → `patient/gamification/notifications_screen.dart`
- `education_screen.dart` → `patient/gamification/education_screen.dart`

### ✅ Personnel Module
- `personnel_home_screen.dart` → `personnel/personnel_home_screen.dart`

### ✅ Appointments Module
- `create_appointment_screen.dart` → `appointments/create_appointment_screen.dart`
- `edit_appointment_screen.dart` → `appointments/edit_appointment_screen.dart`
- `appointment_detail_screen.dart` → `appointments/appointment_detail_screen.dart`
- `mockup_citas_screen.dart` → `appointments/mockup_citas_screen.dart`
- `crear_cita_mockup.dart` → `appointments/crear_cita_mockup.dart`

## 🔄 Imports Actualizados

Los siguientes archivos han sido actualizados con los nuevos paths:

- ✅ `lib/main.dart`
- ✅ `lib/presentation/screens/auth/login_screen.dart`
- ✅ `lib/presentation/screens/auth/home_dispatcher_screen.dart`
- ✅ `lib/presentation/screens/patient/patient_dashboard_screen.dart`

## 🚀 Próximos Pasos

1. **Actualizar imports restantes**: Completar la actualización de imports en todos los archivos
2. **Eliminar archivos originales**: Una vez que todos los imports estén actualizados
3. **Verificar compilación**: Asegurar que no hay errores de compilación
4. **Testing**: Probar la navegación entre pantallas

## 📝 Convenciones de Nomenclatura

- **Carpetas**: lowercase_with_underscores
- **Archivos**: lowercase_with_underscores.dart
- **Clases**: PascalCase
- **Módulos**: Nombres descriptivos y claros

## 🎨 Estructura Visual

```
📱 EHealth App
├── 🔐 Auth (Autenticación)
├── 👩‍⚕️ Patient (Pacientes)
│   └── 🎮 Gamification (Gamificación)
├── 👨‍⚕️ Personnel (Personal de Salud)
└── 📅 Appointments (Citas Médicas)
```

Esta estructura hace que el código sea más mantenible, escalable y profesional. 🎉 