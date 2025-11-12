// ValueNotifier -> holds the data
// ValueListenableBuilder -> listens to the data (dont need setstate)

import 'package:flutter/material.dart';

ValueNotifier<int> selectedPageNotifier = ValueNotifier<int>(0);
ValueNotifier<bool> isDarkModeNotifier = ValueNotifier<bool>(false);
ValueNotifier<Set<String>> selectedAllergens = ValueNotifier<Set<String>>({
  'tree nuts',
});
ValueNotifier<List<String>> allergensNotifier = ValueNotifier<List<String>>([]);
