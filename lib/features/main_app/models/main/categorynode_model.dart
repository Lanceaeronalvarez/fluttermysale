import 'package:flutter_mysale/features/main_app/models/main/categorybrand_model.dart';

enum NodeType {
  url,
  usual,
  brands, //custom for brands
  fixed,
  giftcards,
  clearance, //custom for clearance
  unknown;

  static NodeType? parse(String s) {
    final t = s.toLowerCase();
    for (final v in NodeType.values) {
      if (v.name.toLowerCase() == t) return v;
    }
    return null;
  }
}

class _CategoryKeys {
  const _CategoryKeys();

  final String id = 'id';
  final String payload = 'payload';
  final String count = 'count';
  final String children = 'children';
  final String brands = 'brands';
  final String categoryHasSales = 'categoryHasSales';
  final String key = 'key';
  final String nodeType = 'nodeType';
  final String name = 'name';
  final String isHighlighted = 'isHighlighted';
  final String isCustomCategory = 'isCustomCategory';
  final String textColor = 'textColor';
}

class CategoryNodeModel {
  static const K = _CategoryKeys();

  final String? id; // Present on "usual" nodes
  final String? payload; // Present on "url" nodes

  final int? count;
  final List<CategoryNodeModel>? children;
  final List<CategoryBrandModel>? brands;
  final bool? categoryHasSales;
  final String? key;
  final String? nodeType;
  final String? name;
  final bool? isHighlighted;
  final bool? isCustomCategory;
  final String? textColor;

  const CategoryNodeModel({
    this.id,
    this.payload,
    this.count,
    this.children = const [],
    this.brands = const [],
    this.categoryHasSales,
    this.key,
    this.nodeType,
    this.name,
    this.isHighlighted,
    this.isCustomCategory,
    this.textColor,
  });

  factory CategoryNodeModel.fromJson(Map<String, dynamic> j) =>
      CategoryNodeModel(
        id: j[K.id] as String?,
        payload: j[K.payload] as String?,
        count: j[K.count] as int?,
        children: (j[K.children] as List? ?? const [])
            .map((e) => CategoryNodeModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        brands: (j[K.brands] as List? ?? const [])
            .map((e) => CategoryBrandModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        categoryHasSales: j[K.categoryHasSales] as bool?,
        key: j[K.key] as String?,
        nodeType: j[K.nodeType] as String?,
        name: j[K.name] as String?,
        isHighlighted: j[K.isHighlighted] as bool?,
        isCustomCategory: j[K.isCustomCategory] as bool?,
        textColor: j[K.textColor] as String?,
      );

  Map<String, dynamic> toJson() => {
    if (id != null) K.id: id,
    if (payload != null) K.payload: payload,
    if (count != null) K.count: count,
    K.children: children?.map((e) => e.toJson()).toList(),
    K.brands: brands?.map((e) => e.toJson()).toList(),
    if (categoryHasSales != null) K.categoryHasSales: categoryHasSales,
    if (key != null) K.key: key,
    if (nodeType != null) K.nodeType: nodeType,
    if (name != null) K.name: name,
    if (isHighlighted != null) K.isHighlighted: isHighlighted,
    if (isCustomCategory != null) K.isCustomCategory: isCustomCategory,
    if (textColor != null) K.textColor: textColor,
  };

  bool get hasChild => children != null && children!.isNotEmpty;

  NodeType? getNodeType() {
    return NodeType.parse(nodeType ?? "");
  }
}
