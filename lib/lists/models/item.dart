import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Item extends Equatable {
  final String name;
  final String quantity;
  final bool done;

  Item({
    @required this.name,
    @required this.quantity,
    @required this.done,
  });

  static Item fromJson(Map<String, dynamic> json) {
    return Item(
        name: json["name"] as String,
        quantity: json["quantity"] as String,
        done: json["done"] as bool);
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "quantity": quantity,
      "done": done,
    };
  }

  @override
  List<Object> get props => [name, quantity, done];

  @override
  String toString() {
    return 'Item { name: $name, quantity: $quantity, done: $done }';
  }
}
