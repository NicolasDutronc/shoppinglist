import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoplist/users/authentication/bloc.dart';
import 'package:shoplist/users/authentication/events.dart';

AppBar getAppBar(BuildContext context) {
  return AppBar(
    title: Text("Courses"),
    actions: [
      IconButton(
        icon: const Icon(Icons.power_settings_new),
        onPressed: () {
          print('logout');
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
        },
      )
    ],
  );
}
