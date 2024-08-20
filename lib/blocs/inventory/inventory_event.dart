

import '../../model/inventory_model.dart';

sealed class InventoryEvent {}

class AddInventoryEvent extends InventoryEvent {
  final String id;
  final String name;
  final int quantity;
  final double price;
  final String description;

  AddInventoryEvent(
    this.id,
    this.name,
    this.quantity,
    this.price,
    this.description,
  );
}

class UpdateInventoryEvent extends InventoryEvent {
  InventoryModel item;

  UpdateInventoryEvent(this.item);
}

class DeleteInventoryEvent extends InventoryEvent {
  InventoryModel item;

  DeleteInventoryEvent(this.item);
}

class FetchInventoryEvent extends InventoryEvent {
  FetchInventoryEvent();
}

class FilterInventoryEvent extends InventoryEvent {
  final String query;

  FilterInventoryEvent(this.query);
}
