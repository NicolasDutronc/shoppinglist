import 'package:flutter/foundation.dart';
import 'package:bloc/bloc.dart';
import 'package:shoppinglist/users/authentication_cubit/states.dart';

import 'package:shoppinglist/users/repository/repository.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final UserRepository _userRepository;

  AuthenticationCubit({@required UserRepository userRepository})
      : _userRepository = userRepository,
        super(Unauthenticated(error: null));

  Future<void> checkLoggedIn() async {
    // loading screen
    emit(Authenticating());

    bool isLoggedIn = await _userRepository.hasToken();
    if (isLoggedIn) {
      emit(Authenticated());
    } else {
      emit(Unauthenticated(error: null));
    }
  }

  Future<void> logIn(
      {@required String username, @required String password}) async {
    try {
      // loading screen
      emit(Authenticating());

      // attemp to login
      String token = await _userRepository.authenticate(
          username: username, password: password);
      await _userRepository.persistToken(token);

      // success
      emit(Authenticated());
    } catch (error) {
      // failure
      emit(Unauthenticated(error: error.toString()));
    }
  }

  Future<void> logOut() async {
    // loading screen
    emit(Authenticating());

    // deleting token
    await _userRepository.deleteToken();

    // redirect to login page
    emit(Unauthenticated(error: null));
  }
}
