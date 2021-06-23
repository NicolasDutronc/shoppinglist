import 'package:shoppinglist/inventory/models/ListSummary.dart';
import 'package:shoppinglist/shoppinglist/models/item.dart';
import 'package:shoppinglist/shoppinglist/models/shoppinglist.dart';

abstract class ShoppinglistRepository {
  Future<List<ShoppingList>> findAll();
  Future<List<ListSummary>> getInventory();
  Future<ShoppingList> findById(String id);
  Future<ShoppingList> store(String name);
  Future<int> delete(String id);
  Future<Item> addItem(ShoppingList list, Item item);
  Future<int> updateItem(
      ShoppingList list, Item item, String newName, String newQuantity);
  Future<int> deleteItem(ShoppingList list, Item item);
  Future<int> toggleItem(ShoppingList list, Item item);
  Future<int> clearList(ShoppingList list);
}
