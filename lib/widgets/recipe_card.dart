import 'package:flutter/material.dart';
import '../models/recipe.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb; // Para Image.file

import '../services/recipe_service.dart'; // Importar o serviço para acesso às cores

class RecipeCard extends StatelessWidget {
  const RecipeCard({
    super.key,
    required this.recipe,
    required this.onToggleFavorite,
  });

  final Recipe recipe;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    // Instancia o RecipeService para pegar as cores
    final RecipeService recipeService = RecipeService();

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: recipe.imageUrl.startsWith('assets/')
                  ? Image.asset(
                      recipe.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : kIsWeb
                      ? Image.asset(
                          // Fallback para web se for caminho local
                          'assets/images/default_recipe.png',
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(recipe.imageUrl),
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (recipe.category != null)
                  Container(
                    margin: const EdgeInsets.only(top: 4.0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      // Usar cor da categoria
                      color: recipeService.getCategoryColor(recipe.category!),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      recipe.category!,
                      style: TextStyle(
                        // Usar cor do texto da categoria para contraste
                        color: recipeService.getCategoryTextColor(
                          recipe.category!,
                        ),
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        Text(
                          recipe.rating.toStringAsFixed(1),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        recipe.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.red,
                      ),
                      onPressed: onToggleFavorite,
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
}
