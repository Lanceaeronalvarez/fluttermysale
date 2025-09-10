import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mysale/core/widgets/product_card.dart';
import 'package:flutter_mysale/features/main_app/app.dart';
import 'package:flutter_mysale/features/main_app/models/main/facetfilter_model.dart';
import 'package:flutter_mysale/features/main_app/models/main/productitem_model.dart';
import 'package:flutter_mysale/features/main_app/models/main/productlist_model.dart';
import 'package:flutter_mysale/features/main_app/providers/productlist_provider.dart';
import 'package:flutter_mysale/features/main_app/providers/productsort_provider.dart';
import 'package:paged_grid_view/paged_grid_view.dart';
import 'package:provider/provider.dart';

import '../../../../config/config.dart';
import '../../../../core/core.dart';

typedef ProductListArguments = ({
  List<String> categoryKeys,
  FacetFilterModel facetFilters,
  String sort,
});

class ProductList extends StatefulWidget {
  final String? title;

  const ProductList({Key? key, this.title}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  ProductListArguments args = (
    categoryKeys: <String>[],
    facetFilters: FacetFilterModel(),
    sort: "",
  );

  final TextEditingController _controller = TextEditingController(text: '');
  bool dayAndNight = false;

  List<ProductItem> _products = [];
  int _page = 0;
  final _pageSize = 10;

  void resetProductList() {
    _products = [];
    _page = 0;
  }

  void getProductList(ProductListProvider provider) {
    GetProductListRequest request = GetProductListRequest(
      _controller.text,
      _page.toString(),
      _pageSize.toString(),
      args.categoryKeys.toString(),
      jsonEncode(args.facetFilters.toJson()),
      args.sort,
    );
    provider.getProductList(request);
  }

  @override
  void initState() {
    super.initState();
    var tm = context.read<ThemeProvider>();
    dayAndNight = tm.isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as ProductListArguments;

    final provider = Provider.of<ProductListProvider>(context, listen: false);
    getProductList(provider);
    return Scaffold(
      appBar: AppBar(
        title: searchBar(provider),
        leading: const Center(child: Icon(Icons.search)),
        actions: [_createTempSortButton()],
      ),
      body: Center(child: Column(children: [productsDisplay()])),
      bottomNavigationBar: BottomBar(),
    );
  }

  //Temp Only, delete if not needed anymore
  Widget _createTempSortButton() {
    return TextButton(
      onPressed: () {
        ProductSortProvider p = context.read<ProductSortProvider>();
        Nav.toNamed(
          context,
          App.productSort,
          arguments: (productSortProvider: p),
        );
      },
      child: Text('Sort'),
      style: TextButton.styleFrom(foregroundColor: Colors.black),
    );
  }

  SizedBox searchBar(ProductListProvider provider) {
    return SizedBox(
      width: double.infinity,
      child: TextField(
        decoration: const InputDecoration(hintText: 'Search'),
        controller: _controller,
        onChanged: (val) {
          resetProductList();
          getProductList(provider);
        },
      ),
    );
  }

  Expanded productsDisplay() {
    return Expanded(
      child: Consumer<ProductListProvider>(
        builder: (_, provider, __) {
          if (provider.isLoading) {
            return const Center(child: Text('Loading....'));
          } else if (provider.productList.products != null) {
            if (provider.productList.page == _page) {
              _products.addAll(provider.productList.products!);
            }
            return PagedGridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 353, //TODO: calculate
              ),
              itemBuilder: (_, index) => productCard(_products[index]),
              itemCount: _products.length,
              scrollDirection: Axis.vertical,
              onPageChanged: (index) {
                if (index > _page) {
                  _page++;
                  getProductList(provider);
                }
              },
            );
          } else {
            return const Center(child: Text('No products'));
          }
        },
      ),
    );
  }

  Widget productCard(ProductItem product) {
    return ProductCard(product: product);
    // TODO: onTap
  }
}
