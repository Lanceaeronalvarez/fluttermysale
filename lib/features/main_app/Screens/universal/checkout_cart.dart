import 'package:flutter/material.dart';
import 'package:flutter_mysale/architect.dart';
import 'package:flutter_mysale/core/helpers/style_helper.dart';
import 'package:flutter_mysale/features/main_app/app.dart';
import 'package:flutter_mysale/features/main_app/models/main/cart/cart_item_model.dart';
import 'package:flutter_mysale/features/main_app/models/main/cart/cart_shipment_model.dart';
import 'package:flutter_mysale/features/main_app/providers/checkout_provider.dart';
import 'package:flutter_mysale/features/main_app/utils/helpers.dart';
import 'package:flutter_mysale/features/main_app/widgets/cart_item_row.dart';
import 'package:flutter_mysale/features/main_app/widgets/cart_shipping_row.dart';
import 'package:provider/provider.dart';

enum CheckoutCartMode {
  addToCart, //add to cart
  cart, //checkout - cart left side
  summary, //checkout - cart right side
  summaryFull, //checkout - other steps - right side
  cartModal, //cart modal inside checkout
}

class _CheckoutCartStyle {
  Color sectionColor;
  bool showAppBar;
  String appBarTitle;
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
  bool showExpressCheckout;

  double hSpacing = 16;
  double vSpacing = 16;

  TextStyle textRegular = TextStyle(fontSize: 14, fontWeight: FontWeight.w400);
  TextStyle textBold = TextStyle(fontSize: 16, fontWeight: FontWeight.w800);

  _CheckoutCartStyle._({
    required this.sectionColor,
    required this.showAppBar,
    required this.appBarTitle,
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
    required this.showExpressCheckout,
  });

  factory _CheckoutCartStyle.defaultInstance({bool show = false}) {
    return _CheckoutCartStyle._(
      sectionColor: Colors.white,
      showAppBar: show,
      appBarTitle: '',
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
      showExpressCheckout: show,
    );
  }

  factory _CheckoutCartStyle.fromCheckoutCartMode(CheckoutCartMode mode) {
    switch (mode) {
      case CheckoutCartMode.addToCart:
        return _CheckoutCartStyle._(
          sectionColor: Colors.white,
          showAppBar: true,
          appBarTitle: 'SHOPPING CART',
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
          showExpressCheckout: true,
        );
      case CheckoutCartMode.cart:
        return _CheckoutCartStyle._(
          sectionColor: checkoutGrey,
          showAppBar: false,
          appBarTitle: '',
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
          showExpressCheckout: false,
        );
      case CheckoutCartMode.summary:
        return _CheckoutCartStyle._(
          sectionColor: checkoutGrey,
          showAppBar: false,
          appBarTitle: '',
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
          showExpressCheckout: false,
        );
      case CheckoutCartMode.summaryFull:
        return _CheckoutCartStyle._(
          sectionColor: checkoutGrey,
          showAppBar: false,
          appBarTitle: '',
          showProductListHeader: true,
          showProductList: true,
          productRowPriceAtBottom: true,
          productRowShowDivider: false,
          showContinueToContact: false,
          addDividerBetweenProductAndSummary: false,
          showAddVoucher: true,
          showOrderSummarySectionTitle: false,
          showOrderSummarySection: true,
          showContinueToCheckout: false,
          showExpressCheckout: false,
        );
      case CheckoutCartMode.cartModal:
        return _CheckoutCartStyle._(
          sectionColor: Colors.white,
          showAppBar: true,
          appBarTitle: 'ORDER SUMMARY',
          showProductListHeader: false,
          showProductList: true,
          productRowPriceAtBottom: true,
          productRowShowDivider: false,
          showContinueToContact: false,
          addDividerBetweenProductAndSummary: false,
          showAddVoucher: true,
          showOrderSummarySectionTitle: false,
          showOrderSummarySection: true,
          showContinueToCheckout: false,
          showExpressCheckout: false,
        );
    }
  }
}

