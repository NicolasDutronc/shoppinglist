import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shoplist/lists/models/list.dart';

abstract class ListsEvent extends Equatable {
  const ListsEvent();

  @override
  List<Object> get props => [];
}

class ListsLoadSuccess extends ListsEvent {}

class ListAdded extends ListsEvent {
  final String name;

  const ListAdded({@required this.name});

  @override
  List<Object> get props => [name];

  @override
  String toString() => "ListAdded { name: $name }";
}

// ListUpdated should only be called when a item is added or removed from the list
// On the UI, the number of article can then be updated
class ListUpdated extends ListsEvent {
  final ShoppingList updatedList;

  const ListUpdated({@required this.updatedList});

  @override
  List<Object> get props => [updatedList];

  @override
  String toString() => "ListUpdated { updatedList: $updatedList }";
}

class ListDeleted extends ListsEvent {
  final ShoppingList list;

  const ListDeleted({@required this.list});

  @override
  List<Object> get props => [list];

  @override
  String toString() => "ShoppingList { list: $list }";
}
