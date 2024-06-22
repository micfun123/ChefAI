import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'item_model.dart';

class AddItemPage extends StatefulWidget {
  final Item? item;

  AddItemPage({this.item});

  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  String _unit = 'grams';
  DateTime? _expirationDate;
  DateTime _dateAdded = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _nameController.text = widget.item!.name;
      _amountController.text = widget.item!.amount.toString();
      _unit = widget.item!.unit;
      _expirationDate = widget.item!.expirationDate != null
          ? DateTime.parse(widget.item!.expirationDate!)
          : null;
      _dateAdded = DateTime.parse(widget.item!.dateAdded);
    }
  }

  Future<void> _addItem() async {
    if (_formKey.currentState!.validate()) {
      final item = Item(
        id: widget.item?.id,
        name: _nameController.text,
        amount: double.parse(_amountController.text),
        unit: _unit,
        expirationDate: _expirationDate?.toIso8601String(),
        dateAdded: _dateAdded.toIso8601String(),
      );

      final dbHelper = DatabaseHelper();
      if (widget.item == null) {
        await dbHelper.insertItem(item.toMap());
      } else {
        await dbHelper.updateItem(item.toMap());
      }

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Add Item' : 'Edit Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),


              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  return null;
                },
              ),


              DropdownButtonFormField<String>( //select amount from grams or ml (maybe add US units later)
                value: _unit,
                decoration: InputDecoration(labelText: 'Unit'),
                items: ['grams', 'ml'].map((String unit) {
                  return DropdownMenuItem<String>(
                    value: unit,
                    child: Text(unit),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _unit = newValue!;
                  });
                },
              ),


              ElevatedButton( //experation date drop down
                onPressed: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      _expirationDate = selectedDate;
                    });
                  }
                },
                child: Text(_expirationDate == null
                    ? 'Select Expiration Date'
                    : 'Expiration Date: ${_expirationDate!.toLocal()}'.split(' ')[0]),
              ),
              
              ElevatedButton( //confirm button
                onPressed: _addItem,
                child: Text(widget.item == null ? 'Add Item' : 'Update Item'),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
