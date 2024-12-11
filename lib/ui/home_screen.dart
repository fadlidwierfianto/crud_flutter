import 'package:flutter/material.dart';
import 'package:resepmakanan_5b/models/recipe_model.dart';
import 'package:resepmakanan_5b/services/recipe_service.dart';
import 'package:resepmakanan_5b/ui/add_recipe.dart';
import 'package:resepmakanan_5b/ui/detail_recipe.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  RecipeService _recipeService = RecipeService();
  late Future<List<RecipeModel>> futureRecipes;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureRecipes = _recipeService.getAllRecipe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: FutureBuilder<List<RecipeModel>>(
          future: futureRecipes,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error load data ${snapshot.error}"),
              );
            } else if (!snapshot.hasData) {
              return Center(
                child: Text("Tidak ada data"),
              );
            } else {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final data = snapshot.data![index];
                  return CustomCard(
                      id: data.id,
                      title: data.title,
                      img: data.photoUrl,
                      likes_count: data.likesCount,
                      comments_count: data.commentsCount);
                },
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddRecipe()),
          );

          if (result == true) {
            // Refresh data
            setState(() {
              futureRecipes = _recipeService.getAllRecipe();
            });
          }
        },
        child: Icon(Icons.add),
        tooltip: 'Add Recipe',
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  String title;
  String img;
  int likes_count;
  int comments_count;
  int id;
  CustomCard({
    required this.id,
    required this.title,
    required this.img,
    required this.likes_count,
    required this.comments_count,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // nagitor push
        // Pindah ke halaman detail
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RecipeDetailScreen(recipeId: id)));
      },
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          children: [
            Image.network(
              "$img",
              fit: BoxFit.cover,
              width: 50,
              height: 50,
            ),
            Text(
              "$title",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [Icon(Icons.star), Text("$likes_count")],
                ),
                Row(
                  children: [Icon(Icons.comment), Text("$comments_count")],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
