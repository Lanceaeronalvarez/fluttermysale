import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mysale/core/widgets/bottom_bar.dart';
import 'package:flutter_mysale/core/widgets/toast_message.dart';
import 'package:flutter_mysale/features/main_app/utils/helpers.dart';
import 'package:provider/provider.dart';

import '../../../../core/helpers/style_helper.dart';
import '../../models/model.dart';
import '../../providers/address_provider.dart';

class AddNewAddress extends StatefulWidget {
  const AddNewAddress({
    super.key,
    required this.decorations,
    this.isWidgetOnly,
    this.onCancelTap,
    this.onSavedAddress,
  });

  final List<AddressDecoration> decorations;
  final bool? isWidgetOnly;
  final VoidCallback? onCancelTap;
  final VoidCallback? onSavedAddress;

  @override
  State<AddNewAddress> createState() => _AddNewAddressState();
}

class _AddNewAddressState extends State<AddNewAddress> {
  late final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};

  static const _forenameKey = "forename";
  static const _surnameKey = "surname";
  static const _selectType = "select";

  bool isWidgetOnly = false;

  AddressItem newAddress = new AddressItem();
  Map<String, dynamic> myAddress = {};
  String dropdownValue = "";

  @override
  void initState() {
    super.initState();
    for (final d in widget.decorations) {
      final key = d.name?.toLowerCase();
      if (key != null && key.isNotEmpty) {
        _controllers[key] = TextEditingController(text: d.value ?? "");
      }
    }

    if (widget.isWidgetOnly != null) {
      isWidgetOnly = widget.isWidgetOnly!;
    }
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isWidgetOnly
        ? Column(children: [_createForm(), _createBottomActionBar()])
        : Scaffold(
            appBar: _createAppBar(),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: _createForm(),
                    ),
                  ),
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
        preferredSize: const Size.fromHeight(0.75),
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

  Widget _createForm() {
    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: isWidgetOnly ? true : false,
        physics: isWidgetOnly
            ? const NeverScrollableScrollPhysics()
            : const AlwaysScrollableScrollPhysics(),
        children: _createFormFields(),
      ),
    );
  }

  List<Widget> _createFormFields() {
    return widget.decorations.map((d) {
      if (d.type == _selectType) {
        return _createDropdown(d);
      }
      return _createTextField(d);
    }).toList();
  }

  Widget _createDropdown(AddressDecoration decoration) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        decoration: _inputDecoration(decoration.label ?? ""),
        value: decoration.value,
        items: decoration.options!
            .map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
            .toList(),
        onChanged: decoration.readOnly == true
            ? null
            : (val) {
                dropdownValue = val!;
              },
        validator: (value) => _validate(value, decoration),
      ),
    );
  }

  Widget _createTextField(AddressDecoration decoration) {
    final key = (decoration.name ?? "").toLowerCase();
    final controller = _controllers.putIfAbsent(
      key,
      () => TextEditingController(text: decoration.value),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        readOnly: decoration.readOnly ?? false,
        keyboardType: _mapKeyboardType(decoration.dataType),
        validator: (val) => _validate(val, decoration),
        decoration: _inputDecoration(decoration.label ?? ""),
      ),
    );
  }

  Widget _createActionButton({
    required String label,
    required VoidCallback onTap,
    required BoxDecoration decoration,
    required TextStyle textStyle,
  }) {
    return Container(
      height: 48,
      decoration: decoration,
      child: InkWell(
        onTap: onTap,
        child: Center(child: Text(label, style: textStyle)),
      ),
    );
  }

  Widget _createSaveButton() {
    return Consumer<AddressProvider>(
      builder: (_, provider, __) {
        return _createActionButton(
          label: provider.isLoading ? "SAVING..." : "SAVE",
          onTap: () {
            for (final d in widget.decorations) {
              final key = d.name?.toLowerCase();
              if (key != null) {
                if (key == "addresslines") {
                  myAddress["address_lines"] = _controllers[key]?.text;
                } else if (key == "state") {
                  myAddress[key] = dropdownValue;
                } else {
                  myAddress[key] = _controllers[key]?.text;
                }
              }
            }
            _saveAddress(provider);
          },
          decoration: appPrimaryButtonBoxDecoration,
          textStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    );
  }

  Widget _createCancelButton() {
    return _createActionButton(
      label: "CANCEL",
      onTap: () {
        if (isWidgetOnly) {
          widget.onCancelTap;
        } else {
          Navigator.pop(context);
        }
      },
      decoration: appSecondaryButtonBoxDecoration,
      textStyle: const TextStyle(
        color: Color(0xFF54ECFF),
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  void _saveAddress(AddressProvider provider) {
    if (!provider.isLoading) {
      if (_formKey.currentState!.validate()) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Saving address...")));
        provider
            .postAddress(jsonEncode(myAddress))
            .then((data) {
              provider.isLoading = false;
              ApplyAddressRequest request = ApplyAddressRequest(
                countryID: dotenv.get("SETTINGS_COUNTRY_ID"),
                languageID: dotenv.get("SETTINGS_LANGUAGE_ID"),
                imageSize: "100",
                deliveryAddressID: provider.addressId,
              );
              _applyAddress(provider, request);
            })
            .catchError((error) {
              provider.isLoading = false;
              showMessage(context, error);
            });
      }
    }
  }

  void _applyAddress(AddressProvider provider, ApplyAddressRequest request) {
    provider
        .applyAddress(request)
        .then((data) {
          provider.isLoading = false;
          widget.onSavedAddress;
          provider.mode.value = CheckoutShippingMode.view;
          provider.getAddresses();
          showMessage(context, 'Address Added Successfully');
        })
        .catchError((error) {
          provider.isLoading = false;
          provider.mode.value = CheckoutShippingMode.add;
          showMessage(context, error);
        });
  }

  String? _validate(String? value, AddressDecoration d) {
    final label = d.label ?? "This field";
    final trimmed = value?.trim() ?? "";

    if (trimmed.isEmpty) return "$label is required";

    if (d.minLength != null && trimmed.length < d.minLength!) {
      return "$label must be at least ${d.minLength} characters";
    }
    if (d.maxLength != null && trimmed.length > d.maxLength!) {
      return "$label must be at most ${d.maxLength} characters";
    }

    if (d.regexp != null) {
      final regex = RegExp(d.regexp!);
      if (!regex.hasMatch(trimmed)) return "$label is invalid";
    }

    // Forename & Surname must not be the same
    final forename =
        _controllers[_forenameKey]?.text.trim().toLowerCase() ?? "";
    final surname = _controllers[_surnameKey]?.text.trim().toLowerCase() ?? "";
    if (forename.isNotEmpty && surname.isNotEmpty && forename == surname) {
      if (d.name?.toLowerCase() == _forenameKey ||
          d.name?.toLowerCase() == _surnameKey) {
        return "First name and last name cannot be the same";
      }
    }

    return null;
  }

  TextInputType _mapKeyboardType(String? dataType) {
    switch (dataType) {
      case "number":
        return TextInputType.number;
      case "phone":
        return TextInputType.phone;
      default:
        return TextInputType.text;
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color(0xFFFFF5F5),
      errorMaxLines: 2,
      errorStyle: const TextStyle(
        color: Colors.red,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.brown.shade300),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.cyan, width: 2),
      ),
    );
  }

  Widget _createBottomActionBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(child: _createCancelButton()),
          const SizedBox(width: 12),
          Expanded(child: _createSaveButton()),
        ],
      ),
    );
  }
}
