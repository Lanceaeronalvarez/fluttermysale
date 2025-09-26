// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'productlist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductListResponse _$ProductListResponseFromJson(Map<String, dynamic> json) =>
    ProductListResponse(
      (json['categories'] as List<dynamic>?)
          ?.map((e) => CategoryNodeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['count'] as num?)?.toInt(),
      json['excludeSearchDetails'] as bool?,
      (json['hits'] as num?)?.toInt(),
      (json['page'] as num?)?.toInt(),
      (json['pages'] as num?)?.toInt(),
      (json['products'] as List<dynamic>?)
          ?.map((e) => ProductItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['query'] as String?,
      (json['recommendedProducts'] as List<dynamic>?)
          ?.map((e) => ProductItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['total'] as num?)?.toInt(),
      (json['facets'] as List<dynamic>?)
          ?.map((e) => FacetFilterModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductListResponseToJson(
  ProductListResponse instance,
) => <String, dynamic>{
  'categories': instance.categories,
  'count': instance.count,
  'excludeSearchDetails': instance.excludeSearchDetails,
  'hits': instance.hits,
  'page': instance.page,
  'pages': instance.pages,
  'products': instance.products,
  'query': instance.query,
  'recommendedProducts': instance.recommendedProducts,
  'total': instance.total,
  'facets': instance.facets,
};
