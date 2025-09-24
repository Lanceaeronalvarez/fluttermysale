import 'package:flutter/material.dart';
import 'package:flutter_mysale/core/helpers/useragent_helper.dart';
import 'package:flutter_mysale/features/main_app/Screens/universal/product_list.dart';
import 'package:flutter_mysale/features/main_app/models/main/categorynode_model.dart';
import 'package:flutter_mysale/features/main_app/models/main/facetfilter_model.dart';
import 'package:flutter_mysale/features/main_app/models/main/productsort_model.dart';
import 'package:provider/provider.dart';

import '../../../../core/core.dart';
import '../../providers/productlist_provider.dart';

class ProductListArguments {
  String saleId;
  List<CategoryNodeModel> appliedCategories;
  List<FacetFilterModel> appliedFilters;
  ProductSortModel? sort;

  ProductListArguments._({
    required this.saleId,
    required this.appliedCategories,
    required this.appliedFilters,
    required this.sort,
  });

  factory ProductListArguments({
    required String saleId,
    required List<CategoryNodeModel> appliedCategories,
    required List<FacetFilterModel> appliedFilters,
    required ProductSortModel? sort,
  }) {
    return ProductListArguments._(
      saleId: saleId,
      appliedCategories: appliedCategories,
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

  @override
  void initState() {
    super.initState();

    _productListProvider = ProductListProvider(
      userAgentHelper: UserAgentHelper.shared,
      saleId: widget.args.saleId,
      appliedCategories: widget.args.appliedCategories,
      appliedFilters: widget.args.appliedFilters,
      sort: widget.args.sort,
    );
  }

  @override
  void dispose() {
    _productListProvider.dispose();
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
      ],
      child: child,
    );

    return Display(title: 'Product List', mobile: multiProvider);
  }
}
