import 'package:flutter/material.dart';
import '../models/recipe.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../services/recipe_service.dart';
import 'add_recipe_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late double _currentRating;
  late bool _isRecipeSaved;
  late bool _isRecipeFavorite;

  // LÓGICA DE TAMANHO DA FONTE
  // 1. Variáveis para os tamanhos pré-definidos
  final double _smallFontSize = 14.0;
  final double _mediumFontSize = 16.0;
  final double _largeFontSize = 19.0;

  // 2. Variável de estado que guarda o tamanho da fonte atual
  late double _currentBodyFontSize;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.recipe.rating;
    _isRecipeSaved = widget.recipe.isSaved;
    _isRecipeFavorite = widget.recipe.isFavorite;

    // 3. Inicia com o tamanho médio
    _currentBodyFontSize = _mediumFontSize;
  }

  // 4. Função para ciclar entre os tamanhos de fonte
  void _cycleFontSize() {
    setState(() {
      if (_currentBodyFontSize == _mediumFontSize) {
        _currentBodyFontSize = _largeFontSize;
      } else if (_currentBodyFontSize == _largeFontSize) {
        _currentBodyFontSize = _smallFontSize;
      } else {
        _currentBodyFontSize = _mediumFontSize;
      }
    });
  }
  // --- FIM DA ADIÇÃO ---

  Widget _buildRecipeImage(String imageUrl) {
    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
      );
    } else if (kIsWeb) {
      return Image.asset(
        'assets/images/default_recipe.png',
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
      );
    } else {
      return Image.file(
        File(imageUrl),
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
      );
    }
  }

  Widget _buildRatingStars(RecipeService recipeService, String recipeId) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < _currentRating.floor()
                ? Icons.star
                : index < _currentRating
                    ? Icons.star_half
                    : Icons.star_border,
            color: Colors.amber,
            size: 30,
          ),
          onPressed: () {
            recipeService.updateRecipeRating(recipeId, (index + 1).toDouble());
            setState(() {
              _currentRating = (index + 1).toDouble();
            });
          },
        );
      }),
    );
  }

  void _toggleSaved(RecipeService recipeService, String recipeId) {
    recipeService.toggleSaved(recipeId);
    setState(() {
      _isRecipeSaved = !_isRecipeSaved;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(_isRecipeSaved
              ? 'Receita salva!'
              : 'Receita removida dos salvos!'),
          duration: const Duration(seconds: 1)),
    );
  }

  void _toggleFavorite(RecipeService recipeService, String recipeId) {
    recipeService.toggleFavorite(recipeId);
    setState(() {
      _isRecipeFavorite = !_isRecipeFavorite;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(_isRecipeFavorite
              ? 'Adicionado aos favoritos!'
              : 'Removido dos favoritos!'),
          duration: const Duration(seconds: 1)),
    );
  }

  void _shareRecipe(Recipe recipe) {
    final String textToShare =
        'Confira esta deliciosa receita de ${recipe.name}!\n\n'
        'Avaliação: ${_currentRating.toStringAsFixed(1)} estrelas\n\n'
        'Categoria: ${recipe.category ?? 'N/A'}\n\n'
        'Criado em: ${DateFormat('dd/MM/yyyy HH:mm').format(recipe.createdAt)}\n'
        '${recipe.updatedAt != null && recipe.updatedAt!.isAfter(recipe.createdAt) ? 'Editado em: ${DateFormat('dd/MM/yyyy HH:mm').format(recipe.updatedAt!)}\n' : ''}'
        'Ingredientes:\n${recipe.ingredients?.map((e) => '- $e').join('\n') ?? 'Nenhum ingrediente listado'}\n\n'
        'Modo de preparo:\n${recipe.preparationMethod?.map((e) => '- $e').join('\n') ?? 'Nenhum modo de preparo listado'}\n\n'
        'Custo aproximado: R\$${recipe.estimatedCost?.toStringAsFixed(2) ?? 'N/A'}\n'
        'Tempo de preparo: ${recipe.prepTime ?? 'N/A'}\n'
        'Rendimento: ${recipe.yieldAndQuantity ?? 'N/A'}\n';

    Share.share(textToShare, subject: 'Receita: ${recipe.name}');
  }

  Future<void> _confirmDelete(
      RecipeService recipeService, String recipeId, String recipeName) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: Text('Tem certeza que deseja excluir "$recipeName"?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Excluir', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    if (confirm == true) {
      recipeService.deleteRecipe(recipeId);
      Navigator.pop(context, true);
    }
  }

  void _editRecipe(RecipeService recipeService, Recipe recipeToEdit) async {
    final dynamic result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext ctx) =>
            AddRecipeScreen(recipeToEdit: recipeToEdit),
      ),
    );

    if (!mounted) return;

    if (result != null && result is Recipe) {
      final updatedRecipeFromService = recipeService.getRecipeById(result.id);
      if (updatedRecipeFromService != null) {
        setState(() {
          _currentRating = updatedRecipeFromService.rating;
          _isRecipeSaved = updatedRecipeFromService.isSaved;
          _isRecipeFavorite = updatedRecipeFromService.isFavorite;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Receita alterada com sucesso!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipeService = Provider.of<RecipeService>(context);

    final Recipe? currentRecipeFromService =
        recipeService.getRecipeById(widget.recipe.id);

    if (currentRecipeFromService == null) {
      return const Scaffold(body: SizedBox.shrink());
    }

    _currentRating = currentRecipeFromService.rating;
    _isRecipeSaved = currentRecipeFromService.isSaved;
    _isRecipeFavorite = currentRecipeFromService.isFavorite;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        actions: [
          // ADICIONADO: Botão para alterar o tamanho da fonte
          IconButton(
            icon: const Icon(Icons.text_increase, color: Colors.black),
            tooltip: 'Alterar tamanho da fonte',
            onPressed: _cycleFontSize, // Chama a função que troca o tamanho
          ),
          IconButton(
            icon: Icon(
              _isRecipeSaved ? Icons.bookmark : Icons.bookmark_border,
              color: _isRecipeSaved ? Colors.red : Colors.black,
            ),
            onPressed: () =>
                _toggleSaved(recipeService, currentRecipeFromService.id),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onSelected: (String result) {
              if (result == 'edit') {
                _editRecipe(recipeService, currentRecipeFromService);
              } else if (result == 'delete') {
                _confirmDelete(recipeService, currentRecipeFromService.id,
                    currentRecipeFromService.name);
              }
            },
            itemBuilder: (BuildContext ctx) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'edit',
                child: Text('Editar Receita'),
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('Excluir Receita'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: _buildRecipeImage(currentRecipeFromService.imageUrl),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Custo aproximado da receita: R\$${currentRecipeFromService.estimatedCost?.toStringAsFixed(2) ?? 'N/A'}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        _isRecipeFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: _isRecipeFavorite ? Colors.red : Colors.grey,
                      ),
                      onPressed: () => _toggleFavorite(
                          recipeService, currentRecipeFromService.id),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentRecipeFromService.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (currentRecipeFromService.category != null)
                    Container(
                      margin: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 6.0),
                      decoration: BoxDecoration(
                        color: recipeService.getCategoryColor(
                            currentRecipeFromService.category!),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        currentRecipeFromService.category!,
                        style: TextStyle(
                          color: recipeService.getCategoryTextColor(
                              currentRecipeFromService.category!),
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildRatingStars(
                          recipeService, currentRecipeFromService.id),
                      const SizedBox(width: 16),
                      const Icon(Icons.access_time,
                          color: Colors.grey, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        currentRecipeFromService.prepTime ?? 'N/A',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Registrado em: ${DateFormat('dd/MM/yyyy HH:mm').format(currentRecipeFromService.createdAt)}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  if (currentRecipeFromService.updatedAt != null &&
                      currentRecipeFromService.updatedAt!
                          .isAfter(currentRecipeFromService.createdAt))
                    Text(
                      'Última edição: ${DateFormat('dd/MM/yyyy HH:mm').format(currentRecipeFromService.updatedAt!)}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  const SizedBox(height: 20),
                  Text(
                    'Ingredientes:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (currentRecipeFromService.ingredients != null)
                    ...currentRecipeFromService.ingredients!.map((item) =>
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          // MODIFICADO: Aplicando o tamanho de fonte dinâmico
                          child: Text('• $item',
                              style: TextStyle(fontSize: _currentBodyFontSize)),
                        )),
                  if (currentRecipeFromService.ingredients == null ||
                      currentRecipeFromService.ingredients!.isEmpty)
                    Text('Nenhum ingrediente listado.',
                        style: TextStyle(fontSize: _currentBodyFontSize)),
                  const SizedBox(height: 20),
                  Text(
                    'Rendimento e Quantidade:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentRecipeFromService.yieldAndQuantity ?? 'N/A',
                    style:
                        TextStyle(fontSize: _currentBodyFontSize), // MODIFICADO
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Equipamentos e Utensílios:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (currentRecipeFromService.equipmentAndUtensils != null)
                    ...currentRecipeFromService.equipmentAndUtensils!
                        .map((item) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.0),
                              // MODIFICADO: Aplicando o tamanho de fonte dinâmico
                              child: Text('• $item',
                                  style: TextStyle(
                                      fontSize: _currentBodyFontSize)),
                            )),
                  if (currentRecipeFromService.equipmentAndUtensils == null ||
                      currentRecipeFromService.equipmentAndUtensils!.isEmpty)
                    Text('Nenhum equipamento listado.',
                        style: TextStyle(fontSize: _currentBodyFontSize)),
                  const SizedBox(height: 20),
                  Text(
                    'Modo de preparo:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (currentRecipeFromService.preparationMethod != null)
                    ...currentRecipeFromService.preparationMethod!.map((item) =>
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          // MODIFICADO: Aplicando o tamanho de fonte dinâmico
                          child: Text('• $item',
                              style: TextStyle(fontSize: _currentBodyFontSize)),
                        )),
                  if (currentRecipeFromService.preparationMethod == null ||
                      currentRecipeFromService.preparationMethod!.isEmpty)
                    Text('Nenhum modo de preparo listado.',
                        style: TextStyle(fontSize: _currentBodyFontSize)),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _shareRecipe(currentRecipeFromService),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.share),
        label: const Text('Compartilhar'),
      ),
    );
  }
}
