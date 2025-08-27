import 'package:flutter/material.dart';

class FilterSelectWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FilterSelectWidgetState();
  }
}

class _FilterSelectWidgetState extends State<FilterSelectWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: Text("Filter Select"));
  }
}
