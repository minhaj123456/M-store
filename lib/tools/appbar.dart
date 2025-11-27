import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoe_world/provider/theme_provider.dart';
import 'package:shoe_world/user/login.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return AppBar(
      elevation: 0,
      title: Column(
        children: [
   
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.person),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
          },
        ),
        IconButton(
          icon: Icon(themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode),
          onPressed: () {
            themeProvider.toggleTheme();
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Notifications clicked')),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 20); // slightly taller for logo
}
