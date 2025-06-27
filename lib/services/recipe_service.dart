import 'package:flutter/material.dart';
import '../models/recipe.dart';
// import 'package:flutter/foundation.dart';

enum RecipeSortOrder { none, mostRecent, oldest, highestRated, mostFavorited }

class RecipeService extends ChangeNotifier {
  static final Map<String, Color> _categoryColors = {
    'Carnes': Colors.red[200]!,
    'Tortas e Bolos': Colors.brown[200]!,
    'Frutos do Mar': Colors.blue[200]!,
    'Saladas': Colors.green[200]!,
    'Molhos e Acompanhamentos': Colors.orange[200]!,
    'Sopas': Colors.teal[200]!,
    'Massas': Colors.amber[200]!,
    'Bebidas': Colors.purple[200]!,
    'Doces e Sobremesas': Colors.pink[200]!,
    'Lanches': Colors.lime[200]!,
    'Alimentação Saudável': Colors.lightGreen[200]!,
  };

  Color getCategoryColor(String category) {
    return _categoryColors[category] ?? Colors.grey[200]!;
  }

  Color getCategoryTextColor(String category) {
    final Color baseColor = _categoryColors[category] ?? Colors.grey[200]!;
    return baseColor.computeLuminance() > 0.5
        ? Colors.grey[800]!
        : Colors.white;
  }

// Lista de receitas de exemplo
  static final List<Recipe> _recipes = [
    Recipe(
      id: '1',
      name: 'Brigadeiro caseiro',
      rating: 4.9,
      imageUrl: 'assets/images/brigadeiro.png',
      category: 'Doces e Sobremesas',
      estimatedCost: 8.50,
      prepTime: '30 mins',
      ingredients: [
        '1 lata de leite condensado',
        '4 colheres de sopa de chocolate em pó',
        '2 colheres de sopa de manteiga',
        'Granulado para decorar',
      ],
      yieldAndQuantity: '20 brigadeiros',
      equipmentAndUtensils: ['Panela', 'Colher de pau', 'Prato untado'],
      preparationMethod: [
        'Misture o leite condensado, o chocolate em pó e a manteiga em uma panela.',
        'Leve ao fogo baixo, mexendo sempre até desgrudar do fundo da panela.',
        'Desligue o fogo, espere esfriar um pouco e enrole as bolinhas, passando-as no granulado.',
      ],
      createdAt: DateTime.now().subtract(
        const Duration(days: 50),
      ), // Data de criação
      updatedAt: DateTime.now().subtract(
        const Duration(days: 10),
      ), // Data de atualização
    ),
    Recipe(
      id: '2',
      name: 'Torta de frango',
      rating: 4.8,
      imageUrl: 'assets/images/torta_frango.png',
      category: 'Tortas e Bolos',
      estimatedCost: 25.00,
      prepTime: '1h 15 mins',
      ingredients: [
        '500g de peito de frango cozido e desfiado',
        '1 cebola picada',
        '1 tomate picado',
        '1/2 xícara de azeitonas picadas',
        'Massa pronta para torta',
        'Requeijão a gosto',
      ],
      yieldAndQuantity: '8 porções',
      equipmentAndUtensils: ['Assadeira', 'Panela', 'Garfo'],
      preparationMethod: [
        'Refogue a cebola e o tomate, adicione o frango desfiado e as azeitonas.',
        'Tempere a gosto e misture com requeijão.',
        'Forre uma assadeira com metade da massa, coloque o recheio e cubra com o restante da massa.',
        'Leve ao forno pré-aquecido até dourar.',
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    Recipe(
      id: '3',
      name: 'Bolo de chocolate',
      rating: 4.6,
      imageUrl: 'assets/images/bolo_chocolate.png',
      category: 'Tortas e Bolos',
      estimatedCost: 18.00,
      prepTime: '50 mins',
      ingredients: [
        '2 xícaras de farinha de trigo',
        '1 xícara de chocolate em pó',
        '2 xícaras de açúcar',
        '4 ovos',
        '1 xícara de leite',
        '1/2 xícara de óleo',
        '1 colher de sopa de fermento em pó',
      ],
      yieldAndQuantity: '1 bolo grande',
      equipmentAndUtensils: ['Batedeira', 'Forma de bolo', 'Tigelas'],
      preparationMethod: [
        'Bata os ovos, açúcar e óleo na batedeira.',
        'Adicione a farinha, chocolate e leite, misturando bem.',
        'Por último, adicione o fermento.',
        'Despeje na forma untada e enfarinhada e asse em forno médio por 40 minutos.',
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
    Recipe(
      id: '4',
      name: 'Mousse de Maracujá',
      rating: 4.5,
      imageUrl: 'assets/images/mousse_maracuja.png',
      category: 'Doces e Sobremesas',
      estimatedCost: 10.00,
      prepTime: '26 mins',
      ingredients: [
        '1 lata de leite condensado',
        '2 maracujás',
        '1 lata de creme de leite',
      ],
      yieldAndQuantity: '250ml',
      equipmentAndUtensils: ['Copo de vidro de 300ml', 'Liquidificador'],
      preparationMethod: [
        'Retire a polpa do maracujá',
        'bater a polpa e peneirar',
        'colocar no copo o leite condensado e o suco',
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
    Recipe(
      id: '5',
      name: 'Salada Caesar',
      rating: 4.2,
      imageUrl: 'assets/images/salada_caesar.png',
      category: 'Saladas',
      prepTime: '15 mins',
      ingredients: [
        'Alface romana',
        'Croutons',
        'Queijo parmesão',
        'Molho Caesar',
      ],
      yieldAndQuantity: '2 porções',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    Recipe(
      id: '6',
      name: 'Molho Branco Básico',
      rating: 4.0,
      imageUrl: 'assets/images/molho_branco.png',
      category: 'Molhos e Acompanhamentos',
      prepTime: '10 mins',
      ingredients: [
        'Manteiga',
        'Farinha de trigo',
        'Leite',
        'Sal',
        'Noz-moscada',
      ],
      yieldAndQuantity: '200ml',
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
    ),
    Recipe(
      id: '7',
      name: 'Bife à Parmegiana',
      rating: 4.7,
      imageUrl: 'assets/images/bife_a_parmediana.png',
      category: 'Carnes',
      prepTime: '45 mins',
      ingredients: [
        'Bifes de carne',
        'Molho de tomate',
        'Queijo mussarela',
        'Farinha de rosca',
        'Ovo',
      ],
      yieldAndQuantity: '4 porções',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
    Recipe(
      id: '8',
      name: 'Sopa de Legumes',
      rating: 4.3,
      imageUrl: 'assets/images/sopa_de_legumes.png',
      category: 'Sopas',
      prepTime: '1h',
      ingredients: ['Batata', 'Cenoura', 'Abobrinha', 'Caldo de legumes'],
      yieldAndQuantity: '6 porções',
      createdAt: DateTime.now().subtract(const Duration(days: 6)),
    ),
    Recipe(
      id: '9',
      name: 'Lasanha à Bolonhesa',
      rating: 4.9,
      imageUrl: 'assets/images/lasanha_a_bolonhesa.png',
      category: 'Massas',
      prepTime: '1h 30 mins',
      ingredients: [
        'Massa de lasanha',
        'Carne moída',
        'Molho de tomate',
        'Queijo',
        'Presunto',
      ],
      yieldAndQuantity: '8 porções',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Recipe(
      id: '10',
      name: 'Suco Verde Detox',
      rating: 4.1,
      imageUrl: 'assets/images/suco_verde_detox.png',
      category: 'Bebidas',
      prepTime: '5 mins',
      ingredients: ['Couve', 'Maçã', 'Gengibre', 'Água de coco'],
      yieldAndQuantity: '1 porção',
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
    Recipe(
      id: '11',
      name: 'Sanduíche Natural',
      rating: 4.4,
      imageUrl: 'assets/images/sanduiche_natural.png',
      category: 'Lanches',
      prepTime: '10 mins',
      ingredients: [
        'Pão integral',
        'Peito de peru',
        'Alface',
        'Tomate',
        'Requeijão light',
      ],
      yieldAndQuantity: '1 porção',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Recipe(
      id: '12',
      name: 'Salmão Assado com Legumes',
      rating: 4.8,
      imageUrl: 'assets/images/salmao_assado.png',
      category: 'Alimentação Saudável',
      prepTime: '30 mins',
      ingredients: ['Filé de salmão', 'Brócolis', 'Cenoura', 'Azeite', 'Limão'],
      yieldAndQuantity: '2 porções',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Recipe(
      id: '13',
      name: 'Moqueca de Peixe',
      rating: 4.6,
      imageUrl: 'assets/images/moqueca_de_peixe.png',
      category: 'Frutos do Mar',
      prepTime: '50 mins',
      ingredients: [
        'Peixe branco',
        'Leite de coco',
        'Azeite de dendê',
        'Pimentões',
        'Cebola',
        'Coentro',
      ],
      yieldAndQuantity: '4 porções',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  List<Recipe> getRecipes() {
    return List.from(_recipes);
  }

  List<Recipe> getSortedRecipes(RecipeSortOrder order) {
    List<Recipe> sortedList = List.from(_recipes);

    switch (order) {
      case RecipeSortOrder.mostRecent:
        sortedList.sort(
          (a, b) => b.createdAt.compareTo(a.createdAt),
        ); // Ordena por createdAt
        break;
      case RecipeSortOrder.oldest:
        sortedList.sort(
          (a, b) => a.createdAt.compareTo(b.createdAt),
        ); // Ordena por createdAt
        break;
      case RecipeSortOrder.highestRated:
        sortedList.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case RecipeSortOrder.mostFavorited:
        sortedList.sort((a, b) {
          if (a.isFavorite && !b.isFavorite) return -1;
          if (!a.isFavorite && b.isFavorite) return 1;
          return b.createdAt.compareTo(
            a.createdAt,
          ); // Usar createdAt para estabilidade
        });
        break;
      case RecipeSortOrder.none:
        sortedList.sort(
          (a, b) => a.createdAt.compareTo(b.createdAt),
        ); // Padrão: mais antigas
        break;
    }
    return sortedList;
  }

  Recipe? getRecipeById(String id) {
    try {
      return _recipes.firstWhere((recipe) => recipe.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Recipe> getFavoriteRecipes() {
    return _recipes.where((recipe) => recipe.isFavorite).toList();
  }

  List<Recipe> getSavedRecipes() {
    return _recipes.where((recipe) => recipe.isSaved).toList();
  }

  List<String> getAllCategories() {
    final categories = _recipes
        .map((recipe) => recipe.category)
        .whereType<String>()
        .toSet()
        .toList();
    categories.sort();
    return categories;
  }

  List<Recipe> getRecipesByCategory(String category) {
    return _recipes.where((recipe) => recipe.category == category).toList();
  }

  void toggleFavorite(String recipeId) {
    final index = _recipes.indexWhere((recipe) => recipe.id == recipeId);
    if (index != -1) {
      _recipes[index] = _recipes[index].copyWith(
        isFavorite: !_recipes[index].isFavorite,
      );
      notifyListeners();
    }
  }

  void toggleSaved(String recipeId) {
    final index = _recipes.indexWhere((recipe) => recipe.id == recipeId);
    if (index != -1) {
      _recipes[index] = _recipes[index].copyWith(
        isSaved: !_recipes[index].isSaved,
      );
      notifyListeners();
    }
  }

  void updateRecipeRating(String recipeId, double newRating) {
    final index = _recipes.indexWhere((recipe) => recipe.id == recipeId);
    if (index != -1) {
      _recipes[index] = _recipes[index].copyWith(rating: newRating);
      notifyListeners();
    }
  }

  void addRecipe(Recipe newRecipe) {
    final now = DateTime.now();
    final String newId =
        now.millisecondsSinceEpoch.toString(); // ID baseado em timestamp
    _recipes.add(newRecipe.copyWith(id: newId, createdAt: now, updatedAt: now));
    notifyListeners();
  }

  void updateRecipe(Recipe updatedRecipe) {
    final index = _recipes.indexWhere(
      (recipe) => recipe.id == updatedRecipe.id,
    );
    if (index != -1) {
      _recipes[index] = updatedRecipe.copyWith(updatedAt: DateTime.now());
      notifyListeners();
    }
  }

  void deleteRecipe(String recipeId) {
    _recipes.removeWhere((recipe) => recipe.id == recipeId);
    notifyListeners();
  }
}
