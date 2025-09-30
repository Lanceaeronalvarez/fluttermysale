import 'package:flutter/material.dart';
import 'package:flutter_mysale/core/helpers/style_helper.dart';
import 'package:flutter_mysale/features/main_app/providers/checkout_provider.dart';
import 'package:flutter_mysale/features/main_app/widgets/cart_product_row.dart';
import 'package:provider/provider.dart';

enum CheckoutCartMode { addToCart, checkoutCart, summaryOnly }

class _CheckoutCartStyle {
  Color sectionColor;
  bool showAppBar;
  bool showProductListHeader;
  bool showProductList;
  bool productRowPriceAtBottom;
  bool productRowShowDivider;
  bool showContinueToContact;
  bool addDividerBetweenProductAndSummary;
  bool showAddVoucher;
  bool showOrderSummarySectionTitle;
  bool showOrderSummarySection;
  bool showContinueToCheckout;

  double hSpacing = 16;
  double vSpacing = 16;

  TextStyle textRegular = TextStyle(fontSize: 14, fontWeight: FontWeight.w400);
  TextStyle textBold = TextStyle(fontSize: 16, fontWeight: FontWeight.w800);

  _CheckoutCartStyle._({
    required this.sectionColor,
    required this.showAppBar,
    required this.showProductListHeader,
    required this.showProductList,
    required this.productRowPriceAtBottom,
    required this.productRowShowDivider,
    required this.showContinueToContact,
    required this.addDividerBetweenProductAndSummary,
    required this.showAddVoucher,
    required this.showOrderSummarySectionTitle,
    required this.showOrderSummarySection,
    required this.showContinueToCheckout,
  });

  factory _CheckoutCartStyle.defaultInstance({bool show = false}) {
    return _CheckoutCartStyle._(
      sectionColor: Colors.white,
      showAppBar: show,
      showProductListHeader: show,
      showProductList: show,
      productRowPriceAtBottom: show,
      productRowShowDivider: show,
      showContinueToContact: show,
      addDividerBetweenProductAndSummary: show,
      showAddVoucher: show,
      showOrderSummarySectionTitle: show,
      showOrderSummarySection: show,
      showContinueToCheckout: show,
    );
  }

  factory _CheckoutCartStyle.fromCheckoutCartMode(CheckoutCartMode mode) {
    switch (mode) {
      case CheckoutCartMode.addToCart:
        return _CheckoutCartStyle._(
          sectionColor: Colors.white,
          showAppBar: true,
          showProductListHeader: false,
          showProductList: true,
          productRowPriceAtBottom: false,
          productRowShowDivider: true,
          showContinueToContact: false,
          addDividerBetweenProductAndSummary: false,
          showAddVoucher: false,
          showOrderSummarySectionTitle: false,
          showOrderSummarySection: true,
          showContinueToCheckout: true,
        );
      case CheckoutCartMode.checkoutCart:
        return _CheckoutCartStyle._(
          sectionColor: Color(0xFFEFEFEF),
          showAppBar: false,
          showProductListHeader: true,
          showProductList: true,
          productRowPriceAtBottom: true,
          productRowShowDivider: false,
          showContinueToContact: true,
          addDividerBetweenProductAndSummary: true,
          showAddVoucher: true,
          showOrderSummarySectionTitle: true,
          showOrderSummarySection: true,
          showContinueToCheckout: false,
        );
      case CheckoutCartMode.summaryOnly:
        return _CheckoutCartStyle._(
          sectionColor: Color(0xFFEFEFEF),
          showAppBar: false,
          showProductListHeader: false,
          showProductList: false,
          productRowPriceAtBottom: true,
          productRowShowDivider: false,
          showContinueToContact: false,
          addDividerBetweenProductAndSummary: false,
          showAddVoucher: false,
          showOrderSummarySectionTitle: true,
          showOrderSummarySection: true,
          showContinueToCheckout: false,
        );
    }
  }
}

class CheckoutCart extends StatefulWidget {
  final List<CartProductWrapper> productList = CartProductWrapper.tempList();

  final CheckoutCartMode mode;

  CheckoutCart({this.mode = CheckoutCartMode.addToCart});

  @override
  State<StatefulWidget> createState() {
    return _CheckoutCart();
  }
}

class _CheckoutCart extends State<CheckoutCart> {
  _CheckoutCartStyle _style = _CheckoutCartStyle.defaultInstance(show: false);

  @override
  void initState() {
    super.initState();

    _style = _CheckoutCartStyle.fromCheckoutCartMode(widget.mode);
    //widget._style = _CheckoutCartStyle.defaultInstance(show: true);
    Future.microtask(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: (_style.showAppBar) ? _createAppBar() : null,
      body: _createBody(context),
    );
  }

