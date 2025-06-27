import 'package:flutter/material.dart';
import 'package:receitas_app/screens/add_recipe_screen.dart';
import 'package:receitas_app/screens/favorites_screen.dart'; // Import FavoritesScreen
import 'package:receitas_app/screens/profile_screen.dart';
import 'package:receitas_app/screens/splash_screen.dart';
import 'package:receitas_app/screens/recipe_detail_screen.dart';
import 'package:receitas_app/screens/saved_recipes_screen.dart'; // Import SavedRecipesScreen
import 'package:receitas_app/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:receitas_app/providers/theme_notifier.dart';
import 'package:receitas_app/models/recipe.dart';
import 'package:receitas_app/services/recipe_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeNotifier()),
        ChangeNotifierProvider(create: (context) => RecipeService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    final lightTheme = ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.red,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      scaffoldBackgroundColor: Colors.white,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      bottomAppBarTheme: const BottomAppBarTheme(
        color: Colors.red,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(color: Colors.grey[600]),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black87),
        bodyMedium: TextStyle(color: Colors.black87),
        headlineSmall: TextStyle(color: Colors.black87),
        headlineMedium: TextStyle(color: Colors.black87),
        titleMedium: TextStyle(color: Colors.black87),
        titleSmall: TextStyle(color: Colors.black87),
      ),
    );

    final darkTheme = ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.red,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.grey[850],
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      bottomAppBarTheme: BottomAppBarTheme(
        color: Colors.grey[900],
      ),
      cardTheme: CardThemeData(
        color: Colors.grey[800],
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[700],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(color: Colors.grey[400]),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white70),
        bodyMedium: TextStyle(color: Colors.white70),
        headlineSmall: TextStyle(color: Colors.white),
        headlineMedium: TextStyle(color: Colors.white),
        titleMedium: TextStyle(color: Colors.white),
        titleSmall: TextStyle(color: Colors.white),
      ),
    );

    return MaterialApp(
      title: 'Tá na Mesa',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeNotifier.themeMode,
      //========================================================//
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'), // alterando a linguagem para Português do Brasil
      ],
      //========================================================//
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/add_recipe': (context) => const AddRecipeScreen(),
        '/favorites': (context) => const FavoritesScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/saved_recipes': (context) => const SavedRecipesScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/recipe_detail') {
          final args = settings.arguments as Recipe;
          return MaterialPageRoute(
            builder: (context) {
              return RecipeDetailScreen(recipe: args);
            },
          );
        }
        return null;
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
