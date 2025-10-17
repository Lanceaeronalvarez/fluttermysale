import 'package:flutter/material.dart';
import 'package:flutter_mysale/core/widgets/bottom_bar.dart';
import 'package:flutter_mysale/features/main_app/controllers/main/product_details_controller.dart';
import 'package:flutter_mysale/features/main_app/models/main/productdetail_model.dart';
import 'package:flutter_mysale/features/main_app/utils/helpers.dart';
import 'package:provider/provider.dart';

import '../../providers/productdetail_provider.dart';
import '../../providers/recentlyviewed_provider.dart';
import '../../providers/trendingbrands_provider.dart';
import '../../widgets/widget.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductDetailArguments args;

  const ProductDetailPage({super.key, required this.args});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showFloatingBar = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ProductDetailProvider>();

      if (widget.args.product != null) {
        provider.preloadData(widget.args.product!);
      }

      provider.getProductDetail(
        seoIdentifier: widget.args.product?.seoIdentifier ?? '',
        saleId: widget.args.saleId,
      );

      _addAndFetchRecentlyViewed();
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    const threshold = 400.0;
    final shouldShow = _scrollController.offset > threshold;
    if (shouldShow != _showFloatingBar) {
      setState(() => _showFloatingBar = shouldShow);
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _createAppBar(),
      backgroundColor: Colors.white,
      body: Consumer<ProductDetailProvider>(
        builder: (context, provider, _) {
          final preloadedProduct = widget.args.product;
          final productDetail = provider.product;

          if (preloadedProduct == null && productDetail == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final displayProduct =
              productDetail ??
              ProductDetailMapper.fromProductItem(preloadedProduct!);

          return Stack(
            children: [
              _buildScrollView(displayProduct),
              if (_showFloatingBar) _buildFloatingBar(),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomBar(),
    );
  }

  Widget _buildScrollView(ProductDetail product) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverToBoxAdapter(child: ImageGalleryWidget(images: product.images)),
        SliverToBoxAdapter(child: ProductInfoSection(product: product)),
        SliverToBoxAdapter(child: _buildSizeSection(product)),
        const SliverToBoxAdapter(
          child: ShippingAndDeliveryWidget(appName: '', isFreeDelivery: false),
        ),
        SliverToBoxAdapter(
          child: CollapsibleDescription(htmlText: product.description ?? ""),
        ),
        SliverToBoxAdapter(child: _buildPaymentSection()),
        const SliverToBoxAdapter(child: ProductDetailsPageReturnsWidget()),
        SliverToBoxAdapter(child: _buildTrendingBrands()),
        SliverToBoxAdapter(child: _buildRecentlyViewed()),
        const SliverToBoxAdapter(child: SizedBox(height: 120)),
      ],
    );
  }

  Widget _buildFloatingBar() => Positioned(
    left: 0,
    right: 0,
    bottom: 0,
    child: FloatingButton(
      onAddToCart: () => debugPrint("Add to cart tapped"),
      onBuyNow: () => debugPrint("Buy now tapped"),
    ),
  );

  Widget _buildSizeSection(ProductDetail product) {
    final List<SkuVariant> skuVariants = product.skuVariants ?? [];

    final List<ProductSizeItem> sizeItems = skuVariants
        .where((v) => v.attributes?.size != null)
        .map<ProductSizeItem>(
          (v) => ProductSizeItem(
            v.attributes!.size!,
            isSoldOut: v.isSoldOut ?? false,
          ),
        )
        .toList();

    if (sizeItems.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text("No size options available."),
      );
    }

    return SizeSelectionWidget<ProductSizeItem>(
      sizesList: sizeItems,
      onTap: (ProductSizeItem p0, int p1) {
        // TODO: Handle size selection
        debugPrint(
          "Selected size: ${p0.getTitle()}, Sold out: ${p0.isSoldOut}",
        );
      },
    );
  }

  Widget _buildPaymentSection() {
    return Consumer<ProductDetailProvider>(
      builder: (_, provider, __) => ProductPaymentWidget(
        isAfterpayEnabled: provider.isAfterpayEnabled,
        isKlarnaEnabled: false,
        isLPayEnabled: false,
        isGenoaPayEnabled: false,
      ),
    );
  }

  Widget _buildTrendingBrands() {
    return Consumer<TrendingBrandsProvider>(
      builder: (_, provider, __) {
        final brands = provider.trendingBrands;
        if (brands == null || brands.isEmpty) return const SizedBox.shrink();

        debugPrint("👉 Trending brands count: ${brands.length}");
        return TrendingBrandsWidget(brands: brands);
      },
    );
  }

  Widget _buildRecentlyViewed() {
    return Consumer<RecentlyViewedProvider>(
      builder: (_, provider, __) {
        if (provider.recentlyViewed.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text("No recently viewed items."),
            ),
          );
        }

        return ProductCarousel(
          title: "RECENTLY VIEWED",
          products: provider.recentlyViewed,
        );
      },
    );
  }

  PreferredSizeWidget _createAppBar() {
    return AppBar(
      leadingWidth: 56,
      centerTitle: true,
      toolbarHeight: 56,
      scrolledUnderElevation: 0,
      backgroundColor: const Color(0xfff7f7f7),
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Colors.black),
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0.75),
        child: Divider(
          height: 0.75,
          thickness: 0.75,
          color: 'CCA68B'.toColor(),
        ),
      ),
      title: Text(
        widget.args.brandName,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  void getTrendingBrands(String categoryId) {
    context.read<TrendingBrandsProvider>().getTrendingBrands();
  }

  void getProductDetails() {
    context.read<ProductDetailProvider>().getProductDetail(
      seoIdentifier: widget.args.seo ?? '',
      saleId: widget.args.saleId,
      includeSkuVariants: true,
    );
  }

  Future<void> _addAndFetchRecentlyViewed() async {
    final provider = context.read<RecentlyViewedProvider>();

    await provider.addToRecentlyViewed(
      productId: widget.args.productId,
      masterSkuId: widget.args.masterSkuId,
    );

    await provider.fetchRecentlyViewed();
  }
}

class ProductSizeItem extends SizeItem {
  final String title;
  final bool isSoldOut;

  ProductSizeItem(this.title, {this.isSoldOut = false});

  @override
  String getTitle() => title;
}
