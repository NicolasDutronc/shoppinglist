import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoplist/lists/list/bloc.dart';
import 'package:shoplist/lists/list/events.dart';
import 'package:shoplist/lists/models/item.dart';

class EditItem extends StatefulWidget {
  final Item item;

  EditItem({this.item});

  @override
  State<StatefulWidget> createState() {
    return EditItemState(item);
  }
}

class EditItemState extends State<EditItem> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final quantityController = TextEditingController();

  EditItemState(Item item) {
    nameController.text = item.name;
    quantityController.text = item.quantity;
  }

  @override
  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Modifier un élément"),
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
                  decoration: InputDecoration(labelText: "Modifier le nom"),
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
                  decoration:
                      InputDecoration(labelText: "Modifier la quantité"),
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
                          ItemUpdatedEvent(
                            item: widget.item,
                            newName: nameController.text,
                            newQuantity: quantityController.text,
                          ),
                        );
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(
                      "Modifier",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.blue,
                  )
                ],
              ),
            ],
          )),
    );
  }
}
