import 'package:json_annotation/json_annotation.dart';

part 'productsort_model.g.dart';

@JsonSerializable()
class ProductSortModel {
  String? key;
  String? title;

  ProductSortModel({required this.key, required this.title});

  factory ProductSortModel.fromJson(Map<String, dynamic> json) => _$ProductSortModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductSortModelToJson(this);
}
