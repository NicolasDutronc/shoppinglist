import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppinglist/components/appbar.dart';
import 'package:shoppinglist/inventory/cubit.dart';
import 'package:shoppinglist/inventory/models/ListSummary.dart';
import 'package:shoppinglist/inventory/states.dart';
import 'package:shoppinglist/screens/addList.dart';
import 'package:shoppinglist/screens/list.dart';
import 'package:shoppinglist/shoppinglist/cubit.dart';

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
      body: BlocConsumer<InventoryCubit, InventoryState>(
        listener: (context, state) {
          if (state is InventoryLoaded) {
            _refreshCompleter?.complete();
            _refreshCompleter = Completer<void>();
          }
        },
        builder: (context, state) {
          // loading
          if (state is InventoryLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // error fetching lists
          if (state is InventoryLoadFailed) {
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
                context.read<InventoryCubit>().loadInventory();
                return _refreshCompleter.future;
              },
            );
          }

          // lists fetched successfully
          if (state is InventoryLoaded) {
            // empty list
            if (state.inventory.length == 0) {
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
                  context.read<InventoryCubit>().loadInventory();
                  return _refreshCompleter.future;
                },
              );
            }

            return RefreshIndicator(
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                  itemCount: state.inventory.length,
                  padding: const EdgeInsets.all(15.0),
                  itemBuilder: (BuildContext context, int index) {
                    ListSummary summary = state.inventory[index];
                    int n = summary.length;

                    return Card(
                      child: ListTile(
                        title: Text(summary.name),
                        subtitle: Text(n > 1 ? "$n articles" : "$n article"),
                        onTap: () {
                          context
                              .read<ShoppinglistCubit>()
                              .loadShoppinglist(summary.id);

                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              return ListScreen();
                            }),
                          ).then((value) {
                            context.read<InventoryCubit>().loadInventory();
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
                                    TextButton(
                                      child: Text("Annuler"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text("Confirmer"),
                                      onPressed: () {
                                        context
                                            .read<InventoryCubit>()
                                            .deleteList(index: index);
                                        Navigator.of(context).pop();
                                      },
                                    )
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
                  context.read<InventoryCubit>().loadInventory();
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
