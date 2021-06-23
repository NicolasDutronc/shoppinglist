import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shoppinglist/lists/models/list.dart';

abstract class ListState extends Equatable {
  const ListState();

  @override
  List<Object> get props => [];
}

class ListLoadInProgress extends ListState {}

class ListLoadSuccessState extends ListState {
  final ShoppingList list;

  const ListLoadSuccessState({@required this.list});

  @override
  List<Object> get props => [list];
}

class ListLoadFailure extends ListState {
  final String error;

  const ListLoadFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => "ListLoadFailure { error: $error }";
}
