import 'package:shoplist/lists/models/list.dart';
import 'package:shoplist/lists/models/item.dart';
import 'package:shoplist/lists/repository/repository.dart';

class MemoryListsRepository extends ListsRepository {
  Map<String, ShoppingList> lists;

  MemoryListsRepository() {
    lists = Map<String, ShoppingList>();
  }

  @override
  Future<Item> addItem(ShoppingList list, Item item) {
    lists[list.id].items.add(item);
    return Future<Item>.delayed(Duration(milliseconds: 500), () => item);
  }

  @override
  Future<int> clearList(ShoppingList list) {
    int length = list.items.length;
    lists[list.id].items.clear();
    return Future<int>.delayed(Duration(milliseconds: 500), () => length);
  }

  @override
  Future<int> deleteItem(ShoppingList list, Item item) {
    lists[list.id].items.remove(item);
    return Future<int>.delayed(Duration(milliseconds: 500), () => 1);
  }

  @override
  Future<List<ShoppingList>> findAll() {
    return Future<List<ShoppingList>>.delayed(
        Duration(milliseconds: 500), () => lists.values.toList());
  }

  @override
  Future<ShoppingList> findById(String id) {
    return Future<ShoppingList>.delayed(
        Duration(milliseconds: 500), () => lists[id]);
  }

  @override
  Future<ShoppingList> store(String name) {
    String id = lists.length.toString();
    ShoppingList newList =
        ShoppingList(name: name, id: id, items: List<Item>());
    lists[id] = newList;

    return Future<ShoppingList>.delayed(
        Duration(milliseconds: 500), () => newList);
  }

  @override
  Future<int> delete(ShoppingList list) {
    lists.remove(list.id);
    return Future<int>.delayed(Duration(milliseconds: 500), () => 1);
  }

  @override
  Future<int> toggleItem(ShoppingList list, Item item) {
    lists[list.id].items.map((e) => e == item
        ? Item(
            name: item.name,
            quantity: item.quantity,
            done: !item.done,
          )
        : e);

    return Future<int>.delayed(Duration(milliseconds: 500), () => 1);
  }

  @override
  Future<int> updateItem(
      ShoppingList list, Item item, String newName, String newQuantity) {
    lists[list.id].items.map((e) => e == item
        ? Item(
            name: newName,
            quantity: newQuantity,
            done: item.done,
          )
        : e);

    return Future<int>.delayed(Duration(milliseconds: 500), () => 1);
  }
}
