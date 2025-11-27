import 'package:flutter/material.dart';
import 'package:shoe_world/model/product.dart';

class WishlistProvider extends ChangeNotifier {
  final List<Product> _wishlistItems = [];

  List<Product> get wishlistItems => _wishlistItems;

  bool isInWishlist(Product product) => _wishlistItems.contains(product);

  void toggleWishlist(Product product) {
    if (_wishlistItems.contains(product)) {
      _wishlistItems.remove(product);
    } else {
      _wishlistItems.add(product);
    }
    notifyListeners();
  }

  int get count => _wishlistItems.length;
}
