import 'package:flutter/material.dart';

class SortWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SortWidgetState();
  }
}

class _SortWidgetState extends State<SortWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: Text("Sort"));
  }
}
