import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppinglist/components/appbar.dart';
import 'package:shoppinglist/users/authentication_cubit/cubit.dart';
import 'package:shoppinglist/users/authentication_cubit/states.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context),
      body: BlocConsumer<AuthenticationCubit, AuthenticationState>(
        listener: (context, state) {
          if (state is Unauthenticated && state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("${state.error}"),
              backgroundColor: Colors.red,
            ));
          }
        },
        builder: (context, state) {
          return Form(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TextFormField(
                    autofocus: true,
                    decoration: InputDecoration(labelText: "username"),
                    controller: _usernameController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Entrer votre nom d'utilisateur";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(labelText: "password"),
                    controller: _passwordController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Entrer votre mot de passe";
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50, bottom: 50),
                    child: ElevatedButton(
                      onPressed: () {
                        if (state is! Authenticating) {
                          context.read<AuthenticationCubit>().logIn(
                                username: _usernameController.text,
                                password: _passwordController.text,
                              );
                        }
                      },
                      child: Text("Login"),
                    ),
                  ),
                  Container(
                    child: state is Authenticating
                        ? CircularProgressIndicator()
                        : null,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
