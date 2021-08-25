import 'package:flutter/material.dart';
import 'package:learningtuto/recipe.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:learningtuto/recipe_database.dart';
// import 'package:learningtuto/recipe_screen.dart';

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({Key key}) : super(key: key);

  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes recettes'),
      ),
      body: FutureBuilder<List<Recipe>>(
        future: RecipeDatabase.instance.recipes(),
        builder: (BuildContext context, AsyncSnapshot<List<Recipe>> snapshot) {
          if (snapshot.hasData) {
            List<Recipe> recipes = snapshot.data;
            return ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return Dismissible(
                  key: Key(recipe.title),
                  onDismissed: (direction) {
                    setState(() {
                      RecipeDatabase.instance.deleteRecipe(recipe.title);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${recipe.title} supprimé'),
                      ),
                    );
                  },
                  background: Container(
                    color: Colors.red,
                  ),
                  child: RecipeItemWidget(
                    recipe: recipe,
                  ),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class RecipeItemWidget extends StatelessWidget {
  final Recipe recipe;
  final routeName = '/recipe';
  const RecipeItemWidget({Key key, @required this.recipe}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, routeName, arguments: recipe);
      },
      child: Card(
        margin: EdgeInsets.all(8),
        elevation: 5,
        child: Row(
          children: [
            Hero(
              tag: 'imageRecipe ${recipe.title}',
              child: CachedNetworkImage(
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                imageUrl: recipe.imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(
                      recipe.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Text(
                    recipe.user,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
