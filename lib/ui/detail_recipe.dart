import 'package:flutter/material.dart';
import 'package:resepmakanan_5b/models/recipe_model.dart';
import 'package:resepmakanan_5b/services/recipe_service.dart';

class RecipeDetailScreen extends StatefulWidget {
  final int recipeId;

  const RecipeDetailScreen({Key? key, required this.recipeId})
      : super(key: key);

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  final RecipeService _recipeService = RecipeService();
  late Future<RecipeModel> futureRecipe;

  @override
  void initState() {
    super.initState();
    futureRecipe = _recipeService.getRecipeById(widget.recipeId.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Recipe"),
      ),
      body: FutureBuilder<RecipeModel>(
        future: futureRecipe,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text("Recipe not found"),
            );
          } else {
            final recipe = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      recipe.photoUrl,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      recipe.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        //likes
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text("${recipe.likesCount} likes"),
                        SizedBox(
                          width: 12,
                        ),
                        // comments
                        Icon(Icons.comment),
                        SizedBox(
                          width: 4,
                        ),
                        Text("${recipe.commentsCount} comment")
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Description:",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(recipe.description),
                    const SizedBox(height: 16),
                    Text(
                      "Ingredients:",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(recipe.ingredients),
                    const SizedBox(height: 16),
                    Text(
                      "Steps:",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(recipe.cookingMethod),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
