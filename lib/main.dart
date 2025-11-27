import 'package:flutter/material.dart';
import 'package:shoe_world/provider/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:shoe_world/provider/theme_provider.dart';
import 'package:shoe_world/provider/wislist_provider.dart';
import 'package:shoe_world/screen/splash_screen.dart';
import 'package:shoe_world/tools/mainlayout.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return AnimatedTheme(
      data: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      duration: const Duration(milliseconds: 500),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.grey[100],
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
        ),
        darkTheme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
          cardColor: Colors.grey[900],
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
