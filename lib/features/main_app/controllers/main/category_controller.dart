import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_mysale/core/core.dart';

import '../../Screens/universal/categorytree_widget.dart' as universal;

class CategoryTreeController extends StatelessController {
  const CategoryTreeController({Key? key}) : super(key: key);

  @override
  Display view(BuildContext context) {
    return Display(title: "Category", mobile: universal.CategoryTreeWidget());
  }
}
