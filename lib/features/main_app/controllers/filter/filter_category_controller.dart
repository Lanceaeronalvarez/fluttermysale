import 'package:flutter/material.dart';
import 'package:flutter_mysale/core/core.dart';

import '../../Screens/universal/filter_category.dart' as universal;

class FilterCategoryController extends StatelessController {
  const FilterCategoryController({Key? key}) : super(key: key);

  @override
  Display view(BuildContext context) {
    return Display(
      title: "Filter Category",
      mobile: universal.FilterCategory(),
    );
  }
}