class CheckoutCart extends StatefulWidget {
  final CheckoutCartMode mode;
  final VoidCallback? onContinueToContact;

  CheckoutCart({
    this.mode = CheckoutCartMode.addToCart,
    this.onContinueToContact,
  });

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
      title: Text(
        _style.appBarTitle,
        style: const TextStyle(
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
              if (_style.showProductList) _createProductList(provider),
              if (_style.showContinueToContact)
                SliverToBoxAdapter(child: _createContactButtonSection()),
              if (_style.addDividerBetweenProductAndSummary)
                SliverToBoxAdapter(child: SizedBox(height: 16)),
              if (_style.showOrderSummarySection)
                SliverToBoxAdapter(child: _createSummarySection(provider)),
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

  Widget _createProductList(CheckoutProvider provider) {
    List<(int, int, dynamic)> list = [];
    List<CartShipment> shipments = provider.cart?.shipments ?? [];
    for (final (int shipmentIndex, CartShipment shipment)
        in shipments.indexed) {
      List<CartItem> items = shipments[shipmentIndex].items ?? [];
      for (final (int itemIndex, CartItem item) in items.indexed) {
        list.add((shipmentIndex, itemIndex, item));
      }
      list.add((shipmentIndex, 0, shipment));
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final obj = list[index];
          if (obj.$3 is CartItem) {
            CartItem item = obj.$3;
            final productRow = CartItemRow(
              isLoading: provider.isLoading && provider.targetItemID == item.id,
              item: item,
              section: obj.$1,
              row: obj.$2,
              sectionColor: _style.sectionColor,
              showPriceAtBottom: _style.productRowPriceAtBottom,
              showDivider: _style.productRowShowDivider,
              onTap: (_) {
                debugPrint('tap');
              },
              onPlus: (_) {
                debugPrint('increase qty');
                provider.callIncreasePublicOrderItem(item.id).then((
                  errorMessage,
                ) {
                  _showErrorMessage(errorMessage);
                });
              },
              onMinus: (_) {
                debugPrint('decrease qty');
                provider.callDecreasePublicOrderItem(item.id).then((
                  errorMessage,
                ) {
                  _showErrorMessage(errorMessage);
                });
              },
              onRemove: (_) {
                debugPrint('remove item');
                provider.callDeletePublicOrderItem(item.id).then((
                  errorMessage,
                ) {
                  _showErrorMessage(errorMessage);
                });
              },
            );
            return productRow;
          } else if (obj.$3 is CartShipment) {
            return CartShippingRow(
              shipment: obj.$3,
              section: obj.$1,
              row: obj.$2,
              sectionColor: checkoutDarkGrey,
              showDivider: false,
            );
          } else {
            return SizedBox.shrink();
          }
        },
        childCount: list.length,
        addAutomaticKeepAlives: true,
        addRepaintBoundaries: true,
      ),
    );
  }

  void _showErrorMessage(String? errorMessage) {
    if (errorMessage != null && errorMessage.isNotEmpty) {
      showMessage(context, errorMessage);
    }
  }

