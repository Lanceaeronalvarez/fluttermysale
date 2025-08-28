class _BrandKeys {
  const _BrandKeys();
  final String name = 'name';
  final String value = 'value';
}

class CategoryBrandModel {
  static const K = _BrandKeys();

  final String? name;
  final double? value;

  const CategoryBrandModel({this.name, this.value});

  factory CategoryBrandModel.fromJson(Map<String, dynamic> j) =>
      CategoryBrandModel(
        name: j[K.name] as String?,
        value: (j[K.value] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
    if (name != null) K.name: name,
    if (value != null) K.value: value,
  };
}
