import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'item_model.dart';
import 'add_item_page.dart';

class ViewFridgePage extends StatefulWidget {
  @override
  _ViewFridgePageState createState() => _ViewFridgePageState();
}

class _ViewFridgePageState extends State<ViewFridgePage> {
  late Future<List<Item>> _items;

  @override
  void initState() {
    super.initState();
    _items = _fetchItems();
  }

  Future<List<Item>> _fetchItems() async {
    final dbHelper = DatabaseHelper();
    final itemsList = await dbHelper.getItems();
    return itemsList.map((item) => Item.fromMap(item)).toList();
  }

  Future<void> _deleteItem(int id) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.deleteItem(id);
    setState(() {
      _items = _fetchItems();
    });
  }

  Future<void> _editItem(Item item) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddItemPage(item: item)),
    );

    if (result == true) {
      setState(() {
        _items = _fetchItems();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Fridge'),
      ),
      body: FutureBuilder<List<Item>>(
        future: _items,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No items in the fridge.'));
          } else {
            final items = snapshot.data!;
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text(
                    'Amount: ${item.amount} ${item.unit}\n'
                    'Date Added: ${item.dateAdded}\n'
                    'Expiration Date: ${item.expirationDate ?? 'N/A'}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editItem(item),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteItem(item.id!),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
