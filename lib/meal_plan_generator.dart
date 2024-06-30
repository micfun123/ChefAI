// meal_plan_generator.dart
import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:chef_ai/database_helper.dart';
import 'item_model.dart';


final model = GenerativeModel(
  model: 'gemini-1.5-flash',
  apiKey: getApiKey(),
);

// Function to generate meal plan based on ingredients and prompt
Future<String?> generateMealPlan(List<String> ingredients, List<Item> items, selectedMealType) async {
  // Sort items by expiry date or date added (adjust as per your priority)
  
  // Prepare prompt for generative model
  final prompt = 'Generate me a $selectedMealType meal that uses $ingredients prioritized by the expiry date or date added to the fridge (Not all items have expirty dates and that is ok.). return this with a title,nutritionalInfo and then recipes there are no dietary requirments. please dont ask any more follow up questions. Return as a Json Do not have ```json or ``` You must allways have the recipe(ingredients, instructions) , calories,fat,carbohydrates,protein. ONLY EVER RETURN ONE THING. CHANGE IT EVERY TIME Note: you do not need to use everything. Just the things that fit the meal we want';
  print(prompt);
  try {
    // Generate response from generative model
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    return response.text;
  } catch (e) {
    print('Error generating meal plan: $e');
    // Handle specific error types here (optional)
    rethrow; // Re-throw for further handling if needed
  }
}

// Function to retrieve the API key securely (replace with your implementation)
String getApiKey() {
  // Implement logic to retrieve the API key from a secure source (e.g., environment variable)
  return "API_KEY"; // Replace with placeholder
}
