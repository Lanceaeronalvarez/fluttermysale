import 'package:json_annotation/json_annotation.dart';

part 'productlistfacet_model.g.dart';

@JsonSerializable()
class ProductListFacetModel {
  String? name;
  List<Value>? values;

  ProductListFacetModel(this.name, this.values);

  factory ProductListFacetModel.fromJson(Map<String, dynamic> json) =>
      _$ProductListFacetModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductListFacetModelToJson(this);
}

@JsonSerializable()
class Value {
  String? value;
  int? count;

  Value(this.value, this.count);

  factory Value.fromJson(Map<String, dynamic> json) => _$ValueFromJson(json);

  Map<String, dynamic> toJson() => _$ValueToJson(this);
}
