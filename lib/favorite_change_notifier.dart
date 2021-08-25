import 'package:flutter/foundation.dart';
import 'package:learningtuto/recipe.dart';
import 'package:learningtuto/recipe_database.dart';

class FavoriteChangeNotifier with ChangeNotifier {
  Recipe recipe;

  FavoriteChangeNotifier(this.recipe);

  bool get isFavorited => recipe.isFavorite;
  int get favoriteCount => recipe.favoriteCount + (recipe.isFavorite ? 1 : 0);

  set isFavorited(bool isFavorited) {
    recipe.isFavorite = isFavorited;
    RecipeDatabase.instance.updateRecipe(recipe);
    notifyListeners();
  }
}
