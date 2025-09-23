import 'package:flutter_mysale/features/main_app/models/main/categorynode_model.dart';

enum FilterCategoryStatus { unchecked, checked, partial }

class FilterCategoryModel {
  final CategoryNodeModel category;
  late final List<FilterCategoryModel> filterChildren;
  final int depth;

  bool _isExpanded;
  bool get isExpanded => _isExpanded;
  void toggleIsExpanded() {
    if (isExpanded) {
      childrenIsExpandedToggleOff();
    } else {
      _isExpanded = true;
    }
  }

  void childrenIsExpandedToggleOff() {
    _isExpanded = false;
    for (FilterCategoryModel fChild in filterChildren) {
      fChild.childrenIsExpandedToggleOff();
    }
  }

  //only the leaf node will use this value
  FilterCategoryStatus _status;
  //leaf node will return _status else status will be computed based on the status of it's child nodes
  FilterCategoryStatus get status {
    if (hasChild) {
      int unchecked = 0;
      int partial = 0;
      int checked = 0;
      for (FilterCategoryModel filterChild in filterChildren) {
        FilterCategoryStatus status = filterChild.status;
        switch (status) {
          case FilterCategoryStatus.unchecked:
            unchecked += 1;
          case FilterCategoryStatus.partial:
            partial += 1;
          case FilterCategoryStatus.checked:
            checked += 1;
        }
      }
      int childCount = filterChildren.length;
      if (unchecked == childCount) {
        return FilterCategoryStatus.unchecked;
      } else if (checked == childCount) {
        return FilterCategoryStatus.checked;
      } else {
        return FilterCategoryStatus.partial;
      }
    } else {
      return _status;
    }
  }

  //modify status of all of it's leaf node, status of node is computed and retrieved via the getter status
  void setStatusOfLeafCategories(bool isSelected) {
    if (hasChild) {
      for (FilterCategoryModel filterChild in filterChildren) {
        filterChild.setStatusOfLeafCategories(isSelected);
      }
    } else {
      if (isSelected) {
        _status = FilterCategoryStatus.checked;
      } else {
        _status = FilterCategoryStatus.unchecked;
      }
    }
  }

  FilterCategoryModel({
    required this.category,
    required List<FilterCategoryModel> fChildren,
    required this.depth,
    required bool isExpanded,
    required FilterCategoryStatus status,
  }) : filterChildren = List.unmodifiable(fChildren),
       _isExpanded = isExpanded,
       _status = status;

  bool get hasChild => filterChildren.isNotEmpty;
}
