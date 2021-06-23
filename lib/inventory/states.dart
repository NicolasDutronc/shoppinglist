import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:shoppinglist/inventory/models/ListSummary.dart';

abstract class InventoryState extends Equatable {
  const InventoryState();

  @override
  List<Object> get props => [];
}

class InventoryLoading extends InventoryState {}

class InventoryLoaded extends InventoryState {
  final List<ListSummary> inventory;

  const InventoryLoaded({@required this.inventory});

  @override
  List<Object> get props => [inventory];
}

class InventoryLoadFailed extends InventoryState {
  final String error;

  const InventoryLoadFailed({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => "InventoryLoadFailed { error: $error }";
}
