import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:shoppinglist/users/repository/repository.dart';

class HttpUserRepository extends UserRepository {
  final String url;
  final bool tls;
  HttpClient _client;

  HttpUserRepository({@required this.url, @required this.tls}) {
    _client = HttpClient();
  }

  Uri makeUri(String path) {
    if (tls) {
      return Uri.https(url, path);
    } else {
      return Uri.http(url, path);
    }
  }

  @override
  Future<String> authenticate(
      {@required String username, @required String password}) async {
    // build request
    HttpClientRequest req = await _client.postUrl(makeUri('/api/v1/login'));
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
