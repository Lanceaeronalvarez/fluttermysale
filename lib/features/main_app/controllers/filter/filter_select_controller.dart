import 'package:flutter/material.dart';
import 'package:flutter_mysale/core/core.dart';

import '../../Screens/universal/filter_select_widget.dart' as universal;

class FilterSelectController extends StatelessController {
  const FilterSelectController({Key? key}) : super(key: key);

  @override
  Display view(BuildContext context) {
    return Display(
      title: "Filter Select",
      mobile: universal.FilterSelectWidget(),
    );
  }
}
