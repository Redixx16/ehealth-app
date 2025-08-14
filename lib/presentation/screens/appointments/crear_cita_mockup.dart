import 'package:flutter/material.dart';

// --- Paleta de Colores Profesional ---
const Color kPrimaryColorProfessional = Color(0xFF0D47A1); // Azul Corporativo
const Color kBackgroundColorProfessional = Color(0xFFF5F7FA);

// --- EJECUTA ESTA APP PARA VER LA PLANTILLA DE CREACIÓN DE CITA ---
void main() {
  runApp(const CreateAppointmentMockupApp());
}

class CreateAppointmentMockupApp extends StatelessWidget {
  const CreateAppointmentMockupApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crear Cita Mockup',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColorProfessional,
        scaffoldBackgroundColor: kBackgroundColorProfessional,
        fontFamily: 'sans-serif',
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide:
                const BorderSide(color: kPrimaryColorProfessional, width: 2.0),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      home: const CreateAppointmentScreen(),
    );
  }
}

// --- PANTALLA DE CREACIÓN DE CITA (ROL: PERSONAL DE SALUD) ---
class CreateAppointmentScreen extends StatefulWidget {
  const CreateAppointmentScreen({super.key});

  @override
  State<CreateAppointmentScreen> createState() =>
      _CreateAppointmentScreenState();
}

class _CreateAppointmentScreenState extends State<CreateAppointmentScreen> {
  // Valor de ejemplo para el dropdown
  String? _selectedPatient = 'Ana Lucía Rojas';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColorProfessional,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black54),
        title: const Text(
          'Programar Nueva Cita', // Título requerido
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Información del Paciente"),
            // --- CAMPO DESPLEGABLE: SELECCIONAR PACIENTE ---
            DropdownButtonFormField<String>(
              initialValue: _selectedPatient,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedPatient = newValue;
                });
              },
              items: <String>['Ana Lucía Rojas', 'Mariana Torres', 'Sofia Vera']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Seleccionar Paciente', // Etiqueta del campo
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionTitle("Fecha y Hora del Control"),
            // --- CAMPOS DE FECHA Y HORA ---
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    controller: TextEditingController(text: '23 / 06 / 2025'),
                    decoration: const InputDecoration(
                      labelText: 'Fecha',
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                    ),
                    onTap: () {/* Simula abrir el selector de fecha */},
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    controller: TextEditingController(text: '10:30 AM'),
                    decoration: const InputDecoration(
                      labelText: 'Hora',
                      prefixIcon: Icon(Icons.access_time_outlined),
                    ),
                    onTap: () {/* Simula abrir el selector de hora */},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            _buildSectionTitle("Detalles del Control"),
            // --- ÁREA DE TEXTO GRANDE ---
            TextFormField(
              maxLines: 5,
              decoration: const InputDecoration(
                labelText:
                    'Recomendaciones e Indicaciones', // Etiqueta del campo
                hintText: 'Escriba aquí las indicaciones para la paciente...',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 32),

            // --- BOTÓN PRINCIPAL: GUARDAR CITA ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.save_outlined),
                label: const Text('Guardar Cita'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColorProfessional,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black54,
        ),
      ),
    );
  }
}
