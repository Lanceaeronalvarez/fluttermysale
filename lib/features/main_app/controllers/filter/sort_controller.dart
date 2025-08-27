import 'package:flutter/material.dart';
import 'package:flutter_mysale/core/core.dart';

import '../../Screens/universal/sort_widget.dart' as universal;

class SortController extends StatelessController {
  const SortController({Key? key}) : super(key: key);

  @override
  Display view(BuildContext context) {
    return Display(title: "Sort", mobile: universal.SortWidget());
  }
}
