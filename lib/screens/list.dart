import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppinglist/shoppinglist/models/item.dart';
import 'package:shoppinglist/shoppinglist/models/shoppinglist.dart';
import 'package:shoppinglist/screens/editItem.dart';
import 'package:shoppinglist/shoppinglist/cubit.dart';
import 'package:shoppinglist/shoppinglist/states.dart';

import 'addItem.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShoppinglistCubit, ShoppinglistState>(
      listener: (context, state) {
        if (state is ShoppinglistLoaded) {
          _refreshCompleter?.complete();
          _refreshCompleter = Completer<void>();
        }
      },
      builder: (context, state) {
        if (state is ShoppinglistLoading) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Loading...'),
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ShoppinglistLoaded) {
          return RefreshIndicator(
            child: Scaffold(
              appBar: AppBar(
                title: Text(state.list.name),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return AddItemForm();
                  }));
                },
                child: Icon(Icons.add),
              ),
              body: _buildShoplist(context, state.list),
              backgroundColor: Colors.grey[200],
            ),
            onRefresh: () {
              context.read<ShoppinglistCubit>().loadShoppinglist(state.list.id);
              return _refreshCompleter.future;
            },
          );
        }

        return null;
      },
    );
  }

  Widget _buildShoplist(BuildContext context, ShoppingList list) {
    // empty list
    if (list.items.length == 0) {
      return _buildEmptyListScreen();
    }

    // build list
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemCount: list.items.length + 1,
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      itemBuilder: (context, itemIndex) {
        // build header
        if (itemIndex == 0) {
          return _buildListHeader(
            context,
          );
        }

        itemIndex--;

        // build list items
        if (itemIndex < list.items.length) {
          return _buildItem(context, list.items[itemIndex], itemIndex);
        }
        return null;
      },
    );
  }

  Widget _buildEmptyListScreen() {
    return Stack(
      children: [
        Center(
          child: Text(
            "La liste de course est vide.",
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
        ListView(),
      ],
    );
  }

  Widget _buildListHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, right: 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              "Nom",
              style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.bold,
              ),
            ),
            flex: 3,
          ),
          Expanded(
            child: Text(
              "Quantité",
              style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.bold,
              ),
            ),
            flex: 4,
          ),
          Expanded(
            child: TextButton(
              child: Icon(
                Icons.remove_shopping_cart,
                color: Colors.grey[800],
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Supprimer tous les articles ?"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Annuler"),
                        ),
                        TextButton(
                            onPressed: () {
                              context
                                  .read<ShoppinglistCubit>()
                                  .deleteAllItems();
                              Navigator.of(context).pop();
                            },
                            child: Text("Confirmer"))
                      ],
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, Item item, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Text(
            item.name,
            style: TextStyle(
              color: Colors.grey[800],
              decoration:
                  item.done ? TextDecoration.lineThrough : TextDecoration.none,
            ),
          ),
          flex: 3,
          // decoration: BoxDecoration(border: Border.all()),
        ),
        Expanded(
          child: Text(
            item.quantity,
            style: TextStyle(
              color: Colors.grey[800],
              decoration:
                  item.done ? TextDecoration.lineThrough : TextDecoration.none,
            ),
          ),
          flex: 2,

          // decoration: BoxDecoration(border: Border.all()),
        ),
        Expanded(
          child: Checkbox(
            value: item.done,
            onChanged: (value) => context
                .read<ShoppinglistCubit>()
                .toggleItem(item: item, index: index),
          ),
          // decoration: BoxDecoration(border: Border.all()),
        ),
        Expanded(
          child: TextButton(
            child: Icon(
              Icons.edit,
              color: Colors.grey[800],
            ),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                return EditItem(item: item, index: index);
              }),
            ),
          ),
          // decoration: BoxDecoration(border: Border.all()),
        ),
        Expanded(
          child: TextButton(
            child: Icon(
              Icons.remove,
              color: Colors.grey[800],
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Supprimer ${item.name} de la liste ?"),
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
                                .read<ShoppinglistCubit>()
                                .deleteItem(item: item);
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  });
            },
          ),
        )
      ],
    );
  }
}
