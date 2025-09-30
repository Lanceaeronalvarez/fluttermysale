import 'package:flutter/material.dart';

import '../models/model.dart';

class AddressCard extends StatelessWidget {
  final AddressItem? address;
  final VoidCallback onTap;
  final bool showChevron;

  const AddressCard({
    super.key,
    required this.address,
    required this.onTap,
    this.showChevron = true,
  });

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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: _createTextColumn()),
          if (showChevron) _createIcon(),
        ],
      ),
    );
  }

  Widget _createTextColumn() {
    if (address == null) {
      return const Text("Add new address");
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _createName(),
        const SizedBox(height: 4),
        _createAddressLine(),
        _createSuburbCityPostcode(),
        _createPhone(),
      ],
    );
  }

  Widget _createName() {
    return Text(
      address?.name ?? "Add new address",
      style: const TextStyle(fontWeight: FontWeight.w600),
    );
  }

  Widget _createAddressLine() {
    if (address?.addressLines?.isEmpty ?? true) return const SizedBox.shrink();
    return Text(address!.addressLines!);
  }

  Widget _createSuburbCityPostcode() {
    final suburb = address?.suburb ?? "";
    final city = address?.city ?? "";
    final postcode = address?.postcode ?? "";
    if ([suburb, city, postcode].every((e) => e.isEmpty)) {
      return const SizedBox.shrink();
    }
    return Text("$suburb, $city $postcode");
  }

  Widget _createPhone() {
    if (address?.phone?.isEmpty ?? true) return const SizedBox.shrink();
    return Text(address!.phone!);
  }

  Widget _createIcon() {
    return const Icon(Icons.chevron_right);
  }
}
