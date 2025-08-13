// lib/presentation/screens/auth/register_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ehealth_app/injection_container.dart' as di; // Importa GetIt
import '../../bloc/register/register_bloc.dart';

// Reutilizamos la paleta de colores de la pantalla de login para consistencia
const Color kPrimaryColor = Color(0xFFF48FB1);
const Color kPrimaryLightColor = Color(0xFFF8BBD0);
const Color kBackgroundColor = Color(0xFFFFF7F8);
const Color kTextColor = Color(0xFF424242);

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

// Añadimos SingleTickerProviderStateMixin para las animaciones
class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _fullNameController = TextEditingController();
  String _role = 'gestante';
  bool _isPasswordVisible = false;

  // Controlador y variables para la animación escalonada
  late AnimationController _animationController;
  late List<Animation<Offset>> _slideAnimations;
  late List<Animation<double>> _fadeAnimations;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    const int itemCount = 5;
    const double itemAnimationDuration = 0.5;
    const double step = 0.15;

    _slideAnimations = List.generate(
      itemCount,
      (index) => Tween<Offset>(
        begin: const Offset(0, 0.5),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
            step * index,
            (step * index) + itemAnimationDuration > 1.0
                ? 1.0
                : (step * index) + itemAnimationDuration,
            curve: Curves.easeOutCubic),
      )),
    );

    _fadeAnimations = List.generate(
      itemCount,
      (index) => Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
            step * index,
            (step * index) + itemAnimationDuration > 1.0
                ? 1.0
                : (step * index) + itemAnimationDuration,
            curve: Curves.easeOutCubic),
      )),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  void _onRegister(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
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
    return BlocProvider(
      // CORRECCIÓN: Usamos GetIt para crear el BLoC
      create: (_) => di.locator<RegisterBloc>(),
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: BlocConsumer<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content:
                        Text('¡Registro exitoso! Ya puedes iniciar sesión.'),
                    backgroundColor: Colors.green,
                  ),
                );
              Navigator.of(context).pop();
            } else if (state is RegisterFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.redAccent,
                  ),
                );
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                _buildDecorativeShape(),
                SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(),
                          const SizedBox(height: 32),
                          _buildRegisterForm(context, state),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BackButton(color: kTextColor.withOpacity(0.7)),
        const SizedBox(height: 16),
        Text(
          'Crea tu cuenta',
          style: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: kTextColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Es rápido y fácil.',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: kTextColor.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterForm(BuildContext context, RegisterState state) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildAnimatedFormField(
            animationIndex: 0,
            child: TextFormField(
              controller: _fullNameController,
              decoration: _buildInputDecoration(
                hintText: 'Nombre completo',
                icon: Icons.person_outline,
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Ingresa tu nombre completo'
                  : null,
            ),
          ),
          const SizedBox(height: 16),
          _buildAnimatedFormField(
            animationIndex: 1,
            child: TextFormField(
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
                if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
                  return 'Email inválido';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 16),
          _buildAnimatedFormField(
            animationIndex: 2,
            child: TextFormField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: _buildInputDecoration(
                hintText: 'Contraseña',
                icon: Icons.lock_outline,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: kTextColor.withOpacity(0.5),
                  ),
                  onPressed: () =>
                      setState(() => _isPasswordVisible = !_isPasswordVisible),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingresa tu contraseña';
                }
                if (value.length < 6) return 'Mínimo 6 caracteres';
                return null;
              },
            ),
          ),
          const SizedBox(height: 16),
          _buildAnimatedFormField(
            animationIndex: 3,
            child: TextFormField(
              controller: _confirmPasswordController,
              obscureText: !_isPasswordVisible,
              decoration: _buildInputDecoration(
                hintText: 'Confirmar contraseña',
                icon: Icons.lock_outline,
              ),
              validator: (value) => (value != _passwordController.text)
                  ? 'Las contraseñas no coinciden'
                  : null,
            ),
          ),
          const SizedBox(height: 16),
          _buildAnimatedFormField(
            animationIndex: 4,
            child: DropdownButtonFormField<String>(
              value: _role,
              decoration: _buildInputDecoration(
                hintText: 'Soy...',
                icon: Icons.people_outline,
              ),
              items: const [
                DropdownMenuItem(value: 'gestante', child: Text('Gestante')),
                DropdownMenuItem(
                    value: 'personal_salud', child: Text('Personal de salud')),
              ],
              onChanged: (value) => setState(() => _role = value!),
            ),
          ),
          const SizedBox(height: 32),
          _buildRegisterButton(context, state),
        ],
      ),
    );
  }

  Widget _buildAnimatedFormField(
      {required int animationIndex, required Widget child}) {
    return FadeTransition(
      opacity: _fadeAnimations[animationIndex],
      child: SlideTransition(
        position: _slideAnimations[animationIndex],
        child: child,
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: kPrimaryColor.withOpacity(0.8)),
      hintText: hintText,
      hintStyle: GoogleFonts.poppins(color: kTextColor.withOpacity(0.6)),
      filled: true,
      fillColor: Colors.white.withOpacity(0.8),
      suffixIcon: suffixIcon,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: kPrimaryColor, width: 2),
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context, RegisterState state) {
    final isLoading = state is RegisterLoading;
    return GestureDetector(
      onTap: isLoading ? null : () => _onRegister(context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 50,
        width: isLoading ? 50 : double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [kPrimaryLightColor, kPrimaryColor],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(isLoading ? 25 : 30),
          boxShadow: [
            if (!isLoading)
              BoxShadow(
                color: kPrimaryColor.withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(0, 5),
              )
          ],
        ),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 2.5)
              : Text(
                  'Registrarme',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildDecorativeShape() {
    return Positioned(
      bottom: -100,
      left: -100,
      child: Container(
        height: 300,
        width: 300,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              kPrimaryColor.withOpacity(0.3),
              kPrimaryLightColor.withOpacity(0.1),
              kBackgroundColor.withOpacity(0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
