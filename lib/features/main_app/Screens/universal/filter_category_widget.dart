import 'package:flutter/material.dart';

class FilterCategoryWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FilterCategoryWidgetState();
  }
}

class _FilterCategoryWidgetState extends State<FilterCategoryWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: Text("Filter Category"));
  }
}
