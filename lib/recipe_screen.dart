import 'package:flutter/material.dart';
import 'package:learningtuto/favorite_change_notifier.dart';
import 'package:learningtuto/favorite_widget.dart';
import 'package:learningtuto/recipe.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RecipeScreen extends StatelessWidget {
  final Recipe recipe;
  const RecipeScreen({Key key, @required this.recipe}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Widget titleSection = Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
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
          ),
          FavoriteIconWidget(),
          FavoriteTextWidget(),
        ],
      ),
    );

    Widget buttonSection = Container(
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonColumn(
            Colors.blue,
            Icons.comment_outlined,
            "Comment",
          ),
          _buildButtonColumn(
            Colors.blue,
            Icons.share,
            "Share",
          ),
        ],
      ),
    );

    Widget descriptionSection = Container(
      padding: const EdgeInsets.all(32),
      child: Text(
        recipe.description,
        softWrap: true,
      ),
    );

    return ChangeNotifierProvider(
      create: (context) =>
          FavoriteChangeNotifier(recipe),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Mes recettes"),
        ),
        body: ListView(
          children: [
            Hero(
              tag: 'imageRecipe ${recipe.title}',
              child: CachedNetworkImage(
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                imageUrl: recipe.imageUrl,
                width: 600,
                height: 240,
                fit: BoxFit.cover,
              ),
            ),
            titleSection,
            buttonSection,
            descriptionSection,
          ],
        ),
      ),
    );
  }

  Column _buildButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            padding: EdgeInsets.only(bottom: 8),
            child: Icon(
              icon,
              color: color,
              size: 40,
            )),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: color,
          ),
        ),
      ],
    );
  }
}
