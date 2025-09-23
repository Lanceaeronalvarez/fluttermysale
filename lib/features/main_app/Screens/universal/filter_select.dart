import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mysale/core/helpers/style_helper.dart';
import 'package:flutter_mysale/features/main_app/models/main/facetfilter_model.dart';
import 'package:flutter_mysale/features/main_app/providers/filter_provider.dart';
import 'package:flutter_mysale/features/main_app/utils/helpers.dart';
import 'package:provider/provider.dart';

enum _SortKey { name, totalItems }

enum _SortDirection { asc, desc }

typedef _SortState = ({_SortKey key, _SortDirection dir});

class FilterSelect extends StatefulWidget {
  final bool showSearch;
  final bool showSort;
  final FilterKey filterKey;

  FilterSelect({
    required this.showSearch,
    required this.showSort,
    required this.filterKey,
  });

  @override
  State<StatefulWidget> createState() {
    return _FilterSelectState();
  }
}

class _FilterSelectState extends State<FilterSelect> {
  final sortNotifier = ValueNotifier<_SortState>((
    key: _SortKey.name,
    dir: _SortDirection.desc,
  ));

  //TODO: JCA - move path somewhere (config maybe)
  final String _pathCheckbox = 'assets/images/filterCheckbox.png';
  final String _pathCheckboxChecked = 'assets/images/filterCheckboxChecked.png';
  final String _pathCheckboxPartial = 'assets/images/filterCheckboxPartial.png';

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      FilterProvider p = context.read<FilterProvider>();
      String key = widget.filterKey.key;
      if (widget.showSort) {
        p.sortDisplayedFacetFilterValues(
          filterKey: key,
          ascending: false,
          byName: true,
          callNotify: true,
        );
      } else {
        p.resetDisplayedFacetFilterValues(filterKey: key, callNotify: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _createAppBar(),
      body: _createBody(),
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
    return Text(
      widget.filterKey.displayName,
      style: const TextStyle(color: Colors.black),
    );
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
        provider.clearAppliedFilter(widget.filterKey.key);
        provider.getProductList(context);
      },
      style: TextButton.styleFrom(
        foregroundColor: 'CCA68B'.toColor(),
        splashFactory: NoSplash.splashFactory,
        overlayColor: Colors.transparent,
      ),
      child: const Text('Clear'),
    );
  }

  Widget _createBody() {
    return SafeArea(
      child: Column(
        children: [
          if (widget.showSearch) _createSearchBar(),
          if (widget.showSort) _createSortContainer(),
          Expanded(child: _createFilterListView()),
          _createFilterButtonSection(),
        ],
      ),
    );
  }

  Widget _createSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: CupertinoSearchTextField(
        placeholder: 'Search for a ${widget.filterKey.displayName}',
        backgroundColor: CupertinoColors.systemGrey5,
        padding: const EdgeInsets.all(8),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        prefixIcon: const Icon(Icons.search),
        suffixIcon: const Icon(Icons.clear),
        onChanged: (text) {
          print('onChanged $text');
          context.read<FilterProvider>().searchDisplayedFacetFilterValues(
            filterKey: widget.filterKey.key,
            searchTerm: text,
          );
        },
        onSubmitted: (text) {
          print('onSubmitted $text');
          context.read<FilterProvider>().searchDisplayedFacetFilterValues(
            filterKey: widget.filterKey.key,
            searchTerm: text,
          );
        },
      ),
    );
  }

  Widget _createSortContainer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _createSortNotifier(),
    );
  }

  Widget _createSortNotifier() {
    return ValueListenableBuilder(
      valueListenable: sortNotifier,
      builder: (context, value, child) {
        return Row(
          children: [
            Expanded(
              child: _createSortButton(
                widget.filterKey.displayName,
                _SortKey.name,
                value,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _createSortButton(
                'Total Items',
                _SortKey.totalItems,
                value,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _createSortButton(String title, _SortKey sortkey, _SortState state) {
    bool isSelected = state.key == sortkey;
    String t = title;
    if (sortkey == _SortKey.name) {
      if (isSelected) {
        t = '${t}s ${state.dir == _SortDirection.desc ? 'A-Z' : 'Z-A'}';
      } else {
        t = '${t}s A-Z';
      }
    }

    IconData icon = (isSelected)
        ? (state.dir == _SortDirection.desc
              ? Icons.arrow_downward
              : Icons.arrow_upward)
        : Icons.swap_vert;
    return OutlinedButton.icon(
      onPressed: () {
        _SortDirection dir = (state.dir == _SortDirection.asc)
            ? _SortDirection.desc
            : _SortDirection.asc;
        sortNotifier.value = (key: sortkey, dir: dir);
        bool ascending = dir == _SortDirection.asc;
        bool byName = sortkey == _SortKey.name;
        context.read<FilterProvider>().sortDisplayedFacetFilterValues(
          filterKey: widget.filterKey.key,
          ascending: ascending,
          byName: byName,
        );
      },
      icon: Icon(icon),
      label: Text(t),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
        side: BorderSide(color: Colors.brown.shade200),
        backgroundColor: isSelected ? Colors.pink.shade50 : Colors.transparent,
        foregroundColor: Colors.black,
        fixedSize: const Size.fromHeight(50),
        splashFactory: NoSplash.splashFactory,
        overlayColor: Colors.transparent,
      ),
    );
  }

  Widget _createFilterListView() {
    return Consumer<FilterProvider>(
      builder: (BuildContext ctx, FilterProvider provider, Widget? child) {
        List<FacetFilterValueModel> sizes = provider.displayedFacetFilterValues;
        return ListView.separated(
          itemBuilder: (context, index) {
            return _createListTile(provider, sizes[index]);
          },
          separatorBuilder: (context, index) {
            return _createDivider();
          },
          itemCount: sizes.length,
        );
      },
    );
  }

  Widget _createListTile(
    FilterProvider provider,
    FacetFilterValueModel facetFilterValue,
  ) {
    bool showCount = (facetFilterValue.count ?? 0) > 0;
    bool isSelected = provider.isFacetFilterValueSelected(
      filterKey: widget.filterKey.key,
      facetFilterValue: facetFilterValue,
    );
    Image image = (isSelected)
        ? Image.asset(_pathCheckboxChecked)
        : Image.asset(_pathCheckbox);
    TextStyle style = TextStyle(fontSize: 16, fontWeight: FontWeight.normal);
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: ListTile(
        leading: image,
        title: Text(facetFilterValue.value ?? '', style: style),
        trailing: (showCount)
            ? Text('(${facetFilterValue.count ?? 0})', style: style)
            : null,
        onTap: () {
          print(facetFilterValue.value);
          print(facetFilterValue.count);
          provider.addOrRemoveAppliedFilter(
            widget.filterKey.key,
            facetFilterValue,
          );
          provider.getProductList(context);
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

  Widget _createFilterButtonSection() {
    return Consumer<FilterProvider>(
      builder: (BuildContext ctx, FilterProvider provider, Widget? child) {
        int productCount = provider.productTotal;
        String text = (productCount == 0)
            ? 'See all products'
            : 'See all $productCount products';
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              print('Filter Price');
            },
            style: appElevatedButtonStyle,
            child: Text(text),
          ),
        );
      },
    );
  }
}
