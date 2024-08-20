import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_app/model/inventory_model.dart';
import 'package:uuid/uuid.dart';
import '../../blocs/inventory/inventory_bloc.dart';
import '../../blocs/inventory/inventory_event.dart';
import '../../blocs/inventory/inventory_state.dart';

class AddInventoryItem extends StatefulWidget {
  final InventoryModel? item;
  const AddInventoryItem({Key? key, this.item}) : super(key: key);

  @override
  State<AddInventoryItem> createState() => _AddInventoryItemState();
}

class _AddInventoryItemState extends State<AddInventoryItem> {
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item?.name ?? '');
    _quantityController = TextEditingController(text: widget.item?.quantity.toString() ?? '');
    _priceController = TextEditingController(text: widget.item?.price.toString() ?? '');
    _descriptionController = TextEditingController(text: widget.item?.description ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Add Inventory' : 'Edit Inventory', style: TextStyle(color: Colors.white),),
         backgroundColor: Colors.green,
         foregroundColor: Colors.white,

      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 15),
              BlocBuilder<InventoryBloc, InventoryState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: () async {
                      final id = widget.item?.id ?? const Uuid().v4();
                      final name = _nameController.text;
                      final price = int.tryParse(_priceController.text) ?? 0;
                      final quantity = int.tryParse(_quantityController.text) ?? 0;
                      final description = _descriptionController.text;

                      if (widget.item == null) {
                        context.read<InventoryBloc>().add(AddInventoryEvent(id, name, quantity, price.toDouble(), description));
                      } else {
                        context.read<InventoryBloc>().add(UpdateInventoryEvent(InventoryModel(id, name, quantity, price.toDouble(), description)));
                      }
                      context.read<InventoryBloc>().add(FetchInventoryEvent());

                      if (!mounted) return;
                      Navigator.of(context).pop();
                    },
                    child: Text(widget.item == null ? 'Add' : 'Update'),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
