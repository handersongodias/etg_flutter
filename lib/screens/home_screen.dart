import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';
import '../widgets/recipe_card.dart';
import 'dart:async';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedCategory;
  RecipeSortOrder _currentSortOrder = RecipeSortOrder.none;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  bool _isFabPressed = false; // Variável para controlar a animação do botão

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {});
    });
  }

  void _applyFiltersAndSort() {
    setState(() {});
  }

  void _navigateToRecipeDetail(Recipe recipe) async {
    final dynamic result = await Navigator.pushNamed(
      context,
      '/recipe_detail',
      arguments: recipe,
    );

    if (!mounted) return;

    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Receita excluída com sucesso!'),
          duration: Duration(seconds: 2),
        ),
      );
      _applyFiltersAndSort();
    } else if (result != null && result is Recipe) {
      _applyFiltersAndSort();
    }
  }

  void _showCategoryFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        final recipeService = Provider.of<RecipeService>(ctx, listen: false);
        return ListView(
          children: [
            ListTile(
              leading:
                  _selectedCategory == null ? const Icon(Icons.check) : null,
              title: const Text('Todas as Categorias'),
              onTap: () {
                Navigator.pop(ctx);
                setState(() {
                  _selectedCategory = null;
                  _searchController.clear();
                  _applyFiltersAndSort();
                });
              },
            ),
            ...recipeService.getAllCategories().map((category) => ListTile(
                  leading: _selectedCategory == category
                      ? const Icon(Icons.check)
                      : null,
                  title: Text(category),
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() {
                      _selectedCategory = category;
                      _searchController.clear();
                      _applyFiltersAndSort();
                    });
                  },
                )),
          ],
        );
      },
    );
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Sem Ordenação'),
              leading: _currentSortOrder == RecipeSortOrder.none
                  ? const Icon(Icons.check)
                  : null,
              onTap: () {
                Navigator.pop(ctx);
                setState(() {
                  _currentSortOrder = RecipeSortOrder.none;
                  _applyFiltersAndSort();
                });
              },
            ),
            ListTile(
              title: const Text('Mais Recentes'),
              leading: _currentSortOrder == RecipeSortOrder.mostRecent
                  ? const Icon(Icons.check)
                  : null,
              onTap: () {
                Navigator.pop(ctx);
                setState(() {
                  _currentSortOrder = RecipeSortOrder.mostRecent;
                  _applyFiltersAndSort();
                });
              },
            ),
            ListTile(
              title: const Text('Mais Antigas'),
              leading: _currentSortOrder == RecipeSortOrder.oldest
                  ? const Icon(Icons.check)
                  : null,
              onTap: () {
                Navigator.pop(ctx);
                setState(() {
                  _currentSortOrder = RecipeSortOrder.oldest;
                  _applyFiltersAndSort();
                });
              },
            ),
            ListTile(
              title: const Text('Melhor Avaliadas'),
              leading: _currentSortOrder == RecipeSortOrder.highestRated
                  ? const Icon(Icons.check)
                  : null,
              onTap: () {
                Navigator.pop(ctx);
                setState(() {
                  _currentSortOrder = RecipeSortOrder.highestRated;
                  _applyFiltersAndSort();
                });
              },
            ),
            ListTile(
              title: const Text('Mais Curtidas'),
              leading: _currentSortOrder == RecipeSortOrder.mostFavorited
                  ? const Icon(Icons.check)
                  : null,
              onTap: () {
                Navigator.pop(ctx);
                setState(() {
                  _currentSortOrder = RecipeSortOrder.mostFavorited;
                  _applyFiltersAndSort();
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;

    final double appBarHeight;
    final double logoHeight;

    if (orientation == Orientation.landscape) {
      appBarHeight = 80.0;
      logoHeight = 60.0;
    } else {
      appBarHeight = 180.0;
      logoHeight = 150.0;
    }

    //Lógica para as cores dinâmicas do botão de filtro
    final recipeService = Provider.of<RecipeService>(context, listen: false);

    // 2. Define as variáveis de cor
    final Color filterButtonColor;
    final Color filterIconColor;

    if (_selectedCategory != null) {
      // 3. Se uma categoria está selecionada, pega as cores dela
      filterButtonColor = recipeService.getCategoryColor(_selectedCategory!);
      filterIconColor = recipeService.getCategoryTextColor(_selectedCategory!);
    } else {
      // 4. Se não, usa as cores padrão
      filterButtonColor = Colors.red;
      filterIconColor = Colors.white;
    }
    // --- FIM DA ADIÇÃO ---

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/logo.png',
          height: logoHeight,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0.0,
        toolbarHeight: appBarHeight,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Pesquisar receita...', //
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // --- MODIFICAÇÃO NO BOTÃO DE FILTRO ---
                GestureDetector(
                  onTap: () => _showCategoryFilter(context),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: filterButtonColor, // Usa a cor de fundo dinâmica
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.filter_list,
                      color: filterIconColor, // Usa a cor do ícone dinâmica
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => _showSortOptions(context),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.sort,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Consumer<RecipeService>(
                builder: (BuildContext context, RecipeService recipeService,
                    Widget? child) {
                  String query = _searchController.text.toLowerCase();
                  List<Recipe> currentRecipes =
                      recipeService.getSortedRecipes(_currentSortOrder);

                  if (_selectedCategory != null) {
                    currentRecipes = currentRecipes
                        .where((recipe) => recipe.category == _selectedCategory)
                        .toList();
                  }

                  if (query.isNotEmpty) {
                    currentRecipes = currentRecipes.where((recipe) {
                      final recipeNameLower = recipe.name.toLowerCase();
                      final categoryLower =
                          recipe.category?.toLowerCase() ?? '';
                      return recipeNameLower.contains(query) ||
                          categoryLower.contains(query);
                    }).toList();
                  }

                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: currentRecipes.isEmpty &&
                            (_searchController.text.isNotEmpty ||
                                _selectedCategory != null)
                        ? const Center(
                            key: ValueKey<String>('empty-search'),
                            child: Text(
                                'Nenhuma receita encontrada para a busca/filtro.'),
                          )
                        : currentRecipes.isEmpty
                            ? const Center(
                                key: ValueKey<String>('empty-list'),
                                child:
                                    Text('Nenhuma receita cadastrada ainda.'),
                              )
                            : GridView.builder(
                                key: ValueKey<int>(currentRecipes.length),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 0.75,
                                ),
                                itemCount: currentRecipes.length,
                                itemBuilder:
                                    (BuildContext itemContext, int index) {
                                  final recipe = currentRecipes[index];
                                  return GestureDetector(
                                    onTap: () =>
                                        _navigateToRecipeDetail(recipe),
                                    child: RecipeCard(
                                      recipe: recipe,
                                      onToggleFavorite: () => recipeService
                                          .toggleFavorite(recipe.id),
                                    ),
                                  );
                                },
                              ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: AnimatedScale(
        duration: const Duration(milliseconds: 150),
        scale: _isFabPressed ? 0.9 : 1.0,
        child: GestureDetector(
          // CUIDA APENAS DA ANIMAÇÃO
          onTapDown: (_) => setState(() => _isFabPressed = true),
          onTapUp: (_) => setState(() => _isFabPressed = false),
          onTapCancel: () => setState(() => _isFabPressed = false),

          child: FloatingActionButton(
            onPressed: () async {
              // A ação principal acontece aqui
              await Navigator.pushNamed(context, '/add_recipe');
              if (!mounted) return;

              setState(() => _isFabPressed = false);
            },
            backgroundColor: Colors.red,
            shape: const CircleBorder(),
            heroTag: 'add_recipe_fab',
            child: const Icon(Icons.add, color: Colors.white, size: 30),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () {
                // Já estamos na home
              },
            ),
            IconButton(
              icon: const Icon(Icons.person, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            const SizedBox(width: 48),
            IconButton(
              icon: const Icon(Icons.bookmark, color: Colors.white),
              onPressed: () async {
                await Navigator.pushNamed(context, '/saved_recipes');
                if (!mounted) return;
              },
            ),
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.white),
              onPressed: () async {
                await Navigator.pushNamed(context, '/favorites');
                if (!mounted) return;
              },
            ),
          ],
        ),
      ),
    );
  }
}
