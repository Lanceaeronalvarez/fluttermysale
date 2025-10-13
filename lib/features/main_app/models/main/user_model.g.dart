// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: json['id'] as String,
  userName: json['user_name'] as String? ?? '',
  firstName: json['first_name'] as String? ?? '',
  lastName: json['last_name'] as String? ?? '',
  gender: json['gender'] as bool? ?? false,
  email: json['email'] as String? ?? '',
  receiveInvitations: json['receive_invitations'] as bool? ?? false,
  isFirstTimeCustomer: json['is_first_time_customer'] as bool? ?? false,
  memberPreference: json['member_preference'] as String? ?? '',
  preferenceDate: json['preference_date'] as String? ?? '',
  preferenceCategories: json['preference_categories'] == null
      ? null
      : PreferenceCategories.fromJson(
          json['preference_categories'] as Map<String, dynamic>,
        ),
  mobileNumber: json['mobile_number'] as String? ?? '',
  receiveSms: json['receive_sms'] as bool? ?? false,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'user_name': instance.userName,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'gender': instance.gender,
  'email': instance.email,
  'receive_invitations': instance.receiveInvitations,
  'is_first_time_customer': instance.isFirstTimeCustomer,
  'member_preference': instance.memberPreference,
  'preference_date': instance.preferenceDate,
  'preference_categories': instance.preferenceCategories?.toJson(),
  'mobile_number': instance.mobileNumber,
  'receive_sms': instance.receiveSms,
};

PreferenceCategories _$PreferenceCategoriesFromJson(
  Map<String, dynamic> json,
) => PreferenceCategories(
  womens: json['womens'] as bool? ?? false,
  mens: json['mens'] as bool? ?? false,
  home: json['home'] as bool? ?? false,
  kids: json['kids'] as bool? ?? false,
  sports: json['sports'] as bool? ?? false,
);

Map<String, dynamic> _$PreferenceCategoriesToJson(
  PreferenceCategories instance,
) => <String, dynamic>{
  'womens': instance.womens,
  'mens': instance.mens,
  'home': instance.home,
  'kids': instance.kids,
  'sports': instance.sports,
};
