import 'package:flutter/material.dart';
import 'package:flutter_mysale/core/helpers/style_helper.dart';
import 'package:flutter_mysale/features/main_app/models/main/filter_category_model.dart';
import 'package:flutter_mysale/features/main_app/providers/categorytree_provider.dart';
import 'package:flutter_mysale/features/main_app/providers/filter_provider.dart';
import 'package:flutter_mysale/features/main_app/utils/helpers.dart';
import 'package:provider/provider.dart';

typedef OnCategoryTap(FilterCategoryModel cw);
typedef OnCategoryCheckboxTap(FilterCategoryModel cw);

class FilterCategory extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FilterCategoryState();
  }
}

class _FilterCategoryState extends State<FilterCategory> {
  bool argsRetrieved = false;

  //TEMP ONLY
  late CategoryTreeProvider categoryTreeProvider;

  //TODO: JCA - move path somewhere (config maybe)
  String _pathCheckbox = 'assets/images/filterCheckbox.png';
  String _pathCheckboxChecked = 'assets/images/filterCheckboxChecked.png';
  String _pathCheckboxPartial = 'assets/images/filterCheckboxPartial.png';

  Duration animationDuration = const Duration(milliseconds: 200);

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
    //TODO: JCA - temp only, should be removed
    categoryTreeProvider = CategoryTreeProvider(context: context);
    categoryTreeProvider.getCategoryTree(
      completion: (categories) {
        context.read<FilterProvider>().setCategories(categories);
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _createAppBar(),
      body: _createBody(context),
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
    return Text('Category', style: TextStyle(color: Colors.black));
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
        context.read<FilterProvider>().clearAllSelecteCategories();
      },
      child: Text('Clear'),
      style: TextButton.styleFrom(foregroundColor: 'CCA68B'.toColor()),
    );
  }

  Widget _createBody(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(child: _createCategoryListView(context)),
          _createFilterButtonSection(),
        ],
      ),
    );
  }

  Widget _createCategoryListView(BuildContext context) {
    return Consumer<FilterProvider>(
      builder: (BuildContext ctx, FilterProvider provider, Widget? child) {
        return _createCategoryTree(
          provider.filterCategories,
          onRowTap: (FilterCategoryModel filterCategory) {
            if (filterCategory.hasChild) {
              _handleExpandCollapseCategory(filterCategory, provider);
            } else {
              _handleUpdateCheckboxStatus(filterCategory, provider);
            }
          },
          onCheckboxTap: (FilterCategoryModel filterCategory) {
            _handleUpdateCheckboxStatus(filterCategory, provider);
          },
          provider: provider,
        );
      },
    );
  }

  void _handleExpandCollapseCategory(
    FilterCategoryModel filterCategory,
    FilterProvider provider,
  ) {
    provider.toggleIsExpanded(filterCategory);
  }

  void _handleUpdateCheckboxStatus(
    FilterCategoryModel filterCategory,
    FilterProvider provider,
  ) {
    print('toggle - ${filterCategory.category.name}');

    FilterCategoryStatus status = filterCategory.status;
    bool isSelected = status == FilterCategoryStatus.checked;
    provider.setStatusOfLeafCategories(filterCategory, !isSelected);
    provider.generateSelectedCategories();
  }

  Widget _createCategoryTree(
    List<FilterCategoryModel> rootCategories, {
    required OnCategoryTap onRowTap,
    required OnCategoryCheckboxTap onCheckboxTap,
    required FilterProvider provider,
  }) {
    return ListView(
      children: [
        for (FilterCategoryModel rootCategory in rootCategories)
          _createCategoryNode(
            rootCategory,
            onRowTap: onRowTap,
            onCheckboxTap: onCheckboxTap,
            provider: provider,
          ),
      ],
    );
  }

  Widget _createCategoryNode(
    FilterCategoryModel filterCategory, {
    required OnCategoryTap onRowTap,
    required OnCategoryCheckboxTap onCheckboxTap,
    required FilterProvider provider,
  }) {
    return Column(
      key: ValueKey(filterCategory.category.id),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _createListTile(filterCategory, onRowTap, onCheckboxTap, provider),
        AnimatedSize(
          duration: animationDuration,
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: (filterCategory.hasChild && filterCategory.isExpanded)
              ? Column(
                  children: [
                    for (FilterCategoryModel filterChild in filterCategory.filterChildren)
                      _createCategoryNode(
                        filterChild,
                        onRowTap: onRowTap,
                        onCheckboxTap: onCheckboxTap,
                        provider: provider,
                      ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _createListTile(
    FilterCategoryModel filterCategory,
    OnCategoryTap onRowTap,
    OnCategoryCheckboxTap onCheckboxTap,
    FilterProvider provider,
  ) {
    double leftIndention = 16 * filterCategory.depth.toDouble();

    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(leftIndention, 0, 0, 0),
      leading: _createCheckbox(filterCategory, onCheckboxTap, provider),
      title: Text(
        filterCategory.category.name ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      trailing: _createChevron(filterCategory, animationDuration),
      onTap: () {
        onRowTap.call(filterCategory);
      },
    );
  }

  Widget _createChevron(FilterCategoryModel filterCategory, Duration animationDuration) {
    return filterCategory.hasChild
        ? AnimatedRotation(
            turns: filterCategory.isExpanded ? 0.5 : 0,
            duration: animationDuration,
            child: Icon(Icons.expand_more, color: "#CCA68B".toColor()),
          )
        : const SizedBox.shrink();
  }

  Widget _createCheckbox(
    FilterCategoryModel filterCategory,
    OnCategoryCheckboxTap onCheckboxTap,
    FilterProvider provider,
  ) {

    String checkboxPath = '';
    switch (filterCategory.status) {
      case FilterCategoryStatus.unchecked:
        checkboxPath = _pathCheckbox;
        break;
      case FilterCategoryStatus.checked:
        checkboxPath = _pathCheckboxChecked;
        break;
      case FilterCategoryStatus.partial:
        checkboxPath = _pathCheckboxPartial;
        break;
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onCheckboxTap(filterCategory),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Image.asset(checkboxPath),
      ),
    );
  }

  Widget _createDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 16,
      endIndent: 0,
      color: Color.fromRGBO(246, 246, 246, 1),
    );
  }

  Widget _createFilterButtonSection() {
    return Consumer<FilterProvider>(
      builder: (BuildContext context, FilterProvider provider, Widget? child) {
        int productCount = provider.productCount;
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
