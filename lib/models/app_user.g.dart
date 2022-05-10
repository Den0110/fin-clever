// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUser _$AppUserFromJson(Map<String, dynamic> json) => AppUser(
      json['id'] as String,
      json['name'] as String?,
      json['email'] as String?,
      json['imageUrl'] as String?,
      json['junkCategories'] as String?,
      (json['junkLimit'] as num).toDouble(),
    );

Map<String, dynamic> _$AppUserToJson(AppUser instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'imageUrl': instance.imageUrl,
      'junkCategories': instance.junkCategories,
      'junkLimit': instance.junkLimit,
    };
