import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class CollapsibleDescription extends StatefulWidget {
  final String title;
  final String htmlText;
  final int previewLines;

  const CollapsibleDescription({
    super.key,
    this.title = "Product Description",
    required this.htmlText,
    this.previewLines = 11,
  });

  @override
  State<CollapsibleDescription> createState() => _CollapsibleDescriptionState();
}

class _CollapsibleDescriptionState extends State<CollapsibleDescription> {
  bool _expanded = false;
  bool _isOverflowing = false;

  final GlobalKey _htmlKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkOverflow());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _createTitle(),
          const SizedBox(height: 8),
          _createDescription(),
          _createToggleButton(),
        ],
      ),
    );
  }

  void _checkOverflow() {
    final renderBox = _htmlKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final maxHeight = widget.previewLines * 20.0;
      setState(() {
        _isOverflowing = renderBox.size.height > maxHeight;
      });
    }
  }

  Widget _createTitle() {
    return Row(
      children: [
        Image.asset(
          "assets/images/prod_description.png",
          width: 20,
          height: 20,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 6),
        Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }

  Widget _createDescription() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            ConstrainedBox(
              constraints: !_isOverflowing || _expanded
                  ? const BoxConstraints()
                  : BoxConstraints(maxHeight: widget.previewLines * 20.0),
              child: Html(
                key: _htmlKey,
                data: widget.htmlText,
                style: {
                  "body": Style(
                    margin: Margins.zero,
                    padding: HtmlPaddings.zero,
                    fontSize: FontSize(14),
                    lineHeight: LineHeight.number(1.3),
                    color: Colors.black,
                  ),
                },
              ),
            ),
            if (_isOverflowing && !_expanded)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 40,
                child: IgnorePointer(
                  child: Container(color: Colors.white.withOpacity(0.7)),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _createToggleButton() {
    if (!_isOverflowing) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Text(
          _expanded ? "read less" : "read more",
          style: const TextStyle(
            color: Colors.brown,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
