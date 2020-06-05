import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shoplist/lists/list/events.dart';
import 'package:shoplist/lists/list/states.dart';
import 'package:shoplist/lists/lists/bloc.dart';
import 'package:shoplist/lists/lists/events.dart';
import 'package:shoplist/lists/models/item.dart';
import 'package:shoplist/lists/models/list.dart';

class ShoppingListBloc extends Bloc<ListEvent, ListState> {
  final ListsBloc listsBloc;

  ShoppingListBloc({
    @required this.listsBloc,
  });

  @override
  ListState get initialState => ListLoadInProgress();

  @override
  Stream<ListState> mapEventToState(ListEvent event) async* {
    // load success
    if (event is ListLoadSuccess) {
      yield ListLoadSuccessState(list: event.list);
    }

    // item added
    else if (event is ItemAddedEvent) {
      if (state is ListLoadSuccessState) {
        // retrieve list from state
        final ShoppingList list =
            ShoppingList.from(list: (state as ListLoadSuccessState).list);

        yield ListLoadInProgress();
        try {
          final Item newitem =
              await listsBloc.listRepository.addItem(list, event.item);

          final ShoppingList updatedList = list..items.add(newitem);

          listsBloc.add(ListUpdated(
            updatedList: updatedList,
          ));

          yield ListLoadSuccessState(list: updatedList);
        } catch (e) {
          yield ListLoadFailure(error: e);
        }
      }
    }

    // item updated
    else if (event is ItemUpdatedEvent) {
      if (state is ListLoadSuccessState) {
        final ShoppingList list =
            ShoppingList.from(list: (state as ListLoadSuccessState).list);

        yield ListLoadInProgress();
        try {
          final int numberOfUpdated = await listsBloc.listRepository.updateItem(
            list,
            event.item,
            event.newName,
            event.newQuantity,
          );

          if (numberOfUpdated == 1) {
            final ShoppingList updatedList = ShoppingList(
              name: list.name,
              id: list.id,
              items: list.items.map((item) {
                return item == event.item
                    ? Item(
                        name: event.newName,
                        quantity: event.newQuantity,
                        done: false,
                      )
                    : item;
              }).toList(),
            );

            listsBloc.add(ListUpdated(updatedList: updatedList));
            yield ListLoadSuccessState(list: updatedList);
          }
        } catch (e) {
          yield ListLoadFailure(error: e);
        }
      }
    }

    // item deleted
    else if (event is ItemDeletedEvent) {
      if (state is ListLoadSuccessState) {
        final ShoppingList list =
            ShoppingList.from(list: (state as ListLoadSuccessState).list);

        yield ListLoadInProgress();
        try {
          final int numberOfDeleted = await listsBloc.listRepository.deleteItem(
            list,
            event.item,
          );

          if (numberOfDeleted == 1) {
            final ShoppingList updatedList = list..items.remove(event.item);

            listsBloc.add(ListUpdated(updatedList: updatedList));
            yield ListLoadSuccessState(list: updatedList);
          }
        } catch (e) {
          yield ListLoadFailure(error: e);
        }
      }
    }

    // item toggled
    else if (event is ItemToggledEvent) {
      if (state is ListLoadSuccessState) {
        final ShoppingList list =
            ShoppingList.from(list: (state as ListLoadSuccessState).list);

        yield ListLoadInProgress();
        try {
          final int numberOfUpdated = await listsBloc.listRepository.toggleItem(
            list,
            event.item,
          );

          if (numberOfUpdated == 1) {
            final ShoppingList updatedList = ShoppingList(
              name: list.name,
              id: list.id,
              items: list.items.map((item) {
                return item == event.item
                    ? Item(
                        name: item.name,
                        quantity: item.quantity,
                        done: !item.done,
                      )
                    : item;
              }).toList(),
            );

            listsBloc.add(ListUpdated(updatedList: updatedList));
            yield ListLoadSuccessState(list: updatedList);
          }
        } catch (e) {
          yield ListLoadFailure(error: e);
        }
      }
    }

    // deleted all items
    else if (event is DeleteAllItemsEvent) {
      if (state is ListLoadSuccessState) {
        final ShoppingList list =
            ShoppingList.from(list: (state as ListLoadSuccessState).list);

        yield ListLoadInProgress();
        try {
          final int numberOfDeleted =
              await listsBloc.listRepository.clearList(list);

          if (numberOfDeleted == list.items.length) {
            final ShoppingList updatedList = list..items.clear();

            listsBloc.add(ListUpdated(updatedList: updatedList));
            yield ListLoadSuccessState(list: updatedList);
          }
        } catch (e) {
          yield ListLoadFailure(error: e);
        }
      }
    }
  }
}