  // TODO: JCA AppBar theme currently overriden, should use the appwide theme
  PreferredSizeWidget _createAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      leadingWidth: 0,
      centerTitle: false,
      toolbarHeight: 56,
      leading: const SizedBox.shrink(),
      titleSpacing: 16,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black),
      elevation: 0,
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(0.75),
        child: Divider(height: 0.75, thickness: 0.75, color: Colors.grey),
      ),
      title: const Text(
        'SHOPPING CART',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
        ),
      ),
      actions: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.pop(context);
          },
          child: const Padding(
            padding: EdgeInsets.all(12),
            child: Icon(Icons.close, color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _createTitleText() {
    return Text('Cart', style: TextStyle(color: Colors.black));
  }

  Widget _createCloseButton() {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(Icons.close),
    );
  }

  Widget _createBody(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _createCustomScrollView(),
          if (_style.showContinueToCheckout) _createCheckoutButtonSection(),
        ],
      ),
    );
  }

  Widget _createCustomScrollView() {
    return Consumer<CheckoutProvider>(
      builder: (ctx, provider, _) {
        return Expanded(
          child: CustomScrollView(
            slivers: [
              if (_style.showProductListHeader)
                SliverToBoxAdapter(child: _createHeader('Order Summary')),
              if (_style.showProductList) _createProductList(),
              if (_style.showContinueToContact)
                SliverToBoxAdapter(child: _createContactButtonSection()),
              if (_style.addDividerBetweenProductAndSummary)
                SliverToBoxAdapter(child: SizedBox(height: 16)),
              if (_style.showOrderSummarySection)
                SliverToBoxAdapter(child: _createSummarySection()),
            ],
          ),
        );
      },
    );
  }

  Widget _createHeader(String title) {
    return Container(
      color: _style.sectionColor,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: _style.vSpacing,
          vertical: _style.hSpacing,
        ),
        child: Text(title, style: _style.textBold),
      ),
    );
  }

  Widget _createButton({
    required String title,
    required VoidCallback onTap,
    double? leftSpacing = null,
    double? topSpacing = null,
    double? rightSpacing = null,
    double? bottomSpacing = null,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        leftSpacing ?? _style.hSpacing,
        topSpacing ?? _style.vSpacing,
        rightSpacing ?? _style.hSpacing,
        bottomSpacing ?? _style.vSpacing,
      ),
      child: ElevatedButton(
        onPressed: () {
          onTap.call();
        },
        style: appElevatedButtonStyle,
        child: Text(title),
      ),
    );
  }

  Widget _createProductList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final p = widget.productList[index];
          return CartProductRow(
            item: p,
            sectionColor: _style.sectionColor,
            showPriceAtBottom: _style.productRowPriceAtBottom,
            showDivider: _style.productRowShowDivider,
            onTap: (_) {},
            onPlus: (_) {},
            onMinus: (_) {},
            onRemove: (_) {},
          );
        },
        childCount: widget.productList.length,

        addAutomaticKeepAlives: true,
        addRepaintBoundaries: true,
      ),
    );
  }

  Widget _createSummarySection() {
    double hSpacing = _style.hSpacing;
    double vSpacing = _style.vSpacing;
    return Container(
      color: _style.sectionColor,
      child: Padding(
        padding: EdgeInsets.fromLTRB(hSpacing, vSpacing, hSpacing, vSpacing),
        child: Column(
          children: [
            if (_style.showAddVoucher) _createAddVoucherButton(),
            if (_style.showOrderSummarySectionTitle)
              _createSummaryRow('Order Summary', '', _style.textBold, 8),
            _createSummaryRow(
              'Subtotal (2 items)',
              '\$196.00',
              _style.textRegular,
              16,
            ),
            _createSummaryRow('Total', '\$196.00', _style.textBold, 4),
            _createSummaryRow('', 'Including GST', _style.textRegular, 0),
          ],
        ),
      ),
    );
  }

  Widget _createSummaryRow(
    String title,
    String value,
    TextStyle style,
    double bottomPadding,
  ) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, bottomPadding),
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: style),
        ],
      ),
    );
  }

  Widget _createContactButtonSection() {
    return Container(
      color: _style.sectionColor,
      child: _createButton(
        title: 'CONTINUE TO CHECKOUT',
        onTap: () {
          print('continue to contact');
        },
      ),
    );
  }

  Widget _createCheckoutButtonSection() {
    return Column(
      children: [
        Divider(height: 1, color: Colors.grey),
        _createButton(
          title: 'Continue to Checkout',
          onTap: () {
            print('continue to checkout');
          },
        ),
      ],
    );
  }

  Widget _createAddVoucherButton() {
    return Container(
      color: _style.sectionColor,
      child: _createButton(
        title: 'ADD NEW VOUCHER',
        onTap: () {
          print('continue to contact');
        },
        leftSpacing: 0,
        topSpacing: 0,
        rightSpacing: 0,
      ),
    );
  }
}

extension CheckoutCartSideMenu on CheckoutCart {
  Widget _asSideMenu(BuildContext ctx, double sreenWidthPercent) {
    double swp = sreenWidthPercent.isFinite
        ? sreenWidthPercent.clamp(0.0, 1.0)
        : 0.9;
    double screenWidth = MediaQuery.of(ctx).size.width;
    double screenHeight = MediaQuery.of(ctx).size.height;
    double sideMenuWidth = screenWidth * swp;

    return Align(
      alignment: Alignment.centerRight,
      child: Material(
        color: Colors.white,
        elevation: 8,
        child: SafeArea(
          child: SizedBox(
            width: sideMenuWidth,
            height: screenHeight,
            child: this,
          ),
        ),
      ),
    );
  }

  PageRoute<T> asSideMenuRoute<T>({RouteSettings? settings}) {
    final Color barrierColor = Colors.black54;
    final Duration duration = Duration(milliseconds: 300);
    final double screenWidthPercentage = 0.9;
    return PageRouteBuilder<T>(
      settings: settings,
      opaque: false,
      barrierDismissible: true,
      barrierColor: barrierColor,
      transitionDuration: duration,
      transitionsBuilder: (ctx, anim, _, child) {
        final curved = CurvedAnimation(
          parent: anim,
          curve: Curves.easeOutCubic,
        );
        return SlideTransition(
          position: Tween(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        );
      },
      pageBuilder: (ctx, anim, _) {
        return _asSideMenu(ctx, screenWidthPercentage);
      },
    );
  }
}
