import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../widgets/star_rating.dart';
import 'dart:io';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailScreen({Key? key, required this.recipe}) : super(key: key);

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Εύκολο':
        return Colors.green;
      case 'Μεσαίο':
        return Colors.orange;
      case 'Δύσκολο':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Εικόνα
            Container(
              width: double.infinity,
              height: 250,
              color: Colors.grey[300],
              child: widget.recipe.imagePath.isNotEmpty
                  ? Image.file(
                      File(widget.recipe.imagePath),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Center(child: Icon(Icons.restaurant, size: 80, color: Colors.grey[600])),
                    )
                  : Center(child: Icon(Icons.restaurant, size: 80, color: Colors.grey[600])),
            ),
            
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Τίτλος
                  Text(
                    widget.recipe.title,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Βαθμολογία
                  Row(
                    children: [
                      Text('Βαθμολογία: ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      StarRating(
                        rating: widget.recipe.rating,
                        onRatingChanged: (newRating) {
                          setState(() {
                            widget.recipe.rating = newRating;
                            widget.recipe.save();
                          });
                        },
                        size: 24,
                      ),
                      SizedBox(width: 8),
                      Text('(${widget.recipe.rating.toStringAsFixed(1)}/5)'),
                    ],
                  ),
                  SizedBox(height: 16),
                  
                  // Πληροφορίες
                  Row(
                    children: [
                      Expanded(
                        child: _InfoCard(
                          icon: Icons.schedule,
                          title: 'Χρόνος',
                          value: '${widget.recipe.preparationTime} λεπτά',
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _InfoCard(
                          icon: Icons.bar_chart,
                          title: 'Δυσκολία',
                          value: widget.recipe.difficulty,
                          color: _getDifficultyColor(widget.recipe.difficulty),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  
                  // Περιγραφή
                  Text(
                    'Περιγραφή',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.recipe.description,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color? color;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: (color ?? Theme.of(context).primaryColor).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: (color ?? Theme.of(context).primaryColor).withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color ?? Theme.of(context).primaryColor, size: 24),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: color ?? Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}