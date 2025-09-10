import 'package:flutter/material.dart';
import 'package:flutter_mysale/features/main_app/Screens/universal/product_list.dart';
import 'package:flutter_mysale/features/main_app/providers/productsort_provider.dart';
import 'package:provider/provider.dart';

import '../../../../core/core.dart';
import '../../providers/productlist_provider.dart';

class ProductListController extends StatelessController {
  const ProductListController({Key? key}) : super(key: key);

  @override
  bool get auth => true;

  @override
  Display view(BuildContext context) {
    return Display(
      title: 'Product List',
      mobile: MultiProvider(
        providers: [
          ChangeNotifierProvider<ProductListProvider>(
            create: (context) => ProductListProvider(context: context),
          ),
          ChangeNotifierProvider<ProductSortProvider>(
            create: (context) => ProductSortProvider(),
          ),
        ],
        child: ProductList(),
      ),
    );
  }
}
