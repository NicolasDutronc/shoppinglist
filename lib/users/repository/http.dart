import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:shoplist/users/repository/repository.dart';

class HttpUserRepository extends UserRepository {
  final String url;
  HttpClient _client;

  HttpUserRepository({@required this.url}) {
    _client = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }

  @override
  Future<String> authenticate(
      {@required String username, @required String password}) async {
    // build request
    HttpClientRequest req =
        await _client.postUrl(Uri.https(url, '/api/v1/login'));
    req.headers.contentType = ContentType.json;
    req.add(utf8.encode(jsonEncode({
      'username': username,
      'password': password,
    })));

    // process response
    HttpClientResponse resp = await req.close();
    switch (resp.statusCode) {
      case 200:
        var body = await resp
            .transform(utf8.decoder)
            .join()
            .then((value) => jsonDecode(value));

        String token = body['token'];
        if (token == null || token.length == 0) {
          throw Exception("Invalid token : $token");
        }

        return token;
        break;
      case 401:
        throw Exception("Wrong username/password combination");
      default:
        throw Exception("Failed to authenticate");
    }
  }
}
