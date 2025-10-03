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
  String? title;
  String? initialSearchQuery;
  String saleId;
  List<CategoryNodeModel> appliedCategories;
  List<String>? appliedCategoryKeys;
  List<FacetFilterModel> appliedFilters;
  ProductSortModel? sort;
  CategoryNodeModel? originCategory;

  ProductListArguments._({
    this.title,
    this.initialSearchQuery,
    required this.saleId,
    required this.appliedCategories,
    this.appliedCategoryKeys,
    required this.appliedFilters,
    required this.sort,
    required this.originCategory,
  });

  factory ProductListArguments({
    String? title,
    String? initialSearchQuery,
    required String saleId,
    required List<CategoryNodeModel> appliedCategories,
    required List<FacetFilterModel> appliedFilters,
    required ProductSortModel? sort,
    required CategoryNodeModel? originCategory,
  }) {
    return ProductListArguments._(
      title: title,
      initialSearchQuery: initialSearchQuery,
      saleId: saleId,
      appliedCategories: appliedCategories,
      appliedFilters: appliedFilters,
      sort: sort,
      originCategory: originCategory,
    );
  }

  factory ProductListArguments.withAppliedCategoryKeys({
    String? title,
    String? initialSearchQuery,
    required String saleId,
    required List<String> appliedCategoryKeys,
    required List<FacetFilterModel> appliedFilters,
    required ProductSortModel? sort,
  }) {
    return ProductListArguments._(
      title: title,
      initialSearchQuery: initialSearchQuery,
      saleId: saleId,
      appliedCategories: [],
      appliedCategoryKeys: appliedCategoryKeys,
      appliedFilters: appliedFilters,
      sort: sort,
      originCategory: null,
    );
  }
}

class ProductListController extends StatefulController {
  final ProductListArguments args;

  ProductListController({Key? key, required this.args}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProductListState();
  }
}

class _ProductListState extends ControllerState<ProductListController> {
  late final List<ChangeNotifierProvider<ChangeNotifier>> _providers;

  @override
  void initState() {
    super.initState();

    _providers = [
      ChangeNotifierProvider<ProductListProvider>(
        create: (context) => ProductListProvider(
          userAgentHelper: UserAgentHelper.shared,
          searchQuery: widget.args.initialSearchQuery ?? "",
          saleId: widget.args.saleId,
          appliedCategories: widget.args.appliedCategories,
          appliedCategoryKeys: widget.args.appliedCategoryKeys,
          appliedFilters: widget.args.appliedFilters,
          sort: widget.args.sort,
          originCategory: widget.args.originCategory,
        ),
      ),
    ];
  }

  @override
  Display view(BuildContext context) {
    MultiProvider multiProvider = MultiProvider(
      providers: _providers,
      child: ProductList(title: _cleanUpTitle(widget.args.title)),
    );

    return Display(title: 'Product List', mobile: multiProvider);
  }

  String? _cleanUpTitle(String? titleString) {
    return titleString?.replaceAll(">>>", " • ");
  }
}
