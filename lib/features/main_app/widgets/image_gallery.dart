import 'package:flutter/material.dart';
import 'package:flutter_mysale/core/classes/route_manager.dart';
import 'package:flutter_mysale/features/main_app/app.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ImageGalleryWidget extends StatefulWidget {
  final List<String>? images;

  const ImageGalleryWidget({super.key, this.images});

  @override
  State<ImageGalleryWidget> createState() => _ImageGalleryWidgetState();
}

class _ImageGalleryWidgetState extends State<ImageGalleryWidget> {
  final ItemScrollController itemScrollController = ItemScrollController();

  String selectedImage = "";
  int selectedImageIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.images != null && widget.images!.isNotEmpty) {
      selectedImage = widget.images!.first;
    }
  }

  Widget imageListRowWithChevron() {
    final List<String> imagesList = widget.images ?? [];

    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        SizedBox(
          height: 200,
          child: ScrollablePositionedList.builder(
            scrollDirection: Axis.horizontal,
            itemCount: imagesList.length,
            itemScrollController: itemScrollController,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return rowImage(imagesList[index], index);
            },
          ),
        ),
        leftButton(),
        rightButton(),
      ],
    );
  }

  Widget rowImage(String imageUrl, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedImage = imageUrl;
          selectedImageIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
          width: 120,
          height: 200,
        ),
      ),
    );
  }

  Widget leftButton() {
    return widget.images!.length > 3
        ? Positioned(
            bottom: 0,
            top: 0,
            left: 0,
            child: Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  moveToImageBeforeIndex();
                },
                child: Container(
                  height: 50,
                  color: const Color.fromARGB(196, 220, 219, 219),
                  child: const Icon(Icons.chevron_left, size: 40),
                ),
              ),
            ),
          )
        : const SizedBox();
  }

  Widget rightButton() {
    return widget.images!.length > 3
        ? Positioned(
            bottom: 0,
            top: 0,
            right: 0,
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  moveToImageAfterIndex();
                },
                child: Container(
                  height: 50,
                  color: const Color.fromARGB(196, 220, 219, 219),
                  child: const Icon(Icons.chevron_right, size: 40),
                ),
              ),
            ),
          )
        : const SizedBox();
  }

  Widget mainImageContainer(String imageUrl) {
    return Stack(children: [mainImage(imageUrl), zoomButton()]);
  }

  Widget mainImage(String imageUrl) {
    return SizedBox(
      child: Image.network(
        imageUrl,
        fit: BoxFit.contain,
        width: MediaQuery.sizeOf(context).width,
        height: 300,
      ),
    );
  }

  Widget zoomButton() {
    return Positioned(
      bottom: 0,
      right: 0,
      child: GestureDetector(
        onTap: () {
          Nav.toNamed(context, App.imagegalleryzoom, arguments: selectedImage);
        },
        child: Container(
          color: Colors.white,
          height: 60,
          width: 60,
          child: const Icon(Icons.zoom_in, size: 50),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          mainImageContainer(selectedImage),
          imageListRowWithChevron(),
        ],
      ),
    );
  }

  void moveToImageBeforeIndex() {
    int newSelectedIndex = selectedImageIndex - 1;
    selectedImageIndex = 0 <= newSelectedIndex
        ? newSelectedIndex
        : selectedImageIndex;

    itemScrollController.scrollTo(
      index: selectedImageIndex,
      duration: const Duration(seconds: 1),
    );

    setState(() {
      selectedImage = widget.images![selectedImageIndex];
      selectedImageIndex = selectedImageIndex;
    });
  }

  void moveToImageAfterIndex() {
    int newSelectedIndex = selectedImageIndex + 1;
    selectedImageIndex = widget.images!.length > newSelectedIndex
        ? newSelectedIndex
        : selectedImageIndex;

    itemScrollController.scrollTo(
      index: selectedImageIndex,
      duration: const Duration(seconds: 1),
    );

    setState(() {
      selectedImage = widget.images![selectedImageIndex];
      selectedImageIndex = selectedImageIndex;
    });
  }
}
