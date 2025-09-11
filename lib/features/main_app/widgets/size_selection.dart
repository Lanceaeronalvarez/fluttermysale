import 'package:flutter/material.dart';
import 'package:flutter_mysale/core/classes/route_manager.dart';
import 'package:flutter_mysale/features/main_app/app.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';

abstract class SizeItem {
  String getTitle();
}

class SizeSelectionWidget<T extends SizeItem> extends StatelessWidget {
  final List<T> sizesList;
  final String? sizeGuideLink;
  final void Function(T, int)? onTap;

  const SizeSelectionWidget({
    super.key,
    required this.sizesList,
    this.sizeGuideLink,
    this.onTap,
  });

  final Color beige = const Color.fromARGB(255, 214, 176, 118);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _createSizeGuide(context),
          _createSizeSelectionTags(),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _createSizeGuide(BuildContext context) {
    return sizeGuideLink == null
        ? Container(padding: EdgeInsets.fromLTRB(0, 10, 10, 10))
        : Container(
            padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: Row(
              children: [
                _createSizeGuideIcon(),
                _createSizeGuideText(),
                _createViewSizeGuide(context),
              ],
            ),
          );
  }

  Widget _createSizeGuideIcon() {
    return Container(
      padding: EdgeInsets.only(right: 10),
      child: Icon(Icons.piano),
    );
  }

  Widget _createSizeGuideText() {
    return const Text(
      "Size Guide",
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    );
  }

  Widget _createViewSizeGuide(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Nav.toNamed(context, App.imagegalleryzoom, arguments: sizeGuideLink);
      },
      child: Container(
        padding: EdgeInsets.all(10),
        child: Text(
          "View Size Guide",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            decoration: TextDecoration.underline,
            color: beige,
            decorationColor: beige,
          ),
        ),
      ),
    );
  }

  Widget _createSizeSelectionTags() {
    return Tags(
      itemCount: sizesList.length, // required
      itemBuilder: (int index) {
        final item = sizesList[index];

        return ItemTags(
          // Each ItemTags must contain a Key. Keys allow Flutter to
          // uniquely identify widgets.
          key: Key(index.toString()),
          index: index, // required
          title: item.getTitle(),
          textStyle: TextStyle(fontSize: 14),
          icon: null,
          color: Colors.white,
          activeColor: Colors.black,
          textActiveColor: Colors.white,
          elevation: 0,
          borderRadius: BorderRadius.all(Radius.zero),
          border: BoxBorder.all(width: 1, color: beige),
          singleItem: true,
          padding: EdgeInsets.all(10),
          onPressed: (tag) {
            onTap?.call(item, index);
          },
        );
      },
    );
  }
}
