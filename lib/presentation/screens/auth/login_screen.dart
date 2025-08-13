import 'package:ehealth_app/presentation/screens/auth/home_dispatcher_screen.dart';
import 'package:ehealth_app/presentation/bloc/login/login_bloc.dart';
import 'package:ehealth_app/presentation/bloc/login/login_event.dart';
import 'package:ehealth_app/presentation/bloc/login/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ehealth_app/presentation/screens/auth/register_screen.dart';
import 'package:google_fonts/google_fonts.dart';

// Colores principales de la app
const Color kPrimaryColor = Color(0xFFF48FB1);
const Color kPrimaryLightColor = Color(0xFFF8BBD0);
const Color kBackgroundColor = Color(0xFFFFF7F8);
const Color kTextColor = Color(0xFF424242);

// --> NUEVO: Convertimos el widget a StatefulWidget para manejar la animación
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// --> NUEVO: Añadimos 'SingleTickerProviderStateMixin' para la animación
class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // --> NUEVO: Variables para controlar la animación de deslizamiento
  late final AnimationController _animationController;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // --> NUEVO: Configuración e inicio de la animación
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(
          0, 1.5), // Empieza abajo (1.5 = 150% de su altura hacia abajo)
      end: Offset.zero, // Termina en su posición original
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutQuad, // Una curva suave para desacelerar al final
    ));

    _animationController.forward(); // Inicia la animación
  }

  @override
  void dispose() {
    // --> NUEVO: Es crucial limpiar los controladores para evitar fugas de memoria
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
          if (state is LoginSuccess) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => HomeDispatcherScreen(role: state.role),
              ),
              (route) => false,
            );
          }
        },
        child: Stack(
          children: [
            ClipPath(
              clipper: _CustomLoginClipper(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.45,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [kPrimaryLightColor, kPrimaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    _buildHeader(context),
                    // --> NUEVO: Envolvemos el formulario en el widget de animación
                    SlideTransition(
                      position: _slideAnimation,
                      child: _buildLoginForm(context),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/maternal_logo.png',
            height: 120,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.favorite_border,
                size: 100,
                color: Colors.white.withOpacity(0.9),
              );
            },
          ),
          const SizedBox(height: 16),
          Text(
            'eHealth Prenatal',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 5,
          shadowColor: kPrimaryLightColor.withOpacity(0.5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Bienvenida',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: kPrimaryColor,
                  ),
                ),
                const SizedBox(height: 24),
                _buildEmailField(),
                const SizedBox(height: 16),
                _buildPasswordField(),
                _buildForgotPassword(context),
                const SizedBox(height: 24),
                _buildLoginButton(context),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        _buildRegisterLink(context),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Correo Electrónico',
        labelStyle: GoogleFonts.poppins(color: kTextColor.withOpacity(0.7)),
        prefixIcon: const Icon(Icons.email_outlined, color: kPrimaryColor),
        filled: true,
        fillColor: kBackgroundColor.withOpacity(0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: kPrimaryColor, width: 2),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Contraseña',
        labelStyle: GoogleFonts.poppins(color: kTextColor.withOpacity(0.7)),
        prefixIcon: const Icon(Icons.lock_outline, color: kPrimaryColor),
        filled: true,
        fillColor: kBackgroundColor.withOpacity(0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: kPrimaryColor, width: 2),
        ),
      ),
      obscureText: true,
    );
  }

  Widget _buildForgotPassword(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          // TODO: Implementar lógica de "Olvidé mi contraseña"
        },
        child: Text(
          '¿Olvidaste tu contraseña?',
          style: GoogleFonts.poppins(color: kTextColor.withOpacity(0.8)),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    final buttonWidth = MediaQuery.of(context).size.width - 48 - 48;

    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        final isLoading = state is LoginLoading;
        return GestureDetector(
          onTap: isLoading
              ? null
              : () {
                  context.read<LoginBloc>().add(
                        LoginButtonPressed(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                        ),
                      );
                },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 50,
            width: isLoading ? 50 : buttonWidth,
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
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Text(
                      'Ingresar',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRegisterLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '¿No tienes una cuenta?',
          style: GoogleFonts.poppins(color: kTextColor),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const RegisterScreen()),
            );
          },
          child: Text(
            'Regístrate aquí',
            style: GoogleFonts.poppins(
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _CustomLoginClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.8);
    path.cubicTo(
      size.width * 0.25,
      size.height * 0.7,
      size.width * 0.3,
      size.height,
      size.width * 0.6,
      size.height * 0.9,
    );
    path.cubicTo(
      size.width * 0.8,
      size.height * 0.8,
      size.width * 0.95,
      size.height * 0.95,
      size.width,
      size.height * 0.85,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
