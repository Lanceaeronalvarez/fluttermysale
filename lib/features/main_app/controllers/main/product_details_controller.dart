import 'package:flutter/material.dart';
import 'package:flutter_mysale/architect.dart';
import 'package:flutter_mysale/features/main_app/models/main/productitem_model.dart';
import 'package:flutter_mysale/features/main_app/providers/productdetail_provider.dart';
import 'package:flutter_mysale/features/main_app/providers/recentlyviewed_provider.dart';
import 'package:flutter_mysale/features/main_app/providers/trendingbrands_provider.dart';
import 'package:provider/provider.dart';

import '../../Screens/universal/product_detail_page.dart' as mobile;

class ProductDetailArguments {
  final String productId;
  final String masterSkuId;
  final String brandName;
  final String? seo;
  final String? saleId;
  final ProductItem? product;

  ProductDetailArguments({
    required this.productId,
    required this.masterSkuId,
    required this.brandName,
    required this.saleId,
    this.seo,
    required this.product,
  });
}

class ProductDetailController extends StatefulController {
  final ProductDetailArguments args;

  ProductDetailController({Key? key, required this.args}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProductDetailControllerState();
  }
}

class _ProductDetailControllerState
    extends ControllerState<ProductDetailController> {
  late final List<ChangeNotifierProvider<ChangeNotifier>> _providers;

  @override
  void initState() {
    super.initState();

    _providers = [
      ChangeNotifierProvider<ProductDetailProvider>(
        create: (context) => ProductDetailProvider(context: context),
      ),
      ChangeNotifierProvider<TrendingBrandsProvider>(
        create: (context) => TrendingBrandsProvider(context: context),
      ),
      ChangeNotifierProvider<RecentlyViewedProvider>(
        create: (context) => RecentlyViewedProvider(context: context),
      ),
    ];
  }

  @override
  Display view(BuildContext context) {
    return Display(
      title: "Product Detail",
      mobile: MultiProvider(
        providers: _providers,
        child: mobile.ProductDetailPage(args: widget.args),
      ),
    );
  }
}
