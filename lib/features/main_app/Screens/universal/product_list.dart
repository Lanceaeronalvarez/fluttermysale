import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mysale/core/widgets/product_card.dart';
import 'package:flutter_mysale/features/main_app/app.dart';
import 'package:flutter_mysale/features/main_app/controllers/controller.dart';
import 'package:flutter_mysale/features/main_app/models/main/facetfilter_model.dart';
import 'package:flutter_mysale/features/main_app/models/main/productitem_model.dart';
import 'package:flutter_mysale/features/main_app/models/main/productlist_model.dart';
import 'package:flutter_mysale/features/main_app/providers/filter_provider.dart';
import 'package:flutter_mysale/features/main_app/providers/productlist_provider.dart';
import 'package:flutter_mysale/features/main_app/providers/productsort_provider.dart';
import 'package:flutter_mysale/features/main_app/widgets/filter_bar.dart';
import 'package:paged_grid_view/paged_grid_view.dart';
import 'package:provider/provider.dart';

import '../../../../config/config.dart';
import '../../../../core/core.dart';

typedef ProductListArguments = ({
  String saleId,
  List<String> categoryKeys,
  List<FacetFilterModel> facetFilters,
  String sort,
});

class _CategoryFilterItem extends FilterItem {
  final String _categoryKey;
  late String _title;

  _CategoryFilterItem(this._categoryKey) {
    _title = _categoryKey.split(">>>").last;
  }

  @override
  String getTitle() {
    return _title;
  }

  static List<_CategoryFilterItem> fromCategoryKeys(List<String> categoryKeys) {
    List<_CategoryFilterItem> items = [];

    categoryKeys.forEach((String s) {
      items.add(_CategoryFilterItem(s));
    });

    return items;
  }
}

class _FilterItem extends FilterItem {
  late String _title;
  final String _facetFilterName;
  final FacetFilterValueModel _value;

  _FilterItem(this._facetFilterName, this._value) {
    _title = _value.value!; //TODO: readable title?
  }

  @override
  String getTitle() {
    return _title;
  }

  static List<_FilterItem> fromFacetFilters(
    List<FacetFilterModel> facetFilters,
  ) {
    List<_FilterItem> items = [];

    facetFilters.forEach((FacetFilterModel ff) {
      ff.values?.forEach((FacetFilterValueModel value) {
        items.add(_FilterItem(ff.name!, value));
      });
    });
    return items;
  }
}

class _SortMode extends FilterItem {
  late String _title;

  _SortMode(String sortMode) {
    _title = "Sort by " + sortMode; //TODO: readable title?
  }

  @override
  String getTitle() {
    return _title;
  }
}

class ProductList extends StatefulWidget {
  final String? title;

  const ProductList({Key? key, this.title}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList>
    with TickerProviderStateMixin {
  String _logoImagePath = "assets/images/logo.png";

  final TextEditingController _controller = TextEditingController(text: '');
  bool dayAndNight = false;

  bool _showSearch = true;

  double _scrollPosition = 0.0;
  double _scrollSpeed = 0.0;

  AnimationController? _searchAndFilterAnimationController;
  AnimationController? _searchBoxAnimationController;
  Animation<double>? _searchAndFilterTween;
  Animation<double>? _searchBoxTween;

  void getProductList(ProductListProvider provider) {
    GetProductListRequest request = GetProductListRequest(
      _controller.text,
      provider.page.toString(),
      provider.pageSize.toString(),
      jsonEncode(provider.categoryKeys),
      jsonEncode(provider.facetFiltersToRequestArgs()),
      provider.sort,
    );
    provider.getProductList(request);
  }

  @override
  void initState() {
    super.initState();
    var tm = context.read<ThemeProvider>();
    dayAndNight = tm.isDarkMode;
    _searchAndFilterAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _searchAndFilterTween = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _searchAndFilterAnimationController!,
        curve: Curves.linear,
      ),
    );
    _searchBoxAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _searchBoxTween = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _searchBoxAnimationController!,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _searchAndFilterAnimationController?.dispose();
    _searchBoxAnimationController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductListProvider>(context, listen: false);
    getProductList(provider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leadingWidth: 56,
        centerTitle: true,
        toolbarHeight: 56,
        leading: _backButton(),
        scrolledUnderElevation: 0,
        // stop darkening appbar on scroll
        surfaceTintColor: Colors.transparent,
        // disable Material 3 tint overlay
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        // no shadow
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(0.75),
          child: Divider(
            height: 0.75,
            thickness: 0.75,
            color: Color(0xFFCCA68B),
          ),
        ),
        title: SizedBox(height: 32, child: _createAppbarLogo()),
        actions: [
          IconButton(
            onPressed: () {
              _showSearch = !_showSearch;
              if (_showSearch) {
                _searchBoxAnimationController?.reverse();
              } else {
                _searchBoxAnimationController?.forward();
              }
            },
            icon: const Icon(Icons.search),
          ),
          _createTempSortButton(),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            SizeTransition(
              sizeFactor: _searchAndFilterTween!,
              axis: Axis.vertical,
              child: _searchAndFilterDisplay(provider),
            ),
            _productsDisplay(_scrollController()),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }

  //Temp Only, delete if not needed anymore
  Widget _createTempSortButton() {
    return TextButton(
      onPressed: () {
        //ProductSortProvider p = context.read<ProductSortProvider>();
        //Nav.toNamed(
        //  context,
        //  App.productSort,
        //  arguments: (productSortProvider: p),
        //);
        //Nav.toNamed(context, App.cartModal);

        ProductListProvider pl = context.read<ProductListProvider>();

        FilterProvider fp = FilterProvider(
          saleId: '',
          searchQuery: '',
          sort: context.read<ProductSortProvider>().selectedSortItem?.key,
          productTotal: pl.productList.total ?? 0,
          currency: '\$', // TODO JCA get currency symbol somewhere
          maxPrice: pl.initialMaxPrice ?? 1000,
          categories: [...pl.productList.categories ?? []],
          facetFilters: [...pl.productList.facets ?? []],
        );
        ProductListProvider plp = context.read<ProductListProvider>();
        FilterMainArguments args = FilterMainArguments(
          filterProvider: fp,
          productListProvider: plp,
        );
        Nav.toNamed(context, App.filtermain, arguments: args);
      },
      child: Text('Sort'),
      style: TextButton.styleFrom(foregroundColor: Colors.black),
    );
  }

  SizedBox _searchBar(ProductListProvider provider) {
    return SizedBox(
      width: double.infinity,
      child: SizeTransition(
        sizeFactor: _searchBoxTween!,
        axis: Axis.vertical,
        child: TextField(
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Search',
          ),
          controller: _controller,
          onChanged: (val) {
            provider.resetProductList();
            getProductList(provider);
          },
        ),
      ),
    );
  }

