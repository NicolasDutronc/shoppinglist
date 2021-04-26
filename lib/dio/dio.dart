import 'package:dio/dio.dart';
import 'package:shoplist/users/authentication/bloc.dart';
import 'package:shoplist/users/authentication/events.dart';
import 'package:shoplist/users/repository/repository.dart';

Future<Dio> configureDio(String baseUrl, UserRepository userRepository,
    AuthenticationBloc authenticationBloc) async {
  var dio = Dio(BaseOptions(
    baseUrl: baseUrl,
  ));

  dio.interceptors.clear();
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      String token;
      try {
        token = await userRepository.getToken();
      } catch (e) {
        authenticationBloc.add(LoggedOut());
        handler.reject(e);
      }

      options.headers['Authentication'] = 'Bearer $token';

      return handler.next(options);
    },
    onResponse: (response, handler) async {
      switch (response.statusCode) {
        case 401:
          authenticationBloc.add(LoggedOut());
          handler.reject(Exception("Unauthenticated"));
          break;
        case 403:
          handler.reject(Exception("Unauthorized"));
          break;
      }

      handler.next(response);
    },
  ));
}
