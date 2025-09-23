import 'package:flutter_mysale/features/main_app/providers/filter_provider.dart';
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
