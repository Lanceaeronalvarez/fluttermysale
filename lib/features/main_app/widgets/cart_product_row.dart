import 'package:flutter/material.dart';
import 'package:flutter_mysale/features/main_app/models/main/productitem_model.dart';
import 'package:flutter_mysale/features/main_app/widgets/qty_stepper.dart';

//TODO: JCA will probably be just a temp interface
abstract class CartProductItem {
  String? getImageUrl();
  String getName();
  String? getVariant();
  int getSelectedQuantity();
  String getTotalPrice();
}

//TODO: JCA temp model
class CartProductWrapper extends CartProductItem {
  ProductItem product;

  CartProductWrapper({required this.product});

  @override
  String? getImageUrl() => product.images?.firstOrNull;
  @override
  String getName() => product.name ?? '';
  @override
  String getVariant() => product.skus?.firstOrNull?.name ?? '';
  @override
  int getSelectedQuantity() => 1;
  @override
  String getTotalPrice() =>
      '${product.price?.currency ?? ''}${product.price?.value ?? 0}';

  static Sku tempSku() {
    return Sku(
      '1',
      null,
      'one size',
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
    );
  }

  static List<CartProductWrapper> tempList() {
    return [
      ProductItem(
        "1",
        "Air Max 270",
        "Nike",
        "Breathable running shoes with modern design.",
        "Best Seller",
        Price("USD", 120.0),
        Price("USD", 150.0),
        null,
        null,
        [
          "https://cdn.mysalemarketplace.com/v1/files/bffa8ee4-22e7-45fa-805a-883311382e86/f77e22ffe59d8daa2c2ea933918e1a17_225x360.jpg?profile=img&b",
        ],
        true,
        "Now only \$120",
        ["Shoes", "Sportswear"],
        [CartProductWrapper.tempSku()],
        "nike-air-max-270",
        false,
        20,
        true,
        SalePrice("USD", 120.0),
        "20% OFF",
        50,
        "Standard",
        30.0,
        20.0,
      ),
      ProductItem(
        "2",
        "Galaxy S23",
        "Samsung",
        "Latest flagship smartphone with pro-grade camera.",
        "Hot Deal",
        Price("USD", 999.0),
        Price("USD", 1199.0),
        null,
        null,
        [
          "https://cdn.mysalemarketplace.com/v1/files/bffa8ee4-22e7-45fa-805a-883311382e86/b77612f2fde3582ccdb066f004a51ff7_225x360.jpg?profile=img&b",
        ],
        true,
        "Discounted to \$999",
        ["Electronics", "Smartphones"],
        [],
        "samsung-galaxy-s23",
        false,
        15,
        true,
        SalePrice("USD", 5),
        "15% OFF",
        0,
        "Express",
        200.0,
        15.0,
      ),
    ].map((e) {
      return CartProductWrapper(product: e);
    }).toList();
  }
}

class CartProductRow extends StatelessWidget {
  final CartProductItem item;
  final Color sectionColor;
  final bool showPriceAtBottom;
  final bool showDivider;

  final Function(CartProductItem)? onTap;
  final Function(CartProductItem)? onPlus;
  final Function(CartProductItem)? onMinus;
  final Function(CartProductItem)? onRemove;

  const CartProductRow({
    super.key, // pass ValueKey(stableId) from the SliverList
    required this.item,
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
        onTap: () {
          onTap?.call(item);
        },
        child: Column(
          children: [
            Container(
              color: sectionColor,
              child: Padding(
                padding: const EdgeInsets.all(_padding),
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
    bool hasVariant =
        item.getVariant() != null && item.getVariant()!.trim().isNotEmpty;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Expanded horizontally is OK inside Row
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // shrink-wrap
            children: [
              _createNameLabel(),
              if (hasVariant) _createVariantLabel(),
            ],
          ),
        ),
        if (!showPriceAtBottom) const SizedBox(width: _padding),
        if (!showPriceAtBottom) _createPriceLabel(),
      ],
    );
  }

  Widget _createNameLabel() {
    return Text(item.getName(), overflow: TextOverflow.ellipsis, style: _bold);
  }

  Widget _createVariantLabel() {
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Text(
        item.getVariant() ?? '',
        overflow: TextOverflow.ellipsis,
        style: _regular,
      ),
    );
  }

  Widget _createPriceLabel() {
    return Text(item.getTotalPrice(), style: _bold);
  }

  Widget _bottomRow() {
    return Row(
      children: [
        // Your existing QtyStepper (outer-border version); no code shown here
        QtyStepper(
          value: item.getSelectedQuantity(),
          onMinus: (_) {
            onMinus?.call(item);
          },
          onPlus: (_) {
            onPlus?.call(item);
          },
          width: _stepperWidth,
        ),
        _createRemoveButton(),
        const Spacer(),
        if (showPriceAtBottom) const SizedBox(width: _padding),
        if (showPriceAtBottom) _createPriceLabel(),
      ],
    );
  }

  Widget _createRemoveButton() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onRemove?.call(item),
      child: const Padding(
        padding: EdgeInsets.all(_padding),
        child: Text(
          "Remove",
          style: TextStyle(
            color: Color(0xFFB88A5A),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
