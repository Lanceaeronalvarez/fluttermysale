import 'package:flutter/material.dart';
import 'package:flutter_mysale/core/core.dart';
import 'package:flutter_mysale/features/main_app/providers/productsort_provider.dart';
import 'package:provider/provider.dart';

import '../../Screens/universal/product_sort.dart' as universal;

typedef ProductSortArguments = ({ProductSortProvider productSortProvider});

class ProductSortController extends StatelessController {
  const ProductSortController({Key? key}) : super(key: key);

  @override
  Display view(BuildContext context) {
    //This controller will use the productsortprovider in productlistcontroller
    //it will be passed as an arguments since this controller have no direct access to the providers in productlistcontroller
    ProductSortArguments? args =
        ModalRoute.of(context)?.settings.arguments as ProductSortArguments?;
    ProductSortProvider p = args?.productSortProvider ?? ProductSortProvider();
    return Display(
      title: "Product Sort",
      mobile: ChangeNotifierProvider<ProductSortProvider>.value(
        value: p,
        child: universal.ProductSort(),
      ),
    );
  }
}
