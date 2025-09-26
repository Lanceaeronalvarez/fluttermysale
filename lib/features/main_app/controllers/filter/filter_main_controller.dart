import 'package:flutter/material.dart';
import 'package:flutter_mysale/core/core.dart';
import 'package:flutter_mysale/features/main_app/providers/filter_provider.dart';
import 'package:flutter_mysale/features/main_app/providers/productlist_provider.dart';
import 'package:provider/provider.dart';

import '../../Screens/universal/filter_main.dart';

class FilterMainArguments {
  FilterProvider filterProvider;
  ProductListProvider productListProvider;

  FilterMainArguments._({
    required this.filterProvider,
    required this.productListProvider,
  });

  factory FilterMainArguments({
    required FilterProvider filterProvider,
    required ProductListProvider productListProvider,
  }) {
    return FilterMainArguments._(
      filterProvider: filterProvider,
      productListProvider: productListProvider,
    );
  }
}

class FilterMainController extends StatelessController {
  const FilterMainController({Key? key}) : super(key: key);

  @override
  Display view(BuildContext context) {
    FilterMainArguments args =
        (ModalRoute.of(context)?.settings.arguments as FilterMainArguments);

    FilterMain child = FilterMain();

    FilterProvider filterProvider = args.filterProvider;
    ProductListProvider productListProvider = args.productListProvider;
    MultiProvider multiProvider = MultiProvider(
      providers: [
        ChangeNotifierProvider<FilterProvider>.value(value: filterProvider),
        ChangeNotifierProvider<ProductListProvider>.value(
          value: productListProvider,
        ),
      ],
      child: child,
    );

    return Display(title: "Filter Main", mobile: multiProvider);
  }
}
