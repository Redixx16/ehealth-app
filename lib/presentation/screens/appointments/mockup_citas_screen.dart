import 'package:flutter/material.dart';
// Para ImageFilter

// --- PANTALLA PRINCIPAL DE CITAS ---
class MockupCitasScreen extends StatelessWidget {
  const MockupCitasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          _buildNextAppointmentCard(),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          _buildQuickActions(),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
          _buildSectionHeader("Encuentra un Especialista"),
          _buildSpecialistsList(),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
          _buildSectionHeader("Artículos de Salud"),
          _buildHealthArticles(),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.grey[100],
      elevation: 0,
      pinned: true,
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hola de nuevo,',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          Text(
            'Carlos Ruiz',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ],
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            radius: 22,
            backgroundImage:
                NetworkImage('https://randomuser.me/api/portraits/men/32.jpg'),
          ),
        ),
      ],
    );
  }

  Widget _buildNextAppointmentCard() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color(0xFF1E88E5), Color(0xFF0D47A1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Próxima Cita',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 10),
              const Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(
                        'https://randomuser.me/api/portraits/women/44.jpg'),
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dr. Ana Torres',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text('Cardiología',
                          style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_today, color: Colors.white, size: 16),
                    SizedBox(width: 8),
                    Text('Mañana, 23 de Junio',
                        style: TextStyle(color: Colors.white)),
                    SizedBox(width: 15),
                    Icon(Icons.access_time, color: Colors.white, size: 16),
                    SizedBox(width: 8),
                    Text('11:30 AM', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return SliverToBoxAdapter(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionItem(Icons.add_circle_outline, "Agendar\nCita"),
          _buildActionItem(Icons.medical_services_outlined, "Mis\nRecetas"),
          _buildActionItem(Icons.folder_open_outlined, "Mis\nExámenes"),
          _buildActionItem(Icons.person_search_outlined, "Buscar\nDoctores"),
        ],
      ),
    );
  }

  Widget _buildActionItem(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10)
              ]),
          child: Icon(icon, color: const Color(0xFF0D47A1), size: 30),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              'Ver todos',
              style: TextStyle(color: Colors.blue[700], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialistsList() {
    final specialists = [
      {
        'name': 'Dermatólogo',
        'img': 'https://randomuser.me/api/portraits/women/2.jpg'
      },
      {
        'name': 'Psicólogo',
        'img': 'https://randomuser.me/api/portraits/men/5.jpg'
      },
      {
        'name': 'Nutricionista',
        'img': 'https://randomuser.me/api/portraits/women/8.jpg'
      },
      {
        'name': 'Pediatra',
        'img': 'https://randomuser.me/api/portraits/men/12.jpg'
      },
    ];

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 140,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: specialists.length,
          padding: const EdgeInsets.only(left: 16, top: 10),
          itemBuilder: (context, index) {
            return Container(
              width: 100,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(specialists[index]['img']!),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    specialists[index]['name']!,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHealthArticles() {
    final articles = [
      {
        'title': '5 Tips para un Corazón Sano',
        'img':
            'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w1NzA4fDB8MXxzZWFyY2h8MTF8fGhlYWx0aHklMjBoZWFydHxlbnwwfHx8fDE3MTkyMTQ3MzF8MA&ixlib=rb-4.0.3&q=80&w=400'
      },
      {
        'title': 'La Importancia de Dormir Bien',
        'img':
            'https://images.unsplash.com/photo-1530533718754-001d262892d7?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w1NzA4fDB8MXxzZWFyY2h8Mnx8c2xlZXB8ZW58MHx8fHwxNzE5MjE0Nzc3fDA&ixlib=rb-4.0.3&q=80&w=400'
      },
      {
        'title': 'Dieta Mediterránea: Beneficios',
        'img':
            'https://images.unsplash.com/photo-1540420773420-2850a26b0f58?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w1NzA4fDB8MXxzZWFyY2h8NHx8bWVkaXRlcnJhbmVhbiUyMGZvb2R8ZW58MHx8fHwxNzE5MjE0ODE1fDA&ixlib=rb-4.0.3&q=80&w=400'
      },
    ];

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 150,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: 16, top: 10),
          itemCount: articles.length,
          itemBuilder: (context, index) {
            return Container(
              width: 220,
              margin: const EdgeInsets.only(right: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: NetworkImage(articles[index]['img']!),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.4), BlendMode.darken),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    articles[index]['title']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
