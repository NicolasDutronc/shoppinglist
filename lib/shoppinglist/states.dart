import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:shoppinglist/shoppinglist/models/shoppinglist.dart';

abstract class ShoppinglistState extends Equatable {
  const ShoppinglistState();

  @override
  List<Object> get props => [];
}

class ShoppinglistLoading extends ShoppinglistState {}

class ShoppinglistLoaded extends ShoppinglistState {
  final ShoppingList list;

  const ShoppinglistLoaded({@required this.list});

  @override
  List<Object> get props => [list];
}

class ShoppinglistLoadFailed extends ShoppinglistState {
  final String error;

  const ShoppinglistLoadFailed({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => "ShoppinglistLoadFailed { error: $error }";
}
