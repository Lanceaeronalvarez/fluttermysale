import 'package:flutter/material.dart';
import 'package:flutter_mysale/architect.dart';
import 'package:flutter_mysale/features/main_app/app.dart';
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
    );
  }

  // TODO: JCA AppBar theme currently overriden, should use the appwide theme
  PreferredSizeWidget _createAppBar() {
    return AppBar(
      leadingWidth: 56,
      centerTitle: true,
      toolbarHeight: 56,
      leading: _parentCategory == null
          ? const SizedBox.shrink()
          : null, //hide back button when on root category
      scrolledUnderElevation: 0, // stop darkening appbar on scroll
      surfaceTintColor: Colors.transparent, // disable Material 3 tint overlay
      backgroundColor: const Color(0xfff7f7f7),
      iconTheme: const IconThemeData(color: Colors.black),
      elevation: 0, // no shadow
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
    return Column(
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
    );
  }

  Widget _createParentButton({required CategoryNodeModel parentCategory}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: ElevatedButton(
        onPressed: () {
          _navigateToSales(parentCategory);
        },
        style:
            ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF54ECFF), // bright cyan
              foregroundColor: Colors.black, // text/icon color
              elevation: 2,
              shadowColor: Colors.black54,
              minimumSize: const Size.fromHeight(
                48,
              ), // full width, fixed height
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ).copyWith(
              // remove tap ripple/overlay
              overlayColor: MaterialStateProperty.all(Colors.transparent),
            ),
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
          } else if (category.hasChild) {
            _navigateToSubcategory(category);
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
    if (category == null) {
      print("Navigating to PLP - search");
    } else {
      print('Navigating to PLP - ${category.name}');
    }
  }

  void _navigateToSales(CategoryNodeModel? category) {
    print('Navigating to Sales - ${category?.name}');
  }
}
