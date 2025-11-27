import 'package:flutter/material.dart';
import 'package:shoe_world/model/product.dart';

class CartProvider extends ChangeNotifier {
  final List<Product> _cartItems = [];

  List<Product> get cartItems => _cartItems;

  void addToCart(Product product) {
    // Check if already in cart
    final index = _cartItems.indexWhere((item) => item.id == product.id);

    if (index != -1) {
      // Already in cart → increase quantity
      _cartItems[index].quantity++;
    } else {
      // New product → add with quantity = 1
      product.quantity = 1;
      _cartItems.add(product);
    }

    notifyListeners();
  }

  void removeFromCart(Product product) {
    _cartItems.remove(product);
    notifyListeners();
  }

  void increaseQuantity(Product product) {
    final index = _cartItems.indexWhere((item) => item.id == product.id);

    if (index != -1) {
      _cartItems[index].quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity(Product product) {
    final index = _cartItems.indexWhere((item) => item.id == product.id);

    if (index != -1) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity--;
      } else {
        // Remove item if quantity becomes zero
        _cartItems.removeAt(index);
      }
      notifyListeners();
    }
  }

  double get totalPrice {
    double sum = 0.0;

    for (var item in _cartItems) {
      sum += item.price * item.quantity;
    }

    return sum;
  }
}
