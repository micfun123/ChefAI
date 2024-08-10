// meal_plan_generator.dart
import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:chef_ai/database_helper.dart';
import 'item_model.dart';


final model = GenerativeModel(
  model: 'gemini-1.5-flash',
  apiKey: getApiKey(),
  generationConfig: GenerationConfig(responseMimeType: 'application/json'));

// Function to generate meal plan based on ingredients and prompt
Future<String?> generateMealPlan(List<String> ingredients, List<Item> items, selectedMealType) async {
  // Sort items by expiry date or date added (adjust as per your priority)
  
  // Prepare prompt for generative model
  final prompt =
'''
Generate a JSON object representing a meal plan for a $selectedMealType meal using the provided ingredients: $ingredients. Prioritize ingredients by expiry date or date added. 

The JSON object should have the following structure:
* title: [string]
* nutritionalInfo: {
    calories: [integer],
    fat: [float],
    carbohydrates: [integer],
    protein: [integer]
  }
* recipe: {
    title: [string],
    ingredients: [string array],
    instructions: [string array]
  }


Please ensure all fields are present, and numerical values are provided for calories, fat, carbohydrates, and protein.
''';


  
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
  return "API KEY"; // Replace with placeholder
}
