import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../models/recipe.dart';
import 'dart:io';

class AddRecipeScreen extends StatefulWidget {
  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _timeController = TextEditingController();
  
  String _selectedDifficulty = 'Εύκολο';
  String _imagePath = '';
  final ImagePicker _picker = ImagePicker();

  final List<String> _difficulties = ['Εύκολο', 'Μεσαίο', 'Δύσκολο'];

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        // Αντιγραφή της εικόνας στον φάκελο της εφαρμογής
        final Directory appDir = await getApplicationDocumentsDirectory();
        final String fileName = path.basename(image.path);
        final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
        final String newFileName = '${timestamp}_$fileName';
        final String permanentPath = path.join(appDir.path, 'recipe_images', newFileName);
        
        // Δημιουργία φακέλου εάν δεν υπάρχει
        final Directory imageDir = Directory(path.dirname(permanentPath));
        if (!await imageDir.exists()) {
          await imageDir.create(recursive: true);
        }
        
        // Αντιγραφή του αρχείου
        final File tempFile = File(image.path);
        final File permanentFile = await tempFile.copy(permanentPath);
        
        setState(() {
          _imagePath = permanentFile.path;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Η εικόνα προστέθηκε επιτυχώς!')),
        );
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Σφάλμα κατά την επιλογή εικόνας: ${e.toString()}')),
      );
    }
  }

  void _saveRecipe() {
    if (_formKey.currentState!.validate()) {
      final recipe = Recipe(
        title: _titleController.text,
        description: _descriptionController.text,
        preparationTime: int.parse(_timeController.text),
        difficulty: _selectedDifficulty,
        imagePath: _imagePath,
        rating: 0.0,
      );

      final box = Hive.box<Recipe>('recipes');
      box.add(recipe);

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Η συνταγή προστέθηκε επιτυχώς!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Προσθήκη Συνταγής'),
        actions: [
          TextButton(
            onPressed: _saveRecipe,
            child: Text('ΑΠΟΘΗΚΕΥΣΗ', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Εικόνα
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[400]!),
                    ),
                    child: _imagePath.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(_imagePath),
                              fit: BoxFit.cover,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt, size: 50, color: Colors.grey[600]),
                              SizedBox(height: 8),
                              Text('Πατήστε για προσθήκη εικόνας', style: TextStyle(color: Colors.grey[600])),
                            ],
                          ),
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Τίτλος
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Τίτλος Συνταγής',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: Icon(Icons.restaurant_menu),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Παρακαλώ εισάγετε τίτλο';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Περιγραφή
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Περιγραφή',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Παρακαλώ εισάγετε περιγραφή';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Χρόνος προετοιμασίας
              TextFormField(
                controller: _timeController,
                decoration: InputDecoration(
                  labelText: 'Χρόνος Προετοιμασίας (λεπτά)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: Icon(Icons.schedule),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Παρακαλώ εισάγετε χρόνο';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Παρακαλώ εισάγετε έγκυρο αριθμό';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Δυσκολία
              DropdownButtonFormField<String>(
                value: _selectedDifficulty,
                decoration: InputDecoration(
                  labelText: 'Δυσκολία',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: Icon(Icons.bar_chart),
                ),
                items: _difficulties.map((difficulty) {
                  return DropdownMenuItem(
                    value: difficulty,
                    child: Text(difficulty),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDifficulty = value!;
                  });
                },
              ),
              SizedBox(height: 32),

              // Κουμπί αποθήκευσης
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveRecipe,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('ΑΠΟΘΗΚΕΥΣΗ ΣΥΝΤΑΓΗΣ', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _timeController.dispose();
    super.dispose();
  }
}