import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:shoppinglist/inventory/models/ListSummary.dart';
import 'package:shoppinglist/shoppinglist/repository/repository.dart';
import 'package:shoppinglist/users/authentication_cubit/cubit.dart';
import 'package:shoppinglist/users/repository/repository.dart';
import 'package:shoppinglist/shoppinglist/models/item.dart';
import 'package:shoppinglist/shoppinglist/models/shoppinglist.dart';

class HttpListRepository extends ShoppinglistRepository {
  final UserRepository userRepository;
  final AuthenticationCubit authenticationCubit;
  final String url;
  final bool tls;
  HttpClient _client;

  HttpListRepository({
    @required this.url,
    @required this.tls,
    @required this.authenticationCubit,
    @required this.userRepository,
  }) {
    this._client = new HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }

  Uri makeUri(String path) {
    if (tls) {
      return makeUri(path);
    } else {
      return Uri.http(url, path);
    }
  }

  @override
  Future<List<ShoppingList>> findAll() async {
    String token;
    try {
      token = await userRepository.getToken();
    } catch (e) {
      authenticationCubit.logOut();
      return null;
    }

    HttpClientRequest req = await _client.getUrl(makeUri('/api/v1/lists'));

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
        authenticationCubit.logOut();
        return null;
      default:
        throw Exception(
            "Unexpected status code : " + response.statusCode.toString());
    }
  }

  @override
  Future<List<ListSummary>> getInventory() async {
    String token;
    try {
      token = await userRepository.getToken();
    } catch (e) {
      authenticationCubit.logOut();
      return null;
    }

    HttpClientRequest req = await _client.getUrl(makeUri('/api/v1/inventory'));

    req.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');

    HttpClientResponse response = await req.close();

    switch (response.statusCode) {
      case 200:
        var rawBody = await response
            .transform(utf8.decoder)
            .join()
            .then((value) => jsonDecode(value));

        var rawList = rawBody['inventory'] as List;
        return rawList
            .map((listJson) => ListSummary.fromJson(listJson))
            .toList();
      case 401:
        authenticationCubit.logOut();
        return null;
      default:
        throw Exception(
            "Unexpected status code : " + response.statusCode.toString());
    }
  }

  @override
  Future<ShoppingList> findById(String id) async {
    String token;
    try {
      token = await userRepository.getToken();
    } catch (e) {
      authenticationCubit.logOut();
      return null;
    }

    HttpClientRequest req = await _client.getUrl(makeUri('/api/v1/lists/$id'));

    req.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');

    HttpClientResponse response = await req.close();

    switch (response.statusCode) {
      case 200:
        var rawBody = await response
            .transform(utf8.decoder)
            .join()
            .then((value) => jsonDecode(value));
        var createdList = ShoppingList.fromJson(rawBody["list"]);
        return createdList;
      case 401:
        authenticationCubit.logOut();
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
      authenticationCubit.logOut();
      return null;
    }

    HttpClientRequest req = await _client.postUrl(makeUri('/api/v1/lists'));
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
        authenticationCubit.logOut();
        return null;
      default:
        throw Exception(
            "Unexpected status code : " + response.statusCode.toString());
    }
  }

  @override
  Future<int> delete(String id) async {
    String token;
    try {
      token = await userRepository.getToken();
    } catch (e) {
      authenticationCubit.logOut();
      return null;
    }

    HttpClientRequest req =
        await _client.deleteUrl(makeUri('/api/v1/lists/$id'));
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
        authenticationCubit.logOut();
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
      authenticationCubit.logOut();
      return null;
    }

    HttpClientRequest req =
        await _client.postUrl(makeUri('/api/v1/lists/${list.id}'));
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
        authenticationCubit.logOut();
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
      authenticationCubit.logOut();
      return null;
    }

    HttpClientRequest req =
        await _client.putUrl(makeUri('/api/v1/lists/${list.id}'));
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
        authenticationCubit.logOut();
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
      authenticationCubit.logOut();
      return null;
    }

    HttpClientRequest req =
        await _client.putUrl(makeUri('/api/v1/lists/${list.id}/delete'));
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
        authenticationCubit.logOut();
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
      authenticationCubit.logOut();
      return null;
    }

    HttpClientRequest req =
        await _client.putUrl(makeUri('/api/v1/lists/${list.id}/toggle'));
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
        authenticationCubit.logOut();
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
      authenticationCubit.logOut();
      return null;
    }

    HttpClientRequest req =
        await _client.putUrl(makeUri('/api/v1/lists/${list.id}/clear'));
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
        authenticationCubit.logOut();
        return null;
      default:
        throw Exception(
            "Unexpected status code : " + response.statusCode.toString());
    }
  }
}
