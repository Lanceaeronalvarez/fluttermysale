import 'package:flutter_mysale/features/main_app/models/main/productitem_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recentlyviewed_model.g.dart';

@JsonSerializable()
class GetRecentlyViewedResponse extends ProductItem {
  String? masterProductId;

  GetRecentlyViewedResponse(
    this.masterProductId,
    super.id,
    super.name,
    super.brandName,
    super.description,
    super.labelText,
    super.price,
    super.originalPrice,
    super.priceRange,
    super.priceRangeText,
    super.images,
    super.isAvailable,
    super.priceDescription,
    super.categories,
    super.skus,
    super.seoIdentifier,
    super.isSoldOut,
    super.salePercentOff,
    super.isFreeDelivery,
    super.salePrice,
    super.salePercentOffText,
    super.deliveryThreshold,
    super.deliveryType,
    super.savedMoneyValue,
    super.totalPercentOff,
  );

  factory GetRecentlyViewedResponse.fromJson(Map<String, dynamic> json) =>
      _$GetRecentlyViewedResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetRecentlyViewedResponseToJson(this);
}
