import 'package:flutter/material.dart';
import 'package:flutter_mysale/core/core.dart';

import '../../Screens/universal/filter_price_widget.dart' as universal;

class FilterPriceController extends StatelessController {
  const FilterPriceController({Key? key}) : super(key: key);

  @override
  Display view(BuildContext context) {
    return Display(
      title: "Filter Price",
      mobile: universal.FilterPriceWidget(),
    );
  }
}
