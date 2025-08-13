import 'package:flutter/material.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  final List<EducationArticle> articles = [
    EducationArticle(
      id: 1,
      title: 'Nutrición durante el embarazo',
      description:
          'Guía completa sobre qué comer y qué evitar durante el embarazo para mantener una dieta saludable.',
      category: 'Nutrición',
      readTime: '5 min',
      imageUrl: 'assets/images/nutrition.jpg',
      isBookmarked: false,
    ),
    EducationArticle(
      id: 2,
      title: 'Ejercicios seguros para embarazadas',
      description:
          'Rutinas de ejercicio apropiadas para cada trimestre del embarazo.',
      category: 'Ejercicio',
      readTime: '8 min',
      imageUrl: 'assets/images/exercise.jpg',
      isBookmarked: true,
    ),
    EducationArticle(
      id: 3,
      title: 'Preparación para el parto',
      description:
          'Todo lo que necesitas saber para prepararte física y mentalmente para el parto.',
      category: 'Parto',
      readTime: '12 min',
      imageUrl: 'assets/images/birth.jpg',
      isBookmarked: false,
    ),
    EducationArticle(
      id: 4,
      title: 'Cuidados del recién nacido',
      description:
          'Consejos esenciales para el cuidado de tu bebé en los primeros días.',
      category: 'Cuidado del bebé',
      readTime: '10 min',
      imageUrl: 'assets/images/baby.jpg',
      isBookmarked: false,
    ),
    EducationArticle(
      id: 5,
      title: 'Manejo del estrés en el embarazo',
      description:
          'Técnicas de relajación y manejo del estrés durante el embarazo.',
      category: 'Bienestar',
      readTime: '6 min',
      imageUrl: 'assets/images/stress.jpg',
      isBookmarked: true,
    ),
  ];

  final List<String> categories = [
    'Todos',
    'Nutrición',
    'Ejercicio',
    'Parto',
    'Cuidado del bebé',
    'Bienestar',
  ];

  String selectedCategory = 'Todos';

  @override
  Widget build(BuildContext context) {
    final filteredArticles = selectedCategory == 'Todos'
        ? articles
        : articles
            .where((article) => article.category == selectedCategory)
            .toList();

    return Container(
      color: const Color(0xFFF0F2F5),
      child: Column(
        children: [
          _buildHeader(),
          _buildCategoryFilter(),
          Expanded(
            child: _buildArticlesList(filteredArticles),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.school,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Aprende y Crece',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Recursos educativos para tu embarazo',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;

          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  selectedCategory = category;
                });
              },
              backgroundColor: Colors.white,
              selectedColor: Theme.of(context).primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildArticlesList(List<EducationArticle> articles) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        return _buildArticleCard(article);
      },
    );
  }

  Widget _buildArticleCard(EducationArticle article) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen del artículo (placeholder)
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.image,
                size: 50,
                color: Colors.grey.shade400,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(article.category)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        article.category,
                        style: TextStyle(
                          color: _getCategoryColor(article.category),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(
                        article.isBookmarked
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                        color:
                            article.isBookmarked ? Colors.amber : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          article.isBookmarked = !article.isBookmarked;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  article.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  article.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      article.readTime,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () => _onArticleTap(article),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Leer'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Nutrición':
        return Colors.green;
      case 'Ejercicio':
        return Colors.blue;
      case 'Parto':
        return Colors.purple;
      case 'Cuidado del bebé':
        return Colors.pink;
      case 'Bienestar':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _onArticleTap(EducationArticle article) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(article.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(article.description),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey.shade500),
                const SizedBox(width: 4),
                Text(
                  'Tiempo de lectura: ${article.readTime}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Navegar a la vista completa del artículo
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Abriendo: ${article.title}'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Leer Completo'),
          ),
        ],
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
  final String imageUrl;
  bool isBookmarked;

  EducationArticle({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.readTime,
    required this.imageUrl,
    required this.isBookmarked,
  });
}
