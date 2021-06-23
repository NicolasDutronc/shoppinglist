import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:shoppinglist/users/authentication/bloc.dart';
import 'package:shoppinglist/users/authentication/events.dart';
import 'package:shoppinglist/users/repository/repository.dart';

class HubClient {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;
  final String url;
  HttpClient _client;
  String processorId;

  HubClient({
    @required this.url,
    @required this.authenticationBloc,
    @required this.userRepository,
  }) {
    this._client = new HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    this.processorId = null;
  }

  Future<StreamSubscription> connect() async {
    String token;
    try {
      token = await userRepository.getToken();
    } catch (e) {
      authenticationBloc.add(LoggedOut());
      return null;
    }

    HttpClientRequest req =
        await _client.getUrl(Uri.https(url, '/api/v1/connect'));

    req.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');

    HttpClientResponse response = await req.close();

    switch (response.statusCode) {
      case 201:
        Map<String, dynamic> rawBody = await response
            .transform(utf8.decoder)
            .join()
            .then((value) => jsonDecode(value));

        if (rawBody.containsKey("processor-id")) {
          this.processorId = rawBody["processor-id"];
        }

        return null;

      case 200:
        return response
            .transform(utf8.decoder)
            .listen(print, cancelOnError: false);

      case 401:
        authenticationBloc.add(LoggedOut());
        return null;
      default:
        throw Exception(
            "Unexpected status code : " + response.statusCode.toString());
    }
  }
}
