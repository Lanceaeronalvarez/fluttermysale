import 'dart:convert';

import 'package:flutter_mysale/features/main_app/models/main/banners_linkoptions_model.dart';
import 'package:flutter_mysale/features/main_app/providers/filter_provider.dart';
import 'package:json_annotation/json_annotation.dart';

part 'facetfilter_model.g.dart';

@JsonSerializable()
class FacetFilterModel {
  String? name;
  List<FacetFilterValueModel>? values;

  FacetFilterModel(this.name, this.values);

  factory FacetFilterModel.createSupplierFromLocationFilterHash(
    String locationFilterHash,
  ) {
    List<FacetFilterValueModel> values = <FacetFilterValueModel>[];
    values.add(FacetFilterValueModel(locationFilterHash, null));
    return FacetFilterModel("supplier", values);
  }

  factory FacetFilterModel.createBrands(List<String> brands) {
    List<FacetFilterValueModel> values = <FacetFilterValueModel>[];
    brands.forEach((String s) {
      values.add(FacetFilterValueModel(s, null));
    });
    return FacetFilterModel("skus.brandName", values);
  }

  static List<FacetFilterModel> createFromLinkOptionsFacets(Facets facets) {
    List<FacetFilterModel> facetModels = [];
    if (facets.brandName != null) {
      List<FacetFilterValueModel> values = [];
      facets.brandName!.forEach((s) {
        values.add(FacetFilterValueModel(s, 1));
      });
      facetModels.add(FacetFilterModel("skus.brandName", values));
    }
    if (facets.colors != null) {
      List<FacetFilterValueModel> values = [];
      facets.colors!.forEach((s) {
        values.add(FacetFilterValueModel(s, 1));
      });
      facetModels.add(FacetFilterModel("color", values));
    }
    if (facets.sizes != null) {
      List<FacetFilterValueModel> values = [];
      facets.sizes!.forEach((s) {
        values.add(FacetFilterValueModel(s, 1));
      });
      facetModels.add(FacetFilterModel("skus.attributes.size", values));
    }
    if (facets.newArrivals != null) {
      List<FacetFilterValueModel> values = [];
      facets.newArrivals!.forEach((s) {
        values.add(FacetFilterValueModel(s, 1));
      });
      facetModels.add(FacetFilterModel("newArrivals", values));
    }
    if (facets.delivery != null) {
      List<FacetFilterValueModel> values = [];
      facets.delivery!.forEach((s) {
        values.add(FacetFilterValueModel(s, 1));
      });
      facetModels.add(FacetFilterModel("delivery", values));
    }
    if (facets.priceLimit != null) {
      facetModels.add(
        FacetFilterModel("skus.attributesForFaceting.aud", [
          FacetFilterValueModel(jsonEncode(facets.priceLimit!.toJson()), 1),
        ]),
      );
    }

    return facetModels;
  }

  factory FacetFilterModel.fromJson(Map<String, dynamic> json) =>
      _$FacetFilterModelFromJson(json);

  Map<String, dynamic> toJson() => _$FacetFilterModelToJson(this);

  static Map<String, List<String>> toMapStringValues(
    List<FacetFilterModel> facetFilters, {
    required String currency,
  }) {
    Map<String, List<String>> map = <String, List<String>>{};
    for (FacetFilterModel facetFilter in facetFilters) {
      if (facetFilter.values != null &&
          facetFilter.values!.isNotEmpty &&
          facetFilter.name != null &&
          facetFilter.name!.isNotEmpty) {
        List<String> value = facetFilter._compactValueFromFaceFilterValues();
        map[facetFilter.name!] = value;
        if (facetFilter.name! == FilterKey.price.key) {
          map[facetFilter.name!] = value.map<String>((String e) {
            return e.replaceAll(currency, '');
          }).toList();
        }
      }
    }
    return map;
  }

  List<String> _compactValueFromFaceFilterValues() {
    return (values ?? <FacetFilterValueModel>[])
        .map<String?>((FacetFilterValueModel e) => e.value)
        .nonNulls
        .toList();
  }

  @override
  String toString() {
    var encoder = JsonEncoder.withIndent("   ");
    return encoder.convert(toJson());
  }
}

@JsonSerializable()
class FacetFilterValueModel {
  String? value;
  int? count;

  FacetFilterValueModel(this.value, this.count);

  factory FacetFilterValueModel.fromJson(Map<String, dynamic> json) =>
      _$FacetFilterValueModelFromJson(json);

  Map<String, dynamic> toJson() => _$FacetFilterValueModelToJson(this);

  @override
  String toString() {
    var encoder = JsonEncoder.withIndent("   ");
    return encoder.convert(toJson());
  }
}
