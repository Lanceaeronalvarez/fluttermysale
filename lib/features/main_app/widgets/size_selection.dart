import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';

class SizeSelectionWidget extends StatefulWidget {
  final List<String>? sizes;

  const SizeSelectionWidget({super.key, this.sizes});

  @override
  State<SizeSelectionWidget> createState() => _SizeSelectionWidgetState();
}

class _SizeSelectionWidgetState extends State<SizeSelectionWidget> {
  Color beige = const Color.fromARGB(255, 214, 176, 118);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_createSizeGuide(), _createSizeSelectionTags()],
      ),
    );
  }

  Widget _createSizeGuide() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
      child: Row(
        children: [
          _createSizeGuideIcon(),
          _createSizeGuideText(),
          _createViewSizeGuide(),
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

  Widget _createViewSizeGuide() {
    return GestureDetector(
      onTap: () {
        //on tap logic
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
    final sizes =
        widget.sizes ?? ["X-Small", "Small", "Medium", "Large", "X-Large"];

    return Tags(
      itemCount: sizes.length, // required
      itemBuilder: (int index) {
        final item = sizes[index];

        return ItemTags(
          // Each ItemTags must contain a Key. Keys allow Flutter to
          // uniquely identify widgets.
          key: Key(index.toString()),
          index: index, // required
          title: item,
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
          onPressed: (item) {
            print(item);
          },
        );
      },
    );
  }
}
