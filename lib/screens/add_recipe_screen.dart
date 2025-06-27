import 'package:flutter/material.dart';
import '../models/recipe.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../services/recipe_service.dart';
import 'package:provider/provider.dart';

class AddRecipeScreen extends StatefulWidget {
  final Recipe? recipeToEdit;

  const AddRecipeScreen({super.key, this.recipeToEdit});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  late RecipeService _recipeService;

  String _recipeName = '';
  File? _pickedImageFile;
  Uint8List? _pickedImageBytes;
  String? _initialImageUrl;

  String? _selectedCategory;
  final List<String> _categories = [
    'Carnes',
    'Tortas e Bolos',
    'Frutos do Mar',
    'Saladas',
    'Molhos e Acompanhamentos',
    'Sopas',
    'Massas',
    'Bebidas',
    'Doces e Sobremesas',
    'Lanches',
    'Alimentação Saudável',
  ];

  double? _estimatedCost;
  String _prepTime = '';
  String _ingredients = '';
  String _yieldAndQuantity = '';
  String _equipmentAndUtensils = '';
  String _preparationMethod = '';

  final ImagePicker _picker = ImagePicker();
  final Uuid _uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    if (widget.recipeToEdit != null) {
      _recipeName = widget.recipeToEdit!.name;
      _initialImageUrl = widget.recipeToEdit!.imageUrl;
      _selectedCategory = widget.recipeToEdit!.category;
      _estimatedCost = widget.recipeToEdit!.estimatedCost;
      _prepTime = widget.recipeToEdit!.prepTime ?? '';
      _ingredients = widget.recipeToEdit!.ingredients?.join('\n') ?? '';
      _yieldAndQuantity = widget.recipeToEdit!.yieldAndQuantity ?? '';
      _equipmentAndUtensils =
          widget.recipeToEdit!.equipmentAndUtensils?.join('\n') ?? '';
      _preparationMethod =
          widget.recipeToEdit!.preparationMethod?.join('\n') ?? '';
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _recipeService = Provider.of<RecipeService>(context, listen: false);
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Câmera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeria'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile =
        await _picker.pickImage(source: source, imageQuality: 70);
    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _pickedImageBytes = bytes;
          _pickedImageFile = null;
          _initialImageUrl = null;
        });
      } else {
        setState(() {
          _pickedImageFile = File(pickedFile.path);
          _pickedImageBytes = null;
          _initialImageUrl = null;
        });
      }
    }
  }

  Future<String?> _saveImageLocally(File imageFile) async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final String fileName = '${_uuid.v4()}.png';
      final String localPath = '${appDocDir.path}/$fileName';
      final File newImage = await imageFile.copy(localPath);
      return newImage.path;
    } catch (e) {
      print('Erro ao salvar imagem localmente: $e');
      return null;
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String finalImageUrl;

      if (kIsWeb) {
        finalImageUrl = _pickedImageBytes != null
            ? 'web_temp_image_${_uuid.v4()}.png'
            : _initialImageUrl ?? 'assets/images/default_recipe.png';
      } else {
        if (_pickedImageFile != null) {
          final String? savedPath = await _saveImageLocally(_pickedImageFile!);
          finalImageUrl = savedPath ?? 'assets/images/default_recipe.png';
        } else {
          finalImageUrl =
              _initialImageUrl ?? 'assets/images/default_recipe.png';
        }
      }

      final List<String> ingredientsList =
          _ingredients.split('\n').where((s) => s.trim().isNotEmpty).toList();
      final List<String> equipmentList = _equipmentAndUtensils
          .split('\n')
          .where((s) => s.trim().isNotEmpty)
          .toList();
      final List<String> methodList = _preparationMethod
          .split('\n')
          .where((s) => s.trim().isNotEmpty)
          .toList();

      if (widget.recipeToEdit != null) {
        final updatedRecipe = widget.recipeToEdit!.copyWith(
          name: _recipeName,
          imageUrl: finalImageUrl,
          category: _selectedCategory,
          estimatedCost: _estimatedCost,
          prepTime: _prepTime.isNotEmpty ? _prepTime : null,
          ingredients: ingredientsList.isNotEmpty ? ingredientsList : null,
          yieldAndQuantity:
              _yieldAndQuantity.isNotEmpty ? _yieldAndQuantity : null,
          equipmentAndUtensils: equipmentList.isNotEmpty ? equipmentList : null,
          preparationMethod: methodList.isNotEmpty ? methodList : null,
        );
        _recipeService.updateRecipe(updatedRecipe);
        Navigator.pop(context, updatedRecipe); // Retorna a receita atualizada
      } else {
        final now = DateTime.now();
        final newRecipe = Recipe(
          id: now.millisecondsSinceEpoch.toString(),
          name: _recipeName,
          rating: 0.0,
          imageUrl: finalImageUrl,
          category: _selectedCategory,
          estimatedCost: _estimatedCost,
          prepTime: _prepTime.isNotEmpty ? _prepTime : null,
          ingredients: ingredientsList.isNotEmpty ? ingredientsList : null,
          yieldAndQuantity:
              _yieldAndQuantity.isNotEmpty ? _yieldAndQuantity : null,
          equipmentAndUtensils: equipmentList.isNotEmpty ? equipmentList : null,
          preparationMethod: methodList.isNotEmpty ? methodList : null,
          createdAt: now,
          updatedAt: now,
        );
        _recipeService.addRecipe(newRecipe);
        Navigator.pop(context, newRecipe);
      }
    }
  }

  Widget _buildImagePickerDisplay() {
    if (_pickedImageFile != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(
          _pickedImageFile!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 200,
        ),
      );
    } else if (kIsWeb && _pickedImageBytes != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.memory(
          _pickedImageBytes!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 200,
        ),
      );
    } else if (_initialImageUrl != null) {
      if (_initialImageUrl!.startsWith('assets/')) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            _initialImageUrl!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 200,
          ),
        );
      } else if (kIsWeb) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            'assets/images/default_recipe.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: 200,
          ),
        );
      } else {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            File(_initialImageUrl!),
            fit: BoxFit.cover,
            width: double.infinity,
            height: 200,
          ),
        );
      }
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.camera_alt,
            color: Colors.grey[700],
            size: 50,
          ),
          const SizedBox(height: 10),
          Text(
            'Toque para adicionar uma imagem',
            style: TextStyle(color: Colors.grey[700]),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipeToEdit != null
            ? 'Editar Receita'
            : 'Adicionar Nova Receita'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () => _showImageSourceActionSheet(context),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _buildImagePickerDisplay(),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                initialValue: _recipeName,
                decoration: const InputDecoration(labelText: 'Nome da Receita'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome da receita.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _recipeName = value!;
                },
              ),
              const SizedBox(height: 16), // Espaço entre os campos
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                  // Estilo visual igual aos outros campos
                ),
                hint: const Text('Selecione uma categoria'),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione uma categoria.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _selectedCategory = value;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _estimatedCost?.toString(),
                decoration:
                    const InputDecoration(labelText: 'Custo Aproximado (R\$)'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  if (value != null && value.isNotEmpty) {
                    _estimatedCost = double.tryParse(value);
                  }
                },
                validator: (value) {
                  if (value != null &&
                      value.isNotEmpty &&
                      double.tryParse(value) == null) {
                    return 'Por favor, insira um número válido para o custo.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16), // Espaçamento adicionado
              TextFormField(
                initialValue: _prepTime,
                decoration: const InputDecoration(
                    labelText: 'Tempo de Preparo (ex: 30 mins, 1h 15 mins)'),
                onSaved: (value) {
                  _prepTime = value ?? '';
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _yieldAndQuantity,
                decoration: const InputDecoration(
                    labelText:
                        'Rendimento e Quantidade (ex: 8 porções, 250ml)'),
                onSaved: (value) {
                  _yieldAndQuantity = value ?? '';
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _ingredients,
                decoration: const InputDecoration(
                    labelText: 'Ingredientes (um por linha)'),
                maxLines: 5, // Aumentado para melhor visualização
                keyboardType: TextInputType.multiline,
                onSaved: (value) {
                  _ingredients = value ?? '';
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _equipmentAndUtensils,
                decoration: const InputDecoration(
                    labelText: 'Equipamentos e Utensílios (um por linha)'),
                maxLines: 4, // Aumentado para melhor visualização
                keyboardType: TextInputType.multiline,
                onSaved: (value) {
                  _equipmentAndUtensils = value ?? '';
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _preparationMethod,
                decoration: const InputDecoration(
                    labelText: 'Modo de Preparo (um passo por linha)'),
                maxLines: 7, // Aumentado para melhor visualização
                keyboardType: TextInputType.multiline,
                onSaved: (value) {
                  _preparationMethod = value ?? '';
                },
              ),
              const SizedBox(height: 24), // Espaço maior antes do botão
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Text(widget.recipeToEdit != null
                    ? 'Salvar Alterações'
                    : 'Adicionar Receita'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
