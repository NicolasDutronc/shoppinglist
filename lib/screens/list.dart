import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoplist/lists/list/bloc.dart';
import 'package:shoplist/lists/list/events.dart';
import 'package:shoplist/lists/list/states.dart';
import 'package:shoplist/lists/models/item.dart';
import 'package:shoplist/lists/models/list.dart';
import 'package:shoplist/screens/editItem.dart';

import 'addItem.dart';

class ListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingListBloc, ListState>(
      builder: (context, state) {
        if (state is ListLoadInProgress) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Loading...'),
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ListLoadSuccessState) {
          return Scaffold(
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
          return _buildItem(context, list.items[itemIndex]);
        }
        return null;
      },
    );
  }

  Widget _buildEmptyListScreen() {
    return Center(
      child: Text(
        "La liste de course est vide.",
        style: TextStyle(color: Colors.grey[600]),
      ),
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
            child: FlatButton(
              child: Icon(
                Icons.remove_shopping_cart,
                color: Colors.grey[800],
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Supprimer toute la liste ?"),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Annuler"),
                          ),
                          FlatButton(
                              onPressed: () {
                                BlocProvider.of<ShoppingListBloc>(context)
                                    .add(DeleteAllItemsEvent());
                                Navigator.of(context).pop();
                              },
                              child: Text("Confirmer"))
                        ],
                      );
                    });
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, Item item) {
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
            onChanged: (value) => BlocProvider.of<ShoppingListBloc>(context)
                .add(ItemToggledEvent(item: item)),
          ),
          // decoration: BoxDecoration(border: Border.all()),
        ),
        Expanded(
          child: FlatButton(
            child: Icon(
              Icons.edit,
              color: Colors.grey[800],
            ),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                return EditItem(item: item);
              }),
            ),
          ),
          // decoration: BoxDecoration(border: Border.all()),
        ),
        Expanded(
          child: FlatButton(
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
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Annuler"),
                        ),
                        FlatButton(
                            onPressed: () {
                              BlocProvider.of<ShoppingListBloc>(context)
                                  .add(ItemDeletedEvent(item: item));
                              Navigator.of(context).pop();
                            },
                            child: Text("Confirmer"))
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
