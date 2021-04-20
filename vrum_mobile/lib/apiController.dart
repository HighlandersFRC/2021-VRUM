import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vrum_mobile/models/apiToken.dart';

class ApiController {
  ApiToken token = ApiToken();

  ApiController() {}

  Future<http.Response> postApiRequest(String url, String body) async {
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    if(token.token_expires <= currentTime) {
      token = await getAuthToken();
    }
    // print(token.access_token);
    // final response = await http.post(Uri.parse(url), body: body, headers: {"apikey": "9994912f-7d93-402a-9d55-77d7c748704c"});
    final response = await http.post(Uri.parse(url), body: body, headers: {"Authorization": "Bearer ${token.access_token}"});
    print(response.statusCode);
    return response;
  }

  Future<http.Response> getApiRequest(String url) async {
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    if(token.token_expires <= currentTime) {
      token = await getAuthToken();
    }
    // final response = await http.get(Uri.parse(url), headers: {"apikey": "9994912f-7d93-402a-9d55-77d7c748704c"});
    final response = await http.get(Uri.parse(url), headers: {"Authorization": "Bearer ${token.access_token}"});
    print(response.statusCode);
    return response;
  }

  Future<ApiToken> getAuthToken() async{
    var client = http.Client();
    try {
      var url = Uri.parse("https://vrum-rest-api.azurewebsites.net/auth/token/");
      var response = await http.post(url, body: {"username": "user", "password": "9994912f-7d93-402a-9d55-77d7c748704c"});
      print(response.statusCode);
      print(response.body);
      ApiToken token = ApiToken.fromJson(JsonDecoder().convert(response.body));
      return token;
    } finally {
      client.close();
    }

  }

  verifyAuthToken() {

  }


}