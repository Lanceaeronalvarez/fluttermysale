import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_mysale/architect.dart';
import 'package:flutter_mysale/features/main_app/Screens/universal/acount_menu.dart';

class AccountMenuController extends StatelessController {
  @override
  Display view(BuildContext context) {
    AccountMenu child = AccountMenu();
    return Display(title: "Account", mobile: child);
  }
}
