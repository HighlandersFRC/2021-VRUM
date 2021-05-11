import 'package:json_annotation/json_annotation.dart';
part 'apiToken.g.dart';

@JsonSerializable()
class ApiToken {
  final String access_token;
  final String token_type;
  final int token_expires;

  ApiToken({this.access_token = "", this.token_type = "", this.token_expires = 0});

  factory ApiToken.fromJson(Map<String, dynamic> json) => _$ApiTokenFromJson(json);
  Map<String, dynamic> toJson() => _$ApiTokenToJson(this);

}