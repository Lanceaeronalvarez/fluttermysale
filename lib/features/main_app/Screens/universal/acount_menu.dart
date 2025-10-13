import 'package:flutter/material.dart';
import 'package:flutter_mysale/config/app_cache.dart';
import 'package:flutter_mysale/core/widgets/bottom_bar.dart';
import 'package:flutter_mysale/features/main_app/providers/authentication_provider.dart';
import 'package:flutter_mysale/features/main_app/utils/helpers.dart';
import 'package:flutter_mysale/features/main_app/widgets/widget.dart';
import 'package:provider/provider.dart';

class AccountMenu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AccountMenuState();
  }
}

class _AccountMenuState extends State<AccountMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _createAppBar(),
      body: _createBody(),
      bottomNavigationBar: BottomBar(),
    );
  }

  // TODO: JCA AppBar theme currently overriden, should use the appwide theme
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
      leading: SizedBox.shrink(),
      actions: [_createLogoutButton()],
    );
  }

  Widget _createTitleText() {
    return const Text('Account', style: TextStyle(color: Colors.black));
  }

  Widget _createLogoutButton() {
    return TextButton(
      onPressed: () {
        print('logout');
        final p = context.read<AuthenthicationProvider>();
        p.callLogout().then((_) {
          AppCache().loginTicket.then((loginTicket) {
            debugPrint('Logged Out');
            debugPrint('Login Ticket: $loginTicket');
          });
        
        });
      },
      style: TextButton.styleFrom(
        foregroundColor: 'CCA68B'.toColor(),
        splashFactory: NoSplash.splashFactory,
        overlayColor: Colors.transparent,
      ),
      child: const Text('Logout'),
    );
  }

  Widget _createBody() {
    return SafeArea(child: Column(children: []));
  }
}
