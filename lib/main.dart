import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gastronomify',
      theme: ThemeData(
        primaryColor: Colors.purple[200], // Change the primary color
        hintColor: Colors.orange, // Change the accent color
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.purple[200], // Change the button background color
          ),
        ),
      ),
      home: RecipeGenerator(),
    );
  }
}

class RecipeGenerator extends StatefulWidget {
  @override
  _RecipeGeneratorState createState() => _RecipeGeneratorState();
}

class _RecipeGeneratorState extends State<RecipeGenerator> {
  TextEditingController _ingredientsController = TextEditingController();

  String _generatedRecipe = '';
  Future<void> _generateRecipe() async {
    final String apiUrl = 'https://r-g-g.vercel.app/generate_recipe';
    final List<String> ingredients = _ingredientsController.text.split(',');
    final Map<String, dynamic> requestBody = {'ingredients': ingredients};
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      setState(() {
        _generatedRecipe = jsonDecode(response.body)['recipe'];
      });
    } else {
      throw Exception('Failed to load recipe');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gastronomify'), // Change the app bar title
        centerTitle: true, // Center the title
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _ingredientsController,
              decoration: InputDecoration(labelText: 'Enter Ingredients'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _generateRecipe,
              child: Text('Generate Recipe'),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Text(
                      _generatedRecipe,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
