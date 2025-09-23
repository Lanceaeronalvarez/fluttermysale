import 'package:flutter/material.dart';
import 'package:flutter_mysale/core/classes/route_manager.dart';
import 'package:flutter_mysale/core/core.dart';
import 'package:flutter_mysale/core/helpers/style_helper.dart';
import 'package:flutter_mysale/features/main_app/app.dart';
import 'package:flutter_mysale/features/main_app/controllers/controller.dart';
import 'package:flutter_mysale/features/main_app/models/main/categorynode_model.dart';
import 'package:flutter_mysale/features/main_app/providers/filter_provider.dart';
import 'package:flutter_mysale/features/main_app/providers/productlist_provider.dart';
import 'package:flutter_mysale/features/main_app/utils/helpers.dart';
import 'package:flutter_mysale/features/main_app/widgets/filter_bar.dart';
import 'package:provider/provider.dart';

class _FilterItem extends FilterItem {
  String title;

  _FilterItem({required this.title});

  @override
  String getTitle() {
    return title;
  }
}

class _FilterCategoryItem extends FilterItem {
  CategoryNodeModel category;

  _FilterCategoryItem({required this.category});

  @override
  String getTitle() {
    return category.key?.split('>>>').last ?? '';
  }
}

class FilterMain extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FilterMainState();
  }
}

class _FilterMainState extends State<FilterMain> {
  bool argsRetrieved = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!argsRetrieved) {
      argsRetrieved = true;
      //TODO: get filters and currently applied filter
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _createAppBar(),
      body: _consumer(context),
    );
  }

  // TODO: JCA AppBar theme currently overriden, should use the appwide theme
  PreferredSizeWidget _createAppBar() {
    return AppBar(
      leadingWidth: 56,
      centerTitle: true,
      toolbarHeight: 56,
      scrolledUnderElevation: 0, // stop darkening appbar on scroll
      surfaceTintColor: Colors.transparent, // disable Material 3 tint overlay
      backgroundColor: const Color(0xfff7f7f7),
      iconTheme: const IconThemeData(color: Colors.black),
      elevation: 0, // no shadow
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(0.75),
        child: Divider(
          height: 0.75,
          thickness: 0.75,
          color: 'CCA68B'.toColor(),
        ),
      ),
      title: _createTitleText(),
      leading: _createCloseButton(),
      actions: [_createClearButton()],
    );
  }

  Widget _createTitleText() {
    return Text('Filter', style: TextStyle(color: Colors.black));
  }

  Widget _createCloseButton() {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(Icons.close),
    );
  }

  Widget _createClearButton() {
    return TextButton(
      onPressed: () {
        FilterProvider provider = context.read<FilterProvider>();
        provider.clearAllAppliedFilters();
        provider.getProductList(context);
      },
      child: Text('Clear All'),
      style: TextButton.styleFrom(
        foregroundColor: 'CCA68B'.toColor(),
        splashFactory: NoSplash.splashFactory,
        overlayColor: Colors.transparent,
      ),
    );
  }

  Consumer<FilterProvider> _consumer(BuildContext context) {
    return Consumer<FilterProvider>(
      builder: (BuildContext context, FilterProvider provider, Widget? child) {
        return _createBody(provider);
      },
    );
  }

  Widget _createBody(FilterProvider provider) {
    return SafeArea(
      child: Column(
        children: [
          _createFilteredBySection(provider),
          Expanded(child: _createCustomScrollView(provider)),
          _createFilterButtonSection(provider),
        ],
      ),
    );
  }

  Widget _createFilteredBySection(FilterProvider provider) {
    List<FilterItem> filterItems = [];
    filterItems.addAll(
      provider.selectedCategories
          .map<_FilterCategoryItem>((e) => _FilterCategoryItem(category: e))
          .toList(),
    );
    filterItems.addAll(
      provider
          .getFlatAppliedFilters()
          .map((e) => _FilterItem(title: e.value ?? ''))
          .toList(),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: FilterBar<FilterItem>(
        title: 'Filtered by',
        filters: filterItems,
        onTap: (selected, index) {
          if (selected is _FilterItem) {
            provider.removeAppliedFilter(facetFilterValueKey: selected.title);
          } else if (selected is _FilterCategoryItem) {
            provider.removeAppliedFilterCategory(category: selected.category);
          }
          provider.getProductList(context);
        },
      ),
    );
  }

  Widget _createFilterButtonSection(FilterProvider provider) {
    int productCount = provider.productTotal;
    String text = (productCount == 0)
        ? 'See all products'
        : 'See all $productCount products';
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          ProductListProvider productListProvider = context.read<ProductListProvider>();
          provider.appyFilterToProductList(productListProvider);
          Nav.close(context);        
        },
        style: appElevatedButtonStyle,
        child: Text(text),
      ),
    );
  }

  Widget _createCustomScrollView(FilterProvider provider) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _createCategoryTile(provider)),
        _createFilterListView(provider),
      ],
    );
  }

  Widget _createCategoryTile(FilterProvider provider) {
    return _createListTile(provider, FilterKey.categories.displayName);
  }

  Widget _createFilterListView(FilterProvider provider) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final facetFilter = provider.facetFilters[index];
          return _createListTile(
            provider,
            FilterKey.getDisplayNameWithKey(facetFilter.name ?? ''),
          );
        },
        childCount: provider.facetFilters.length,

        addAutomaticKeepAlives: true,
        addRepaintBoundaries: true,
      ),
    );
  }

  Widget _createListTile(FilterProvider provider, String title) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: Column(
        children: [
          ListTile(
            leading: null,
            title: Text(title),
            trailing: Icon(Icons.chevron_right, color: "#CCA68B".toColor()),
            onTap: () {
              print(title);
              if (title == FilterKey.categories.displayName) {
                FilterCategoryArguments args = FilterCategoryArguments(
                  filterProvider: provider,
                  productListProvider: context.read<ProductListProvider>(),
                );
                Nav.toNamed(context, App.filtercategory, arguments: args);
              } else if (title == FilterKey.brandName.displayName) {
                FilterSelectArguments args = FilterSelectArguments(
                  filterKey: FilterKey.brandName,
                  showSearch: false,
                  showSort: true,
                  filterProvider: provider,
                  productListProvider: context.read<ProductListProvider>(),
                );
                Nav.toNamed(context, App.filterselect, arguments: args);
              } else if (title == FilterKey.size.displayName) {
                FilterSelectArguments args = FilterSelectArguments(
                  filterKey: FilterKey.size,
                  showSearch: true,
                  showSort: false,
                  filterProvider: provider,
                  productListProvider: context.read<ProductListProvider>(),
                );
                Nav.toNamed(context, App.filterselect, arguments: args);
              } else if (title == FilterKey.price.displayName) {
                FilterPriceArguments args = FilterPriceArguments(
                  filterProvider: provider,
                  productListProvider: context.read<ProductListProvider>(),
                );
                Nav.toNamed(context, App.filterprice, arguments: args);
              }
            },
          ),
          _createDivider(),
        ],
      ),
    );
  }

  Widget _createDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 16,
      endIndent: 0,
      color: "#F6F6F6".toColor(),
    );
  }
}
