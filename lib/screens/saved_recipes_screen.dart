import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';
import '../widgets/recipe_card.dart';
import 'package:provider/provider.dart';

class SavedRecipesScreen extends StatefulWidget {
  const SavedRecipesScreen({super.key});

  @override
  State<SavedRecipesScreen> createState() => _SavedRecipesScreenState();
}

class _SavedRecipesScreenState extends State<SavedRecipesScreen> {
  void _navigateToRecipeDetail(Recipe recipe) async {
    final dynamic result = await Navigator.pushNamed(
      context,
      '/recipe_detail',
      arguments: recipe,
    );

    if (!mounted) return;

    if (result == true) {
      // Receita deletada
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Receita excluída com sucesso!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receitas Salvas'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Consumer<RecipeService>(
        builder:
            (BuildContext context, RecipeService recipeService, Widget? child) {
          final currentSavedRecipes = recipeService.getSavedRecipes();

          return currentSavedRecipes.isEmpty
              ? const Center(
                  child: Text('Nenhuma receita salva ainda!'),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: currentSavedRecipes.length,
                  itemBuilder: (BuildContext itemContext, int index) {
                    final recipe = currentSavedRecipes[index];
                    return GestureDetector(
                      onTap: () => _navigateToRecipeDetail(recipe),
                      child: RecipeCard(
                        recipe: recipe,
                        onToggleFavorite: () =>
                            recipeService.toggleFavorite(recipe.id),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
