import 'package:flutter/material.dart';
import 'package:flutter_mysale/features/main_app/providers/getappsettings_provider.dart';
import 'package:provider/provider.dart';

import '../../../../core/classes/classes.dart';
import '../../widgets/widget.dart';

class GetAppSettings extends StatefulWidget {
  final String? title;

  const GetAppSettings({Key? key, this.title}) : super(key: key);

  @override
  State<GetAppSettings> createState() => _GetAppSettingsState();
}

class _GetAppSettingsState extends State<GetAppSettings> {
  @override
  void initState() {
    GetAppSettingsProvider as = Provider.of<GetAppSettingsProvider>(context, listen:false);//
    as.getPublicAppSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tablet: ${widget.title!}"),
        actions: const [DayNightSwitch(), MenuButtons()],
      ),
      body: Center(child: Column(children: [appSettingsDisplay()])),
    );
  }

  Expanded appSettingsDisplay() {
    return Expanded(
      child: Consumer<GetAppSettingsProvider>(
        builder: (_, as, __) {
          if (as.isLoading == false) {
            return const Center(child: Text('App Settings Loading....'));
          } else if (as.json.isNotEmpty) {
            String json = as.json;
            return new SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: new Text(
                json,
                style: new TextStyle(fontSize: 16.0, color: Colors.red),
              ),
            );
          } else {
            return const Center(child: Text('No news data fetched'));
          }
        },
      ),
    );
  }
}
