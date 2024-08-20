import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/inventory/inventory_bloc.dart';
import '../../blocs/inventory/inventory_event.dart';
import '../../blocs/inventory/inventory_state.dart';
import '../login_screen.dart';
import 'add_inventory_item.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(76, 175, 80, 1),
        title: Text(
          'Inventory List',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
            icon: Icon(Icons.exit_to_app_rounded, color: Colors.white,),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                context.read<InventoryBloc>().add(FilterInventoryEvent(value));
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<InventoryBloc, InventoryState>(builder: (context, state) {
              if (state is InventoryInitial) {
                context.read<InventoryBloc>().add(FetchInventoryEvent());
              }
              if (state is InventoryListState) {
                var items = state.inventory_list;
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      title: Text(item.name),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Quantity: ${item.quantity}'),
                          Text('Price: ${item.price}'),
                          Text('Description: ${item.description}'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            context.read<InventoryBloc>().add(DeleteInventoryEvent(item));
                            context.read<InventoryBloc>().add(FetchInventoryEvent());
                          });
                        },
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddInventoryItem(item: item))).then((value) {
                          setState(() {});
                        });
                      },
                    );
                  },
                );
              }
              return const Center(child: CircularProgressIndicator());
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onFabClicked,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _onFabClicked() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddInventoryItem())).then((value) {
      setState(() {});
    });
  }
}
