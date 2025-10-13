import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mysale/config/app_cache.dart';
import 'package:flutter_mysale/core/helpers/style_helper.dart';
import 'package:flutter_mysale/core/widgets/toast_message.dart';
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
    selectedAddress ??= provider.addresses[0];
    return Stack(
      children: [
        _createAddressTile(selectedAddress!, null),
        _createChangeAddressButton(provider),
      ],
    );
  }

  Widget _createAddressTile(AddressItem address, VoidCallback? ontap) {
    return GestureDetector(
      onTap: () {
        ontap != null ? ontap() : null;
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        margin: EdgeInsets.only(bottom: 10),
        decoration: _tileBackground,
        child: Column(
          mainAxisSize: MainAxisSize.max,
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
              "${address.addressLines} \n${address.suburb} \n${address.state} \n${address.postcode} \n${address.phone}",
              style: const TextStyle(color: Colors.black, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createChangeAddressButton(AddressProvider provider) {
    return Padding(
      padding: EdgeInsetsGeometry.all(10),
      child: GestureDetector(
        onTap: () {
          provider.mode.value = CheckoutShippingMode.list;
        },
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
            const Text(
              "Select Address",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            GestureDetector(
              onTap: () {
                provider.mode.value = CheckoutShippingMode.add;
              },
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
              _createAddressTile(provider.addresses[index], () {
                selectedAddress = provider.addresses[index];
                if (selectedAddress != null) {
                  ApplyAddressRequest request = ApplyAddressRequest(
                    countryID: dotenv.get("SETTINGS_COUNTRY_ID"),
                    languageID: dotenv.get("SETTINGS_LANGUAGE_ID"),
                    imageSize: "100",
                    deliveryAddressID: selectedAddress!.id,
                  );
                  _applyAddress(provider, request, selectedAddress!);
                }
              }),
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
          AddNewAddress(
            decorations: provider.decorations,
            isWidgetOnly: true,
            onCancelTap: () {
              if (provider.addresses.isNotEmpty) {
                provider.mode.value = CheckoutShippingMode.list;
              }
            },
            onSavedAddress: () {
              provider.mode.value = CheckoutShippingMode.view;
            },
          ),
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
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _createLoadingUi(AddressProvider provider) {
    return const Padding(
      padding: EdgeInsetsGeometry.all(30),
      child: SizedBox(
        child: Row(children: [Text("Loading"), CircularProgressIndicator()]),
      ),
    );
  }

  Widget _createCheckoutContactSection(AddressProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ValueListenableBuilder(
        valueListenable: provider.mode,
        builder: (_, value, _) {
          switch (value) {
            case CheckoutShippingMode.add:
              return _createAddAddress(provider);
            case CheckoutShippingMode.view:
              return _createDisplayAddress(provider);
            case CheckoutShippingMode.list:
              return _createAddressList(provider);
            case CheckoutShippingMode.loading:
              return _createLoadingUi(provider);
          }
        },
      ),
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
              const Text(
                "SHIPPING INFORMATION",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 20),
              _createCheckoutContactSection(provider),
            ],
          );
        },
      ),
    );
  }

  void _applyAddress(
    AddressProvider provider,
    ApplyAddressRequest request,
    AddressItem selectedAddress,
  ) {
    provider
        .applyAddress(request)
        .then((data) {
          provider.isLoading = false;
          provider.mode.value = CheckoutShippingMode.view;
        })
        .catchError((error) {
          provider.isLoading = false;
          provider.mode.value = CheckoutShippingMode.view;
          showMessage(context, error);
        });
  }
}
