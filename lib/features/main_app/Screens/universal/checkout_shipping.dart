import 'package:flutter/material.dart';
import 'package:flutter_mysale/config/app_cache.dart';
import 'package:flutter_mysale/core/classes/route_manager.dart';
import 'package:flutter_mysale/core/helpers/style_helper.dart';
import 'package:flutter_mysale/features/main_app/app.dart';
import 'package:flutter_mysale/features/main_app/models/main/addresses_model.dart';
import 'package:flutter_mysale/features/main_app/providers/address_provider.dart';
import 'package:flutter_mysale/features/main_app/widgets/address_card.dart';
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

  bool isLoggedIn = false;

  AddressItem? selectedAddress;

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
      (Provider.of<AddressProvider>(context, listen: false)).getAddresses();
    });

    checkIfLoggedIn();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void checkIfLoggedIn() async {
    isLoggedIn = await ac.isLogin();
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

  Widget _createDisplayAddress(AddressProvider provider) {
    //Currently using first address.
    // Will change once get cart details is implemented
    if (provider.addressId != "") {
      selectedAddress = provider.addresses.firstWhere(
        (address) => address.id == provider.addressId,
      );
    } else {
      selectedAddress ??= provider.addresses[0];
    }

    return Column(
      children: [
        AddressCard(
          address: selectedAddress,
          showChevron: true,
          onTap: () {
            Nav.toNamed(context, App.address);
          },
        ),
        SizedBox(height: 20),
        _createInfoButton(),
      ],
    );
  }

  Widget _createAddAddress(AddressProvider provider) {
    return GestureDetector(
      onTap: () {
        Nav.toNamed(context, App.newAddress);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20),
        margin: EdgeInsets.only(bottom: 10),
        decoration: _tileBackground,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Add New Address",
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  Widget _createDisplayName(AddressProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isLoggedIn
            ? const Text(
                "Contact Information",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              )
            : SizedBox(),
        SizedBox(height: 20),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: checkoutGrey,
          ),
          child: Text(
            provider.decorations.isNotEmpty
                ? "${provider.decorations.firstWhere((decor) => decor.name == 'Forename').value} ${provider.decorations.firstWhere((decor) => decor.name == 'Surname').value}"
                : "",
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _createLoadingUi(AddressProvider provider) {
    return Center(child: CircularProgressIndicator());
  }

  Widget _createInfoButton() {
    return ElevatedButton(
      onPressed: () {
        widget.onContinueToPayment!();
      },
      style: appElevatedButtonStyle,
      child: Text('CONTINUE TO PAYMENT'),
    );
  }

  Widget _createAddOrViewAddress(AddressProvider provider) {
    return provider.addresses.isEmpty
        ? _createAddAddress(provider)
        : _createDisplayAddress(provider);
  }

  Widget _createCheckoutShippingSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Consumer<AddressProvider>(
        builder: (_, provider, __) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _createDisplayName(provider),
              const Text(
                "SHIPPING INFORMATION",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 20),
              provider.isLoading
                  ? _createLoadingUi(provider)
                  : _createAddOrViewAddress(provider),
            ],
          );
        },
      ),
    );
  }
}
