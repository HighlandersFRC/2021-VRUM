import 'package:json_annotation/json_annotation.dart';

part 'personal_safety_message.g.dart';

@JsonSerializable()
class PersonalSafetyMessage {
  final String basicType;
  final int secMark;
  final int timestamp;
  final int msgCnt;
  final String id;

  @JsonSerializable()
  final Position position;
  final double accuracy;
  final double speed;
  final double heading;

  PersonalSafetyMessage({
    this.basicType,
    this.secMark,
    this.timestamp,
    this.msgCnt,
    this.id,
    this.position,
    this.accuracy,
    this.speed,
    this.heading,
  });

  factory PersonalSafetyMessage.fromJson(Map<String, dynamic> json) => _$PersonalSafetyMessageFromJson(json);



  Map<String, dynamic> toJson() => _$PersonalSafetyMessageToJson(this);
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