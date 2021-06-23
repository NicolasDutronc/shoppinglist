import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:shoppinglist/inventory/models/ListSummary.dart';
import 'package:shoppinglist/inventory/states.dart';
import 'package:shoppinglist/shoppinglist/models/shoppinglist.dart';
import 'package:shoppinglist/shoppinglist/repository/repository.dart';

class InventoryCubit extends Cubit<InventoryState> {
  final ShoppinglistRepository _shoppinglistRepository;

  InventoryCubit({@required ShoppinglistRepository shoppinglistRepository})
      : _shoppinglistRepository = shoppinglistRepository,
        super(InventoryLoading());

  Future<void> loadInventory() async {
    emit(InventoryLoading());
    try {
      List<ListSummary> inventory =
          await _shoppinglistRepository.getInventory();
      emit(InventoryLoaded(inventory: inventory));
    } catch (error) {
      emit(InventoryLoadFailed(error: error));
    }
  }

  Future<void> addList({@required String listName}) async {
    if (state is InventoryLoaded) {
      List<ListSummary> current = (state as InventoryLoaded).inventory;
      emit(InventoryLoading());
      try {
        ShoppingList newList = await _shoppinglistRepository.store(listName);
        emit(InventoryLoaded(
            inventory: current..add(ListSummary.from(shoppinglist: newList))));
      } catch (error) {
        emit(InventoryLoadFailed(error: error));
      }
    }
  }

  Future<void> updateList(
      {@required ShoppingList newList, @required int index}) async {
    if (state is InventoryLoaded) {
      emit(InventoryLoading());
      List<ListSummary> current = (state as InventoryLoaded).inventory;
      current[index] = ListSummary.from(shoppinglist: newList);
      emit(InventoryLoaded(inventory: current));
    }
  }

  Future<void> deleteList({@required int index}) async {
    if (state is InventoryLoaded) {
      List<ListSummary> current = (state as InventoryLoaded).inventory;
      emit(InventoryLoading());
      try {
        int numberOfDeleted =
            await _shoppinglistRepository.delete(current[index].id);
        if (numberOfDeleted == 1) {
          emit(InventoryLoaded(inventory: current..removeAt(index)));
        }
      } catch (error) {
        emit(InventoryLoadFailed(error: error));
      }
    }
  }
}
