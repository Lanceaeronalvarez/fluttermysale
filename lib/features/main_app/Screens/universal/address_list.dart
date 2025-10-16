import 'package:flutter/material.dart';
import 'package:flutter_mysale/architect.dart';
import 'package:flutter_mysale/features/main_app/app.dart';
import 'package:flutter_mysale/features/main_app/providers/address_provider.dart';
import 'package:flutter_mysale/features/main_app/providers/checkout_provider.dart';
import 'package:flutter_mysale/features/main_app/utils/helpers.dart';
import 'package:provider/provider.dart';

import '../../../../core/helpers/style_helper.dart';
import '../../controllers/controller.dart';
import '../../widgets/address_card.dart';

class AddressList extends StatefulWidget {
  final bool showChevron;

  const AddressList({super.key, this.showChevron = true});

  @override
  State<AddressList> createState() => _AddressListState();
}

class _AddressListState extends State<AddressList> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<AddressProvider>().getAddresses());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _createAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            _createHeader(),
            Expanded(child: _createAddressList()),
            _createBottomActionBar(),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }

  PreferredSizeWidget _createAppBar() {
    return AppBar(
      leadingWidth: 56,
      centerTitle: true,
      toolbarHeight: 56,
      scrolledUnderElevation: 0, // stop darkening appbar on scroll
      surfaceTintColor: Colors.transparent, // disable Material 3 tint overlay
      backgroundColor: const Color(0xfff7f7f7),
      iconTheme: const IconThemeData(color: Colors.black),
      elevation: 0, // no shadow
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(0.75),
        child: Divider(
          height: 0.75,
          thickness: 0.75,
          color: 'CCA68B'.toColor(),
        ),
      ),
      title: _createTitleText(),
    );
  }

  Widget _createTitleText() {
    return const Text('My Address', style: TextStyle(color: Colors.black));
  }

  Widget _createHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Select Address",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _createAddressList() {
    return Consumer<AddressProvider>(
      builder: (_, provider, __) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.addresses.isEmpty) {
          return const Center(child: Text("No addresses found"));
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: provider.addresses.length,
          itemBuilder: (context, index) {
            final addr = provider.addresses[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: AddressCard(
                address: addr,
                showChevron: widget.showChevron,
                onTap: () {
                  provider.selectAddress(addr);

                  _applyAddress(addr.id!);
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _createBottomActionBar() {
    return Consumer<AddressProvider>(
      builder: (_, provider, __) {
        final isDisabled = provider.isLoading;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: isDisabled
                  ? null
                  : () {
                      Nav.toNamed(
                        context,
                        App.newAddress,
                        arguments: AddressArguments(
                          decorations: provider.decorations,
                        ),
                      );
                    },
              child: Container(
                width: double.infinity,
                height: 48,
                decoration: appPrimaryButtonBoxDecoration.copyWith(
                  color: isDisabled
                      ? Colors.grey.shade400
                      : appPrimaryButtonBoxDecoration.color,
                ),
                alignment: Alignment.center,
                child: Text(
                  isDisabled ? "LOADING..." : "ADD NEW ADDRESS",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _applyAddress(String addressId) {
    CheckoutProvider cartProvider = context.read<CheckoutProvider>();
    cartProvider
        .applyAddress(addressId)
        .then((data) {
          if (data.$1) {
            Nav.close(context);
          } else {
            showMessage(context, data.$2);
          }
        })
        .catchError((error) {
          cartProvider.isLoading = false;
          showMessage(context, error.toString());
        });
  }
}
