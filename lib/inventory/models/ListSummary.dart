import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:shoppinglist/shoppinglist/models/shoppinglist.dart';

class ListSummary extends Equatable {
  final String name;
  final String id;
  final int length;

  ListSummary({@required this.name, @required this.id, @required this.length});

  ListSummary.from({@required ShoppingList shoppinglist})
      : this(
            name: shoppinglist.name,
            id: shoppinglist.id,
            length: shoppinglist.items.length);

  static ListSummary fromJson(Map<String, dynamic> json) {
    return ListSummary(
      name: json['name'],
      id: json['id'],
      length: json['length'],
    );
  }

  @override
  List<Object> get props => [name, id, length];

  @override
  String toString() {
    return 'List summary { id: $id, name: $name, length: $length }';
  }
}
