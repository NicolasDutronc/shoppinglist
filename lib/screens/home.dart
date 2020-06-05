import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoplist/lists/list/bloc.dart';
import 'package:shoplist/lists/list/events.dart';
import 'package:shoplist/lists/lists/bloc.dart';
import 'package:shoplist/lists/lists/states.dart';
import 'package:shoplist/lists/models/list.dart';
import 'package:shoplist/screens/addList.dart';
import 'package:shoplist/screens/list.dart';

class Home extends StatelessWidget {
  final String title;

  Home(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return AddListForm();
          }));
        },
        child: Icon(Icons.add),
      ),
      body: BlocBuilder<ListsBloc, ListsState>(
        builder: (context, state) {
          // loading
          if (state is ListsLoadInProgress) {
            return Center(child: CircularProgressIndicator());
          }

          // error fetching lists
          if (state is ListsLoadFailure) {
            return Center(
              child: Text(state.error),
            );
          }

          // lists fetched successfully
          if (state is ListsLoadSuccessState) {
            // empty list
            if (state.lists.length == 0) {
              return Center(
                child: Text(
                  "Pas de liste de courses",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              );
            }

            return ListView.separated(
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
                          .add(ListLoadSuccess(list: state.lists[index]));
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          // BlocProvider.of<ShoppingListBloc>(context)
                          //     .add(ListLoadSuccess(list: state.lists[index]));
                          return ListScreen();
                        }),
                      );
                    },
                  ),
                );
              },
            );
          }

          return null;
        },
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
