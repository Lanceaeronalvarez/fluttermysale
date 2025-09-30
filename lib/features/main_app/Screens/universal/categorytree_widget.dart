import 'package:flutter/material.dart';
import 'package:flutter_mysale/architect.dart';
import 'package:flutter_mysale/core/helpers/deeplink_helper.dart';
import 'package:flutter_mysale/core/helpers/style_helper.dart';
import 'package:flutter_mysale/features/main_app/app.dart';
import 'package:flutter_mysale/features/main_app/controllers/main/productlist_controller.dart';
import 'package:flutter_mysale/features/main_app/controllers/main/shop_controller.dart';
import 'package:flutter_mysale/features/main_app/models/main/categorynode_model.dart';
import 'package:flutter_mysale/features/main_app/providers/categorytree_provider.dart';
import 'package:flutter_mysale/features/main_app/utils/helpers.dart';
import 'package:provider/provider.dart';

class CategoryTreeWidget extends StatefulWidget {
  const CategoryTreeWidget({Key? key});

  @override
  State<StatefulWidget> createState() {
    return _CategoryTreeWidgetState();
  }
}

class _CategoryTreeWidgetState extends State<CategoryTreeWidget> {
  CategoryNodeModel? _parentCategory;
  bool argsRetrieved = false;

  //TODO: JCA hardcoded image, should not be hardcoded here
  String _logoImagePath = 'assets/images/logo.png';

  //TODO: JCA constants for text
  //TODO: JCA constants for dimensions

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(AssetImage(_logoImagePath), context);
    if (!argsRetrieved) {
      argsRetrieved = true;
      _parentCategory =
          ModalRoute.of(context)?.settings.arguments as CategoryNodeModel?;
      if (_parentCategory == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<CategoryTreeProvider>().getCategoryTree();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: JCA BG color currently overriden, should use the appwide theme

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _createAppBar(),
      body: _consumer(context),
      bottomNavigationBar: BottomBar(),
    );
  }

  // TODO: JCA AppBar theme currently overriden, should use the appwide theme
  PreferredSizeWidget _createAppBar() {
    return AppBar(
      leadingWidth: 56,
      centerTitle: true,
      toolbarHeight: 56,
      leading: _parentCategory == null ? const SizedBox.shrink() : null,
      //hide back button when on root category
      scrolledUnderElevation: 0,
      // stop darkening appbar on scroll
      surfaceTintColor: Colors.transparent,
      // disable Material 3 tint overlay
      backgroundColor: const Color(0xfff7f7f7),
      iconTheme: const IconThemeData(color: Colors.black),
      elevation: 0,
      // no shadow
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(0.75),
        child: Divider(height: 0.75, thickness: 0.75, color: Color(0xFFCCA68B)),
      ),
      title: SizedBox(height: 32, child: _createAppbarLogo()),
      actions: [_createSearchButton()],
    );
  }

  Widget _createAppbarLogo() {
    return FittedBox(
      fit: BoxFit.contain,
      child: GestureDetector(
        onTap: () {
          _navigateToSales(null);
        },
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 28),
          child: Image.asset(_logoImagePath),
        ),
      ),
    );
  }

  Widget _createSearchButton() {
    return IconButton(
      icon: const Icon(Icons.search),
      onPressed: () async {
        _navigateToPLP(null);
      },
    );
  }

  Consumer<CategoryTreeProvider> _consumer(BuildContext context) {
    return Consumer<CategoryTreeProvider>(
      builder: (context, provider, child) {
        final categories = _parentCategory == null
            ? provider.categories
            : (_parentCategory!.children ?? []);

        if (_parentCategory == null &&
            provider.isLoading &&
            provider.categories.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_parentCategory == null &&
            provider.error != null &&
            provider.categories.isEmpty) {
          return Center(child: Text('Error: ${provider.error!}'));
        }

        if (categories.isEmpty) {
          return const Center(child: Text('No Categories'));
        } else {
          return _createCategoryListBody(
            provider: provider,
            categories: categories,
            parentCategory: _parentCategory,
          );
        }
      },
    );
  }

  Widget _createCategoryListBody({
    required CategoryTreeProvider provider,
    required List<CategoryNodeModel> categories,
    required CategoryNodeModel? parentCategory,
  }) {
    return SafeArea(
      child: Column(
        children: [
          if (parentCategory != null)
            _createParentButton(parentCategory: parentCategory),
          Expanded(
            child: _createCategoryListView(
              provider: provider,
              categories: categories,
            ),
          ),
        ],
      ),
    );
  }

  Widget _createParentButton({required CategoryNodeModel parentCategory}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: ElevatedButton(
        onPressed: () {
          if (parentCategory.level == 2) {
            _navigateToPLP(parentCategory);
          } else {
            _navigateToSales(parentCategory);
          }
        },
        style: appElevatedButtonStyle,
        child: Text(
          'Show All ${parentCategory.name}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }

  Widget _createCategoryListView({
    required CategoryTreeProvider provider,
    required List<CategoryNodeModel> categories,
  }) {
    return ListView.separated(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _createCategoryTile(
          provider: provider,
          category: category,
          index: index,
        );
      },
      separatorBuilder: (context, index) {
        return const Divider(
          height: 1,
          thickness: 1,
          indent: 16,
          endIndent: 0,
          color: Color.fromRGBO(246, 246, 246, 1),
        );
      },
    );
  }

  Widget _createCategoryTile({
    required CategoryTreeProvider provider,
    required CategoryNodeModel category,
    required int index,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: ListTile(
        leading: null,
        title: Text(category.name ?? ""),
        textColor: category.textColor?.toColor(),
        trailing: category.hasChild
            ? const Icon(Icons.chevron_right, color: Color(0xFFCCA68B))
            : null,
        onTap: () {
          print('$index ${category.name}');

          if (category.getNodeType() == NodeType.clearance &&
              (provider.clearanceUrl ?? "").isNotEmpty) {
            print('$index ${provider.clearanceUrl}');
            DeepLinkHelper.processDeeplinkUri(
              context,
              Uri.parse(provider.clearanceUrl!),
            );
          } else if (category.hasChild) {
            _navigateToSubcategory(category);
          } else if (category.level == 0) {
            _navigateToSales(category);
          } else {
            _navigateToPLP(category);
          }
        },
      ),
    );
  }

  void _navigateToSubcategory(CategoryNodeModel category) {
    print('Navigating to Subcategory - ${category.name}');
    Nav.toNamed(context, App.categoryTree, arguments: category);
  }

  void _navigateToPLP(CategoryNodeModel? category) {
    ProductListArguments args;
    if (category == null) {
      print("Navigating to PLP - search");
      args = ProductListArguments(
        saleId: '',
        appliedCategories: [],
        appliedFilters: [],
        sort: null,
        originCategory: null,
      );
    } else {
      print('Navigating to PLP - ${category.name}');
      args = ProductListArguments(
        saleId: '',
        appliedCategories: [category],
        appliedFilters: [],
        sort: null,
        originCategory: category,
      );
    }
    Nav.toNamed(context, App.productList, arguments: args);
  }

  void _navigateToSales(CategoryNodeModel? category) {
    print('Navigating to Sales - ${category?.name}');
    String? categoryId = category?.id;
    if (categoryId == null) {
      Nav.to(context, App.home);
    } else {
      ShopArguments args = ShopArguments(category: categoryId);
      Nav.toNamed(context, App.home, arguments: args);
    }
  }
}
