import 'package:hive/hive.dart';

part 'recipe.g.dart';

@HiveType(typeId: 0)
class Recipe extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late String description;

  @HiveField(2)
  late int preparationTime; // σε λεπτά

  @HiveField(3)
  late String difficulty; // Εύκολο, Μεσαίο, Δύσκολο

  @HiveField(4)
  late String imagePath;

  @HiveField(5)
  late double rating; // 0-5

  Recipe({
    required this.title,
    required this.description,
    required this.preparationTime,
    required this.difficulty,
    required this.imagePath,
    this.rating = 0.0,
  });
}