import 'package:flutter/material.dart';

class RecipePage extends StatelessWidget {
  final Map<String, dynamic> mealPlan;

  const RecipePage({Key? key, required this.mealPlan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mealPlan['title'] ?? 'Recipe'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              mealPlan['title'] ?? 'Recipe',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 16),
            // Nutritional Information
            if (mealPlan['nutritionalInfo'] != null)
              _buildNutritionalInfo(context, mealPlan['nutritionalInfo']),

            // Ingredients
            if (mealPlan['recipe'] != null)
              _buildIngredientsSection(context, mealPlan['recipe']['ingredients']),

            // Instructions
            if (mealPlan['recipe'] != null)
              _buildInstructionsSection(context, mealPlan['recipe']['instructions']),
          ],
        ),
      ),
    );
  }

  // Reusable widgets with context passed as argument
  Widget _buildNutritionalInfo(BuildContext context, Map<String, dynamic> nutritionalInfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nutritional Information:',
          style: Theme.of(context).textTheme.headline6,
        ),
        Text('Calories: ${nutritionalInfo['calories']}'),
        Text('Fat: ${nutritionalInfo['fat']}'),
        Text('Protein: ${nutritionalInfo['protein']}'),
        Text('Carbohydrates: ${nutritionalInfo['carbohydrates']}'),
      ],
    );
  }

  Widget _buildIngredientsSection(BuildContext context, List<dynamic> ingredients) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ingredients:',
          style: Theme.of(context).textTheme.headline6,
        ),
        ...ingredients.map((ingredient) => Text(ingredient as String)).toList(),
      ],
    );
  }

  Widget _buildInstructionsSection(BuildContext context, List<dynamic> instructions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Instructions:',
          style: Theme.of(context).textTheme.headline6,
        ),
        ...instructions.map((instruction) => Text(instruction as String)).toList(),
      ],
    );
  }
}
