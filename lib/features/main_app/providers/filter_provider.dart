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

  List<SizeFilterTemp> _sizes = SizeFilterTemp.tempData();
  late List<SizeFilterTemp> displayedSizes = _sizes;

  List<SizeFilterTemp> _selectedSizes = [];
  List<SizeFilterTemp> get selectedSizes => _selectedSizes;
  void addOrRemoveSelectedSize(SizeFilterTemp selectedSize) {
    final index = _selectedSizes.indexWhere((size) {
      return size.value == selectedSize.value;
    });
    if (index == -1) {
      _selectedSizes.add(selectedSize);
    } else {
      _selectedSizes.removeAt(index);
    }
    notifyListeners();
  }

  void filter({String? searchTerm}) {
    String st = (searchTerm?.trim().toLowerCase()) ?? '';
    if (st.isEmpty) {
      displayedSizes = _sizes;
    } else {
      displayedSizes = _sizes.where((size) {
        return size.value.toLowerCase().contains(st);
      }).toList();
    }
    notifyListeners();
  }

  void sort({
    required bool ascending,
    required bool byName,
    bool callNotify = true,
  }) {
    if (byName) {
      displayedSizes.sort((SizeFilterTemp a, SizeFilterTemp b) {
        if (ascending) {
          return b.value.toLowerCase().compareTo(a.value.toLowerCase());
        } else {
          return a.value.toLowerCase().compareTo(b.value.toLowerCase());
        }
      });
    } else {
      displayedSizes.sort((SizeFilterTemp a, SizeFilterTemp b) {
        if (ascending) {
          return a.count - b.count;
        } else {
          return b.count - a.count;
        }
      });
    }

    if (callNotify) {
      notifyListeners();
    }
  }

  void clearSelectedSizes() {
    _selectedSizes = [];
    notifyListeners();
  }

  void loadInitialSelectedSizes({bool shouldNotify = false}) {
    if (_sizes.isNotEmpty) {
      _selectedSizes = [_sizes.first];
      if (shouldNotify) notifyListeners();
    }
  }

  String currency = '\$';
  double minPrice = 0;
  double maxPrice = 189;
  double _currentMinPrice = 10;
  double get currentMinPrice => _currentMinPrice;
  double _currentMaxPrice = 179;
  double get currentMaxPrice => _currentMaxPrice;
  void setCurrentPriceRange({
    required double currentMinPrice,
    required double currentMaxPrice,
  }) {
    _currentMinPrice = currentMinPrice;
    _currentMaxPrice = currentMaxPrice;
    notifyListeners();
  }
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

class SizeFilterTemp {
  final String value;
  final int count;

  const SizeFilterTemp({required this.value, required this.count});

  static List<SizeFilterTemp> tempData() {
    List<Map<String, dynamic>> tempData = [
      {"value": "30ml", "count": 108},
      {"value": "Set", "count": 99},
      {"value": "50ml", "count": 89},
      {"value": "100ml", "count": 74},
      {"value": "One Size", "count": 50},
      {"value": "300ml", "count": 43},
      {"value": "200ml", "count": 42},
      {"value": "60ml", "count": 30},
      {"value": "3 Pack", "count": 28},
      {"value": "500ml", "count": 27},
      {"value": "15ml", "count": 25},
      {"value": "6 Pack", "count": 21},
      {"value": "75ml", "count": 20},
      {"value": "250ml", "count": 19},
      {"value": "150ml", "count": 11},
      {"value": "400ml", "count": 11},
      {"value": "10g", "count": 10},
      {"value": "2 Pack", "count": 9},
      {"value": "6g", "count": 9},
      {"value": "10ml", "count": 8},
      {"value": "120ml", "count": 8},
      {"value": "28ml", "count": 8},
      {"value": "295ml", "count": 8},
      {"value": "5.4ml", "count": 8},
      {"value": "125ml", "count": 7},
      {"value": "3.1ml", "count": 7},
      {"value": "350ml", "count": 7},
      {"value": "4.5ml", "count": 7},
      {"value": "40ml", "count": 7},
      {"value": "4ml", "count": 7},
      {"value": "1.4g", "count": 6},
      {"value": "14g", "count": 6},
      {"value": "200g", "count": 6},
      {"value": "236ml", "count": 6},
      {"value": "4g", "count": 6},
      {"value": "62ml", "count": 6},
      {"value": "750ml", "count": 6},
      {"value": "7ml", "count": 6},
      {"value": "1000ml", "count": 5},
      {"value": "11ml", "count": 5},
      {"value": "80ml", "count": 5},
      {"value": "1.2g", "count": 4},
      {"value": "1.64g", "count": 4},
      {"value": "150g", "count": 4},
      {"value": "30 Capsules", "count": 4},
      {"value": "3g", "count": 4},
      {"value": "3ml", "count": 4},
      {"value": "4 Pack", "count": 4},
      {"value": "450ml", "count": 4},
      {"value": "1.1g", "count": 3},
    ];
    return tempData.map((dict) {
      String value = (dict['value'] as String?) ?? '';
      int count = (dict['count'] as int?) ?? 0;
      return SizeFilterTemp(value: value, count: count);
    }).toList();
  }
}
