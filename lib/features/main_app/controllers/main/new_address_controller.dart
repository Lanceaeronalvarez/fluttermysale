import 'package:flutter/material.dart';
import 'package:flutter_mysale/core/core.dart';

import '../../Screens/universal/new_address.dart' as widget;
import '../../models/model.dart';

class AddressArguments {
  final List<AddressDecoration> decorations;

  AddressArguments({required this.decorations});
}

class NewAddressController extends StatelessController {
  final AddressArguments args;

  const NewAddressController({Key? key, required this.args}) : super(key: key);

  @override
  Display view(BuildContext context) {
    return Display(
      title: "New Address",
      mobile: widget.AddNewAddress(decorations: args.decorations),
    );
  }
}
