
import 'package:flutter/foundation.dart';

import '../../model/inventory_model.dart';

@immutable
sealed class InventoryState {}

final class InventoryInitial extends InventoryState {}


class InventoryListState extends InventoryState {
  List<InventoryModel> inventory_list;

  InventoryListState(this.inventory_list);
}