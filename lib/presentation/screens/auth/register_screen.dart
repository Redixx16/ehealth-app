import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/datasources/auth_remote_data_source.dart';
import '../../bloc/register/register_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _fullNameController = TextEditingController();
  String _role = 'gestante';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  void _onRegister(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<RegisterBloc>(context).add(
        RegisterSubmitted(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          role: _role,
          fullName: _fullNameController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const primaryColor = Color(0xFF6A5AE0); // Un color de acento morado
    const backgroundColor = Color(0xFFF0F2F5); // Un fondo gris claro

    return BlocProvider(
      create: (_) => RegisterBloc(AuthRemoteDataSource()),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: const Text(
            'Crear Cuenta Nueva',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.transparent, // Fondo transparente
          elevation: 0, // Sin sombra
          iconTheme: const IconThemeData(
              color: Colors.black87), // Ícono de retroceso negro
        ),
        body: BlocConsumer<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Registro exitoso. ¡Bienvenido/a!')),
              );
              Navigator.of(context).pop();
            } else if (state is RegisterFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    backgroundColor: Colors.redAccent,
                    content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            // Usamos SingleChildScrollView para evitar overflow cuando aparece el teclado
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // --- Header Text ---
                      Text(
                        'Únete a nuestra comunidad',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // --- Full Name Field ---
                      TextFormField(
                        controller: _fullNameController,
                        decoration: _buildInputDecoration(
                          hintText: 'Nombre completo',
                          icon: Icons.person_outline,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Ingresa tu nombre completo';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // --- Email Field ---
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _buildInputDecoration(
                          hintText: 'Email',
                          icon: Icons.email_outlined,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Ingresa tu email';
                          }
                          if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                              .hasMatch(value)) {
                            return 'Email inválido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // --- Password Field ---
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: _buildInputDecoration(
                          hintText: 'Contraseña',
                          icon: Icons.lock_outline,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresa tu contraseña';
                          }
                          if (value.length < 6) {
                            return 'Mínimo 6 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // --- Confirm Password Field ---
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: _buildInputDecoration(
                          hintText: 'Confirmar contraseña',
                          icon: Icons.lock_outline,
                        ),
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return 'Las contraseñas no coinciden';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // --- Role Dropdown ---
                      DropdownButtonFormField<String>(
                        value: _role,
                        decoration: _buildInputDecoration(
                          hintText: 'Rol',
                          icon: Icons.people_outline,
                        ),
                        items: const [
                          DropdownMenuItem(
                              value: 'gestante', child: Text('Gestante')),
                          DropdownMenuItem(
                              value: 'personal_salud',
                              child: Text('Personal de salud')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _role = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 32),

                      // --- Register Button ---
                      state is RegisterLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                  color: primaryColor))
                          : SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () => _onRegister(context),
                                child: const Text(
                                  'Registrarse',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

// --- Helper Method for InputDecoration ---
  InputDecoration _buildInputDecoration(
      {required String hintText, required IconData icon}) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.grey.shade600),
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey.shade600),
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none, // Sin borde
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
            color: Color(0xFF6A5AE0), width: 2), // Borde de acento al enfocar
      ),
    );
  }
}
