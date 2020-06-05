import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shoplist/lists/list/bloc.dart';
import 'package:shoplist/lists/lists/bloc.dart';
import 'package:shoplist/lists/lists/events.dart';
import 'package:shoplist/lists/repository/memory.dart';
import 'package:shoplist/lists/repository/repository.dart';
import 'package:shoplist/screens/home.dart';
import 'package:shoplist/users/authentication/bloc.dart';
import 'package:shoplist/users/repository/memory.dart';
import 'package:shoplist/users/repository/repository.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(
    MultiProvider(
      providers: [
        RepositoryProvider<UserRepository>(
          create: (context) => MemoryUserRepository(),
        ),
        RepositoryProvider<ListsRepository>(
          create: (context) => MemoryListsRepository(),
        ),
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(
            userRepository: RepositoryProvider.of<UserRepository>(context),
          ),
        ),
        BlocProvider<ListsBloc>(
          create: (context) => ListsBloc(
            listRepository: RepositoryProvider.of<ListsRepository>(context),
          )..add(ListsLoadSuccess()),
        ),
        BlocProvider<ShoppingListBloc>(
          create: (context) => ShoppingListBloc(
            listsBloc: BlocProvider.of<ListsBloc>(context),
          ),
        )
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CouCourses',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Home("CouCourses"),
    );
  }
}

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    print('event : ' + event.toString());
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print('transition : ' + transition.toString());
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stackTrace) {
    print('error : ' + error.toString());
    super.onError(bloc, error, stackTrace);
  }
}
