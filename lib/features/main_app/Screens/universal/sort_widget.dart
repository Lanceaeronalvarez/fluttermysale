import 'package:flutter/material.dart';
import 'package:flutter_mysale/features/main_app/providers/filter_provider.dart';
import 'package:flutter_mysale/features/main_app/utils/helpers.dart';
import 'package:provider/provider.dart';

class SortWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SortWidgetState();
  }
}

class _SortWidgetState extends State<SortWidget> {
  bool argsRetrieved = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!argsRetrieved) {
      argsRetrieved = true;
      //TODO: JCA get sort data from passed arguments or if no args, fetch in api
      //final sort = ModalRoute.of(context)?.settings.arguments as List<String>?;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _createAppBar(),
      body: _consumer(context),
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
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(0.75),
        child: Divider(height: 0.75, thickness: 0.75, color: Color(0xFFCCA68B)),
      ),
      title: _createTitleText(),
      leading: _createCloseButton(),
    );
  }

  Widget _createTitleText() {
    return Text('Sort', style: TextStyle(color: Colors.black));
  }

  Widget _createCloseButton() {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(Icons.close),
    );
  }

  Consumer<FilterProvider> _consumer(BuildContext context) {
    return Consumer<FilterProvider>(
      builder: (context, provider, child) {
        return _createBody(provider);
      },
    );
  }

  Widget _createBody(FilterProvider provider) {
    return ListView.separated(
      itemCount: provider.sorts.length,
      itemBuilder: (context, index) {
        final title = provider.sorts[index];
        return _createListTile(provider, title);
      },
      separatorBuilder: (context, index) {
        return _createDivider();
      },
    );
  }

  Widget _createListTile(FilterProvider provider, String title) {
    bool isSelected =
        title.toLowerCase == (provider.selectedSort?.toLowerCase ?? '');
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: ListTile(
        leading: null,
        title: Text(title),
        trailing: isSelected ? const Icon(Icons.check) : null,
        onTap: () {
          print(title);
          provider.setSelectedSort(title);
        },
      ),
    );
  }

  Widget _createDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 16,
      endIndent: 0,
      color: "#F6F6F6".toColor(),
    );
  }
}
