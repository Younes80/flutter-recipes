import 'package:flutter/material.dart';
import 'package:learningtuto/recipe.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class RecipeDatabase {
  RecipeDatabase._();

  static final RecipeDatabase instance = RecipeDatabase._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    return await openDatabase(
      join(await getDatabasesPath(), 'recipe_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE recipe(title TEXT PRIMARY KEY, user TEXT, imageUrl TEXT, description TEXT, isFavorite INTEGER, favoriteCount INTEGER)",
        );
      },
      version: 1,
    );
  }

  void insertRecipe(Recipe recipe) async {
    final Database db = await database;
    await db.insert(
      'recipe',
      recipe.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  void updateRecipe(Recipe recipe) async {
    final Database db = await database;
    await db.update(
      "recipe",
      recipe.toMap(),
      where: "title = ?",
      whereArgs: [recipe.title],
    );
  }

  void deleteRecipe(String title) async {
    final Database db = await database;
    db.delete(
      "recipe",
      where: "title = ?",
      whereArgs: [title],
    );
  }

  Future<List<Recipe>> recipes() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('recipe');
    List<Recipe> recipes = List.generate(maps.length, (i) {
      return Recipe.fromMap(maps[i]);
    });

    if (recipes.isEmpty) {
      for (Recipe recipe in defaultRecipes) {
        insertRecipe(recipe);
      }
      recipes = defaultRecipes;
    }

    return recipes;
  }


  final List<Recipe> defaultRecipes = [ 
    Recipe(
      "Pizza facile",
      "Par Younes",
      'https://media.istockphoto.com/photos/high-angle-view-of-vegetables-dill-and-parsley-around-pizza-four-picture-id953514940?k=6&m=953514940&s=612x612&w=0&h=LYd3VGmYGbbOtdongVKqFbeQrBxzPgLUrTLDQMh37QM=',
      "Etaler la pâte à pizza dans un plat à tarte, la piquer avec une fourchette, étaler le coulis de tomate sur la pâte. \n\nDécouper des rondelles de fromage de chèvre et de mozzarella, découper aussi de fines tranches de roquefort. \n\nPlacer le fromage en alternance (une tranche de fromage de chèvre, une de mozzarella, une de roquefort). \n\nCouvrir de gruyère râpé. \n\nSaler et poivrer selon les goûts. \n\nMettre au four à Thermostat 7 (210°C), pendant 1/2 heure et plus si nécessaire.",
      false,
      59,
    ),
    Recipe(
      "Burger maison",
      "Par Cyril",
      'https://www.club-sandwich.net/images/photorecettes/burger-regime-123rf.jpg',
      "Etaler la pâte à pizza dans un plat à tarte, la piquer avec une fourchette, étaler le coulis de tomate sur la pâte. \n\nDécouper des rondelles de fromage de chèvre et de mozzarella, découper aussi de fines tranches de roquefort. \n\nPlacer le fromage en alternance (une tranche de fromage de chèvre, une de mozzarella, une de roquefort). \n\nCouvrir de gruyère râpé. \n\nSaler et poivrer selon les goûts. \n\nMettre au four à Thermostat 7 (210°C), pendant 1/2 heure et plus si nécessaire.",
      false,
      59,
    ),
    Recipe(
      "Bolognaise maison",
      "Par Younes",
      'https://gourmandiz.dhnet.be/app/uploads/2018/04/spaghettisraguagneau-690x388.jpg',
      "Etaler la pâte à pizza dans un plat à tarte, la piquer avec une fourchette, étaler le coulis de tomate sur la pâte. \n\nDécouper des rondelles de fromage de chèvre et de mozzarella, découper aussi de fines tranches de roquefort. \n\nPlacer le fromage en alternance (une tranche de fromage de chèvre, une de mozzarella, une de roquefort). \n\nCouvrir de gruyère râpé. \n\nSaler et poivrer selon les goûts. \n\nMettre au four à Thermostat 7 (210°C), pendant 1/2 heure et plus si nécessaire.",
      false,
      59,
    ),
    Recipe(
        "Crêpe comme chez nous",
        "Par Xouxou",
        "https://cac.img.pmdstatic.net/fit/http.3A.2F.2Fprd2-bone-image.2Es3-website-eu-west-1.2Eamazonaws.2Ecom.2Fcac.2F2018.2F09.2F25.2F830851b1-1f2a-4871-8676-6c06b0962938.2Ejpeg/748x372/quality/90/crop-from/center/crepes-comme-chez-nous.jpeg",
        "Versez la farine dans un grand saladier, creusez un puits. Cassez les œufs, délayez petit à petit avec le lait sans former de grumeaux. Ajoutez l’huile et le sel et mélangez bien.\nLaissez reposer la pâte 1 h sous un torchon propre à température ambiante.\nHuilez légèrement une poêle à crêpes, versez une demi-louche de pâte dans la poêle bien chaude, laissez cuire jusqu’à ce que les bords se détachent (30 sec environ). Retournez la crêpe, faites cuire l’autre face et glissez-la sur une assiette.\nProcédez ainsi pour toutes les crêpes.",
        true,
        13),
    Recipe(
        "Cake nature sucré",
        "Par Huguette",
        "https://cac.img.pmdstatic.net/fit/http.3A.2F.2Fprd2-bone-image.2Es3-website-eu-west-1.2Eamazonaws.2Ecom.2FCAC.2Fvar.2Fcui.2Fstorage.2Fimages.2Fdossiers-gourmands.2Ftendance-cuisine.2Fles-gateaux-du-gouter-45-recettes-gourmandes-en-diaporama-187414.2F1637287-1-fre-FR.2Fles-gateaux-du-gouter-45-recettes-gourmandes-en-diaporama.2Ejpg/748x372/quality/90/crop-from/center/cake-nature-sucre.jpeg",
        "Travaillez le beurre avec le sucre en poudre.\nIncorporez les œufs, 1 par 1. Ajoutez la farine.\nVersez dans un moule à empreinte rectangulaire en silicone. Faites cuire 45 à 50 min dans le four, préchauffé à 180°C (th. 6).\nDémoulez et laissez refroidir avant de déguster.",
        true,
        18),
    Recipe(
        "Donuts avec appareil à donuts",
        "Par Heud",
        "https://cac.img.pmdstatic.net/fit/http.3A.2F.2Fprd2-bone-image.2Es3-website-eu-west-1.2Eamazonaws.2Ecom.2Fcac.2F2018.2F09.2F25.2F80586d11-1f17-40ad-80ae-4cd9b5c42182.2Ejpeg/748x372/quality/90/crop-from/center/donuts-avec-appareil-a-donuts.jpeg",
        "Délayez la levure dans 2 cuil. à soupe de lait tiède. Réservez 15 min. Fouettez les œufs avec les sucres. Mélangez avec la farine et la levure. Incorporez le lait.\nLaissez la pâte reposer 1 h.\nFaites chauffer la machine et huilez les alvéoles avec un pinceau de cuisine. Versez des cuillerées de pâte dans les alvéoles de la machine chaude, en évitant de mettre de la pâte au centre. Faites cuire 2 min environ.\nFaites fondre le chocolat. Détendez-le avec un peu d'eau. Trempez-les beignets dans le chocolat. Parsemez de vermicelles. Laissez refroidir avant de déguster.",
        true,
        109),
    Recipe(
        "Oreilles d'aman",
        "Par Esther",
        "https://2.bp.blogspot.com/-D9fvvQ1XyZk/WL7KSRDBe_I/AAAAAAAAhjI/udiioVWKJ20FV-P3WfW4V8TNXZDkQJ5bgCLcB/s1600/UNADJUSTEDNONRAW_thumb_3e0d.jpg",
        "Dans un saladier, battre l'œuf avec le sucre et le sucre vanillé.\nAjouter la farine et la levure et incorporer à la spatule.\nAjouter les morceaux de beurre et sabler avec les doigts comme quand on égraine la semoule.\nMalaxer ensuite avec les mains pour obtenir une boule.\nLaisser reposer 1h au frigo.",
        true,
        55)
  ];
}
