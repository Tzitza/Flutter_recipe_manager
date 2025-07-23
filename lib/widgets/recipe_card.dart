import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../widgets/star_rating.dart';
import 'dart:io';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;
  final Function(double) onRatingChanged;

  const RecipeCard({
    Key? key,
    required this.recipe,
    required this.onTap,
    required this.onRatingChanged,
  }) : super(key: key);

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

  Widget _buildImage(String imagePath) {
    return Image.file(
      File(imagePath),
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Icon(Icons.restaurant, size: 40, color: Colors.grey[600]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              // Εικόνα ή placeholder
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[300],
                ),
                child: recipe.imagePath.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _buildImage(recipe.imagePath),
                      )
                    : Icon(Icons.restaurant, size: 40, color: Colors.grey[600]),
              ),
              SizedBox(width: 16),
              
              // Περιεχόμενο
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    
                    Row(
                      children: [
                        Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                        SizedBox(width: 4),
                        Text(
                          '${recipe.preparationTime} λεπτά',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        SizedBox(width: 16),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getDifficultyColor(recipe.difficulty).withOpacity(0.1),
                            border: Border.all(color: _getDifficultyColor(recipe.difficulty)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            recipe.difficulty,
                            style: TextStyle(
                              color: _getDifficultyColor(recipe.difficulty),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 8),
                    StarRating(
                      rating: recipe.rating,
                      onRatingChanged: onRatingChanged,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}