// meal_plan_generator.dart
import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:chef_ai/database_helper.dart';
import 'item_model.dart';

// Securely obtain the API key (replace with your approach)
final apiKey = getApiKey(); // Replace with function to retrieve key

final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);


// Function to generate meal plan based on ingredients and prompt
Future<String?> generateMealPlan(String ingredients, List<Item> items) async {
  // Sort items by expiry date or date added (adjust as per your priority)
  
  // Prepare prompt for generative model
  final prompt = 'Generate me a meal that uses $ingredients prioritized by the expiry date or date added to the fridge. return this as a json with a title,nutritionalInfo and then recipes';

  try {
    // Generate response from generative model
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    print(response.text);
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
  return "APIKEY"; // Replace with placeholder
}
