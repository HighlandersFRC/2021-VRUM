// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apiToken.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiToken _$ApiTokenFromJson(Map<String, dynamic> json) {
  return ApiToken(
    access_token: json['access_token'] as String,
    token_type: json['token_type'] as String,
    token_expires: json['token_expires'] as int,
  );
}

Map<String, dynamic> _$ApiTokenToJson(ApiToken instance) => <String, dynamic>{
      'access_token': instance.access_token,
      'token_type': instance.token_type,
      'token_expires': instance.token_expires,
    };
