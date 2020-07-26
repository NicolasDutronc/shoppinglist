import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class UserRepository {
  final storage = new FlutterSecureStorage();

  Future<String> authenticate({
    @required String username,
    @required String password,
  });

  Future<void> persistToken(String token) async {
    return storage.write(key: "token", value: token);
  }

  Future<void> deleteToken() async {
    return storage.delete(key: "token");
  }

  Future<bool> hasToken() async {
    return storage.read(key: "token").then((value) => value != null);
  }

  Future<String> getToken() async {
    String token = await storage.read(key: "token");
    if (token == null) {
      throw new Exception('token not found');
    }
    return token;
  }
}
