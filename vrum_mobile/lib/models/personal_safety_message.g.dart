// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_safety_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonalSafetyMessage _$PersonalSafetyMessageFromJson(
    Map<String, dynamic> json) {
  return PersonalSafetyMessage(
    basicType: json['basicType'] as String,
    secMark: json['secMark'] as int,
    timestamp: json['timestamp'] as int,
    msgCnt: json['msgCnt'] as int,
    id: json['id'] as String,
    position: json['position'] == null
        ? null
        : Position.fromJson(json['position'] as Map<String, dynamic>),
    accuracy: (json['accuracy'] as num)?.toDouble(),
    speed: (json['speed'] as num)?.toDouble(),
    heading: (json['heading'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$PersonalSafetyMessageToJson(
        PersonalSafetyMessage instance) =>
    <String, dynamic>{
      'basicType': instance.basicType,
      'secMark': instance.secMark,
      'timestamp': instance.timestamp,
      'msgCnt': instance.msgCnt,
      'id': instance.id,
      'position': instance.position.toJson(),
      'accuracy': instance.accuracy,
      'speed': instance.speed,
      'heading': instance.heading,
    };

Position _$PositionFromJson(Map<String, dynamic> json) {
  return Position(
    lat: (json['lat'] as num)?.toDouble(),
    lon: (json['lon'] as num)?.toDouble(),
    elevation: (json['elevation'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$PositionToJson(Position instance) => <String, dynamic>{
      'lat': instance.lat,
      'lon': instance.lon,
      'elevation': instance.elevation,
    };
