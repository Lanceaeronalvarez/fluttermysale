import 'package:json_annotation/json_annotation.dart';

part 'cart_item_model.g.dart';

class CartItem {
  // JSON keys
  static const _kID = 'ID';
  static const _kItemID = 'ItemID';
  static const _kItem = 'Item';
  static const _kSize = 'Size';
  static const _kItemsCount = 'ItemsCount';
  static const _kQty = 'Qty';
  static const _kOrigQty = 'OrigQty'; //local key only
  static const _kCount = 'Count';
  static const _kPrice = 'Price';
  static const _kSubtotal = 'Subtotal';
  static const _kBrandID = 'BrandID';
  static const _kBrandName = 'BrandName';
  static const _kImageID = 'ImageID';
  static const _kFileName = 'FileName';
  static const _kFile = 'File';
  static const _kCategory = 'Category';
  static const _kCategorySeparator = ' > ';
  static const _kDiscount = 'Discount';
  static const _kDiscountPercentOff = 'DiscountPercentOff';
  static const _kSubtotalWithDiscount = 'SubtotalWithDiscount';
  static const _kCustomizableItemDetails = 'CustomizableItemDetails';
  static const _kMultiBuyEnabled = 'MultiBuyEnabled';
  static const _kMultiBuyCount = 'MultiBuyCount';
  static const _kMultiBuyDiscountPrice = 'MultiBuyDiscountPrice';
  static const _kIsAgeRestricted = 'IsAgeRestricted';

  final String id;
  final String itemId;
  final String item;
  final String? size;
  final int qty;
  final int origQty;
  final double price;
  final double subtotal;
  final String brandId;
  final String brandName;
  final String imageId;
  final String fileName;
  final String? category;
  final double discount;
  final double? discountPercentOff;
  final double? subtotalWithDiscount;
  final List<CustomizableItemDetail> customizableItemDetails;
  final bool multiBuyEnabled;
  final int multiBuyCount;
  final double multiBuyDiscountPrice;
  final bool isAgeRestricted;

  const CartItem({
    required this.id,
    required this.itemId,
    required this.item,
    this.size,
    required this.qty,
    required this.origQty,
    required this.price,
    required this.subtotal,
    required this.brandId,
    required this.brandName,
    required this.imageId,
    required this.fileName,
    required this.category,
    required this.discount,
    this.discountPercentOff,
    this.subtotalWithDiscount,
    this.customizableItemDetails = const [],
    this.multiBuyEnabled = false,
    this.multiBuyCount = 0,
    this.multiBuyDiscountPrice = 0,
    this.isAgeRestricted = false,
  });

  /// small case-insensitive getter for typed values
  static T? _ci<T>(Map<String, dynamic> json, String wantedKey) {
    final lower = wantedKey.toLowerCase();
    for (final k in json.keys) {
      if (k.toLowerCase() == lower) return json[k] as T?;
    }
    return null;
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final String? id = _ci<String>(json, _kID);
    final String itemId = _ci<String>(json, _kItemID) ?? '';
    final String item = _ci<String>(json, _kItem) ?? '';
    String? size = _ci<String>(json, _kSize);
    if (size == '-') size = null;
    final int? itemsCount = _ci<num>(json, _kItemsCount)?.toInt();
    final int? qty = _ci<num>(json, _kQty)?.toInt();
    final int? count = _ci<num>(json, _kCount)?.toInt();
    final double price = _ci<num>(json, _kPrice)?.toDouble() ?? 0;
    final double subtotal = _ci<num>(json, _kSubtotal)?.toDouble() ?? 0;
    final String brandName = _ci<String>(json, _kBrandName) ?? '';

    final String brandId = _ci<String>(json, _kBrandID) ?? '';
    final String imageId = _ci<String>(json, _kImageID) ?? '';
    final String fileName =
        _ci<String>(json, _kFileName) ?? (_ci<String>(json, _kFile) ?? '');
    final String? category = _ci<String>(json, _kCategory);
    final double discount = _ci<num>(json, _kDiscount)?.toDouble() ?? 0.0;

    final double? discountPercentOff = _ci<num>(
      json,
      _kDiscountPercentOff,
    )?.toDouble();
    final double? subtotalWithDiscount = _ci<num>(
      json,
      _kSubtotalWithDiscount,
    )?.toDouble();

    final List<dynamic> rawDetails =
        _ci<List<dynamic>>(json, _kCustomizableItemDetails) ?? const [];
    final details = rawDetails
        .map((e) => CustomizableItemDetail.fromJson(e as Map<String, dynamic>))
        .toList();

    final bool multiBuyEnabled = _ci<bool>(json, _kMultiBuyEnabled) ?? false;
    final int multiBuyCount = _ci<num>(json, _kMultiBuyCount)?.toInt() ?? 0;
    final double multiBuyDiscountPrice =
        _ci<num>(json, _kMultiBuyDiscountPrice)?.toDouble() ?? 0.0;

    final bool isAgeRestricted = _ci<bool>(json, _kIsAgeRestricted) ?? false;

    return CartItem(
      id: id ?? itemId,
      itemId: itemId,
      item: item,
      size: size,
      qty: itemsCount ?? (qty ?? (count ?? 0)),
      origQty: qty ?? 0,
      price: price,
      subtotal: subtotal,
      brandId: brandId,
      brandName: brandName,
      imageId: imageId,
      fileName: fileName,
      category: category,
      discount: discount,
      discountPercentOff: discountPercentOff,
      subtotalWithDiscount: subtotalWithDiscount,
      customizableItemDetails: details,
      multiBuyEnabled: multiBuyEnabled,
      multiBuyCount: multiBuyCount,
      multiBuyDiscountPrice: multiBuyDiscountPrice,
      isAgeRestricted: isAgeRestricted,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    _kID: id,
    _kItemID: itemId,
    _kItem: item,
    _kSize: size,
    _kQty: qty,
    _kOrigQty: origQty,
    _kPrice: price,
    _kSubtotal: subtotal,
    _kBrandID: brandId,
    _kBrandName: brandName,
    _kImageID: imageId,
    _kFileName: fileName,
    _kCategory: category,
    _kDiscount: discount,
    _kDiscountPercentOff: discountPercentOff,
    _kSubtotalWithDiscount: subtotalWithDiscount,
    _kCustomizableItemDetails: customizableItemDetails
        .map((e) => e.toJson())
        .toList(),
    _kMultiBuyEnabled: multiBuyEnabled,
    _kMultiBuyCount: multiBuyCount,
    _kMultiBuyDiscountPrice: multiBuyDiscountPrice,
    _kIsAgeRestricted: isAgeRestricted,
  };

  List<String> getCategoryComponents() {
    return (category ?? '').split(_kCategorySeparator);
  }

  String getImageUrl() {
    //TODO: JCA imageServerUrl should be retrieved from GET /papi/public/v3.31/api.ashx/GetServerSettings?countryID=as
    String imageServerUrl = 'https://c1.mysalec.com/';
    return "$imageServerUrl/brands/$brandId/$imageId/${Uri.encodeComponent(fileName)}";
  }
}

@JsonSerializable()
class CustomizableItemDetail {
  @JsonKey(name: 'Key')
  final String? key;
  @JsonKey(name: 'Value')
  final String? value;

  const CustomizableItemDetail({this.key, this.value});

  factory CustomizableItemDetail.fromJson(Map<String, dynamic> json) =>
      _$CustomizableItemDetailFromJson(json);
  Map<String, dynamic> toJson() => _$CustomizableItemDetailToJson(this);
}
