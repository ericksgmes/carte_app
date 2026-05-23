// ValueNotifier -> holds the data
// ValueListenableBuilder -> listens to the data (dont need setstate)

import 'package:flutter/material.dart';
import 'package:carte_app/data/api/user_api.dart';

ValueNotifier<int> selectedPageNotifier = ValueNotifier<int>(0);
ValueNotifier<bool> isDarkModeNotifier = ValueNotifier<bool>(false);
ValueNotifier<Set<String>> selectedAllergens = ValueNotifier<Set<String>>({});
ValueNotifier<List<String>> allergensNotifier = ValueNotifier<List<String>>([]);

/// Usuário atualmente logado. null = não autenticado.
ValueNotifier<UserDto?> currentUserNotifier = ValueNotifier<UserDto?>(null);
