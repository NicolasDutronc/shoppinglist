import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shoppinglist/inventory/cubit.dart';
import 'package:shoppinglist/lists/list/bloc.dart';
import 'package:shoppinglist/lists/lists/bloc.dart';
import 'package:shoppinglist/lists/lists/events.dart';
import 'package:shoppinglist/lists/repository/http.dart';
import 'package:shoppinglist/lists/repository/repository.dart';
import 'package:shoppinglist/screens/home.dart';
import 'package:shoppinglist/shoppinglist/cubit.dart';
import 'package:shoppinglist/shoppinglist/repository/memory.dart';
import 'package:shoppinglist/shoppinglist/repository/repository.dart';
import 'package:shoppinglist/users/authentication/bloc.dart';
import 'package:shoppinglist/users/authentication_cubit/states.dart';
import 'package:shoppinglist/users/authentication_cubit/cubit.dart';
import 'package:shoppinglist/screens/login.dart';
import 'package:shoppinglist/users/repository/http.dart';
import 'package:shoppinglist/users/repository/memory.dart';
import 'package:shoppinglist/users/repository/repository.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(InMemoryApp());
}

class HttpApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('kReleaseMode: $kReleaseMode');
    // String backendUrl = '10.0.2.2:8080';
    String backendUrl = 'nicolas-dutronc-shoppinglist.herokuapp.com';

    return MultiProvider(
      providers: [
        RepositoryProvider<UserRepository>(
          create: (context) => HttpUserRepository(
            url: backendUrl,
          ),
        ),
        BlocProvider<AuthenticationCubit>(
          create: (context) => AuthenticationCubit(
            userRepository: context.read<UserRepository>(),
          ),
        ),
        RepositoryProvider<ListsRepository>(
          create: (context) => HttpListRepository(
            url: backendUrl,
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
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
    );
  }
}

class InMemoryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        RepositoryProvider<UserRepository>(
          create: (context) => MemoryUserRepository(),
        ),
        BlocProvider<AuthenticationCubit>(
          create: (context) => AuthenticationCubit(
            userRepository: context.read(),
          )..checkLoggedIn(),
        ),
        RepositoryProvider<ShoppinglistRepository>(
          create: (context) => MemoryListRepository(),
        ),
        BlocProvider<InventoryCubit>(
          create: (context) =>
              InventoryCubit(shoppinglistRepository: context.read()),
        ),
        BlocProvider<ShoppinglistCubit>(
          create: (context) => ShoppinglistCubit(
            shoppinglistRepository: context.read(),
          ),
        )
      ],
      child: MyApp(),
    );
  }
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
      home: BlocBuilder<AuthenticationCubit, AuthenticationState>(
        builder: (context, state) {
          if (state is Authenticated) {
            context.read<InventoryCubit>().loadInventory();
            return Home();
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }
}

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    print('bloc : ' + bloc.toString() + ' => event : ' + event.toString());
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print('bloc : ' +
        bloc.toString() +
        ' => transition : ' +
        transition.toString());
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('bloc : ' + bloc.toString() + ' => error : ' + error.toString());
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    print('bloc : $bloc => change : $change');
    super.onChange(bloc, change);
  }
}
