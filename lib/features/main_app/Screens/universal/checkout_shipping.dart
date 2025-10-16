import 'package:flutter/material.dart';
import 'package:flutter_mysale/config/app_cache.dart';
import 'package:flutter_mysale/core/classes/route_manager.dart';
import 'package:flutter_mysale/core/helpers/style_helper.dart';
import 'package:flutter_mysale/features/main_app/app.dart';
import 'package:flutter_mysale/features/main_app/models/main/user_model.dart';
import 'package:flutter_mysale/features/main_app/models/model.dart';
import 'package:flutter_mysale/features/main_app/providers/checkout_provider.dart';
import 'package:flutter_mysale/features/main_app/widgets/address_card.dart';
import 'package:flutter_mysale/features/main_app/widgets/checkout_contact_section.dart';
import 'package:provider/provider.dart';

class CheckoutShipping extends StatefulWidget {
  final VoidCallback? onContinueToPayment;

  CheckoutShipping({required this.onContinueToPayment});

  @override
  State<StatefulWidget> createState() {
    return _CheckoutShipping();
  }
}

class _CheckoutShipping extends State<CheckoutShipping> {
  AppCache ac = AppCache();

  final BoxDecoration _tileBackground = BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color: Colors.white,
    boxShadow: const <BoxShadow>[
      BoxShadow(color: Colors.grey, spreadRadius: 1),
    ],
  );

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<CheckoutProvider>().callCart();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: null,
      body: _createBody(context),
    );
  }

  Widget _createBody(BuildContext context) {
    return CustomScrollView(
      shrinkWrap: true,
      slivers: [SliverToBoxAdapter(child: _createCheckoutShippingSection())],
    );
  }

  Widget _createDisplayAddress() {
    return Consumer<CheckoutProvider>(
      builder: (_, provider, __) {
        return Column(
          children: [
            AddressCard(
              address: provider.cart?.deliveryAddress != null
                  ? AddressItem(
                      id: provider.cart!.deliveryAddress!.id,
                      name: provider.cart!.deliveryAddress!.name,
                      surname: provider.cart!.deliveryAddress!.surname,
                      forename: provider.cart!.deliveryAddress!.forename,
                      state: provider.cart!.deliveryAddress!.state,
                      addressLines:
                          provider.cart!.deliveryAddress!.addressLines,
                      suburb: provider.cart!.deliveryAddress!.suburb,
                      postcode: provider.cart!.deliveryAddress!.postcode,
                      phone: provider.cart!.deliveryAddress!.phone,
                    )
                  : null,
              showChevron: true,
              onTap: () {
                Nav.toNamed(context, App.address);
              },
            ),
            SizedBox(height: 20),
            _createInfoButton(),
          ],
        );
      },
    );
  }

  Widget _createInfoButton() {
    return ElevatedButton(
      onPressed: () {
        widget.onContinueToPayment!();
      },
      style: appElevatedButtonStyle,
      child: const Text('CONTINUE TO PAYMENT'),
    );
  }

  Widget _createContactInfo() {
    return FutureBuilder<User?>(
      future: AppCache().user,
      builder: (_, snap) {
        if (snap.connectionState == ConnectionState.done) {
          User? u = snap.data;
          String info = '${u?.firstName ?? ''} ${u?.lastName ?? ''}'.trim();
          return _createGuestCheckoutForm(
            contactInfo: CheckoutContactSectionInfo(
              isGuestCheckout: false,
              info: info,
              showContinueToShippingButton: false,
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }

  Widget _createGuestCheckoutForm({
    required CheckoutContactSectionInfo? contactInfo,
  }) {
    return CheckoutContactSection(
      title: 'CONTACT INFORMATION',
      contactInfo: contactInfo,
      onContinueShipping: (email) {},
      onLogin: () {},
      onSignup: () {},
    );
  }

  Widget _createCheckoutShippingSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _createContactInfo(),
          const SizedBox(height: 20),
          const Text(
            "SHIPPING INFORMATION",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 20),
          _createDisplayAddress(),
        ],
      ),
    );
  }
}
