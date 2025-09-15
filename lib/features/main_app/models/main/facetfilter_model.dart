import 'package:json_annotation/json_annotation.dart';

part 'facetfilter_model.g.dart';

@JsonSerializable()
class FacetFilterModel {
  String? name;
  List<FacetFilterValueModel>? values;

  FacetFilterModel(this.name, this.values);

  factory FacetFilterModel.fromJson(Map<String, dynamic> json) =>
      _$ProductListFacetModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductListFacetModelToJson(this);
}

@JsonSerializable()
class FacetFilterValueModel {
  String? value;
  int? count;

  FacetFilterValueModel(this.value, this.count);

  factory FacetFilterValueModel.fromJson(Map<String, dynamic> json) =>
      _$ValueFromJson(json);

  Map<String, dynamic> toJson() => _$ValueToJson(this);
}
