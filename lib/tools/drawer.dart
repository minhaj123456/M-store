import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoe_world/provider/theme_provider.dart';
import 'package:shoe_world/screen/cart_screen.dart';
import 'package:shoe_world/screen/wishlist_page.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text('John Doe'),
            accountEmail: const Text('johndoe@example.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                'J',
                style: TextStyle(fontSize: 24, color: Colors.blue),
              ),
            ),
            decoration: BoxDecoration(
              color: themeProvider.isDarkMode ? Colors.grey[900] : Colors.blueGrey,
            ),
          ),

          // Main navigation links
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Cart'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Wishlist'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WishlistScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.list_alt),
            title: const Text('Orders'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            // trailing: DropdownButton<String>(
            //   value: 'English',
            //   items: const [
            //     DropdownMenuItem(value: 'English', child: Text('English')),
            //     DropdownMenuItem(value: 'Arabic', child: Text('Arabic')),
            //   ],
            //   onChanged: (val) {},
            // ),
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.article),
            title: const Text('Terms & Conditions'),
            onTap: () => Navigator.pop(context),
          ),
          

          const Divider(),

          // Theme toggle
          ListTile(
            leading: Icon(themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            title: const Text('Toggle Theme'),
            onTap: () => themeProvider.toggleTheme(),
          ),

          // Logout
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () => Navigator.pop(context),
          ),

          // App version footer
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'App Version 1.0.0',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
