import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shoppinglist/users/authentication/bloc.dart';
import 'package:shoppinglist/users/authentication/events.dart';
import 'package:shoppinglist/users/login/events.dart';
import 'package:shoppinglist/users/login/states.dart';
import 'package:shoppinglist/users/repository/repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    @required this.userRepository,
    @required this.authenticationBloc,
  })  : assert(userRepository != null),
        assert(authenticationBloc != null),
        super(null);

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();

      // attempt to login
      try {
        final token = await userRepository.authenticate(
          username: event.username,
          password: event.password,
        );

        authenticationBloc.add(LoggedIn(token: token));
        yield LoginInitial();
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }
  }
}
