import 'package:flutter/material.dart';
import 'package:flutter_mysale/core/helpers/useragent_helper.dart';
import 'package:flutter_mysale/features/main_app/models/main/productsort_model.dart';
import 'package:flutter_mysale/features/main_app/providers/productsort_provider.dart';
import 'package:flutter_mysale/features/main_app/utils/helpers.dart';
import 'package:provider/provider.dart';

class ProductSort extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductSortState();
  }
}

class _ProductSortState extends State<ProductSort> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      UserAgentHelper userAgentHelper = UserAgentHelper(context);
      context.read<ProductSortProvider>().fetchSortItems(userAgentHelper);
    });
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
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(0.75),
        child: Divider(height: 0.75, thickness: 0.75, color: Color(0xFFCCA68B)),
      ),
      title: _createTitleText(),
      leading: _createCloseButton(),
    );
  }

  Widget _createTitleText() {
    return Text('Sort', style: TextStyle(color: Colors.black));
  }

  Widget _createCloseButton() {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(Icons.close),
    );
  }

  Consumer<ProductSortProvider> _consumer(BuildContext context) {
    return Consumer<ProductSortProvider>(
      builder: (context, provider, child) {
        return _createBody(provider);
      },
    );
  }

  Widget _createBody(ProductSortProvider provider) {
    return SafeArea(
      child: ListView.separated(
        itemCount: provider.sortItems.length,
        itemBuilder: (context, index) {
          final title = provider.sortItems[index];
          return _createListTile(provider, title);
        },
        separatorBuilder: (context, index) {
          return _createDivider();
        },
      ),
    );
  }

  Widget _createListTile(
    ProductSortProvider provider,
    ProductSortModel sortItem,
  ) {
    String selectedKey = provider.selectedSortItem?.key ?? '';
    String key = sortItem.key ?? '';
    bool isSelected =
        selectedKey.isNotEmpty && key.isNotEmpty && selectedKey == key;

    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: ListTile(
        leading: null,
        title: Text((sortItem.title ?? '').toTitleCase()),
        trailing: isSelected ? const Icon(Icons.check) : null,
        onTap: () {
          provider.setSelectedSortItem(sortItem);
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
