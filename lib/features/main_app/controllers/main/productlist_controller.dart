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

class ProductListController extends StatefulController {
  final ProductListArguments args;

  ProductListController({required this.args});

  @override
  State<StatefulWidget> createState() {
    return _ProductListState();
  }
}

class _ProductListState extends ControllerState<ProductListController> {
  late final ProductListProvider _productListProvider;
  late final ProductSortProvider _productSortProvider;

  @override
  void initState() {
    super.initState();

    _productListProvider = ProductListProvider(
      userAgentHelper: UserAgentHelper.shared,
      saleId: widget.args.saleId,
      categoryKeys: widget.args.categoryKeys,
      facetFilters: widget.args.appliedFilters,
      sort: widget.args.sort,
    );

    _productSortProvider = ProductSortProvider();
  }

  @override
  void dispose() {
    _productListProvider.dispose();
    _productSortProvider.dispose();
    super.dispose();
  }

  @override
  Display view(BuildContext context) {
    ProductList child = ProductList();

    MultiProvider multiProvider = MultiProvider(
      providers: [
        ChangeNotifierProvider<ProductListProvider>.value(
          value: _productListProvider,
        ),
        ChangeNotifierProvider<ProductSortProvider>.value(
          value: _productSortProvider,
        ),
      ],
      child: child,
    );

    return Display(title: 'Product List', mobile: multiProvider);
  }
}
