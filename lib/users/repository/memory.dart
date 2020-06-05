import 'package:shoplist/users/repository/repository.dart';

class MemoryUserRepository extends UserRepository {
  @override
  Future<String> authenticate({String username, String password}) {
    return Future<String>.value("token");
  }
}
