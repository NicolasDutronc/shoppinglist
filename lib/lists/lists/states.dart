import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shoppinglist/lists/models/list.dart';

abstract class ListsState extends Equatable {
  const ListsState();

  @override
  List<Object> get props => [];
}

class ListsLoadInProgress extends ListsState {}

class ListsLoadSuccessState extends ListsState {
  final List<ShoppingList> lists;

  const ListsLoadSuccessState({@required this.lists});

  @override
  List<Object> get props => [lists];
}

class ListsLoadFailure extends ListsState {
  final String error;

  const ListsLoadFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => "ListsLoadFailure { error: $error }";
}
