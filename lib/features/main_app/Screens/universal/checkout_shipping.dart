import 'package:flutter/material.dart';
import 'package:flutter_mysale/config/app_cache.dart';
import 'package:flutter_mysale/core/helpers/style_helper.dart';
import 'package:flutter_mysale/features/main_app/Screens/universal/new_address.dart';
import 'package:flutter_mysale/features/main_app/models/main/addresses_model.dart';
import 'package:flutter_mysale/features/main_app/providers/address_provider.dart';
import 'package:provider/provider.dart';

class CheckoutShipping extends StatefulWidget {
  final VoidCallback? onContinueToShipping;

  CheckoutShipping({required this.onContinueToShipping});

  @override
  State<StatefulWidget> createState() {
    return _CheckoutShipping();
  }
}

class _CheckoutShipping extends State<CheckoutShipping> {
  AppCache ac = AppCache();

  bool isLoggedIn = false;

  BoxDecoration _tileBackground = BoxDecoration(
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
    //Currently using first address. Will change once get cart details is implemented
    AddressItem address = provider.addresses[0];
    return Stack(
      children: [
        _createAddressTile(address, null),
        _createChangeAddressButton(),
      ],
    );
  }

  Widget _createAddressTile(AddressItem address, VoidCallback? ontap) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 10),
      decoration: _tileBackground,
      child: GestureDetector(
        onTap: () {
          ontap != null ? ontap() : null;
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${address.name}",
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            Text(
              "${address.addressLines} \n${address.suburb} \n${address.city} \n${address.postcode} \n${address.phone}",
              style: const TextStyle(color: Colors.black, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createChangeAddressButton() {
    return Padding(
      padding: EdgeInsetsGeometry.all(10),
      child: GestureDetector(
        onTap: () {},
        child: Align(
          alignment: Alignment.topRight,
          child: Text(
            "Change",
            style: TextStyle(
              color: beigeColor,
              decoration: TextDecoration.underline,
              decorationThickness: 1.5,
              decorationColor: beigeColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _createAddressList(AddressProvider provider) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Select Address",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                "Add New Address",
                style: TextStyle(
                  color: beigeColor,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                  decorationThickness: 1.5,
                  decorationColor: beigeColor,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: provider.addresses.length,
          itemBuilder: (context, index) =>
              _createAddressTile(provider.addresses[index], () {}),
        ),
      ],
    );
  }

  Widget _createAddAddress(AddressProvider provider) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: const <BoxShadow>[
          BoxShadow(color: Colors.grey, spreadRadius: 1),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "ADD NEW ADDRESS",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 20),
          AddNewAddress(decorations: provider.decorations, isWidgetOnly: true),
        ],
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
        SizedBox(height: 20),
      ],
    );
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
              Text(
                "SHIPPING INFORMATION",
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 20),
              provider.addresses.isNotEmpty
                  ? _createDisplayAddress(provider)
                  : _createAddAddress(provider),
            ],
          );
        },
      ),
    );
  }
}
