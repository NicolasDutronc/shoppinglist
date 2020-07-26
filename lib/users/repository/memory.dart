import 'package:shoplist/users/repository/repository.dart';

class MemoryUserRepository extends UserRepository {
  @override
  Future<String> authenticate({String username, String password}) async {
    await Future.delayed(Duration(seconds: 1));
    return 'token';
  }
}
