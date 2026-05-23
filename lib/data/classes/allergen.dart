import 'package:flutter/material.dart';

class Allergen {
  final String id;
  final String description;
  final String iconName;
  final Color color;

  const Allergen({
    required this.id,
    required this.description,
    required this.iconName,
    required this.color,
  });

  /// Constrói um Allergen a partir do JSON da API.
  ///
  /// O servidor retorna {id: int, description: String}.
  /// Usamos [description] como chave de slug (ex.: 'gluten', 'milk')
  /// e resolvemos ícone/cor localmente, sem depender de campos extras da API.
  ///
  /// Também aceita o formato legado {id: String, colorHash, iconName}
  /// para manter compatibilidade com mocks e testes existentes.
  factory Allergen.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('id') || !json.containsKey('description')) {
      throw const FormatException('Campos obrigatórios ausentes em Allergen');
    }

    // O id pode vir como int (API) ou String (mocks/testes legados)
    final String id = json['id'] is int
        ? (json['description'] as String)       // usa description como slug
        : json['id'] as String;

    final String description = json['description'] as String;

    // Campos opcionais presentes apenas no formato legado (mocks / testes)
    final String? colorHashRaw = json['colorHash'] as String?;
    final String iconName =
        json['iconName'] as String? ?? _defaultIcon(id);

    final Color color = colorHashRaw != null
        ? Color(int.parse(colorHashRaw.replaceFirst('#', '0xff')))
        : _defaultColor(id);

    return Allergen(
      id: id,
      description: description,
      iconName: iconName,
      color: color,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'iconName': iconName,
        'colorHash': '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
      };

  Allergen copyWith({
    String? id,
    String? description,
    String? iconName,
    Color? color,
  }) {
    return Allergen(
      id: id ?? this.id,
      description: description ?? this.description,
      iconName: iconName ?? this.iconName,
      color: color ?? this.color,
    );
  }

  @override
  bool operator ==(Object other) => other is Allergen && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Allergen($id)';
}

// ---------------------------------------------------------------------------
// Tabelas de ícone e cor por slug (mantidas sincronizadas com o banco)
// ---------------------------------------------------------------------------

String _defaultIcon(String slug) {
  const map = <String, String>{
    'gluten':     'restaurant',
    'milk':       'local_cafe',
    'lactose':    'local_cafe',
    'egg':        'egg',
    'peanut':     'no_food',
    'fish':       'set_meal',
    'soy':        'soup_kitchen',
    'sesame':     'bakery_dining',
    'no-allergens': 'check_circle',
  };
  return map[slug] ?? 'help_outline';
}

Color _defaultColor(String slug) {
  const map = <String, Color>{
    'gluten':     Color(0xFFE57373),
    'milk':       Color(0xFF64B5F6),
    'lactose':    Color(0xFF64B5F6),
    'egg':        Color(0xFFFFD54F),
    'peanut':     Color(0xFFF06292),
    'fish':       Color(0xFF81D4FA),
    'soy':        Color(0xFFA5D6A7),
    'sesame':     Color(0xFFDCE775),
    'no-allergens': Color(0xFFB0BEC5),
  };
  return map[slug] ?? const Color(0xFF000000);
}