  Widget _createSummarySection(CheckoutProvider provider) {
    double hSpacing = _style.hSpacing;
    double vSpacing = _style.vSpacing;

    int itemCount = provider.cart?.itemsCount ?? 0;
    double subtotal = provider.cart?.summary?.subtotal ?? 0;
    String postCode = provider.cart?.summary?.estimateShipmentPostcode ?? '';
    double delivery = provider.cart?.summary?.delivery ?? 0;
    double total = provider.cart?.summary?.total ?? 0;

    return Container(
      color: _style.sectionColor,
      child: Padding(
        padding: EdgeInsets.fromLTRB(hSpacing, vSpacing, hSpacing, vSpacing),
        child: Column(
          children: [
            if (_style.showAddVoucher) _createAddVoucherButton(),
            if (_style.showOrderSummarySectionTitle)
              _createSummaryRow(
                title: 'Order Summary',
                value: '',
                style: _style.textBold,
                bottomPadding: 8,
              ),
            _createSummaryRow(
              title:
                  'Subtotal ($itemCount ${itemCount == 1 ? 'item' : 'items'})',
              value: subtotal.toMoneyString(),
              style: _style.textRegular,
              bottomPadding: 8,
            ),
            _createSummaryRow(
              title: 'Shipping to Postcode ',
              boldTitle: postCode,
              value: delivery.toMoneyString(),
              style: _style.textRegular,
              bottomPadding: 16,
            ),
            _createSummaryRow(
              title: '',
              boldTitle: 'Total',
              value: total.toMoneyString(),
              style: _style.textBold,
              bottomPadding: 4,
            ),
            _createSummaryRow(
              title: '',
              value: 'Including GST',
              style: _style.textRegular,
              bottomPadding: 0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _createSummaryRow({
    required String title,
    String? boldTitle,
    required String value,
    required TextStyle style,
    required double bottomPadding,
  }) {
    RichText titleText = RichText(
      text: TextSpan(
        style: TextStyle(color: Colors.black),
        children: [
          TextSpan(text: title),
          if (boldTitle != null && boldTitle.isNotEmpty)
            TextSpan(
              text: boldTitle,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, bottomPadding),
      child: Row(
        children: [
          Expanded(child: titleText),
          Text(value, style: style),
        ],
      ),
    );
  }

  Widget _createContactButtonSection() {
    return Container(
      color: _style.sectionColor,
      child: _createButton(
        title: 'CONTINUE TO CONTACT',
        onTap: () {
          print('continue to contact');
          widget.onContinueToContact?.call();
        },
      ),
    );
  }

  Widget _createCheckoutButtonSection() {
    return Column(
      children: [
        Divider(height: 1, color: Colors.grey),
        _createButton(
          title: 'CONTINUE TO CHECKOUT',
          onTap: () {
            debugPrint('continue to checkout');
            //TODO: JCA should navigate to checkout - contact
            Nav.toNamed(
              context,
              App.checkout,
              //arguments: CheckoutArguments(checkoutStep: CheckoutStep.contact),
            );
          },
          bottomSpacing: 4,
        ),
        _createExpressCheckoutTitle(),
        _createExpressCheckoutGrid(),
      ],
    );
  }

  Widget _createAddVoucherButton() {
    return Container(
      color: _style.sectionColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
        child: ElevatedButton(
          onPressed: () {},
          style: appElevatedButtonStyle.copyWith(
            backgroundColor: WidgetStatePropertyAll<Color>(Colors.white),
            alignment: Alignment.center,
            padding: WidgetStatePropertyAll(
              EdgeInsetsDirectional.only(start: 16, end: 8),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('ADD NEW VOUCHER', textAlign: TextAlign.left),
              Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createExpressCheckoutTitle() {
    return Text('EXPRESS CHECKOUT', style: TextStyle(color: Colors.grey));
  }

  Widget _createExpressCheckoutGrid() {
    //TODO: JCA temp only
    List<(String, Color)> items = [
      ('assets/images/ec_paypal.png', Color(0xffFCC702)),
      ('assets/images/ec_afterpay.png', Color(0xffB2FCE4)),
    ];
    double spacing = 16;
    double height = 40;
    int rows = 2;
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(spacing, spacing / 2, spacing, spacing / 2),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: rows,
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
        mainAxisExtent: height,
      ),
      itemBuilder: (_, index) {
        final item = items[index];
        return Container(
          color: item.$2,
          child: Center(
            child: SizedBox(
              height: height / 2,
              child: Image.asset(item.$1, fit: BoxFit.contain),
            ),
          ),
        );
      },
      itemCount: items.length,
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

  PageRoute<T> asSideMenuRoute<T>({
    RouteSettings? settings,
    required double widthPercentage,
  }) {
    final Color barrierColor = Colors.black54;
    final Duration duration = Duration(milliseconds: 300);
    final double screenWidthPercentage = widthPercentage;
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
