// main.dart
import 'dart:convert';
import 'package:chef_ai/database_helper.dart';
import 'package:flutter/material.dart';
import 'add_item_page.dart';
import 'view_fridge_page.dart';
import 'meal_plan_generator.dart';
import 'item_model.dart';
import 'recipe_page.dart';
import 'meal_selection_page.dart'; // Import the MealSelectionPage
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chef AI',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            onPrimary: Colors.white,
            textStyle: const TextStyle(
              fontFamily: 'Readex Pro',
              letterSpacing: 0,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: const HomePageWidget(),
    );
  }
}

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          automaticallyImplyLeading: false,
          title: const Text(
            'Chef AI creating unique recipes',
            style: TextStyle(
              fontFamily: 'Outfit',
              color: Colors.white,
              fontSize: 22,
              letterSpacing: 0,
            ),
          ),
          elevation: 2,
        ),
        body: SafeArea(
          top: true,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ViewFridgePage()),
                    );
                  },
                  child: const Text('View my fridge'),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddItemPage()),
                    );
                  },
                  child: const Text('Add to Fridge'),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () async {
                    //check to see if there is a internet connection using dart io
                    bool result = await InternetConnection().hasInternetAccess;
                    print(result);
    	              if (result) {                
                      final selectedMealType = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MealSelectionPage()),
                      );
                      print("internet connection");
                      if (selectedMealType != null) {
                        final dbHelper = DatabaseHelper();
                        final itemsMapList = await dbHelper.getItems();

                        final items = itemsMapList.map((itemMap) => Item.fromMap(itemMap)).toList();
                        final ingredients = items.map((item) => item.name).toList();
                        //check to see if there are any ingredients
                        if (ingredients.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'No ingredients found in your fridge. Please add some items.',
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  color: Colors.white,
                                  fontSize: 22,
                                  letterSpacing: 0,
                                ),
                              ),
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                          );
                          return;
                        }
                        try {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Your meal is being generated by the robot chef!',
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  color: Colors.white,
                                  fontSize: 22,
                                  letterSpacing: 0,
                                ),
                              ),
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                          );
                          final mealPlanString = await generateMealPlan(ingredients, items, selectedMealType);


                          final mealPlanMap = jsonDecode(mealPlanString!);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipePage(mealPlan: mealPlanMap),
                            ),
                          );
                        } catch (e) {
                          print('Failed to generate meal plan: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'A error occured. Please make sure that you have a internet connection and are up to date.',
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  color: Colors.white,
                                  fontSize: 22,
                                  letterSpacing: 0,
                                ),
                              ),
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                          );
                        }
                      } else {
                        print("failed");
                        // make a please connect to the internet and retry
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Please connect to the internet and retry',
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  color: Colors.white,
                                  fontSize: 22,
                                  letterSpacing: 0,
                                ),
                              ),
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                          );
                      }
                    }
                    else if (
                      result == false
                    ) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'No internet connection. Please make sure you are connected to the internet and try again.',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                color: Colors.white,
                                fontSize: 22,
                                letterSpacing: 0,
                              ),
                            ),
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                        );
                    }

                  },
                  child: const Text('Get Cooking'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
