import 'package:carte_app/data/classes/allergen.dart';
import 'package:carte_app/data/classes/food.dart';
import 'package:flutter/material.dart';

final List<Allergen> mockAllergens = [
  Allergen(
    id: 'gluten',
    description: 'Glúten',
    iconName: 'restaurant',
    color: const Color(0xFFE57373),
  ),
  Allergen(
    id: 'milk',
    description: 'Leite / Lactose',
    iconName: 'local_cafe',
    color: const Color(0xFF64B5F6),
  ),
  Allergen(
    id: 'egg',
    description: 'Ovo',
    iconName: 'egg',
    color: const Color(0xFFFFD54F),
  ),
  Allergen(
    id: 'peanut',
    description: 'Amendoim',
    iconName: 'no_food',
    color: const Color(0xFFF06292),
  ),
  Allergen(
    id: 'seafood',
    description: 'Frutos do mar',
    iconName: 'set_meal',
    color: const Color(0xFF4DD0E1),
  ),
  Allergen(
    id: 'soy',
    description: 'Soja',
    iconName: 'spa',
    color: const Color(0xFFA5D6A7),
  ),
  Allergen(
    id: 'nuts',
    description: 'Oleaginosas (castanhas, nozes)',
    iconName: 'eco',
    color: const Color(0xFFBA68C8),
  ),
  Allergen(
    id: 'fish',
    description: 'Peixe',
    iconName: 'fish',
    color: const Color(0xFF81D4FA),
  ),
  Allergen(
    id: 'wheat',
    description: 'Trigo',
    iconName: 'grass',
    color: const Color(0xFFFFB74D),
  ),
  Allergen(
    id: 'sesame',
    description: 'Gergelim',
    iconName: 'grain',
    color: const Color(0xFFDCE775),
  ),
];

final List<Food> mockFoods = [
  Food(
    description: 'Pão francês com manteiga',
    allergen: mockAllergens.firstWhere((a) => a.id == 'gluten'),
  ),
  Food(
    description: 'Macarrão à bolonhesa',
    allergen: mockAllergens.firstWhere((a) => a.id == 'gluten'),
  ),
  Food(
    description: 'Café com leite integral',
    allergen: mockAllergens.firstWhere((a) => a.id == 'milk'),
  ),
  Food(
    description: 'Queijo minas frescal',
    allergen: mockAllergens.firstWhere((a) => a.id == 'milk'),
  ),
  Food(
    description: 'Omelete com tomate e cebola',
    allergen: mockAllergens.firstWhere((a) => a.id == 'egg'),
  ),
  Food(
    description: 'Bolo de cenoura com cobertura de chocolate',
    allergen: mockAllergens.firstWhere((a) => a.id == 'egg'),
  ),
  Food(
    description: 'Paçoca caseira',
    allergen: mockAllergens.firstWhere((a) => a.id == 'peanut'),
  ),
  Food(
    description: 'Camarão ao alho e óleo',
    allergen: mockAllergens.firstWhere((a) => a.id == 'seafood'),
  ),
  Food(
    description: 'Sushi de polvo',
    allergen: mockAllergens.firstWhere((a) => a.id == 'seafood'),
  ),
  Food(
    description: 'Molho shoyu tradicional',
    allergen: mockAllergens.firstWhere((a) => a.id == 'soy'),
  ),
  Food(
    description: 'Mix de castanhas e nozes',
    allergen: mockAllergens.firstWhere((a) => a.id == 'nuts'),
  ),
  Food(
    description: 'Filé de salmão grelhado',
    allergen: mockAllergens.firstWhere((a) => a.id == 'fish'),
  ),
  Food(
    description: 'Biscoito de trigo integral',
    allergen: mockAllergens.firstWhere((a) => a.id == 'wheat'),
  ),
  Food(
    description: 'Pão de hambúrguer com gergelim',
    allergen: mockAllergens.firstWhere((a) => a.id == 'sesame'),
  ),
];
