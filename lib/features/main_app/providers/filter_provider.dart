import 'package:flutter/material.dart';
import 'package:flutter_mysale/features/main_app/widgets/filter_bar.dart';

class FilterProvider extends ChangeNotifier {
  //TODO: JCA - TEMP DATA FOR NOW

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

  List<String> mainFilters = ['Category', 'Brand', 'Price', 'Size'];

  //List<String> selectedFilters = [];

  List<FilterWrapperTemp> selectedFilters = [
    FilterWrapperTemp(title: 'Round Neck'),
    FilterWrapperTemp(title: "1-52"),
  ];

  //int productCount = 0;
  int productCount = 522;
}

//TEMP MODEL
class FilterWrapperTemp implements FilterItem {
  final String title;

  const FilterWrapperTemp({required this.title});

  @override
  String getTitle() {
    return title;
  }
}
