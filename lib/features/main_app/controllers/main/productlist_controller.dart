import 'package:flutter/material.dart';
import 'package:flutter_mysale/core/helpers/useragent_helper.dart';
import 'package:flutter_mysale/features/main_app/Screens/universal/product_list.dart';
import 'package:flutter_mysale/features/main_app/models/main/facetfilter_model.dart';
import 'package:flutter_mysale/features/main_app/providers/productsort_provider.dart';
import 'package:provider/provider.dart';

import '../../../../core/core.dart';
import '../../providers/productlist_provider.dart';

class ProductListArguments {
  String saleId;
  List<String> categoryKeys;
  List<FacetFilterModel> appliedFilters;
  String sort;

  ProductListArguments._({
    required this.saleId,
    required this.categoryKeys,
    required this.appliedFilters,
    required this.sort,
  });

  factory ProductListArguments({
    required String saleId,
    required List<String> categoryKeys,
    required List<FacetFilterModel> appliedFilters,
    required String sort,
  }) {
    return ProductListArguments._(
      saleId: saleId,
      categoryKeys: categoryKeys,
      appliedFilters: appliedFilters,
      sort: sort,
    );
  }
}

class ProductListController extends StatelessController {
  const ProductListController({Key? key}) : super(key: key);

  @override
  bool get auth => true;

  @override
  Display view(BuildContext context) {
    ProductListArguments args =
        (ModalRoute.of(context)?.settings.arguments as ProductListArguments);

    ProductList child = ProductList();

    UserAgentHelper userAgentHelper = UserAgentHelper(context);
    ProductListProvider productListProvider = ProductListProvider(
      userAgentHelper: userAgentHelper,
      saleId: args.saleId,
      categoryKeys: args.categoryKeys,
      facetFilters: args.appliedFilters,
      sort: args.sort,
    );
    ProductSortProvider productSortProvider = ProductSortProvider();

    MultiProvider multiProvider = MultiProvider(
      providers: [
        ChangeNotifierProvider<ProductListProvider>.value(
          value: productListProvider,
        ),
        ChangeNotifierProvider<ProductSortProvider>.value(
          value: productSortProvider,
        ),
      ],
      child: child,
    );

    return Display(title: 'Product List', mobile: multiProvider);
  }
}
