enum Environment {
  development,
  staging,
  production,
}

class EnvironmentConfig {
  // Cambia esta variable para cambiar el entorno
  static const Environment currentEnvironment = Environment.development;

  // Configuraciones por entorno
  static const Map<Environment, String> _baseUrls = {
    Environment.development:
        'http://10.253.106.109:3000', // Tu IP de desarrollo
    Environment.staging:
        'http://192.168.1.100:3000', // IP de staging (cambiar según necesites)
    Environment.production: 'https://api.tudominio.com', // URL de producción
  };

  // Obtener la URL base según el entorno actual
  static String get baseUrl =>
      _baseUrls[currentEnvironment] ?? _baseUrls[Environment.development]!;

  // Configuraciones adicionales por entorno
  static const Map<Environment, Map<String, dynamic>> _configs = {
    Environment.development: {
      'timeout': 10,
      'enableLogging': true,
      'enableDebugMode': true,
    },
    Environment.staging: {
      'timeout': 15,
      'enableLogging': true,
      'enableDebugMode': false,
    },
    Environment.production: {
      'timeout': 30,
      'enableLogging': false,
      'enableDebugMode': false,
    },
  };

  // Obtener configuración específica
  static T getConfig<T>(String key, T defaultValue) {
    final config = _configs[currentEnvironment];
    return config?[key] as T? ?? defaultValue;
  }

  // Métodos de conveniencia
  static int get timeout => getConfig('timeout', 10);
  static bool get enableLogging => getConfig('enableLogging', true);
  static bool get enableDebugMode => getConfig('enableDebugMode', true);

  // Método para cambiar el entorno dinámicamente (útil para testing)
  static void setEnvironment(Environment env) {
    // Nota: En una implementación real, esto requeriría reiniciar la app
    // o usar un sistema de configuración más sofisticado
    print('Environment changed to: $env');
  }

  // Método para obtener información del entorno actual
  static String get environmentInfo {
    return '''
    Environment: $currentEnvironment
    Base URL: $baseUrl
    Timeout: ${timeout}s
    Logging: $enableLogging
    Debug Mode: $enableDebugMode
    ''';
  }
}
