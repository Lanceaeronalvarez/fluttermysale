import 'package:flutter/material.dart';

class FilterPriceWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FilterPriceWidgetState();
  }
}

class _FilterPriceWidgetState extends State<FilterPriceWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: Text("Filter Price"));
  }
}
