// lib/presentation/screens/personnel/personnel_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kPrimary = Color(0xFF0D47A1);
const Color kAccent = Color(0xFF1976D2);
const Color kBackground = Color(0xFFF5F7FA);
const double _cardRadius = 14.0;

class PersonnelProfileScreen extends StatefulWidget {
  final String fullName;
  final String email;
  final String? avatarUrl;

  const PersonnelProfileScreen({
    super.key,
    required this.fullName,
    required this.email,
    this.avatarUrl,
  });

  @override
  State<PersonnelProfileScreen> createState() => _PersonnelProfileScreenState();
}

class _PersonnelProfileScreenState extends State<PersonnelProfileScreen> {
  // Datos simulados (puedes sustituir por datos reales)
  String specialty = 'Ginecólogo Obstetra';
  String phone = '+51 987 654 321';
  double rating = 4.6;
  bool notificationsOn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: Text('Perfil profesional',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: kPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // BANNER SIMPLE (sin solapamientos)
              _buildBanner(context),

              const SizedBox(height: 18),

              // ROW: Avatar + Nombre + Acción (sin overlap)
              _buildProfileRow(context),

              const SizedBox(height: 18),

              // TARJETAS ESTADÍSTICAS HORIZONTALES
              _buildHorizontalStats(),

              const SizedBox(height: 18),

              // INFO: Contacto
              _buildCardSection(
                title: 'Información de contacto',
                children: [
                  _infoTile(Icons.email_outlined, 'Correo', widget.email,
                      trailing: IconButton(
                          icon: const Icon(Icons.copy_outlined, size: 18),
                          onPressed: () {
                            // copiar correo
                          })),
                  const Divider(),
                  _infoTile(Icons.phone_outlined, 'Teléfono', phone,
                      trailing: IconButton(
                          icon: const Icon(Icons.call_outlined, size: 18),
                          onPressed: () {
                            // llamada
                          })),
                  const Divider(),
                  _infoTile(Icons.work_outline, 'Especialidad', specialty),
                ],
              ),

              const SizedBox(height: 12),

              // INFO: Cuenta y Preferencias
              _buildCardSection(
                title: 'Cuenta y preferencias',
                children: [
                  _menuTile(Icons.edit_outlined, 'Editar perfil', onTap: () {}),
                  const Divider(),
                  _menuTile(Icons.lock_outline, 'Cambiar contraseña',
                      onTap: () {}),
                  const Divider(),
                  SwitchListTile(
                    value: notificationsOn,
                    onChanged: (v) => setState(() => notificationsOn = v),
                    title: Text('Notificaciones',
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    secondary: const Icon(Icons.notifications_outlined),
                    contentPadding: EdgeInsets.zero,
                  ),
                  const Divider(),
                  _menuTile(Icons.logout, 'Cerrar sesión',
                      destructive: true, onTap: () {}),
                ],
              ),

              const SizedBox(height: 12),

              // SOBRE MI
              _buildCardSection(
                title: 'Sobre mí',
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6, bottom: 8),
                    child: Text(
                      'Médico con 8+ años de experiencia en ginecología y obstetricia. '
                      'Atención centrada en el paciente, control prenatal y procedimientos mínimamente invasivos.',
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        color: Colors.grey.shade800,
                        height: 1.35,
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _tag('Obstetricia'),
                      _tag('Ginecología'),
                      _tag('Ecografía'),
                      _tag('Control prenatal'),
                    ],
                  )
                ],
              ),

              const SizedBox(height: 22),

              // BOTONES DE ACCIÓN IMPORTANTES (alineados)
              _buildActionButtons(),

              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- Widgets internos ----------

  Widget _buildBanner(BuildContext context) {
    // banner simple con gradiente y icono, sin superponer nada
    return Container(
      height: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_cardRadius),
        gradient: const LinearGradient(
          colors: [kPrimary, kAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // Icono grande a la izquierda
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.local_hospital_outlined,
                  size: 36, color: Colors.white),
            ),
            const SizedBox(width: 12),
            // Texto descriptivo
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Perfil profesional',
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                  const SizedBox(height: 6),
                  Text(
                    'Gestiona tu información, horarios y preferencias desde aquí.',
                    style: GoogleFonts.poppins(
                        fontSize: 13, color: Colors.white70),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProfileRow(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar (sin solapar)
          CircleAvatar(
            radius: 36,
            backgroundColor: kPrimary,
            backgroundImage: widget.avatarUrl != null
                ? NetworkImage(widget.avatarUrl!)
                : null,
            child: widget.avatarUrl == null
                ? const Icon(Icons.person, size: 36, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 14),

          // Nombre y detalles
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.fullName,
                    style: GoogleFonts.poppins(
                        fontSize: 17, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(specialty,
                    style: GoogleFonts.poppins(
                        fontSize: 13.5, color: Colors.grey.shade700)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.star, size: 16, color: Colors.amber.shade600),
                    const SizedBox(width: 6),
                    Text(rating.toStringAsFixed(1),
                        style: GoogleFonts.poppins(fontSize: 13.5)),
                    const SizedBox(width: 12),
                    Text('·',
                        style:
                            GoogleFonts.poppins(color: Colors.grey.shade500)),
                    const SizedBox(width: 12),
                    Text('Activo',
                        style: GoogleFonts.poppins(
                            fontSize: 13.0, color: Colors.green.shade700)),
                  ],
                )
              ],
            ),
          ),

          // Botones secundarios (pequeños)
          Column(
            children: [
              IconButton(
                tooltip: 'Editar',
                onPressed: () {},
                icon: Icon(Icons.edit_outlined, color: kPrimary),
              ),
              IconButton(
                tooltip: 'Más',
                onPressed: () {},
                icon: Icon(Icons.more_vert, color: Colors.grey.shade600),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildHorizontalStats() {
    // tarjetas horizontales independientes; no se solapan
    final stats = [
      {'label': 'Pacientes', 'value': '25', 'color': Colors.blue},
      {'label': 'Citas hoy', 'value': '8', 'color': Colors.green},
      {'label': 'Alertas', 'value': '3', 'color': Colors.orange},
    ];

    return SizedBox(
      height: 108,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: stats.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final s = stats[i];
          return Container(
            width: 150,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: (s['color'] as Color).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8)),
                      child: Icon(
                        Icons.bar_chart,
                        color: s['color'] as Color,
                        size: 18,
                      ),
                    ),
                    const Spacer(),
                    Text(s['value'] as String,
                        style: GoogleFonts.poppins(
                            fontSize: 18, fontWeight: FontWeight.w700)),
                  ],
                ),
                const Spacer(),
                Text(
                  s['label'] as String,
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 6),
                // barra visual (sin calcular progreso exacto)
                LinearProgressIndicator(
                  value: i == 0 ? 0.75 : (i == 1 ? 0.4 : 0.12),
                  minHeight: 6,
                  backgroundColor: Colors.grey.shade200,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(s['color'] as Color),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCardSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 14,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.poppins(
                  fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String subtitle,
      {Widget? trailing}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: kPrimary.withOpacity(0.08),
        child: Icon(icon, color: kPrimary, size: 18),
      ),
      title:
          Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle,
          style: GoogleFonts.poppins(color: Colors.grey.shade700)),
      trailing: trailing,
      onTap: () {},
    );
  }

  Widget _menuTile(IconData icon, String title,
      {required VoidCallback onTap, bool destructive = false}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 18,
        backgroundColor:
            destructive ? Colors.red.withOpacity(0.08) : Colors.grey.shade100,
        child: Icon(icon,
            color: destructive ? Colors.red : Colors.grey.shade700, size: 18),
      ),
      title: Text(title,
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: destructive ? Colors.red.shade700 : Colors.black87)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _tag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: GoogleFonts.poppins(fontSize: 12)),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.calendar_month_outlined),
            label: Text('Ver agenda', style: GoogleFonts.poppins()),
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 6,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.message_outlined),
            label: Text('Mensaje', style: GoogleFonts.poppins()),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              side: BorderSide(color: kPrimary.withOpacity(0.14)),
            ),
          ),
        ),
      ],
    );
  }
}
