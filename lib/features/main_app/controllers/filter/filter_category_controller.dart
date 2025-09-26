import 'package:flutter/material.dart';
import 'package:flutter_mysale/core/core.dart';
import 'package:flutter_mysale/features/main_app/Screens/universal/filter_category.dart';
import 'package:flutter_mysale/features/main_app/providers/filter_provider.dart';
import 'package:flutter_mysale/features/main_app/providers/productlist_provider.dart';
import 'package:provider/provider.dart';

class FilterCategoryArguments {
  FilterProvider filterProvider;
  ProductListProvider productListProvider;

  FilterCategoryArguments._({
    required this.filterProvider,
    required this.productListProvider,
  });

  factory FilterCategoryArguments({
    required FilterProvider filterProvider,
    required ProductListProvider productListProvider,
  }) {
    return FilterCategoryArguments._(
      filterProvider: filterProvider,
      productListProvider: productListProvider,
    );
  }
}

class FilterCategoryController extends StatelessController {
  const FilterCategoryController({Key? key}) : super(key: key);

  @override
  Display view(BuildContext context) {
    FilterCategoryArguments args =
        (ModalRoute.of(context)?.settings.arguments as FilterCategoryArguments);

    FilterCategory child = FilterCategory();

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

    return Display(title: "Filter Category", mobile: multiProvider);
  }
}
