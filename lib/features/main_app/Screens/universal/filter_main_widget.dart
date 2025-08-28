import 'package:flutter/material.dart';

class FilterMainWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FilterMainWidgetState();
  }
}

class _FilterMainWidgetState extends State<FilterMainWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: Text("Filter Main"));
  }
}
