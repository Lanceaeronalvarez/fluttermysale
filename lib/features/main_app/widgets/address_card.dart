import 'package:flutter/material.dart';

import '../models/model.dart';

class AddressCard extends StatelessWidget {
  final AddressItem? address;
  final VoidCallback onTap;

  const AddressCard({super.key, required this.address, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return _buildGestureDetector();
  }

  Widget _buildGestureDetector() {
    return GestureDetector(onTap: onTap, child: _buildContainer());
  }

  Widget _buildContainer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey, width: 1),
          bottom: BorderSide(color: Colors.grey, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: _createTextColumn()),
          _createIcon(),
        ],
      ),
    );
  }

  Widget _createTextColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _createName(),
        const SizedBox(height: 4),
        if (address != null) _createSuburbCityPostcodePhone(),
      ],
    );
  }

  Widget _createName() {
    return Text(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      address?.name ?? "Add new address",
    );
  }

  Widget _createSuburbCityPostcodePhone() {
    return Text(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      '${address!.addressLines} ${address!.suburb} ${address!.city} ${address!.postcode} ${address!.phone}',
    );
  }

  Widget _createIcon() {
    return const Icon(Icons.chevron_right);
  }
}
