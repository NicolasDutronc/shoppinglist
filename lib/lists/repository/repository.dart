import 'package:shoplist/lists/models/item.dart';
import 'package:shoplist/lists/models/list.dart';

abstract class ListsRepository {
  Future<List<ShoppingList>> findAll();
  Future<ShoppingList> findById(String id);
  Future<ShoppingList> store(String name);
  Future<Item> addItem(ShoppingList list, Item item);
  Future<int> updateItem(
      ShoppingList list, Item item, String newName, String newQuantity);
  Future<int> deleteItem(ShoppingList list, Item item);
  Future<int> toggleItem(ShoppingList list, Item item);
  Future<int> clearList(ShoppingList list);
}
