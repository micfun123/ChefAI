// meal_selection_page.dart
import 'package:flutter/material.dart';

class MealSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Meal Type'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, 'Dinner');
              },
              child: Text('Dinner'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, 'Lunch');
              },
              child: Text('Lunch'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, 'Breakfast');
              },
              child: Text('Breakfast'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, 'Snack');
              },
              child: Text('Snack'),
            ),
          ],
        ),
      ),
    );
  }
}
