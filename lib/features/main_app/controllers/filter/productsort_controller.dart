import 'package:flutter/material.dart';
import 'package:flutter_mysale/core/core.dart';
import 'package:flutter_mysale/features/main_app/providers/productlist_provider.dart';
import 'package:flutter_mysale/features/main_app/providers/productsort_provider.dart';
import 'package:provider/provider.dart';

import '../../Screens/universal/product_sort.dart';

class ProductSortArguments {
  ProductSortProvider productSortProvider;
  ProductListProvider productListProvider;

  ProductSortArguments._({
    required this.productSortProvider,
    required this.productListProvider,
  });

  factory ProductSortArguments({
    required ProductSortProvider productSortProvider,
    required ProductListProvider productListProvider,
  }) {
    return ProductSortArguments._(
      productSortProvider: productSortProvider,
      productListProvider: productListProvider,
    );
  }
}

class ProductSortController extends StatelessController {
  const ProductSortController({Key? key}) : super(key: key);

  @override
  Display view(BuildContext context) {
    ProductSortArguments args =
        ModalRoute.of(context)?.settings.arguments as ProductSortArguments;
    ProductSortProvider productSortProvider = args.productSortProvider;
    ProductListProvider productListProvider = args.productListProvider;

    ProductSort child = ProductSort();

    MultiProvider multiProvider = MultiProvider(
      providers: [
        ChangeNotifierProvider<ProductSortProvider>.value(
          value: productSortProvider,
        ),
        ChangeNotifierProvider<ProductListProvider>.value(
          value: productListProvider,
        ),
      ],
      child: child,
    );

    return Display(
      title: "Product Sort",
      mobile: ChangeNotifierProvider<ProductSortProvider>.value(
        value: productSortProvider,
        child: multiProvider,
      ),
    );
  }
}
