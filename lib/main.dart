import 'package:flutter/material.dart';
import 'package:learningtuto/recipe_box.dart';
// import 'package:learningtuto/recipe.dart';
import 'package:learningtuto/recipe_list_screen.dart';
import 'package:learningtuto/recipe_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // ignore: await_only_futures
  await RecipeBox.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute: '/',
      onGenerateRoute: (settings) => RouteGenerator.generateRoute(settings),
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
    );
  }
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => RecipeListScreen());
      case '/recipe':
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              RecipeScreen(recipe: settings.arguments),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            animation = CurvedAnimation(parent: animation, curve: Curves.ease);
            return FadeTransition(opacity: animation, child: child);
            // var begin = Offset(0.0, 1.0);
            // var end = Offset.zero;
            // var curve = Curves.ease;
            // var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            // return SlideTransition(
            //   position: animation.drive(tween),
            //   child: child,
            // );
          },
        );
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text("Error"),
              centerTitle: true,
            ),
            body: Text("Page not found"),
          ),
        );
    }
  }
}
