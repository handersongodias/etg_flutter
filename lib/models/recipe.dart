class Recipe {
  final String id;
  final String name;
  final double rating;
  final String imageUrl;
  bool isFavorite;
  bool isSaved;
  final String? category;
  final double? estimatedCost;
  final String? prepTime;
  final List<String>? ingredients;
  final String? yieldAndQuantity;
  final List<String>? equipmentAndUtensils;
  final List<String>? preparationMethod;
  final DateTime createdAt;
  final DateTime? updatedAt;
  Recipe({
    required this.id,
    required this.name,
    required this.rating,
    required this.imageUrl,
    this.isFavorite = false,
    this.isSaved = false,
    this.category,
    this.estimatedCost,
    this.prepTime,
    this.ingredients,
    this.yieldAndQuantity,
    this.equipmentAndUtensils,
    this.preparationMethod,
    required this.createdAt, // Deve ser sempre fornecida
    this.updatedAt, // Opcional
  });

  Recipe copyWith({
    String? id,
    String? name,
    double? rating,
    String? imageUrl,
    bool? isFavorite,
    bool? isSaved,
    String? category,
    double? estimatedCost,
    String? prepTime,
    List<String>? ingredients,
    String? yieldAndQuantity,
    List<String>? equipmentAndUtensils,
    List<String>? preparationMethod,
    DateTime? createdAt, // Manter o original se não fornecido
    DateTime? updatedAt, // Pode ser atualizado ou manter o original
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      rating: rating ?? this.rating,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
      isSaved: isSaved ?? this.isSaved,
      category: category ?? this.category,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      prepTime: prepTime ?? this.prepTime,
      ingredients: ingredients ?? this.ingredients,
      yieldAndQuantity: yieldAndQuantity ?? this.yieldAndQuantity,
      equipmentAndUtensils: equipmentAndUtensils ?? this.equipmentAndUtensils,
      preparationMethod: preparationMethod ?? this.preparationMethod,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
