import 'package:flutter/material.dart';
import 'package:flutter_mysale/core/widgets/product_card.dart';
import 'package:flutter_mysale/features/main_app/app.dart';
import 'package:flutter_mysale/features/main_app/controllers/controller.dart';
import 'package:flutter_mysale/features/main_app/models/main/categorynode_model.dart';
import 'package:flutter_mysale/features/main_app/models/main/facetfilter_model.dart';
import 'package:flutter_mysale/features/main_app/models/main/productitem_model.dart';
import 'package:flutter_mysale/features/main_app/models/main/productsort_model.dart';
import 'package:flutter_mysale/features/main_app/providers/filter_provider.dart';
import 'package:flutter_mysale/features/main_app/providers/productlist_provider.dart';
import 'package:flutter_mysale/features/main_app/providers/productsort_provider.dart';
import 'package:flutter_mysale/features/main_app/widgets/filter_bar.dart';
import 'package:flutter_mysale/features/main_app/widgets/icon_text_badge_button.dart';
import 'package:paged_grid_view/paged_grid_view.dart';
import 'package:provider/provider.dart';

import '../../../../config/config.dart';
import '../../../../core/core.dart';

class _CategoryFilterItem extends FilterItem {
  final CategoryNodeModel _category;
  late String _title;

  _CategoryFilterItem(this._category) {
    _title = _category.name ?? '';
  }

  @override
  String getTitle() {
    return _title;
  }

  static List<_CategoryFilterItem> fromAppliedCategories(
    List<CategoryNodeModel> appliedCategories,
  ) {
    List<_CategoryFilterItem> items = [];

    appliedCategories.forEach((CategoryNodeModel category) {
      items.add(_CategoryFilterItem(category));
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
  ProductSortModel sort;

  _SortMode({required this.sort});

  @override
  String getTitle() {
    return 'Sort by ${sort.title ?? ''}';
  }
}

class ProductList extends StatefulWidget {
  final String? _initialTitle;
  final bool willShowSearchBoxOnOpen;

  const ProductList({
    Key? key,
    String? title,
    required this.willShowSearchBoxOnOpen,
  }) : this._initialTitle = title,
       super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList>
    with TickerProviderStateMixin {
  String _logoImagePath = "assets/images/logo.png";

  final TextEditingController _searchTextFieldController =
      TextEditingController(text: '');
  bool dayAndNight = false;

  bool _showSearch = false;

  late final ScrollController _scrollController;
  double _scrollPosition = 0.0;
  double _scrollSpeed = 0.0;

  AnimationController? _searchAndFilterAnimationController;
  AnimationController? _searchBoxAnimationController;
  Animation<double>? _searchAndFilterTween;
  Animation<double>? _searchBoxTween;

  String? _title;

  @override
  void initState() {
    super.initState();
    var tm = context.read<ThemeProvider>();
    dayAndNight = tm.isDarkMode;
    _searchTextFieldController.text =
        (Provider.of<ProductListProvider>(
          context,
          listen: false,
        )).searchQuery ??
        '';
    _title = _searchTextFieldController.text;
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
    _searchBoxTween = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _searchBoxAnimationController!,
        curve: Curves.linear,
      ),
    );
    if (widget.willShowSearchBoxOnOpen) {
      _showSearch = true;
      _searchBoxAnimationController?.value = 1.0;
    } else {
      _showSearch = false;
      _searchBoxAnimationController?.value = 0.0;
    }

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollSpeed > 0) {
        _searchAndFilterAnimationController?.forward();
      } else if (_scrollSpeed < 0) {
        _searchAndFilterAnimationController?.reverse();
      }
      _calculateScrollSpeed(_scrollController);
    });

