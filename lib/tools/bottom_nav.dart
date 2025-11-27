import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        onTap(index);

        switch (index) {
          case 0:
            if (ModalRoute.of(context)?.settings.name != '/') {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            }
            break;
          case 1:
            if (ModalRoute.of(context)?.settings.name != '/cart') {
              Navigator.pushNamed(context, '/cart');
            }
            break;
          case 2:
            if (ModalRoute.of(context)?.settings.name != '/wishlist') {
              Navigator.pushNamed(context, '/wishlist');
            }
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Wishlist'),
      ],
    );
  }
}
