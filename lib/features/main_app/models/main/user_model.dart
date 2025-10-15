import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  final String id;

  @JsonKey(name: 'user_name', defaultValue: '')
  final String userName;

  @JsonKey(name: 'first_name', defaultValue: '')
  final String firstName;

  @JsonKey(name: 'last_name', defaultValue: '')
  final String lastName;

  @JsonKey(defaultValue: false)
  final bool gender;

  @JsonKey(defaultValue: '')
  final String email;

  @JsonKey(name: 'receive_invitations', defaultValue: false)
  final bool receiveInvitations;

  @JsonKey(name: 'is_first_time_customer', defaultValue: false)
  final bool isFirstTimeCustomer;

  @JsonKey(name: 'member_preference', defaultValue: '')
  final String memberPreference;

  // Kept as String so it can default to '' per your requirement.
  @JsonKey(name: 'preference_date', defaultValue: '')
  final String preferenceDate;

  @JsonKey(name: 'preference_categories')
  final PreferenceCategories? preferenceCategories;

  @JsonKey(name: 'mobile_number', defaultValue: '')
  final String mobileNumber;

  @JsonKey(name: 'receive_sms', defaultValue: false)
  final bool receiveSms;

  const User({
    required this.id,
    this.userName = '',
    this.firstName = '',
    this.lastName = '',
    this.gender = false,
    this.email = '',
    this.receiveInvitations = false,
    this.isFirstTimeCustomer = false,
    this.memberPreference = '',
    this.preferenceDate = '',
    this.preferenceCategories,
    this.mobileNumber = '',
    this.receiveSms = false,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class PreferenceCategories {
  @JsonKey(defaultValue: false)
  final bool womens;

  @JsonKey(defaultValue: false)
  final bool mens;

  @JsonKey(defaultValue: false)
  final bool home;

  @JsonKey(defaultValue: false)
  final bool kids;

  @JsonKey(defaultValue: false)
  final bool sports;

  const PreferenceCategories({
    this.womens = false,
    this.mens = false,
    this.home = false,
    this.kids = false,
    this.sports = false,
  });

  factory PreferenceCategories.fromJson(Map<String, dynamic> json) =>
      _$PreferenceCategoriesFromJson(json);
  Map<String, dynamic> toJson() => _$PreferenceCategoriesToJson(this);
}
