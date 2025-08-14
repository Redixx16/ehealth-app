// lib/presentation/screens/patient/gamification/education_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Paleta de colores consistente
const Color kPrimaryColor = Color(0xFFF48FB1);
const Color kPrimaryLightColor = Color(0xFFF8BBD0);
const Color kBackgroundColor = Color(0xFFFFF7F8);
const Color kTextColor = Color(0xFF424242);

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  // Datos de ejemplo
  final List<EducationArticle> articles = [
    EducationArticle(
      id: 1,
      title: 'Nutrición Esencial en el Embarazo',
      description:
          'Guía sobre qué comer para mantener una dieta saludable para ti y tu bebé.',
      category: 'Nutrición',
      readTime: '5 min',
      icon: Icons.restaurant_menu_outlined,
      isBookmarked: false,
    ),
    EducationArticle(
      id: 2,
      title: 'Ejercicios Seguros y Recomendados',
      description:
          'Rutinas de ejercicio apropiadas para cada trimestre de tu embarazo.',
      category: 'Ejercicio',
      readTime: '8 min',
      icon: Icons.fitness_center_outlined,
      isBookmarked: true,
    ),
    EducationArticle(
      id: 3,
      title: 'Preparándote para el Gran Día',
      description:
          'Todo lo que necesitas saber para prepararte física y mentalmente para el parto.',
      category: 'Parto',
      readTime: '12 min',
      // 'icon' no se provee intencionalmente para probar el fallback
      isBookmarked: false,
    ),
    EducationArticle(
      id: 4,
      title: 'Primeros Cuidados del Recién Nacido',
      description:
          'Consejos esenciales para el cuidado de tu bebé en los primeros y preciosos días.',
      category: 'Cuidado del bebé',
      readTime: '10 min',
      icon: Icons.stroller_outlined,
      isBookmarked: false,
    ),
  ];

  final List<String> categories = [
    'Todos',
    'Nutrición',
    'Ejercicio',
    'Parto',
    'Cuidado del bebé',
  ];

  String selectedCategory = 'Todos';

  @override
  Widget build(BuildContext context) {
    final filteredArticles = selectedCategory == 'Todos'
        ? articles
        : articles
            .where((article) => article.category == selectedCategory)
            .toList();

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          _buildHeader(),
          _buildCategoryFilter(),
          _buildArticlesList(filteredArticles),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [kPrimaryColor, kPrimaryLightColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: kPrimaryColor.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.school_outlined,
                  color: Colors.white, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Aprende y Crece',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Recursos para tu bienestar',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SliverToBoxAdapter(
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          padding: const EdgeInsets.only(left: 16),
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = category == selectedCategory;
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: FilterChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    selectedCategory = category;
                  });
                },
                backgroundColor: Colors.white,
                selectedColor: kPrimaryColor,
                checkmarkColor: Colors.white,
                labelStyle: GoogleFonts.poppins(
                  color: isSelected ? Colors.white : kTextColor,
                  fontWeight: FontWeight.w600,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected ? kPrimaryColor : kPrimaryLightColor,
                    width: 1.5,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildArticlesList(List<EducationArticle> articles) {
    if (articles.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Text(
            'No hay artículos en esta categoría.',
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final article = articles[index];
            return _buildArticleCard(article);
          },
          childCount: articles.length,
        ),
      ),
    );
  }

  Widget _buildArticleCard(EducationArticle article) {
    return Card(
      elevation: 2,
      shadowColor: kPrimaryColor.withOpacity(0.1),
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: kPrimaryLightColor.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    // ================== CORRECCIÓN CLAVE ==================
                    // Usamos un ícono por defecto si el del artículo es nulo
                    child: Icon(article.icon ?? Icons.school_outlined,
                        color: kPrimaryColor, size: 24),
                    // ======================================================
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.title,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: kTextColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          article.category,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                article.description,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              const Divider(height: 24),
              Row(
                children: [
                  Icon(Icons.access_time,
                      size: 16, color: Colors.grey.shade500),
                  const SizedBox(width: 6),
                  Text(
                    'Lectura de ${article.readTime}',
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: Colors.grey.shade500),
                  ),
                  const Spacer(),
                  Icon(
                    article.isBookmarked
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    color: article.isBookmarked
                        ? kPrimaryColor
                        : Colors.grey.shade400,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EducationArticle {
  final int id;
  final String title;
  final String description;
  final String category;
  final String readTime;
  // ================== CORRECCIÓN CLAVE ==================
  // Hacemos que el ícono sea opcional (nullable) añadiendo '?'
  final IconData? icon;
  // ======================================================
  bool isBookmarked;

  EducationArticle({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.readTime,
    this.icon, // Ya no es 'required'
    required this.isBookmarked,
  });
}
