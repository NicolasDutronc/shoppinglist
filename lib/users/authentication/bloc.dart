import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shoppinglist/users/authentication/events.dart';
import 'package:shoppinglist/users/authentication/states.dart';
import 'package:shoppinglist/users/repository/repository.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticateState> {
  final UserRepository userRepository;

  AuthenticationBloc({@required this.userRepository})
      : assert(userRepository != null),
        super(null);

  @override
  AuthenticateState get initialState => AuthenticationUninitialised();

  @override
  Stream<AuthenticateState> mapEventToState(AuthenticationEvent event) async* {
    if (event is AppStarted) {
      final bool hasToken = await userRepository.hasToken();

      if (hasToken) {
        yield AuthenticationAuthenticated();
      } else {
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is LoggedIn) {
      yield AuthenticationLoading();
      await userRepository.persistToken(event.token);
      yield AuthenticationAuthenticated();
    }

    if (event is LoggedOut) {
      yield AuthenticationLoading();
      await userRepository.deleteToken();
      yield AuthenticationUnauthenticated();
    }
  }
}
