import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoplist/components/appbar.dart';
import 'package:shoplist/lists/list/bloc.dart';
import 'package:shoplist/lists/list/events.dart';
import 'package:shoplist/lists/lists/bloc.dart';
import 'package:shoplist/lists/lists/events.dart';
import 'package:shoplist/lists/lists/states.dart';
import 'package:shoplist/lists/models/list.dart';
import 'package:shoplist/screens/addList.dart';
import 'package:shoplist/screens/list.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return AddListForm();
          }));
        },
        child: Icon(Icons.add),
      ),
      body: BlocConsumer<ListsBloc, ListsState>(
        listener: (context, state) {
          if (state is ListsLoadSuccessState) {
            _refreshCompleter?.complete();
            _refreshCompleter = Completer<void>();
          }
        },
        builder: (context, state) {
          // loading
          if (state is ListsLoadInProgress) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // error fetching lists
          if (state is ListsLoadFailure) {
            return RefreshIndicator(
              child: Stack(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(state.error),
                    ),
                  ),
                  ListView(),
                ],
              ),
              onRefresh: () {
                BlocProvider.of<ListsBloc>(context).add(ListsLoadSuccess());
                return _refreshCompleter.future;
              },
            );
          }

          // lists fetched successfully
          if (state is ListsLoadSuccessState) {
            // empty list
            if (state.lists.length == 0) {
              return RefreshIndicator(
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        "Pas de liste de courses",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    ListView(),
                  ],
                ),
                onRefresh: () {
                  BlocProvider.of<ListsBloc>(context).add(ListsLoadSuccess());
                  return _refreshCompleter.future;
                },
              );
            }

            return RefreshIndicator(
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                  itemCount: state.lists.length,
                  padding: const EdgeInsets.all(15.0),
                  itemBuilder: (BuildContext context, int index) {
                    ShoppingList list = state.lists[index];
                    int n = list.items.length;

                    return Card(
                      child: ListTile(
                        title: Text(list.name),
                        subtitle: Text(n > 1 ? "$n articles" : "$n article"),
                        onTap: () {
                          BlocProvider.of<ShoppingListBloc>(context)
                              .add(ListLoadSuccess(listId: list.id));
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              // BlocProvider.of<ShoppingListBloc>(context)
                              //     .add(ListLoadSuccess(list: state.lists[index]));
                              return ListScreen();
                            }),
                          ).then((value) {
                            BlocProvider.of<ListsBloc>(context)
                                .add(ListsLoadSuccess());
                          });
                        },
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Supprimer la liste ?"),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Annuler"),
                                    ),
                                    FlatButton(
                                        onPressed: () {
                                          BlocProvider.of<ListsBloc>(context)
                                              .add(ListDeleted(list: list));
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Confirmer"))
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
                onRefresh: () {
                  BlocProvider.of<ListsBloc>(context).add(ListsLoadSuccess());
                  return _refreshCompleter.future;
                });
          }

          return null;
        },
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
