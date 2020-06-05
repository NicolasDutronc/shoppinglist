import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoplist/lists/lists/bloc.dart';
import 'package:shoplist/lists/lists/events.dart';

class AddListForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddListFormState();
  }
}

class AddListFormState extends State<AddListForm> {
  final TextEditingController nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Créer une nouvelle liste"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: nameController,
                autofocus: true,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Entrer un nom pour cette liste de courses";
                  }
                  return null;
                },
                decoration: InputDecoration(labelText: "Entrer un nom"),
              ),
            ),
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
                      BlocProvider.of<ListsBloc>(context)
                          .add(ListAdded(name: nameController.text));
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(
                    "Créer",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.blue,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
