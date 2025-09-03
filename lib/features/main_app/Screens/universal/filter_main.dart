import 'package:flutter/material.dart';
import 'package:flutter_mysale/core/classes/route_manager.dart';
import 'package:flutter_mysale/core/core.dart';
import 'package:flutter_mysale/core/helpers/style_helper.dart';
import 'package:flutter_mysale/features/main_app/app.dart';
import 'package:flutter_mysale/features/main_app/providers/filter_provider.dart';
import 'package:flutter_mysale/features/main_app/utils/helpers.dart';
import 'package:flutter_mysale/features/main_app/widgets/filter_bar.dart';
import 'package:provider/provider.dart';

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
      onPressed: () {},
      child: Text('Clear All'),
      style: TextButton.styleFrom(foregroundColor: 'CCA68B'.toColor()),
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
          Expanded(child: _createFilterListView(provider)),
          _createFilterButtonSection(provider),
        ],
      ),
    );
  }

  Widget _createFilteredBySection(FilterProvider provider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: FilterBar<FilterWrapperTemp>(
        title: 'Filtered by',
        filters: provider.selectedFilters,
        onTap: (selected, index) {
          print(selected.title);
          print(index);
        },
      ),
    );
  }

  Widget _createFilterButtonSection(FilterProvider provider) {
    int productCount = provider.productCount;
    String text = (productCount == 0)
        ? 'See all products'
        : 'See all $productCount products';
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          print('Filter');
        },
        style: appElevatedButtonStyle,
        child: Text(text),
      ),
    );
  }

  Widget _createFilterListView(FilterProvider provider) {
    return ListView.separated(
      itemBuilder: (context, index) {
        String title = provider.mainFilters[index];
        return _createListTile(provider, title);
      },
      separatorBuilder: (context, index) {
        return _createDivider();
      },
      itemCount: provider.mainFilters.length,
    );
  }

  Widget _createListTile(FilterProvider provider, String title) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: ListTile(
        leading: null,
        title: Text(title),
        trailing: Icon(Icons.chevron_right, color: "#CCA68B".toColor()),
        onTap: () {
          print(title);
          if (title == 'Brand') {
            Nav.toNamed(
              context,
              App.filterselect,
              arguments: (title: 'Brand', showSearch: false, showSort: true),
            );
          } else if (title == 'Size') {
            Nav.toNamed(
              context,
              App.filterselect,
              arguments: (title: 'Size', showSearch: true, showSort: false),
            );
          } else if (title == 'Price') {
            Nav.toNamed(context, App.filterprice);
          }
        },
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
