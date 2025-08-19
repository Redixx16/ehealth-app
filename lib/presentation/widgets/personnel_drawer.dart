// lib/presentation/widgets/personnel_drawer.dart
import 'package:ehealth_app/presentation/bloc/login/login_bloc.dart';
import 'package:ehealth_app/presentation/screens/auth/login_screen.dart';
import 'package:ehealth_app/presentation/screens/personnel/personnel_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ehealth_app/injection_container.dart' as di;

class PersonnelDrawer extends StatelessWidget {
  final String personnelName;
  final String personnelEmail;

  const PersonnelDrawer({
    super.key,
    required this.personnelName,
    required this.personnelEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          _buildDrawerHeader(context, personnelName, personnelEmail),
          const SizedBox(height: 10),
          _buildDrawerMenuList(context),
          const Spacer(),
          const Divider(indent: 16, endIndent: 16),
          _buildLogoutTile(context),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context, String name, String email) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
      decoration: BoxDecoration(
        color: theme.primaryColor,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.white.withOpacity(0.9),
            child: Icon(
              Icons.local_hospital_outlined,
              size: 32,
              color: theme.primaryColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: theme.textTheme.titleLarge
                        ?.copyWith(color: Colors.white)),
                Text(email,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: Colors.white.withOpacity(0.9))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerMenuList(BuildContext context) {
    return Column(
      children: [
        _buildDrawerItem(
          context,
          icon: Icons.account_circle_outlined,
          text: 'Mi Perfil',
          onTap: () {
            Navigator.pop(context); // Cierra el drawer
            // ================== CORRECCIÓN CLAVE AQUÍ ==================
            // Navegamos a la pantalla de perfil pasando los datos
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PersonnelProfileScreen(
                  fullName: personnelName,
                  email: personnelEmail,
                ),
              ),
            );
            // ==========================================================
          },
        ),
        _buildDrawerItem(
          context,
          icon: Icons.bar_chart_outlined,
          text: 'Generar Reportes',
          onTap: () {
            // Lógica para navegar a la pantalla de reportes
          },
        ),
        _buildDrawerItem(
          context,
          icon: Icons.settings_outlined,
          text: 'Configuración',
          onTap: () {
            // Lógica para navegar a la pantalla de configuración
          },
        ),
      ],
    );
  }

  Widget _buildDrawerItem(BuildContext context,
      {required IconData icon,
      required String text,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey.shade600),
      title: Text(text, style: Theme.of(context).textTheme.titleMedium),
      onTap: onTap,
    );
  }

  Widget _buildLogoutTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.redAccent),
      title: Text(
        'Cerrar sesión',
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(color: Colors.redAccent, fontWeight: FontWeight.w600),
      ),
      onTap: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('jwt_token');
        if (!context.mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => di.locator<LoginBloc>(),
              child: const LoginScreen(),
            ),
          ),
          (Route<dynamic> route) => false,
        );
      },
    );
  }
}
