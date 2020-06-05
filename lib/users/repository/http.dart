import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:shoplist/users/repository/repository.dart';
import 'package:http/http.dart' as http;

class HttpUserRepository extends UserRepository {
  final String url;

  HttpUserRepository({@required this.url});

  @override
  Future<String> authenticate(
      {@required String username, @required String password}) async {
    String route = url + "/api/v1/login";
    final response = await http.post(
      route,
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      },
      body: jsonEncode(<String, String>{
        "username": username,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)["token"];
    } else if (response.statusCode == 401) {
      throw Exception("Wrong username/password combination");
    } else {
      throw Exception("Failed to authenticate");
    }
  }
}
