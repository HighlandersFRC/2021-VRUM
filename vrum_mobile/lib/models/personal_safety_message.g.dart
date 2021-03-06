// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_safety_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonalSafetyMessage _$PersonalSafetyMessageFromJson(
    Map<String, dynamic> json) {
  return PersonalSafetyMessage(
    basicType: json['basicType'] as String,
    timestamp: json['timestamp'] as int,
    msgCnt: json['msgCnt'] as int,
    id: json['id'] as String,
    deviceId: json['deviceId'] as String,
    position: json['position'] == null
        ? null
        : Position.fromJson(json['position'] as Map<String, dynamic>),
    accuracy: (json['accuracy'] as num)?.toDouble(),
    speed: (json['speed'] as num)?.toDouble(),
    heading: (json['heading'] as num)?.toDouble(),
    pathHistory: (json['pathHistory'] as List)
        ?.map((e) => e == null
            ? null
            : PathHistoryPoint.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PersonalSafetyMessageToJson(
        PersonalSafetyMessage instance) =>
    <String, dynamic>{
      'basicType': instance.basicType,
      'timestamp': instance.timestamp,
      'msgCnt': instance.msgCnt,
      'id': instance.id,
      'deviceId': instance.deviceId,
      'position': instance.position,
      'accuracy': instance.accuracy,
      'speed': instance.speed,
      'heading': instance.heading,
      'pathHistory': instance.pathHistory,
    };

PathHistoryPoint _$PathHistoryPointFromJson(Map<String, dynamic> json) {
  return PathHistoryPoint(
    position: json['position'] == null
        ? null
        : Position.fromJson(json['position'] as Map<String, dynamic>),
    timestamp: json['timestamp'] as int,
    speed: (json['speed'] as num)?.toDouble(),
    heading: (json['heading'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$PathHistoryPointToJson(PathHistoryPoint instance) =>
    <String, dynamic>{
      'position': instance.position,
      'timestamp': instance.timestamp,
      'speed': instance.speed,
      'heading': instance.heading,
    };

VruNotification _$VruNotificationFromJson(Map<String, dynamic> json) {
  return VruNotification(
    id: json['id'] as String,
    vehiclePsmId: json['vehiclePsmId'] as String,
    vruPsmId: json['vruPsmId'] as String,
    timeToCollision: (json['timeToCollision'] as num)?.toDouble(),
    distance: (json['distance'] as num)?.toDouble(),
    reason: json['reason'] as String,
    timestamp: json['timestamp'] as int,
    pathHistory: (json['pathHistory'] as List)
        ?.map((e) => e == null
            ? null
            : PathHistoryPoint.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    vehicleDeviceId: json['vehicleDeviceId'] as String,
    vruDeviceId: json['vruDeviceId'] as String,
  );
}

Map<String, dynamic> _$VruNotificationToJson(VruNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'timestamp': instance.timestamp,
      'vehiclePsmId': instance.vehiclePsmId,
      'vruPsmId': instance.vruPsmId,
      'vruDeviceId': instance.vruDeviceId,
      'vehicleDeviceId': instance.vehicleDeviceId,
      'timeToCollision': instance.timeToCollision,
      'distance': instance.distance,
      'reason': instance.reason,
      'pathHistory': instance.pathHistory,
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
