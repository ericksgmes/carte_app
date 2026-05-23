import 'package:carte_app/data/classes/allergen.dart';
import 'package:carte_app/data/classes/food.dart';
import 'package:flutter/material.dart';

final List<Allergen> mockAllergens = [
  const Allergen(
    id: 'gluten',
    description: 'Glúten',
    iconName: 'restaurant',
    color: Color(0xFFE57373),
  ),
  const Allergen(
    id: 'milk',
    description: 'Leite / Lactose',
    iconName: 'local_cafe',
    color: Color(0xFF64B5F6),
  ),
  const Allergen(
    id: 'egg',
    description: 'Ovo',
    iconName: 'egg',
    color: Color(0xFFFFD54F),
  ),
  const Allergen(
    id: 'peanut',
    description: 'Amendoim',
    iconName: 'no_food',
    color: Color(0xFFF06292),
  ),
  const Allergen(
    id: 'fish',
    description: 'Peixe',
    iconName: 'set_meal',
    color: Color(0xFF81D4FA),
  ),
  const Allergen(
    id: 'soy',
    description: 'Soja',
    iconName: 'soup_kitchen',
    color: Color(0xFFA5D6A7),
  ),
  const Allergen(
    id: 'sesame',
    description: 'Gergelim',
    iconName: 'bakery_dining',
    color: Color(0xFFDCE775),
  ),
  const Allergen(
    id: 'lactose',
    description: 'Lactose',
    iconName: 'local_cafe',
    color: Color(0xFF90CAF9),
  ),
  const Allergen(
    id: 'no-allergens',
    description: 'Sem alérgenos',
    iconName: 'check_circle',
    color: Color(0xFFB0BEC5),
  ),
];

final List<Food> mockFoods = [
  Food(
    description: 'Pão francês com manteiga',
    allergens: [
      mockAllergens.firstWhere((a) => a.id == 'gluten'),
      mockAllergens.firstWhere((a) => a.id == 'milk'),
    ],
  ),
  Food(
    description: 'Macarrão à bolonhesa',
    allergens: [mockAllergens.firstWhere((a) => a.id == 'gluten')],
  ),
  Food(
    description: 'Café com leite integral',
    allergens: [mockAllergens.firstWhere((a) => a.id == 'milk')],
  ),
  Food(
    description: 'Omelete com tomate',
    allergens: [mockAllergens.firstWhere((a) => a.id == 'egg')],
  ),
  Food(
    description: 'Filé de salmão grelhado',
    allergens: [mockAllergens.firstWhere((a) => a.id == 'fish')],
  ),
  Food(
    description: 'Molho shoyu',
    allergens: [mockAllergens.firstWhere((a) => a.id == 'soy')],
  ),
  Food(
    description: 'Pão de hambúrguer com gergelim',
    allergens: [
      mockAllergens.firstWhere((a) => a.id == 'gluten'),
      mockAllergens.firstWhere((a) => a.id == 'sesame'),
    ],
  ),
  Food(
    description: 'Frango grelhado',
    allergens: [mockAllergens.firstWhere((a) => a.id == 'no-allergens')],
  ),
];
