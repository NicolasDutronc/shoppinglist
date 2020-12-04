import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shoplist/lists/models/item.dart';

abstract class ListEvent extends Equatable {
  const ListEvent();

  @override
  List<Object> get props => [];
}

class ListLoadSuccess extends ListEvent {
  final String listId;

  const ListLoadSuccess({@required this.listId});

  @override
  List<Object> get props => [listId];

  @override
  String toString() => "ListLoadSuccess { listId: $listId }";
}

class ItemAddedEvent extends ListEvent {
  final Item item;

  const ItemAddedEvent({@required this.item});

  @override
  List<Object> get props => [item];

  @override
  String toString() => "ItemAddedEvent { item: $item }";
}

class ItemUpdatedEvent extends ListEvent {
  final Item item;
  final String newName;
  final String newQuantity;

  const ItemUpdatedEvent({
    @required this.item,
    @required this.newName,
    @required this.newQuantity,
  });

  @override
  List<Object> get props => [item, newName, newQuantity];

  @override
  String toString() =>
      "ItemAddedEvent { item: $item, new name: $newName, new quantity: $newQuantity }";
}

class ItemDeletedEvent extends ListEvent {
  final Item item;

  const ItemDeletedEvent({@required this.item});

  @override
  List<Object> get props => [item];

  @override
  String toString() => "ItemDeletedEvent { item: $item }";
}

class ItemToggledEvent extends ListEvent {
  final Item item;

  const ItemToggledEvent({@required this.item});

  @override
  List<Object> get props => [item];

  @override
  String toString() => "ItemToggledEvent { item: $item }";
}

class DeleteAllItemsEvent extends ListEvent {}
