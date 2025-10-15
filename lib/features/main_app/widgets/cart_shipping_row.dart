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
    return RichText(
      text: TextSpan(
        style: _regular,
        children: [
          TextSpan(text: 'Shipping to Postcode '),
          TextSpan(text: shipment.estimateShipmentPostcode ?? '', style: _bold),
          TextSpan(text: ': ${shipment.deliveryPrice?.toMoneyString() ?? ''}'),
        ],
      ),
    );
  }

  //TODO: JCA change to image
  Widget _createFreeShipping() {
    return Text('Free Shipping', style: _regular);
  }
}
