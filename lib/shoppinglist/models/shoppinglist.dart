import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shoppinglist/shoppinglist/models/item.dart';

class ShoppingList extends Equatable {
  final String name;
  final String id;
  final List<Item> items;

  ShoppingList({
    @required this.name,
    @required this.id,
    @required this.items,
  });

  ShoppingList.from({@required ShoppingList list})
      : this(name: list.name, id: list.id, items: List.from(list.items));

  static ShoppingList fromJson(Map<String, dynamic> json) {
    var rawItems = json['items'] as List;
    return ShoppingList(
      id: json['id'] as String,
      name: json['name'] as String,
      items: rawItems.map((itemJson) => Item.fromJson(itemJson)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  @override
  List<Object> get props => [id, name];

  @override
  String toString() {
    return 'List { id: $id, name: $name, items: ${items.map((item) => item.toString()).toList()} }';
  }
}
