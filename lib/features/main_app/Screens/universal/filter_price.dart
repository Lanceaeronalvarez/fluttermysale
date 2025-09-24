import 'package:flutter/material.dart';
import 'package:flutter_mysale/core/classes/route_manager.dart';
import 'package:flutter_mysale/core/helpers/style_helper.dart';
import 'package:flutter_mysale/features/main_app/app.dart';
import 'package:flutter_mysale/features/main_app/providers/filter_provider.dart';
import 'package:flutter_mysale/features/main_app/providers/productlist_provider.dart';
import 'package:flutter_mysale/features/main_app/utils/helpers.dart';
import 'package:flutter_mysale/features/main_app/widgets/price_range_slider.dart';
import 'package:provider/provider.dart';

class FilterPrice extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FilterPriceState();
  }
}

class _FilterPriceState extends State<FilterPrice> {
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
    return Text('Price', style: TextStyle(color: Colors.black));
  }

  Widget _createCloseButton() {
    return BackButton(
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  Widget _createClearButton() {
    return TextButton(
      onPressed: () {
        FilterProvider provider = context.read<FilterProvider>();
        provider.clearAppliedFilter(FilterKey.price.key);
        provider.getProductList(context);
      },
      child: Text('Clear'),
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
          _createPriceRange(provider),
          Expanded(child: SizedBox()),
          _createFilterButtonSection(provider),
        ],
      ),
    );
  }

  Widget _createPriceRange(FilterProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: PriceRangeSlider(
          title: 'Price (${provider.currency})',
          minValue: provider.minPrice,
          maxValue: provider.maxPrice,
          currentMinValue: provider.currentMinPrice,
          currentMaxValue: provider.currentMaxPrice,
          tooltipOffset: -4,
          mergeGap: 16,
          onDrag: (currentMinPrice, currentMaxPrice) {
            provider.updateAppliedFilterPrice(currentMinPrice, currentMaxPrice);
          },
          onDragEnd: (currentMinPrice, currentMaxPrice) {
            provider.updateAppliedFilterPrice(currentMinPrice, currentMaxPrice);
            provider.getProductList(context);
          },
        ),
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
          print('Filter Price');
          ProductListProvider productListProvider = context
              .read<ProductListProvider>();
          provider.appyFilterToProductList(productListProvider);
          Nav.closeUntil(context, App.productList);
        },
        style: appElevatedButtonStyle,
        child: Text(text),
      ),
    );
  }
}
