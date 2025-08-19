import 'environment_config.dart';

class IpChanger {
  /// Muestra la configuración actual
  static void showCurrentConfig() {
    print('=== CONFIGURACIÓN ACTUAL ===');
    print(EnvironmentConfig.environmentInfo);
    print('============================');
  }

  static void showCommonIPs() {
    print('\n=== IPs COMUNES POR RED ===');
    print('Red WiFi Casa: 192.168.1.X');
    print('Red WiFi Trabajo: 10.0.X.X o 172.16.X.X');
    print('Red Móvil: 192.168.X.X');
    print('Localhost: 127.0.0.1 (solo si el backend está en la misma máquina)');
    print('===========================');
  }

  /// Instrucciones para cambiar la IP
  static void showInstructions() {
    print('\n=== INSTRUCCIONES PARA CAMBIAR IP ===');
    print('1. Abre el archivo: lib/core/config/environment_config.dart');
    print('2. Busca la línea con tu entorno actual:');
    print('   Environment.development: \'http://192.168.1.17:3000\'');
    print('3. Cambia la IP por la nueva:');
    print('   Environment.development: \'http://TU_NUEVA_IP:3000\'');
    print('4. Guarda el archivo');
    print('5. Reinicia la aplicación Flutter');
    print('6. ¡Listo!');
    print('=====================================');
  }

  /// Verifica si la IP actual es accesible
  static Future<bool> testConnection() async {
    try {
      final url = Uri.parse('${EnvironmentConfig.baseUrl}/health');
      final response = await Future.delayed(const Duration(seconds: 2));
      print('✅ Conexión exitosa a: ${EnvironmentConfig.baseUrl}');
      return true;
    } catch (e) {
      print('❌ Error de conexión a: ${EnvironmentConfig.baseUrl}');
      print('   Error: $e');
      return false;
    }
  }

  /// Ejecuta todas las verificaciones
  static void runDiagnostics() {
    showCurrentConfig();
    showCommonIPs();
    showInstructions();

    print('\n=== DIAGNÓSTICO DE CONEXIÓN ===');
    testConnection().then((success) {
      if (!success) {
        print('\n💡 SUGERENCIAS:');
        print('- Verifica que el backend esté corriendo');
        print('- Verifica que la IP sea correcta');
        print('- Verifica que estés en la misma red WiFi');
        print('- Prueba con ping a la IP desde tu terminal');
      }
    });
  }
}

void main() {
  IpChanger.runDiagnostics();
}