  Column _searchAndFilterDisplay(ProductListProvider provider) {
    return Column(
      children: [
        _searchBar(provider),
        _createTempSortButton(),
        _filterBubblesDisplay(),
      ],
    );
  }

  Widget _filterBubblesDisplay() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Consumer<ProductListProvider>(
        builder: (_, provider, __) {
          return FilterBar<FilterItem>(
            filters: _filterItemsFromArgs(),
            onTap: (FilterItem item, int index) {
              List<String> categoryKeys = [...provider.categoryKeys];
              List<FacetFilterModel> facetFilters = [...provider.facetFilters];
              String sort = provider.sort;
              if (item is _CategoryFilterItem) {
                categoryKeys.remove(item._categoryKey);
              } else if (item is _FilterItem) {
                facetFilters
                    .where((FacetFilterModel ff) {
                      return item._facetFilterName == ff.name;
                    })
                    .first
                    .values
                    ?.removeWhere((FacetFilterValueModel value) {
                      return item._value.value == value.value;
                    });
              } else if (item is _SortMode) {
                sort = "";
              }

              //should replicate this

              provider.updateAppliedFilters(
                aCategoryKeys: categoryKeys,
                aFacetFilters: facetFilters,
                aSort: sort,
              );
              provider.resetProductList();
              getProductList(provider);
            },
          );
        },
      ),
    );
  }

  Expanded _productsDisplay(ScrollController scrollController) {
    return Expanded(
      child: Consumer<ProductListProvider>(
        builder: (_, provider, __) {
          if (provider.isLoading) {
            return const Center(child: Text('Loading....'));
          } else if (provider.productList.products != null) {
            if (provider.productList.page == provider.page) {
              provider.products.addAll(provider.productList.products!);
            }
            return PagedGridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 353, //TODO: calculate?
              ),
              itemBuilder: (_, index) => _productCard(provider.products[index]),
              itemCount: provider.products.length,
              scrollDirection: Axis.vertical,
              controller: scrollController,
              physics: null,
              onPageChanged: (index) {
                if (index > provider.page) {
                  provider.incrementPage();
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

  Widget _productCard(ProductItem product) {
    return ProductCard(product: product);
    // TODO: onTap
  }

  ScrollController _scrollController() {
    ScrollController scrollController = ScrollController();
    scrollController.addListener(() {
      if (_scrollSpeed > 0) {
        _searchAndFilterAnimationController?.forward();
      } else if (_scrollSpeed < 0) {
        _searchAndFilterAnimationController?.reverse();
      }
      _calculateScrollSpeed(scrollController);
    });
    return scrollController;
  }

  void _calculateScrollSpeed(ScrollController scrollController) {
    double currentPosition = scrollController.position.pixels;
    _scrollSpeed = currentPosition - _scrollPosition;
    _scrollPosition = currentPosition;
  }

  Widget _createAppbarLogo() {
    return FittedBox(
      fit: BoxFit.contain,
      child: GestureDetector(
        onTap: () {},
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 28),
          child: Image.asset(_logoImagePath),
        ),
      ),
    );
  }

  Widget _backButton() {
    return GestureDetector(
      onTap: () {
        Nav.close(context);
      },
      child: Icon(Icons.backspace),
    );
  }

  List<FilterItem> _filterItemsFromArgs() {
    ProductListProvider pl = context.read<ProductListProvider>();
    List<FilterItem> items = [];
    items.addAll(_CategoryFilterItem.fromCategoryKeys(pl.categoryKeys));
    items.addAll(_FilterItem.fromFacetFilters(pl.facetFilters));
    if (pl.sort.isNotEmpty) {
      items.add(_SortMode(pl.sort));
    }
    return items;
  }
}
