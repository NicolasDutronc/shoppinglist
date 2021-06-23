import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppinglist/users/authentication_cubit/cubit.dart';

AppBar getAppBar(BuildContext context) {
  return AppBar(
    title: Text("Courses"),
    actions: [
      IconButton(
        icon: const Icon(Icons.power_settings_new),
        onPressed: () {
          print('logout');
          context.read<AuthenticationCubit>().logOut();
        },
      )
    ],
  );
}
