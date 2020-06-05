import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoplist/lists/list/bloc.dart';
import 'package:shoplist/lists/list/events.dart';
import 'package:shoplist/lists/models/item.dart';

class AddItemForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddItemFormState();
  }
}

class _AddItemFormState extends State<AddItemForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Ajouter un nouvel élément"),
        ),
        body: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                // Name of the new item
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    controller: nameController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Entrer un nom pour cet élément";
                      }
                      return null;
                    },
                    autofocus: true,
                    decoration: InputDecoration(labelText: "Entrer un nom"),
                    onEditingComplete: focusNode.requestFocus,
                  ),
                ),

                // Quantity of the new item
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    controller: quantityController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Entrer une quantité pour cet élément";
                      }
                      return null;
                    },
                    focusNode: focusNode,
                    decoration:
                        InputDecoration(labelText: "Entrer une quantité"),
                  ),
                ),

                // Cancel and Add buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    // Cancel button
                    RaisedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Annuler",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.red,
                    ),

                    // Add button
                    RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          BlocProvider.of<ShoppingListBloc>(context).add(
                            ItemAddedEvent(
                              item: Item(
                                name: nameController.text,
                                quantity: quantityController.text,
                                done: false,
                              ),
                            ),
                          );

                          Navigator.of(context).pop();
                        }
                      },
                      child: Text(
                        "Ajouter",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.blue,
                    )
                  ],
                ),
              ],
            )));
  }
}
