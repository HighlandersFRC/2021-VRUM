import 'package:json_annotation/json_annotation.dart';

part 'personal_safety_message.g.dart';

@JsonSerializable()
class PersonalSafetyMessage {
  final String basicType;
  final int timestamp;
  final int msgCnt;
  final String id;
  final String deviceId;
  final Position position;
  final double accuracy;
  final double speed;
  final double heading;
  final List<PathHistoryPoint> pathHistory;

  PersonalSafetyMessage({
    this.basicType,
    this.timestamp,
    this.msgCnt,
    this.id,
    this.deviceId,
    this.position,
    this.accuracy,
    this.speed,
    this.heading,
    this.pathHistory,
  });

  factory PersonalSafetyMessage.fromJson(Map<String, dynamic> json) => _$PersonalSafetyMessageFromJson(json);

  Map<String, dynamic> toJson() => _$PersonalSafetyMessageToJson(this);
}

@JsonSerializable()
class PathHistoryPoint {
  final Position position;
  final int timestamp;
  final double speed;
  final double heading;

  PathHistoryPoint({
    this.position,
    this.timestamp,
    this.speed,
    this.heading,
  });

  factory PathHistoryPoint.fromJson(Map<String, dynamic> json) => _$PathHistoryPointFromJson(json);
  Map<String, dynamic> toJson() => _$PathHistoryPointToJson(this);
}

@JsonSerializable()
class VruNotification {
  final String id;
  final int timestamp;
  final String vehiclePsmId;
  final String vruPsmId;
  final String vruDeviceId;
  final String vehicleDeviceId;
  final double timeToCollision;
  final double distance;
  final String reason;
  final List<PathHistoryPoint> pathHistory;

  VruNotification({
    this.id,
    this.vehiclePsmId,
    this.vruPsmId,
    this.timeToCollision,
    this.distance,
    this.reason,
    this.timestamp,
    this.pathHistory,
    this.vehicleDeviceId,
    this.vruDeviceId,
  });

  factory VruNotification.fromJson(Map<String, dynamic> json) => _$VruNotificationFromJson(json);
  Map<String, dynamic> toJson() => _$VruNotificationToJson(this);
}

@JsonSerializable()
class Position {
  double lat;
  double lon;
  double elevation;

  Position({
    this.lat,
    this.lon,
    this.elevation
  });

  factory Position.fromJson(Map<String, dynamic> json) => _$PositionFromJson(json);

  Map<String, dynamic> toJson() => _$PositionToJson(this);
}

//    "basicType": "aPEDESTRIAN",
//     "secMark": 231,
//     "msgCnt": 1,
//     "id": "d419eac0-1736-4e6a-aa78-d54661fbae17",
//     "position": {
//         "lat": 47,
//         "long": -105,
//         "elevation": 1
//     },
//     "accuracy": 1,
//     "speed": 12,
//     "heading": 360