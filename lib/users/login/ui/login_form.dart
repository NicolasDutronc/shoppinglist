import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoplist/users/login/bloc.dart';
import 'package:shoplist/users/login/events.dart';
import 'package:shoplist/users/login/states.dart';

class LoginForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          Scaffold.of(context).showSnackBar(SnackBar(
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
                  child: RaisedButton(
                    onPressed: () {
                      if (state is! LoginLoading) {
                        BlocProvider.of<LoginBloc>(context)
                            .add(LoginButtonPressed(
                          username: _usernameController.text,
                          password: _passwordController.text,
                        ));
                      }
                    },
                    child: Text("Login"),
                  ),
                ),
                Container(
                  child: state is LoginLoading
                      ? CircularProgressIndicator()
                      : null,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
