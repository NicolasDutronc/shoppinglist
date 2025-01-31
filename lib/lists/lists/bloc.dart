import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shoppinglist/lists/lists/events.dart';
import 'package:shoppinglist/lists/lists/states.dart';
import 'package:shoppinglist/lists/models/list.dart';
import 'package:shoppinglist/lists/repository/repository.dart';

class ListsBloc extends Bloc<ListsEvent, ListsState> {
  final ListsRepository listRepository;

  ListsBloc({@required this.listRepository}) : super(ListsLoadInProgress());

  @override
  Stream<ListsState> mapEventToState(ListsEvent event) async* {
    // load success
    if (event is ListsLoadSuccess) {
      yield ListsLoadInProgress();
      try {
        final lists = await listRepository.findAll();
        if (lists != null) {
          yield ListsLoadSuccessState(lists: lists);
        }
      } catch (e) {
        yield ListsLoadFailure(error: e.toString());
      }
    }
    // new list added
    else if (event is ListAdded) {
      if (state is ListsLoadSuccessState) {
        // retrieve lists from state
        final currentLists = (state as ListsLoadSuccessState).lists;

        yield ListsLoadInProgress();
        try {
          // call the repository to store the new list
          final newList = await listRepository.store(event.name);

          // add the new list locally
          final List<ShoppingList> updatedLists = List.from(currentLists)
            ..add(newList);

          // send new state with the updated lists
          yield ListsLoadSuccessState(lists: updatedLists);
        } catch (e) {
          yield ListsLoadFailure(error: e.toString());
        }
      }
    }

    // list updated
    // the event is supposed to provide the updated list
    // we just have to update our list of lists
    else if (event is ListUpdated) {
      if (state is ListsLoadSuccessState) {
        List<ShoppingList> currentList = (state as ListsLoadSuccessState).lists;
        yield ListsLoadInProgress();

        // retrieve the index of the updated list
        final int index = currentList
            .indexWhere((shoppingList) => shoppingList == event.updatedList);

        // update the list of lists
        currentList[index] = event.updatedList;

        yield ListsLoadSuccessState(lists: currentList);
      }
    } else if (event is ListDeleted) {
      // retrieve lists from state
      final currentLists = (state as ListsLoadSuccessState).lists;
      if (state is ListsLoadSuccessState) {
        yield ListsLoadInProgress();
        try {
          await listRepository.delete(event.list);
          // remove the new list locally
          final List<ShoppingList> updatedLists = List.from(currentLists)
            ..remove(event.list);

          // send new state with the updated lists
          yield ListsLoadSuccessState(lists: updatedLists);
        } catch (e) {
          yield ListsLoadFailure(error: e.toString());
        }
      }
    }
  }
}