    Future.microtask(() {
      final provider = Provider.of<ProductListProvider>(context, listen: false);
      provider.getProductList();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchTextFieldController.dispose();
    _searchAndFilterAnimationController?.dispose();
    _searchBoxAnimationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductListProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leadingWidth: 56,
        centerTitle: true,
        toolbarHeight: 56,
        leading: null,
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
                _searchBoxAnimationController?.forward();
              } else {
                _searchBoxAnimationController?.reverse();
              }
            },
            icon: const Icon(Icons.search),
          ),
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
            _productsDisplay(_scrollController),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }

  SizedBox _titleBar() {
    String title = "";
    if (_title != null && _title!.isNotEmpty) {
      title = _title!;
    } else if (widget._initialTitle != null &&
        widget._initialTitle!.isNotEmpty) {
      title = widget._initialTitle!;
    }
    if (title.isEmpty) {
      return SizedBox();
    } else {
      return SizedBox(
        width: double.infinity,
        child: Container(
          margin: const EdgeInsets.only(
            left: 10.0,
            right: 10.0,
            top: 4.0,
            bottom: 4.0,
          ),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      );
    }
  }

  SizedBox _searchBar(ProductListProvider provider) {
    Color color = Color(0xFFEEEEEE);
    return SizedBox(
      width: double.infinity,
      child: SizeTransition(
        sizeFactor: _searchBoxTween!,
        axis: Axis.vertical,
        child: Container(
          margin: const EdgeInsets.only(
            left: 10.0,
            right: 10.0,
            top: 4.0,
            bottom: 4.0,
          ),
          child: TextFormField(
            decoration: InputDecoration(
              fillColor: color,
              filled: true,
              contentPadding: const EdgeInsets.all(4.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: color, width: 0.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: color, width: 0.0),
              ),
              prefixIcon: const Icon(Icons.search),
              hintText: 'Search',
            ),
            controller: _searchTextFieldController,
            onChanged: (val) {
              provider.resetProductList();
              provider.updateSearchQuery(val);
              provider.getProductList();
              setState(() {
                _title = val;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _searchAndFilterDisplay(ProductListProvider provider) {
    return Column(
      children: [
        _searchBar(provider),
        _titleBar(),
        _createFilterSection(),
        _filterBubblesDisplay(),
      ],
    );
  }

  Widget _createFilterSection() {
    return Consumer<ProductListProvider>(
      builder: (BuildContext context, ProductListProvider p, Widget? child) {
        int appliedCategoryCount = p.appliedCategories.length;
        int appliedFilterCount = p.appliedFilters
            .map<int?>((FacetFilterModel e) => e.values?.length)
            .nonNulls
            .fold(0, (a, b) => a + b);
        int sortCount = p.sort != null ? 1 : 0;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              _createFilterButton(appliedFilterCount + appliedCategoryCount),
              const SizedBox(width: 8),
              _createSortButton(sortCount),
            ],
          ),
        );
      },
    );
  }

  Widget _createFilterButton(int count) {
    return Expanded(
      child: IconTextBadgeButton(
        height: 50,
        icon: Icons.tune,
        text: 'Filter',
        count: count,
        onTap: () {
          ProductListProvider pl = context.read<ProductListProvider>();
          FilterProvider fp = FilterProvider(
            saleId: '',
            searchQuery: '',
            productTotal: pl.productList?.total ?? 0,
            currency: '\$',
            // TODO JCA get currency symbol somewhere
            maxPrice: pl.getInitialMaxPrice() ?? 1000,
            categories: [...pl.initialProductListResponse?.categories ?? []],
            selectedCategories: [...pl.appliedCategories],
            facetFilters: [...pl.initialProductListResponse?.facets ?? []],
            appliedFilters: [...pl.appliedFilters],
            originCategory: pl.originCategory,
          );
          FilterMainArguments args = FilterMainArguments(
            filterProvider: fp,
            productListProvider: pl,
          );

          Nav.toNamed(context, App.filtermain, arguments: args);
        },
      ),
    );
  }

  Widget _createSortButton(int count) {
    return Expanded(
      child: IconTextBadgeButton(
        height: 50,
        icon: Icons.swap_vert,
        text: 'Sort',
        count: count,
        onTap: () {
          ProductListProvider pl = context.read<ProductListProvider>();
          ProductSortProvider ps = ProductSortProvider(
            selectedSortItem: pl.sort,
            sortItems: null,
          );

          ProductSortArguments args = ProductSortArguments(
            productSortProvider: ps,
            productListProvider: pl,
          );
          Nav.toNamed(context, App.productSort, arguments: args);
        },
      ),
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
              List<CategoryNodeModel> appliedCategories = [
                ...provider.appliedCategories,
              ];
              List<FacetFilterModel> facetFilters = [
                ...provider.appliedFilters,
              ];
              if (item is _CategoryFilterItem) {
                appliedCategories.remove(item._category);
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
                provider.updateSort(null);
              }

              provider.updateAppliedFilters(
                aAppliedCategories: appliedCategories,
                aAppliedFilters: facetFilters,
              );
              provider.resetProductList();
              provider.getProductList();
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
          } else if (provider.productList?.products != null) {
            if (provider.productList?.page == provider.page) {
              provider.products.addAll(provider.productList?.products ?? []);
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
                  provider.getProductList();
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
    ProductListProvider pl = context.read<ProductListProvider>();
    return GestureDetector(
      child: ProductCard(product: product),
      onTap: () => {
        Nav.toNamed(
          context,
          App.productDetail,
          arguments: ProductDetailArguments(
            productId: product.id ?? '',
            masterSkuId: product.skus?.first.id ?? '',
            brandName: product.brandName ?? '',
            seo: product.seoIdentifier,
            saleId: pl.saleId,
            product: product,
          ),
        ),
      },
    );
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

  List<FilterItem> _filterItemsFromArgs() {
    ProductListProvider pl = context.read<ProductListProvider>();
    List<FilterItem> items = [];
    items.addAll(
      _CategoryFilterItem.fromAppliedCategories(pl.appliedCategories),
    );
    items.addAll(_FilterItem.fromFacetFilters(pl.appliedFilters));
    if (pl.sort != null) {
      items.add(_SortMode(sort: pl.sort!));
    }
    return items;
  }
}
