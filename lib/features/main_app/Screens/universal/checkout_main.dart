import 'package:flutter/material.dart';
import 'package:flutter_mysale/architect.dart';
import 'package:flutter_mysale/core/helpers/style_helper.dart';
import 'package:flutter_mysale/features/main_app/Screens/universal/checkout_cart.dart';
import 'package:flutter_mysale/features/main_app/Screens/universal/checkout_contact.dart';
import 'package:flutter_mysale/features/main_app/Screens/universal/checkout_shipping.dart';
import 'package:flutter_mysale/features/main_app/app.dart';
import 'package:flutter_mysale/features/main_app/providers/authentication_provider.dart';
import 'package:flutter_mysale/features/main_app/providers/checkout_provider.dart';
import 'package:flutter_mysale/features/main_app/utils/helpers.dart';
import 'package:flutter_mysale/features/main_app/widgets/checkout_stepper.dart';
import 'package:flutter_mysale/features/main_app/widgets/promo_banner.dart';
import 'package:provider/provider.dart';

class CheckoutMain extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CheckoutMain();
  }
}

class _CheckoutMain extends State<CheckoutMain> {
  //TODO: JCA hardcoded image, should not be hardcoded here
  String _logoImagePath = 'assets/images/logo.png';

  ValueNotifier<CheckoutStep> _currentCheckoutStep = ValueNotifier(
    CheckoutStep.cart,
  );

  @override
  void dispose() {
    _currentCheckoutStep.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _createAppBar(),
      body: _createBody(context),
      bottomNavigationBar: BottomBar(),
    );
  }

  Widget _createBody(BuildContext context) {
    bool isTablet = MediaQuery.of(context).isTablet;
    return SafeArea(
      child: Column(
        children: [
          _createSecureCheckoutContainer(isTablet),
          _createStepperContainer(),
          Container(
            constraints: BoxConstraints(minWidth: double.infinity),
            child: PromoBanner(
              onTap: () {
                print('promo banner tap');
              },
            ),
          ),
          (isTablet)
              ? Expanded(
                  child: Row(
                    children: [
                      Expanded(child: _createSubpage()),
                      SizedBox(width: 1),
                      Expanded(
                        child: CheckoutCart(mode: CheckoutCartMode.summary),
                      ),
                    ],
                  ),
                )
              : Expanded(child: _createSubpage()),
        ],
      ),
    );
  }

  Widget _createSecureCheckoutContainer(bool isTablet) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: _createSecureCheckoutRow(isTablet),
          ),
          _createDivider(),
        ],
      ),
    );
  }

  Widget _createSecureCheckoutRow(bool isTablet) {
    return ValueListenableBuilder(
      valueListenable: _currentCheckoutStep,
      builder: (_, value, _) {
        return SizedBox(
          height: 40,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _createSecureCheckoutTitle(),
              if (!isTablet && value != CheckoutStep.cart)
                _createOrderSummaryButton(),
            ],
          ),
        );
      },
    );
  }

  Widget _createSecureCheckoutTitle() {
    return const Expanded(
      child: ClipRect(
        child: Align(
          alignment: Alignment.centerLeft,
          widthFactor: 1.0, // paint only within the parent's width
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock, size: 18),
              const SizedBox(width: 8),
              // Only the text shrinks; it ellipsizes when tight
              const Flexible(
                child: Text(
                  'Secure Checkout',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createOrderSummaryButton() {
    return Consumer<CheckoutProvider>(
      builder: (_, provider, _) {
        int itemCount = provider.cart?.itemsCount ?? 0;
        String item = itemCount == 1 ? 'item' : 'items';
        String price = provider.cart?.summary?.total?.toMoneyString() ?? '';
        if (provider.cart?.isEmpty ?? true) {
          return SizedBox.shrink();
        } else {
          return ElevatedButton(
            onPressed: () {
              Nav.toNamed(context, App.cartModal);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              minimumSize: const Size(0, 32),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text('$itemCount $item • $price'),
          );
        }
      },
    );
  }

  Widget _createSubpage() {
    return ValueListenableBuilder(
      valueListenable: _currentCheckoutStep,
      builder: (_, value, _) {
        switch (value) {
          case CheckoutStep.cart:
            return CheckoutCart(
              mode: CheckoutCartMode.cart,
              onContinueToContact: () {
                _currentCheckoutStep.value = CheckoutStep.contact;
              },
            );
          case CheckoutStep.contact:
            final ap = context.read<AuthenthicationProvider>();
            return FutureBuilder(
              future: ap.isLoggedIn(),
              builder: (_, snap) {
                if (snap.connectionState == ConnectionState.done) {
                  bool isLoggedIn = snap.data ?? false;
                  return CheckoutContact(
                    mode: isLoggedIn
                        ? CheckoutContactMode.loggedIn
                        : CheckoutContactMode.guestCheckoutForm,
                    onContinueToShipping: () {
                      _currentCheckoutStep.value = CheckoutStep.shipping;
                    },
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            );
          case CheckoutStep.shipping:
            return CheckoutShipping(
              onContinueToPayment: () {
                _currentCheckoutStep.value = CheckoutStep.payment;
              },
            );
          case CheckoutStep.payment:
            return Container(
              child: Center(child: Text('Payment')),
              color: Colors.grey,
            );
        }
      },
    );
  }

  Widget _createStepperContainer() {
    List<(CheckoutStep, String)> steps = [
      (CheckoutStep.cart, 'CART'),
      (CheckoutStep.contact, 'CONTACT'),
      (CheckoutStep.shipping, 'SHIPPING'),
      (CheckoutStep.payment, 'PAYMENT'),
    ];
    return ValueListenableBuilder(
      valueListenable: _currentCheckoutStep,
      builder: (_, value, _) {
        return Container(
          color: checkoutGrey,
          child: Column(
            children: [
              CheckoutStepper(
                currentCheckoutStep: value,
                valueChanged: (newCheckoutStep) {
                  _currentCheckoutStep.value = newCheckoutStep;
                },
              ),
              _createDivider(),
            ],
          ),
        );
      },
    );
  }

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
      bottom: _createDivider(),
      title: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 28),
        child: Image.asset(_logoImagePath),
      ),
      actions: [
        //_createCloseButton()
      ],
    );
  }

  Widget _createCloseButton() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.pop(context);
      },
      child: const Padding(
        padding: EdgeInsets.all(12),
        child: Icon(Icons.close, color: Colors.black),
      ),
    );
  }

  PreferredSize _createDivider() {
    return const PreferredSize(
      preferredSize: Size.fromHeight(0.75),
      child: Divider(height: 0.75, thickness: 0.75, color: Colors.grey),
    );
  }
}
