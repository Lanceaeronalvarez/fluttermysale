import 'package:flutter/material.dart';

class FilterProvider extends ChangeNotifier {
  List<String> sorts = [
    'Bestselling',
    'Price: Low To High',
    'Price: High To Low',
    'New Arrivals',
    'Category',
  ];

  String? _selectedSort;
  String? get selectedSort => _selectedSort;
  void setSelectedSort(String? selectedSort) {
    _selectedSort = selectedSort;
    notifyListeners();
  }
}
