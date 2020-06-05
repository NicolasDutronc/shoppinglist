import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoplist/components/appbar.dart';
import 'package:shoplist/users/authentication/bloc.dart';
import 'package:shoplist/users/login/bloc.dart';
import 'package:shoplist/users/login/ui/login_form.dart';
import 'package:shoplist/users/repository/repository.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: BlocProvider(
        create: (context) {
          return LoginBloc(
              authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
              userRepository: RepositoryProvider.of<UserRepository>(context));
        },
        child: LoginForm(),
      ),
    );
  }
}
