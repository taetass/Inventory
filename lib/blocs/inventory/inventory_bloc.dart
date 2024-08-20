import 'package:bloc/bloc.dart';
import '../../db/database_helper.dart';
import '../../model/inventory_model.dart';
import 'inventory_event.dart';
import 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  DatabaseHelper databaseHelper = DatabaseHelper.instance;
  List<InventoryModel> inventory_list = [];
  InventoryBloc() : super(InventoryInitial()) {
    on<AddInventoryEvent>(
      (event, emit) async {
        try {
          await databaseHelper.insertInventory(InventoryModel(event.id, event.name, event.quantity, event.price, event.description));
          print('InventoryEvent added successfully');
        } catch (e) {
          print('AddInventoryEvent Error ===> $e');
        }
      },
    );

    on<UpdateInventoryEvent>(
      (event, emit) async {
        await databaseHelper.updateInventory(event.item);
      },
    );

    on<DeleteInventoryEvent>(
      (event, emit) async {
        await databaseHelper.deleteInventory(event.item);
      },
    );

    on<FetchInventoryEvent>(
      (event, emit) async {
        inventory_list = await databaseHelper.fetchInventory();
        emit(InventoryListState(inventory_list));
      },
    );

    on<FilterInventoryEvent>((event, emit) {
      final filteredItems = inventory_list.where((item) {
        final nameLower = item.name.toLowerCase();
        final queryLower = event.query.toLowerCase();
        return nameLower.contains(queryLower);
      }).toList();
      emit(InventoryListState(filteredItems));
    });
  }
}
