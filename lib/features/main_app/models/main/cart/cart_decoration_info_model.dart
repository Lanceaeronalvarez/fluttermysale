import 'package:json_annotation/json_annotation.dart';

part 'cart_decoration_info_model.g.dart';

@JsonSerializable()
class CartDecorationInfo {
  @JsonKey(name: 'Label')
  final String? label;

  @JsonKey(name: 'Name')
  final String? name;

  @JsonKey(name: 'Type')
  final String? type;

  @JsonKey(name: 'DataType')
  final String? dataType;

  @JsonKey(name: 'Class')
  final String? infoClass;

  @JsonKey(name: 'Value')
  final String? value;

  @JsonKey(name: 'MaxLength')
  final int? maxLength;

  @JsonKey(name: 'MinLength')
  final int? minLength;

  @JsonKey(name: 'Validate')
  final String? validate;

  @JsonKey(name: 'ReadOnly')
  final bool? readOnly;

  @JsonKey(name: 'WithoutComma')
  final bool? withoutComma;

  @JsonKey(name: 'Options')
  final List<String>? options;

  @JsonKey(name: 'Regexp')
  final String? regexp;

  @JsonKey(name: 'ValidateConsistency')
  final bool? validateConsistency;

  @JsonKey(name: 'Suggestion')
  final CartDecorationSuggestion? suggestion;

  const CartDecorationInfo({
    this.label,
    this.name,
    this.type,
    this.dataType,
    this.infoClass,
    this.value,
    this.maxLength,
    this.minLength,
    this.validate,
    this.readOnly,
    this.withoutComma,
    this.options,
    this.regexp,
    this.validateConsistency,
    this.suggestion,
  });

  factory CartDecorationInfo.fromJson(Map<String, dynamic> json) =>
      _$CartDecorationInfoFromJson(json);

  Map<String, dynamic> toJson() => _$CartDecorationInfoToJson(this);
}

@JsonSerializable()
class CartDecorationSuggestion {
  @JsonKey(name: 'Field')
  final String? field;

  @JsonKey(name: 'Mode')
  final String? mode;

  const CartDecorationSuggestion({this.field, this.mode});

  factory CartDecorationSuggestion.fromJson(Map<String, dynamic> json) =>
      _$CartDecorationSuggestionFromJson(json);

  Map<String, dynamic> toJson() => _$CartDecorationSuggestionToJson(this);
}
