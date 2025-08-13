# Configuración Centralizada de la API

## Descripción
Este sistema de configuración centralizada permite manejar fácilmente las URLs de la API y configuraciones por entorno sin tener que cambiar múltiples archivos.

## Archivos de Configuración

### 1. `environment_config.dart`
Maneja las configuraciones por entorno (desarrollo, staging, producción).

### 2. `api_config.dart`
Proporciona URLs y configuraciones específicas de la API.

## Cómo Cambiar la IP/URL de la API

### Opción 1: Cambiar el Entorno (Recomendado)
En `environment_config.dart`, cambia la variable `currentEnvironment`:

```dart
static const Environment currentEnvironment = Environment.development;
```

Y actualiza las URLs en el mapa `_baseUrls`:

```dart
static const Map<Environment, String> _baseUrls = {
  Environment.development: 'http://TU_NUEVA_IP:3000', // Cambia aquí
  Environment.staging: 'http://192.168.1.100:3000',
  Environment.production: 'https://api.tudominio.com',
};
```

### Opción 2: Cambiar Directamente la URL de Desarrollo
En `environment_config.dart`, modifica la URL de desarrollo:

```dart
static const Map<Environment, String> _baseUrls = {
  Environment.development: 'http://TU_NUEVA_IP:3000', // Solo cambia esta línea
  // ... resto del código
};
```

## Entornos Disponibles

### Development (Desarrollo)
- URL: `http://192.168.1.17:3000` (por defecto)
- Timeout: 10 segundos
- Logging: Habilitado
- Debug Mode: Habilitado

### Staging
- URL: `http://192.168.1.100:3000` (configurable)
- Timeout: 15 segundos
- Logging: Habilitado
- Debug Mode: Deshabilitado

### Production
- URL: `https://api.tudominio.com` (configurable)
- Timeout: 30 segundos
- Logging: Deshabilitado
- Debug Mode: Deshabilitado

## Ventajas de este Sistema

1. **Configuración Centralizada**: Solo necesitas cambiar la IP en un lugar
2. **Múltiples Entornos**: Fácil cambio entre desarrollo, staging y producción
3. **Configuraciones Específicas**: Cada entorno puede tener diferentes timeouts y configuraciones
4. **Mantenimiento Fácil**: No más búsqueda y reemplazo en múltiples archivos

## Uso en el Código

Los data sources ya están configurados para usar `ApiConfig`. Ejemplo:

```dart
// Antes (hardcodeado)
final response = await http.get(Uri.parse('http://192.168.1.17:3000/auth/login'));

// Ahora (centralizado)
final response = await http.get(Uri.parse(ApiConfig.loginUrl));
```

## Información del Entorno Actual

Para ver la configuración actual, puedes usar:

```dart
print(EnvironmentConfig.environmentInfo);
```

Esto mostrará:
```
Environment: development
Base URL: http://192.168.1.17:3000
Timeout: 10s
Logging: true
Debug Mode: true
```

## Migración Completa

Todos los data sources han sido actualizados para usar esta configuración:

- ✅ `auth_remote_data_source.dart`
- ✅ `patient_remote_data_source_impl.dart`
- ✅ `appointment_remote_data_source.dart`
- ✅ `gamification_remote_data_source.dart`

Ya no necesitas cambiar la IP en múltiples archivos. ¡Todo está centralizado! 