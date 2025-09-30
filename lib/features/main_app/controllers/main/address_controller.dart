import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_mysale/core/core.dart';

import '../../Screens/universal/address_list.dart' as widget;

class AddressController extends StatelessController {
  const AddressController({Key? key}) : super(key: key);

  @override
  Display view(BuildContext context) {
    return Display(title: 'My Addressess', mobile: widget.AddressList());
  }
}
