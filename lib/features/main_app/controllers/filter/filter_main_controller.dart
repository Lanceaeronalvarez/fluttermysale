import 'package:flutter/material.dart';
import 'package:flutter_mysale/core/core.dart';

import '../../Screens/universal/filter_main.dart' as universal;

class FilterMainController extends StatelessController {
  const FilterMainController({Key? key}) : super(key: key);

  @override
  Display view(BuildContext context) {
    return Display(title: "Filter Main", mobile: universal.FilterMain());
  }
}
