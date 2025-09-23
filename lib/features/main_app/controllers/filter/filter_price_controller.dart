import 'package:flutter/material.dart';
import 'package:flutter_mysale/core/core.dart';
import 'package:flutter_mysale/features/main_app/providers/filter_provider.dart';
import 'package:flutter_mysale/features/main_app/providers/productlist_provider.dart';
import 'package:provider/provider.dart';

import '../../Screens/universal/filter_price.dart';

class FilterPriceArguments {
  FilterProvider filterProvider;
  ProductListProvider productListProvider;

  FilterPriceArguments._({
    required this.filterProvider,
    required this.productListProvider,
  });

  factory FilterPriceArguments({
    required FilterProvider filterProvider,
    required ProductListProvider productListProvider,
  }) {
    return FilterPriceArguments._(
      filterProvider: filterProvider,
      productListProvider: productListProvider,
    );
  }
}

class FilterPriceController extends StatelessController {
  const FilterPriceController({Key? key}) : super(key: key);

  @override
  Display view(BuildContext context) {
    FilterPriceArguments args =
        (ModalRoute.of(context)?.settings.arguments as FilterPriceArguments);

    FilterPrice child = FilterPrice();

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

    return Display(title: "Filter Price", mobile: multiProvider);
  }
}
