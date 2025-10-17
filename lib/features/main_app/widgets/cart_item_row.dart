import 'package:flutter/material.dart';
import 'package:flutter_mysale/features/main_app/models/main/cart/cart_item_model.dart';
import 'package:flutter_mysale/features/main_app/utils/helpers.dart';
import 'package:flutter_mysale/features/main_app/widgets/qty_stepper.dart';

class CartItemRow extends StatelessWidget {
  final bool isLoading;
  final CartItem item;
  final int section;
  final int row;
  final Color sectionColor;
  final bool showPriceAtBottom;
  final bool showDivider;

  final Function(CartItem)? onTap;
  final Function(CartItem)? onPlus;
  final Function(CartItem)? onMinus;
  final Function(CartItem)? onRemove;

  const CartItemRow({
    super.key, // pass ValueKey(stableId) from the SliverList
    required this.isLoading,
    required this.item,
    required this.section,
    required this.row,
    required this.sectionColor,
    required this.showPriceAtBottom,
    required this.showDivider,
    required this.onTap,
    required this.onPlus,
    required this.onMinus,
    required this.onRemove,
  });

  static const double _padding = 8;
  static const double _imageSize = 40;
  static const double _stepperWidth = 120;
  static const _bold = TextStyle(fontSize: 16, fontWeight: FontWeight.w800);
  static const _regular = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: Colors.black54,
  );

  @override
  Widget build(BuildContext context) {
    return _createParentContainer();
  }

  Widget _createParentContainer() {
    return KeyedSubtree(
      key: key ?? ObjectKey(item),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: isLoading
            ? null
            : () {
                onTap?.call(item);
              },
        child: Column(
          children: [
            Container(
              color: sectionColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: _padding,
                  vertical: _padding * 2,
                ),
                child: _createProductContainer(),
              ),
            ),
            if (showDivider) Divider(height: 1, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _createProductContainer() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _createImage(item.getImageUrl()),
            const SizedBox(width: _padding),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _topRow(),
                  const SizedBox(height: _padding),
                  _bottomRow(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _createImage(String? url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        width: _imageSize,
        height: _imageSize,
        child: (url != null && url.trim().isNotEmpty)
            ? Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox(),
              )
            : const SizedBox(),
      ),
    );
  }

  Widget _topRow() {
    bool hasSize = item.size != null && item.size!.trim().isNotEmpty;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [_createNameLabel(), if (hasSize) _createVariantLabel()],
          ),
        ),
        if (!showPriceAtBottom) const SizedBox(width: _padding),
        if (!showPriceAtBottom) _createPriceLabel(),
      ],
    );
  }

  Widget _createNameLabel() {
    return Text(
      item.item,
      overflow: TextOverflow.ellipsis,
      style: _bold,
      maxLines: 3,
    );
  }

  Widget _createVariantLabel() {
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Text(
        item.size ?? '',
        overflow: TextOverflow.ellipsis,
        style: _regular,
      ),
    );
  }

  Widget _createPriceLabel() {
    final subtotal = item.subtotal.toMoneyString();
    if (item.discount > 0) {
      final subtotalWithDiscount = item.subtotalWithDiscount!.toMoneyString();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(subtotalWithDiscount, style: _bold),
          Text(
            'WAS $subtotal',
            style: const TextStyle(
              color: Colors.black38,
              decorationColor: Colors.black38,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.lineThrough,
              decorationThickness: 2,
              decorationStyle: TextDecorationStyle.solid,
            ),
          ),
        ],
      );
    } else {
      return Text(subtotal, style: _bold);
    }
  }

  Widget _bottomRow() {
    return Row(
      children: [
        QtyStepper(
          isLoading: isLoading,
          value: item.qty,
          onMinus: (_) {
            if (!isLoading) {
              onMinus?.call(item);
            }
          },
          onPlus: (_) {
            if (!isLoading) {
              onPlus?.call(item);
            }
          },
          width: _stepperWidth,
        ),
        _createRemoveButton(),
        if (showPriceAtBottom) const SizedBox(width: _padding),
        if (showPriceAtBottom) _createPriceLabel(),
      ],
    );
  }

  Widget _createRemoveButton() {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: isLoading
            ? null
            : () {
                onRemove?.call(item);
              },
        child: const Padding(
          padding: EdgeInsets.all(_padding),
          child: Text(
            "Remove",
            maxLines: 1,
            overflow: TextOverflow.clip,
            style: TextStyle(
              color: Color(0xFFB88A5A),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
