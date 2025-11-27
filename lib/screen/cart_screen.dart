import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoe_world/provider/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
     

      bottomNavigationBar: cartProvider.cartItems.isEmpty
          ? null
          : Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.transparent,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Total Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total:",
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "\$${cartProvider.totalPrice.toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                           ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Checkout Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).brightness == Brightness.dark
        ? Colors.orange[700]  // dark mode button color
        : Colors.orange,      // light mode button color
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  onPressed: () {
    // Your checkout logic here
  },
  child: Text(
    "Checkout",
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.black   // dark mode text color
          : Colors.white,  // light mode text color
    ),
  ),
),

                  ),
                ],
              ),
            ),

      body: cartProvider.cartItems.isEmpty
          ? const Center(
              child: Text(
                '🛒 Your cart is empty',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cartProvider.cartItems.length,
              itemBuilder: (context, index) {
                final item = cartProvider.cartItems[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
  color: Theme.of(context).brightness == Brightness.dark
      ? Colors.white30 // in dark mode
      : Colors.white, // in light mode                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      // Product Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          item.image,
                          width: 70,
                          height: 70,
                          fit: BoxFit.fill,
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Product Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "\$${item.price.toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontSize: 15,
                                  // color: Colors.black87,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),

                      // Quantity Buttons
                      Row(
                        children: [
                          // "-" Button
                          IconButton(
                            onPressed: () {
                              cartProvider.decreaseQuantity(item);
                            },
                            icon: const Icon(Icons.remove_circle_outline),
                          ),

                          Text(
                            item.quantity.toString(),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),

                          // "+" Button
                          IconButton(
                            onPressed: () {
                              cartProvider.increaseQuantity(item);
                            },
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                        ],
                      ),

                      // Delete Button
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          cartProvider.removeFromCart(item);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
