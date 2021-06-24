import 'package:dio/dio.dart';
import 'package:shoppinglist/users/authentication_cubit/cubit.dart';
import 'package:shoppinglist/users/repository/repository.dart';

Dio configureDio(
  String baseUrl,
  UserRepository userRepository,
  AuthenticationCubit authenticationCubit,
) {
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
        authenticationCubit.logOut();
        handler.reject(e);
      }

      options.headers['Authentication'] = 'Bearer $token';

      return handler.next(options);
    },
    onResponse: (response, handler) async {
      switch (response.statusCode) {
        case 401:
          authenticationCubit.logOut();
          handler.reject(Exception("Unauthenticated"));
          break;
        case 403:
          handler.reject(Exception("Unauthorized"));
          break;
      }

      handler.next(response);
    },
  ));

  return dio;
}
