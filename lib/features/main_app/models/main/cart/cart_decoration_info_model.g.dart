// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_decoration_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartDecorationInfo _$CartDecorationInfoFromJson(Map<String, dynamic> json) =>
    CartDecorationInfo(
      label: json['Label'] as String?,
      name: json['Name'] as String?,
      type: json['Type'] as String?,
      dataType: json['DataType'] as String?,
      infoClass: json['Class'] as String?,
      value: json['Value'] as String?,
      maxLength: (json['MaxLength'] as num?)?.toInt(),
      minLength: (json['MinLength'] as num?)?.toInt(),
      validate: json['Validate'] as String?,
      readOnly: json['ReadOnly'] as bool?,
      withoutComma: json['WithoutComma'] as bool?,
      options: (json['Options'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      regexp: json['Regexp'] as String?,
      validateConsistency: json['ValidateConsistency'] as bool?,
      suggestion: json['Suggestion'] == null
          ? null
          : CartDecorationSuggestion.fromJson(
              json['Suggestion'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$CartDecorationInfoToJson(CartDecorationInfo instance) =>
    <String, dynamic>{
      'Label': instance.label,
      'Name': instance.name,
      'Type': instance.type,
      'DataType': instance.dataType,
      'Class': instance.infoClass,
      'Value': instance.value,
      'MaxLength': instance.maxLength,
      'MinLength': instance.minLength,
      'Validate': instance.validate,
      'ReadOnly': instance.readOnly,
      'WithoutComma': instance.withoutComma,
      'Options': instance.options,
      'Regexp': instance.regexp,
      'ValidateConsistency': instance.validateConsistency,
      'Suggestion': instance.suggestion,
    };

CartDecorationSuggestion _$CartDecorationSuggestionFromJson(
  Map<String, dynamic> json,
) => CartDecorationSuggestion(
  field: json['Field'] as String?,
  mode: json['Mode'] as String?,
);

Map<String, dynamic> _$CartDecorationSuggestionToJson(
  CartDecorationSuggestion instance,
) => <String, dynamic>{'Field': instance.field, 'Mode': instance.mode};
