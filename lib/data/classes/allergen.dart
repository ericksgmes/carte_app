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

  factory Allergen.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('id') || !json.containsKey('description')) {
      throw const FormatException('Campos obrigatórios ausentes em Allergen');
    }

    final colorHash = json['colorHash'] as String? ?? '#000000';
    final colorValue = int.parse(
      colorHash.replaceFirst('#', '0xff'),
    );

    return Allergen(
      id: json['id'] as String,
      description: json['description'] as String,
      iconName: json['iconName'] as String? ?? 'help_outline',
      color: Color(colorValue),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'iconName': iconName,
        'colorHash': '#${color.value.toRadixString(16).substring(2).toUpperCase()}',
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
}
