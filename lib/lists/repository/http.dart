import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:shoplist/lists/repository/repository.dart';
import 'package:shoplist/users/authentication/bloc.dart';
import 'package:shoplist/users/repository/repository.dart';
import 'package:shoplist/lists/models/item.dart';
import 'package:shoplist/lists/models/list.dart';
import 'package:http/http.dart' as http;
import 'package:shoplist/users/authentication/events.dart';

class HttpListRepository extends ListsRepository {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;
  final String url;

  HttpListRepository({
    @required this.url,
    @required this.authenticationBloc,
    @required this.userRepository,
  });

  @override
  Future<List<ShoppingList>> findAll() async {
    String token = await userRepository.getToken();
    final response = await http.get(
      url + "/api/v1/lists",
      headers: {HttpHeaders.authorizationHeader: "Bearer " + token},
    );

    switch (response.statusCode) {
      case 200:
        var rawBody = jsonDecode(response.body);
        var rawList = jsonDecode(rawBody["lists"]) as List;
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
    String token = await userRepository.getToken();
    final response = await http.post(
      url + "/api/v1/lists",
      headers: {HttpHeaders.authorizationHeader: "Bearer " + token},
      body: {
        "name": name,
      },
    );

    switch (response.statusCode) {
      case 201:
        var createdList =
            ShoppingList.fromJson(jsonDecode(response.body)["list"]);
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
    String token = await userRepository.getToken();
    final response = await http.post(
      url + "/api/v1/lists/${list.id}",
      headers: {HttpHeaders.authorizationHeader: "Bearer " + token},
      body: {
        "name": item.name,
        "quantity": item.quantity,
      },
    );

    switch (response.statusCode) {
      case 200:
        var item = Item.fromJson(jsonDecode(response.body)["item"]);
        return item;
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
    String token = await userRepository.getToken();
    final response = await http.put(
      url + "/api/v1/lists/${list.id}",
      headers: {HttpHeaders.authorizationHeader: "Bearer " + token},
      body: {
        "name": item.name,
        "quantity": item.quantity,
        "new_name": newName,
        "new_quantity": newQuantity,
      },
    );

    switch (response.statusCode) {
      case 200:
        var numberOfUpdated =
            int.parse(jsonDecode(response.body)["number_of_updated"]);
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
    String token = await userRepository.getToken();
    final response = await http.put(
      url + "/api/v1/lists/${list.id}/delete",
      headers: {HttpHeaders.authorizationHeader: "Bearer " + token},
      body: {
        "name": item.name,
        "quantity": item.quantity,
      },
    );

    switch (response.statusCode) {
      case 200:
        var numberOfDeleted =
            int.parse(jsonDecode(response.body)["number_of_deleted"]);
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
    String token = await userRepository.getToken();
    final response = await http.put(
      url + "/api/v1/lists/${list.id}/toggle",
      headers: {HttpHeaders.authorizationHeader: "Bearer " + token},
      body: {
        "name": item.name,
        "quantity": item.quantity,
        "value": !item.done,
      },
    );

    switch (response.statusCode) {
      case 200:
        var numberOfToggled =
            int.parse(jsonDecode(response.body)["number_of_toggled"]);
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
    String token = await userRepository.getToken();
    final response = await http.put(
      url + "/api/v1/lists/${list.id}/clear",
      headers: {HttpHeaders.authorizationHeader: "Bearer " + token},
    );

    switch (response.statusCode) {
      case 200:
        var numberOfDeleted =
            int.parse(jsonDecode(response.body)["number_of_deleted"]);
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
