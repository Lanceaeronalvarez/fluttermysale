import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ImageGalleryWidget extends StatefulWidget {
  final List<ImageGallery>? images;

  const ImageGalleryWidget({super.key, this.images});

  @override
  State<ImageGalleryWidget> createState() => _ImageGalleryWidgetState();
}

class _ImageGalleryWidgetState extends State<ImageGalleryWidget> {
  // Default fallback data
  final List<ImageGallery> images = [
    ImageGallery(
      imageUrl:
          'https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?q=80&w=1672&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ImageGallery(
      imageUrl:
          'https://plus.unsplash.com/premium_photo-1675186049222-0b5018db6ce9?q=80&w=987&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ImageGallery(
      imageUrl:
          'https://plus.unsplash.com/premium_photo-1728759436968-db4b52249ffa?q=80&w=2071&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ImageGallery(
      imageUrl:
          'https://images.unsplash.com/photo-1516762689617-e1cffcef479d?q=80&w=1011&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ImageGallery(
      imageUrl:
          'https://plus.unsplash.com/premium_photo-1676225678979-80df276a983e?q=80&w=2069&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    ImageGallery(
      imageUrl:
          'https://images.unsplash.com/photo-1670014543406-a26719b352ca?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
  ];

  final ItemScrollController itemScrollController = ItemScrollController();

  String selectedImage = "";
  int selectedImageIndex = 0;

  @override
  void initState() {
    super.initState();
    selectedImage = images.first.imageUrl;
  }

  Widget imageListRowWithChevron() {
    final List<ImageGallery> imagesList = widget.images ?? images;

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
              return rowImage(imagesList[index].imageUrl, index);
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
    return images.length > 3
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
    return images.length > 3
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
      child: Container(
        color: Colors.white,
        height: 60,
        width: 60,
        child: const Icon(Icons.zoom_in, size: 50),
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
      selectedImage = images[selectedImageIndex].imageUrl;
      selectedImageIndex = selectedImageIndex;
    });
  }

  void moveToImageAfterIndex() {
    int newSelectedIndex = selectedImageIndex + 1;
    selectedImageIndex = images.length > newSelectedIndex
        ? newSelectedIndex
        : selectedImageIndex;

    itemScrollController.scrollTo(
      index: selectedImageIndex,
      duration: const Duration(seconds: 1),
    );

    setState(() {
      selectedImage = images[selectedImageIndex].imageUrl;
      selectedImageIndex = selectedImageIndex;
    });
  }
}

class ImageGallery {
  final String imageUrl;

  ImageGallery({required this.imageUrl});
}
