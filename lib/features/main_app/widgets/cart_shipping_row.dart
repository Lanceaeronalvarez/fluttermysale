import 'package:flutter/material.dart';
import 'package:flutter_mysale/features/main_app/models/main/cart/cart_shipment_model.dart';
import 'package:flutter_mysale/features/main_app/utils/helpers.dart';

class CartShippingRow extends StatelessWidget {
  final CartShipment shipment;
  final int section;
  final int row;
  final Color sectionColor;
  final bool showDivider;

  static const double _padding = 8;
  final String _freeShippingImage = "assets/images/free_shipping.png";
  final double _imageHeight = 13;

  const CartShippingRow({
    super.key, // pass ValueKey(stableId) from the SliverList
    required this.shipment,
    required this.section,
    required this.row,
    required this.sectionColor,
    required this.showDivider,
  });

  static const _bold = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w800,
    color: Colors.black,
  );
  static const _regular = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );

  @override
  Widget build(BuildContext context) {
    return _createParentContainer();
  }

  Widget _createParentContainer() {
    return KeyedSubtree(
      key: key ?? ObjectKey(shipment),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              color: sectionColor,
              child: Padding(
                padding: const EdgeInsets.all(_padding),
                child: _createShippingContainer(),
              ),
            ),
            if (showDivider) Divider(height: 1, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _createShippingContainer() {
    return Align(
      alignment: Alignment.centerRight,
      child: ((shipment.deliveryPrice ?? 0) == 0)
          ? _createFreeShipping()
          : _createShippingText(),
    );
  }

  Widget _createShippingText() {
    double amountToPromoPrice = shipment.amountToPromoPrice ?? 0;
    Widget shipping = RichText(
      text: TextSpan(
        style: _regular,
        children: [
          TextSpan(text: 'Shipping to Postcode '),
          TextSpan(text: shipment.estimateShipmentPostcode ?? '', style: _bold),
          TextSpan(text: ': ${shipment.deliveryPrice?.toMoneyString() ?? ''}'),
        ],
      ),
    );
    if (amountToPromoPrice > 0) {
      Widget promoPrice = RichText(
        textAlign: TextAlign.right,
        text: TextSpan(
          style: _regular,
          children: [
            TextSpan(
              text:
                  'Add extra ${amountToPromoPrice.toMoneyString()} of eligible products to get ',
            ),
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              baseline: TextBaseline.alphabetic,
              child: SizedBox(
                height: _imageHeight,
                child: Image.asset(_freeShippingImage),
              ),
            ),
          ],
        ),
      );
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [shipping, promoPrice],
      );
    } else {
      return shipping;
    }
  }

  Widget _createFreeShipping() {
    return SizedBox(
      height: _imageHeight,
      child: Image.asset(_freeShippingImage),
    );
  }
}
