import 'package:flutter/material.dart';
import 'package:flutter_mysale/features/main_app/models/main/categorynode_model.dart';
import 'package:flutter_mysale/features/main_app/models/main/filter_category_model.dart';
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

  List<CategoryNodeModel> _selectedCategories = [];
  List<CategoryNodeModel> get selectedCategories => _selectedCategories;

  List<FilterCategoryModel> _filterCategories = [];
  List<FilterCategoryModel> get filterCategories => _filterCategories;

  void setCategories(List<CategoryNodeModel> categories) {
    const int rootDepth = 1;
    _filterCategories = [
      for (CategoryNodeModel category in categories)
        _generateFilterCategoryModelFrom(
          category,
          rootDepth,
          _selectedCategories,
        ),
    ];
    notifyListeners();
  }

  FilterCategoryModel _generateFilterCategoryModelFrom(
    CategoryNodeModel category,
    int depth,
    List<CategoryNodeModel> sCategories,
  ) {
    List<FilterCategoryModel> filterCategoryChildren = [];
    if (category.hasChild &&
        category.children != null &&
        category.children!.isNotEmpty) {
      filterCategoryChildren = category.children!
          .map((child) {
            return _generateFilterCategoryModelFrom(
              child,
              depth + 1,
              sCategories,
            );
          })
          .toList(growable: false);
    }

    final FilterCategoryStatus status = _generateInitialCategoryStatus(
      category.id ?? '',
      sCategories,
    );

    return FilterCategoryModel(
      category: category,
      fChildren: List.unmodifiable(filterCategoryChildren),
      depth: depth,
      isExpanded: false,
      status: status,
    );
  }

  FilterCategoryStatus _generateInitialCategoryStatus(
    String categoryId,
    List<CategoryNodeModel> sCategories,
  ) {
    if (categoryId.isNotEmpty) {
      for (CategoryNodeModel sCategory in sCategories) {
        if (sCategory.id != null && categoryId.startsWith(sCategory.id!)) {
          return FilterCategoryStatus.checked;
        }
      }
    }
    return FilterCategoryStatus.unchecked;
  }

  void generateSelectedCategories({bool callNotify = true}) {
    List<CategoryNodeModel> result = [];
    for (FilterCategoryModel filterCategory in _filterCategories) {
      result.addAll(_collectSelectedCategories(filterCategory));
    }
    _selectedCategories = result;
    if (callNotify) notifyListeners();
  }

  List<CategoryNodeModel> _collectSelectedCategories(
    FilterCategoryModel filterCategory,
  ) {
    switch (filterCategory.status) {
      case FilterCategoryStatus.checked:
        return [filterCategory.category];
      case FilterCategoryStatus.partial:
        List<CategoryNodeModel> res = [];
        for (FilterCategoryModel child in filterCategory.filterChildren) {
          res.addAll(_collectSelectedCategories(child));
        }
        return res;
      case FilterCategoryStatus.unchecked:
        return [];
    }
  }

  void toggleIsExpanded(FilterCategoryModel fCategory) {
    fCategory.toggleIsExpanded();
    notifyListeners();
  }

  void setStatusOfLeafCategories(
    FilterCategoryModel fCategory,
    bool isSelected,
  ) {
    fCategory.setStatusOfLeafCategories(isSelected);
  }

  //used for clearing all the selection
  void clearAllSelecteCategories() {
    for (FilterCategoryModel filterCategory in _filterCategories) {
      setStatusOfLeafCategories(filterCategory, false);
    }
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
      /*
      {"value": "Grown Alchemist", "count": 24},
      {"value": "Dr Botanicals", "count": 47},
      {"value": "Elizabeth Arden", "count": 14},
      {"value": "Revlon", "count": 31},
      {"value": "Ted Baker", "count": 4},
      {"value": "Lacoste", "count": 3},
      {"value": "DKNY", "count": 7},
      {"value": "Coach", "count": 2},
      {"value": "Marc Jacobs", "count": 5},
      {"value": "Molton Brown", "count": 66},
      {"value": "Clarins", "count": 17},
      {"value": "Shiseido", "count": 8},
      {"value": "K18", "count": 6},
      {"value": "Clinique", "count": 66},
      {"value": "MAC", "count": 28},
      {"value": "L'Occitane", "count": 1},
      {"value": "Burberry", "count": 2},
      {"value": "La Mer", "count": 1},
      {"value": "Dolce & Gabbana", "count": 1},
      {"value": "L'Oreal Paris", "count": 36},
      {"value": "Max Factor", "count": 30},
      {"value": "Rimmel London", "count": 15},
      {"value": "Peppermint Grove Australia", "count": 20},
      {"value": "Living Proof", "count": 26},
      {"value": "RAWW Cosmetics", "count": 12},
      {"value": "Bondi Sands", "count": 15},
      {"value": "Tigi", "count": 16},
      {"value": "Laura Mercier", "count": 50},
      {"value": "Madonna", "count": 5},
      {"value": "Sunday Rain", "count": 14},
      {"value": "Sugar Baby", "count": 13},
      {"value": "Calvin Klein", "count": 15},
      {"value": "Estée Lauder", "count": 34},
      {"value": "Wella", "count": 8},
      {"value": "American Crew", "count": 7},
      {"value": "Nude by Nature", "count": 38},
      {"value": "Dermedicine", "count": 9},
      {"value": "Nivea", "count": 5},
      {"value": "Fanola", "count": 10},
      {"value": "REN", "count": 5},
      {"value": "Provoke", "count": 4},
      {"value": "Impulse", "count": 3},
      {"value": "Skin Chemists", "count": 14},
      {"value": "Its Giving Glam", "count": 2},
      {"value": "Wet Brush", "count": 3},
      {"value": "Maybelline", "count": 6},
      {"value": "It's A 10", "count": 17},
      {"value": "Olay", "count": 7},
      {"value": "Eylure", "count": 7},
      {"value": "Schwarzkopf", "count": 2},
      {"value": "Jack Black", "count": 3},
      {"value": "Lancaster", "count": 6},
      {"value": "Jimmy Choo", "count": 7},
      {"value": "Lux", "count": 2},
      {"value": "Clean & Clear", "count": 1},
      {"value": "Neutrogena", "count": 7},
      {"value": "Dr Dennis Gross", "count": 4},
      {"value": "Regarding Skin", "count": 11},
      {"value": "Murad", "count": 4},
      {"value": "Al Haramain", "count": 3},
      {"value": "Brut", "count": 1},
      {"value": "Concentrated Naturals", "count": 1},
      {"value": "Diesel", "count": 5},
      {"value": "Britney Spears", "count": 7},
      {"value": "Cosmesis Skincare", "count": 3},
      {"value": "Vaseline", "count": 6},
      {"value": "Giorgio Armani", "count": 3},
      {"value": "So…?", "count": 1},
      {"value": "Too Faced", "count": 3},
      {"value": "Urban Decay", "count": 1},
      {"value": "A'kin", "count": 2},
      {"value": "Bosistos", "count": 1},
      {"value": "Herbal Essences", "count": 3},
      {"value": "Issey Miyake", "count": 5},
      {"value": "Kate Somerville", "count": 9},
      {"value": "Tresemme", "count": 3},
      {"value": "W7", "count": 4},
      {"value": "Davidoff", "count": 2},
      {"value": "Nuxe", "count": 4},
      {"value": "Police", "count": 2},
      {"value": "Algenist", "count": 6},
      {"value": "Anastasia Beverly Hills", "count": 3},
      {"value": "Dr H", "count": 6},
      {"value": "Community Sixty-Six", "count": 2},
      {"value": "Coty", "count": 1},
      {"value": "Elemis", "count": 10},
      {"value": "Jane Iredale", "count": 5},
      {"value": "Paco Rabanne", "count": 10},
      {"value": "Style & Grace", "count": 1},
      {"value": "Veet", "count": 2},
      {"value": "Cabello", "count": 2},
      {"value": "Colgate", "count": 1},
      {"value": "Escada", "count": 3},
      {"value": "Guerlain", "count": 5},
      {"value": "Sally Hansen", "count": 1},
      {"value": "Stila", "count": 9},
      {"value": "Yeauty", "count": 3},
      {"value": "Anna Sui", "count": 1},
      {"value": "Charlotte Tilbury", "count": 2},
      {"value": "Essano", "count": 2},
      */
    ];
    return tempData.map((dict) {
      String value = (dict['value'] as String?) ?? '';
      int count = (dict['count'] as int?) ?? 0;
      return SizeFilterTemp(value: value, count: count);
    }).toList();
  }
}
