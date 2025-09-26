import 'package:flutter/material.dart';
import 'package:flutter_mysale/core/core.dart';
import 'package:flutter_mysale/features/main_app/providers/filter_provider.dart';
import 'package:flutter_mysale/features/main_app/providers/productlist_provider.dart';
import 'package:provider/provider.dart';

import '../../Screens/universal/filter_select.dart';

class FilterSelectArguments {
  FilterKey filterKey;
  bool showSearch;
  bool showSort;
  FilterProvider filterProvider;
  ProductListProvider productListProvider;

  FilterSelectArguments._({
    required this.filterKey,
    required this.showSearch,
    required this.showSort,
    required this.filterProvider,
    required this.productListProvider,
  });

  factory FilterSelectArguments({
    required FilterKey filterKey,
    required bool showSearch,
    required bool showSort,
    required FilterProvider filterProvider,
    required ProductListProvider productListProvider,
  }) {
    return FilterSelectArguments._(
      filterKey: filterKey,
      showSearch: showSearch,
      showSort: showSort,
      filterProvider: filterProvider,
      productListProvider: productListProvider,
    );
  }
}

class FilterSelectController extends StatelessController {
  const FilterSelectController({Key? key}) : super(key: key);

  @override
  Display view(BuildContext context) {
    FilterSelectArguments args =
        (ModalRoute.of(context)?.settings.arguments as FilterSelectArguments);

    FilterSelect child = FilterSelect(
      filterKey: args.filterKey,
      showSearch: args.showSearch,
      showSort: args.showSort,
    );

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

    return Display(title: "Filter Select", mobile: multiProvider);
  }
}
