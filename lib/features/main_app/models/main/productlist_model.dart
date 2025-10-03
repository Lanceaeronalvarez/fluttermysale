import 'dart:convert';
import 'dart:core';

import 'package:flutter_mysale/features/main_app/models/main/categorynode_model.dart';
import 'package:flutter_mysale/features/main_app/models/main/productitem_model.dart';
import 'package:flutter_mysale/features/main_app/models/main/facetfilter_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'productlist_model.g.dart';

class GetProductListRequest {
  String? query;
  String? pageNumberString;
  String? pageSize;
  String? categoryKey;
  String? facetFilter;
  String? sorting;

  GetProductListRequest(
    this.query,
    this.pageNumberString,
    this.pageSize,
    this.categoryKey,
    this.facetFilter,
    this.sorting,
  );

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'q': query,
      'pn': pageNumberString,
      'ps': pageSize,
      'c': categoryKey,
      'ff': facetFilter,
      'sa': sorting,
    };
    map.removeWhere((k, v) => (v == null));
    return map;
  }

  @override
  String toString() {
    var encoder = JsonEncoder.withIndent("   ");
    return encoder.convert(toMap());
  }
}

@JsonSerializable()
class ProductListResponse {
  List<CategoryNodeModel>? categories;
  int? count;
  bool? excludeSearchDetails;
  int? hits;
  int? page;
  int? pages;
  List<ProductItem>? products;
  String? query;
  List<ProductItem>? recommendedProducts;
  int? total;

  List<FacetFilterModel>? facets;

  ProductListResponse(
    this.categories,
    this.count,
    this.excludeSearchDetails,
    this.hits,
    this.page,
    this.pages,
    this.products,
    this.query,
    this.recommendedProducts,
    this.total,
    this.facets,
  );

  factory ProductListResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProductListResponseToJson(this);
}
