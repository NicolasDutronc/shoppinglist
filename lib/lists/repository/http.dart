import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:shoplist/lists/repository/repository.dart';
import 'package:shoplist/users/authentication/bloc.dart';
import 'package:shoplist/users/repository/repository.dart';
import 'package:shoplist/lists/models/item.dart';
import 'package:shoplist/lists/models/list.dart';
import 'package:shoplist/users/authentication/events.dart';

class HttpListRepository extends ListsRepository {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;
  final String url;
  HttpClient _client;

  HttpListRepository({
    @required this.url,
    @required this.authenticationBloc,
    @required this.userRepository,
  }) {
    this._client = new HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }

  @override
  Future<List<ShoppingList>> findAll() async {
    String token;
    try {
      token = await userRepository.getToken();
    } catch (e) {
      authenticationBloc.add(LoggedOut());
      return null;
    }

    HttpClientRequest req =
        await _client.getUrl(Uri.https(url, '/api/v1/lists'));

    req.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');

    HttpClientResponse response = await req.close();

    switch (response.statusCode) {
      case 200:
        var rawBody = await response
            .transform(utf8.decoder)
            .join()
            .then((value) => jsonDecode(value));

        var rawList = rawBody['lists'] as List;
        return rawList
            .map((listJson) => ShoppingList.fromJson(listJson))
            .toList();
      case 401:
        authenticationBloc.add(LoggedOut());
        return null;
      default:
        throw Exception(
            "Unexpected status code : " + response.statusCode.toString());
    }
  }

  @override
  Future<ShoppingList> store(String name) async {
    String token;
    try {
      token = await userRepository.getToken();
    } catch (e) {
      authenticationBloc.add(LoggedOut());
      return null;
    }

    HttpClientRequest req =
        await _client.postUrl(Uri.https(url, '/api/v1/lists'));
    req.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');
    req.headers.contentType = ContentType.json;
    req.add(utf8.encode(jsonEncode({
      'name': name,
    })));

    HttpClientResponse response = await req.close();

    switch (response.statusCode) {
      case 201:
        var rawBody = await response
            .transform(utf8.decoder)
            .join()
            .then((value) => jsonDecode(value));
        var createdList = ShoppingList.fromJson(rawBody["list"]);
        return createdList;
      case 401:
        authenticationBloc.add(LoggedOut());
        return null;
      default:
        throw Exception(
            "Unexpected status code : " + response.statusCode.toString());
    }
  }

  @override
  Future<Item> addItem(ShoppingList list, Item item) async {
    String token;
    try {
      token = await userRepository.getToken();
    } catch (e) {
      authenticationBloc.add(LoggedOut());
      return null;
    }

    HttpClientRequest req =
        await _client.postUrl(Uri.https(url, '/api/v1/lists/${list.id}'));
    req.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');
    req.headers.contentType = ContentType.json;
    req.add(utf8.encode(jsonEncode({
      'name': item.name,
      'quantity': item.quantity,
    })));

    HttpClientResponse response = await req.close();

    switch (response.statusCode) {
      case 200:
        var rawBody = await response
            .transform(utf8.decoder)
            .join()
            .then((value) => jsonDecode(value));
        var addedItem = Item.fromJson(rawBody["item"]);
        return addedItem;
      case 401:
        authenticationBloc.add(LoggedOut());
        return null;
      default:
        throw Exception(
            "Unexpected status code : " + response.statusCode.toString());
    }
  }

  @override
  Future<int> updateItem(
      ShoppingList list, Item item, String newName, String newQuantity) async {
    String token;
    try {
      token = await userRepository.getToken();
    } catch (e) {
      authenticationBloc.add(LoggedOut());
      return null;
    }

    HttpClientRequest req =
        await _client.putUrl(Uri.https(url, '/api/v1/lists/${list.id}'));
    req.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');
    req.headers.contentType = ContentType.json;
    req.add(utf8.encode(jsonEncode({
      'name': item.name,
      'quantity': item.quantity,
      'new_name': newName,
      'new_quantity': newQuantity,
    })));

    HttpClientResponse response = await req.close();

    switch (response.statusCode) {
      case 200:
        var rawBody = await response
            .transform(utf8.decoder)
            .join()
            .then((value) => jsonDecode(value));
        var numberOfUpdated = rawBody['number_of_updated'];
        return numberOfUpdated;
      case 401:
        authenticationBloc.add(LoggedOut());
        return null;
      default:
        throw Exception(
            "Unexpected status code : " + response.statusCode.toString());
    }
  }

  @override
  Future<int> deleteItem(ShoppingList list, Item item) async {
    String token;
    try {
      token = await userRepository.getToken();
    } catch (e) {
      authenticationBloc.add(LoggedOut());
      return null;
    }

    HttpClientRequest req =
        await _client.putUrl(Uri.https(url, '/api/v1/lists/${list.id}/delete'));
    req.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');
    req.headers.contentType = ContentType.json;
    req.add(utf8.encode(jsonEncode({
      'name': item.name,
      'quantity': item.quantity,
    })));

    HttpClientResponse response = await req.close();

    switch (response.statusCode) {
      case 200:
        var rawBody = await response
            .transform(utf8.decoder)
            .join()
            .then((value) => jsonDecode(value));
        var numberOfDeleted = rawBody['number_of_deleted'];
        return numberOfDeleted;
      case 401:
        authenticationBloc.add(LoggedOut());
        return null;
      default:
        throw Exception(
            "Unexpected status code : " + response.statusCode.toString());
    }
  }

  @override
  Future<int> toggleItem(ShoppingList list, Item item) async {
    String token;
    try {
      token = await userRepository.getToken();
    } catch (e) {
      authenticationBloc.add(LoggedOut());
      return null;
    }

    HttpClientRequest req =
        await _client.putUrl(Uri.https(url, '/api/v1/lists/${list.id}/toggle'));
    req.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');
    req.headers.contentType = ContentType.json;
    req.add(utf8.encode(jsonEncode({
      'name': item.name,
      'quantity': item.quantity,
      'value': !item.done,
    })));

    HttpClientResponse response = await req.close();

    switch (response.statusCode) {
      case 200:
        var rawBody = await response
            .transform(utf8.decoder)
            .join()
            .then((value) => jsonDecode(value));
        var numberOfToggled = rawBody['number_of_toggled'];
        return numberOfToggled;
      case 401:
        authenticationBloc.add(LoggedOut());
        return null;
      default:
        throw Exception(
            "Unexpected status code : " + response.statusCode.toString());
    }
  }

  @override
  Future<int> clearList(ShoppingList list) async {
    String token;
    try {
      token = await userRepository.getToken();
    } catch (e) {
      authenticationBloc.add(LoggedOut());
      return null;
    }

    HttpClientRequest req =
        await _client.putUrl(Uri.https(url, '/api/v1/lists/${list.id}/clear'));
    req.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');

    HttpClientResponse response = await req.close();

    switch (response.statusCode) {
      case 200:
        var rawBody = await response
            .transform(utf8.decoder)
            .join()
            .then((value) => jsonDecode(value));
        var numberOfDeleted = rawBody['number_of_deleted'];
        return numberOfDeleted;
      case 401:
        authenticationBloc.add(LoggedOut());
        return null;
      default:
        throw Exception(
            "Unexpected status code : " + response.statusCode.toString());
    }
  }
}
