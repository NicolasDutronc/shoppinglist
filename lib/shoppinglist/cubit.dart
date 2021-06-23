import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:shoppinglist/shoppinglist/models/item.dart';
import 'package:shoppinglist/shoppinglist/models/shoppinglist.dart';
import 'package:shoppinglist/shoppinglist/repository/repository.dart';
import 'package:shoppinglist/shoppinglist/states.dart';

class ShoppinglistCubit extends Cubit<ShoppinglistState> {
  final ShoppinglistRepository _shoppinglistRepository;

  ShoppinglistCubit({@required ShoppinglistRepository shoppinglistRepository})
      : _shoppinglistRepository = shoppinglistRepository,
        super(ShoppinglistLoading());

  Future<void> loadShoppinglist(String listId) async {
    // loading
    emit(ShoppinglistLoading());

    // get list
    try {
      ShoppingList list = await _shoppinglistRepository.findById(listId);
      emit(ShoppinglistLoaded(list: list));
    } catch (error) {
      emit(ShoppinglistLoadFailed(error: error));
    }
  }

  Future<void> addItem({@required Item item}) async {
    if (state is ShoppinglistLoaded) {
      // get list from state
      ShoppingList list = ShoppingList.from(
        list: (state as ShoppinglistLoaded).list,
      );

      // loading
      emit(ShoppinglistLoading());

      try {
        // call api to add item and emit list loaded with new list
        Item addedItem = await _shoppinglistRepository.addItem(list, item);
        emit(ShoppinglistLoaded(list: list..items.add(addedItem)));
      } catch (error) {
        emit(ShoppinglistLoadFailed(error: error));
      }
    }
  }

  Future<void> updateItem(
      {@required int index,
      @required String newName,
      @required String newQuantity}) async {
    if (state is ShoppinglistLoaded) {
      // get list from state
      ShoppingList list = ShoppingList.from(
        list: (state as ShoppinglistLoaded).list,
      );
      Item item = list.items[index];

      // loading
      emit(ShoppinglistLoading());
      try {
        // call api to add item and emit list loaded with new list
        int numberOfUpdated = await _shoppinglistRepository.updateItem(
            list, item, newName, newQuantity);
        if (numberOfUpdated == 1) {
          list.items[index] =
              new Item(done: item.done, name: newName, quantity: newQuantity);
          emit(ShoppinglistLoaded(list: list));
        }
      } catch (error) {
        emit(ShoppinglistLoadFailed(error: error));
      }
    }
  }

  Future<void> deleteItem({@required Item item}) async {
    if (state is ShoppinglistLoaded) {
      // get list from state
      ShoppingList list = ShoppingList.from(
        list: (state as ShoppinglistLoaded).list,
      );

      // loading
      emit(ShoppinglistLoading());
      try {
        int numberOfDeleted =
            await _shoppinglistRepository.deleteItem(list, item);
        if (numberOfDeleted == 1) {
          emit(ShoppinglistLoaded(list: list..items.remove(item)));
        }
      } catch (error) {
        emit(ShoppinglistLoadFailed(error: error));
      }
    }
  }

  Future<void> toggleItem({@required Item item, @required int index}) async {
    if (state is ShoppinglistLoaded) {
      // get list from state
      ShoppingList list = ShoppingList.from(
        list: (state as ShoppinglistLoaded).list,
      );
      Item item = list.items[index];

      // loading
      emit(ShoppinglistLoading());
      try {
        // call api to add item and emit list loaded with new list
        int numberOfToggled =
            await _shoppinglistRepository.toggleItem(list, item);
        if (numberOfToggled == 1) {
          list.items[index] = new Item(
              done: !item.done, name: item.name, quantity: item.quantity);
          emit(ShoppinglistLoaded(list: list));
        }
      } catch (error) {
        emit(ShoppinglistLoadFailed(error: error));
      }
    }
  }

  Future<void> deleteAllItems() async {
    if (state is ShoppinglistLoaded) {
      // get list from state
      ShoppingList list = ShoppingList.from(
        list: (state as ShoppinglistLoaded).list,
      );

      // loading
      emit(ShoppinglistLoading());
      try {
        int numberOfDeleted = await _shoppinglistRepository.clearList(list);
        if (numberOfDeleted == list.items.length) {
          emit(ShoppinglistLoaded(list: list..items.clear()));
        }
      } catch (error) {
        emit(ShoppinglistLoadFailed(error: error));
      }
    }
  }
}
