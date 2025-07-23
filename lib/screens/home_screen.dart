import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/recipe.dart';
import '../widgets/recipe_card.dart';
import 'add_recipe_screen.dart';
import 'recipe_detail_screen.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const HomeScreen({Key? key, required this.toggleTheme, required this.isDarkMode}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String sortBy = 'title';
  late Box<Recipe> recipeBox;

  @override
  void initState() {
    super.initState();
    recipeBox = Hive.box<Recipe>('recipes');
    _addSampleData();
  }

  void _addSampleData() {
    if (recipeBox.isEmpty) {
      recipeBox.add(Recipe(
        title: 'Μουσακάς',
        description: 'Παραδοσιακός ελληνικός μουσακάς με μελιτζάνες, κιμά και μπεσαμέλ.',
        preparationTime: 90,
        difficulty: 'Δύσκολο',
        imagePath: '',
        rating: 4.5,
      ));
      
      recipeBox.add(Recipe(
        title: 'Σαλάτα Χωριάτικη',
        description: 'Φρέσκια ελληνική σαλάτα με ντομάτες, αγγούρι, φέτα και ελιές.',
        preparationTime: 15,
        difficulty: 'Εύκολο',
        imagePath: '',
        rating: 4.0,
      ));
    }
  }

  List<Recipe> _getSortedRecipes() {
    List<Recipe> recipes = recipeBox.values.toList();
    
    switch (sortBy) {
      case 'difficulty':
        recipes.sort((a, b) {
          Map<String, int> difficultyOrder = {'Εύκολο': 1, 'Μεσαίο': 2, 'Δύσκολο': 3};
          return difficultyOrder[a.difficulty]!.compareTo(difficultyOrder[b.difficulty]!);
        });
        break;
      case 'rating':
        recipes.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'time':
        recipes.sort((a, b) => a.preparationTime.compareTo(b.preparationTime));
        break;
      default:
        recipes.sort((a, b) => a.title.compareTo(b.title));
    }
    
    return recipes;
  }

  void _deleteRecipe(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Διαγραφή Συνταγής'),
        content: Text('Είστε σίγουροι ότι θέλετε να διαγράψετε αυτή τη συνταγή;'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Ακύρωση'),
          ),
          TextButton(
            onPressed: () async {
              Recipe recipe = recipeBox.getAt(index)!;
              
              // Διαγραφή εικόνας αν υπάρχει
              if (recipe.imagePath.isNotEmpty) {
                try {
                  final File imageFile = File(recipe.imagePath);
                  if (await imageFile.exists()) {
                    await imageFile.delete();
                  }
                } catch (e) {
                  print('Error deleting image: $e');
                }
              }
              
              // Διαγραφή συνταγής
              recipeBox.deleteAt(index);
              Navigator.pop(context);
              setState(() {});
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Η συνταγή διαγράφηκε επιτυχώς!')),
              );
            },
            child: Text('Διαγραφή'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Συνταγές Μαγειρικής'),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.sort),
            onSelected: (value) {
              setState(() {
                sortBy = value;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'title', child: Text('Ταξινόμηση κατά Όνομα')),
              PopupMenuItem(value: 'difficulty', child: Text('Ταξινόμηση κατά Δυσκολία')),
              PopupMenuItem(value: 'rating', child: Text('Ταξινόμηση κατά Βαθμολογία')),
              PopupMenuItem(value: 'time', child: Text('Ταξινόμηση κατά Χρόνο')),
            ],
          ),
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: recipeBox.listenable(),
        builder: (context, Box<Recipe> box, _) {
          if (box.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.restaurant_menu, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Δεν υπάρχουν συνταγές',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text('Προσθέστε την πρώτη σας συνταγή!',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          List<Recipe> recipes = _getSortedRecipes();

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              Recipe recipe = recipes[index];
              
              return Dismissible(
                key: Key(recipe.key.toString()),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20),
                  child: Icon(Icons.delete, color: Colors.white, size: 30),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  int originalIndex = recipeBox.values.toList().indexOf(recipe);
                  _deleteRecipe(originalIndex);
                },
                child: RecipeCard(
                  recipe: recipe,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeDetailScreen(recipe: recipe),
                      ),
                    );
                  },
                  onRatingChanged: (newRating) {
                    recipe.rating = newRating;
                    recipe.save();
                    setState(() {});
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddRecipeScreen()),
          ).then((_) => setState(() {}));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}