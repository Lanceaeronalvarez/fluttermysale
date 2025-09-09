import 'package:flutter/material.dart';
import 'package:flutter_mysale/core/classes/route_manager.dart';
import 'package:zoom_hover_pinch_image/zoom_hover_pinch_image.dart';

class ImageGalleryZoomWidget extends StatefulWidget {
  const ImageGalleryZoomWidget({super.key});

  @override
  State<ImageGalleryZoomWidget> createState() => _ImageGalleryZoomWidgetState();
}

class _ImageGalleryZoomWidgetState extends State<ImageGalleryZoomWidget> {
  // Default fallback data

  final ZoomManager zoomManager = ZoomManager();

  String selectedImage = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    selectedImage = ModalRoute.of(context)?.settings.arguments as String;
  }

  Widget mainImageContainer(String imageUrl) {
    return Stack(children: [_mainImage(imageUrl), _closeButton()]);
  }

  Widget _mainImage(String imageUrl) {
    return Positioned(
      bottom: 0,
      top: 0,
      left: 0,
      right: 0,
      child: Zoom.zoomOnTap(
        zoomManager: zoomManager,
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
          width: MediaQuery.sizeOf(context).width,
        ),
      ),
    );
  }

  Widget _closeButton() {
    return Positioned(
      top: 0,
      right: 0,
      child: GestureDetector(
        onTap: () {
          print("close");
          Nav.close(context);
        },
        child: Container(height: 30, width: 30, child: Icon(Icons.close)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 30),
      decoration: const BoxDecoration(color: Colors.white),
      child: mainImageContainer(selectedImage),
    );
  }
}
