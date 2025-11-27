import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shoe_world/model/product.dart';
import 'package:shoe_world/provider/cart_provider.dart';
import 'package:shoe_world/screen/checkout.dart';
import 'package:shoe_world/services/api_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

// Skeleton loader for similar products
class SkeletonSimilarProduct extends StatelessWidget {
  const SkeletonSimilarProduct({super.key});
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey,
        ),
      ),
    );
  }
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 1;
  String? selectedColor;
  String? selectedSize;
  List<Product> similarProducts = [];
  bool isLoadingSimilar = true;

  @override
  void initState() {
    super.initState();
    selectedColor = widget.product.colors?.first;
    selectedSize = widget.product.sizes?.first;
    _loadSimilarProducts();
  }

  Future<void> _loadSimilarProducts() async {
    if (widget.product.category == null) return;
    try {
      final products = await ApiService.fetchProductsByCategory(widget.product.category!);
      setState(() {
        similarProducts = products.where((p) => p.id != widget.product.id).map((p) {
          p.colors = ApiService.generateRandomColors();
          p.sizes = ApiService.generateRandomSizes();
          return p;
        }).toList();
        isLoadingSimilar = false;
      });
    } catch (e) {
      debugPrint('Failed to load similar products: $e');
      setState(() => isLoadingSimilar = false);
    }
  }

@override
Widget build(BuildContext context) {
  final cartProvider = Provider.of<CartProvider>(context, listen: false);

  return Scaffold(
    appBar: AppBar(
      title: Text(widget.product.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      elevation: 0,
      centerTitle: true,
    ),
    bottomNavigationBar: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Add to Cart Button
          Expanded(
            child: ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).brightness == Brightness.dark
        ? const Color.fromARGB(255, 254, 253, 253)
        : const Color.fromARGB(255, 4, 4, 4), // adapts to dark/light mode
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    minimumSize: const Size.fromHeight(50),
  ),
  onPressed: () {
    for (int i = 0; i < quantity; i++) {
      cartProvider.addToCart(widget.product);
    }
    Fluttertoast.showToast(msg: '$quantity item(s) added to cart');
  },
  child: Text(
    'Add to Cart',
    style: TextStyle(
      fontSize: 18,
      color: Theme.of(context).brightness == Brightness.dark
          ? const Color.fromARGB(255, 7, 7, 7) // light color in dark mode
          : const Color.fromARGB(255, 254, 254, 254),                 // dark color in light mode
    ),
  ),
)

          ),
          const SizedBox(width: 16),
          // Buy Now Button
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CheckoutScreen(product: widget.product, quantity: quantity),
                  ),
                );
              },
              child: const Text('Buy Now', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ),
        ],
      ),
    ),
    body: LayoutBuilder(
      builder: (context, constraints) {
        // Breakpoints
        final isMobile = constraints.maxWidth < 600;
        final isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 1200;
        final isDesktop = constraints.maxWidth >= 1200;

        final horizontalPadding = isMobile
            ? 16.0
            : isTablet
                ? 32.0
                : 64.0;
        final imageHeight = isMobile
            ? 260.0
            : isTablet
                ? 350.0
                : 450.0;
        final fontSizeTitle = isMobile
            ? 24.0
            : isTablet
                ? 28.0
                : 32.0;

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Center(
                  child: Hero(
                    tag: 'product_${widget.product.id}',
                    child: Image.network(widget.product.image, height: imageHeight),
                  ),
                ),
                const SizedBox(height: 16),

                // Title & Rating
                Text(widget.product.title,
                    style: TextStyle(fontSize: fontSizeTitle, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    // Quantity Selector (Left)
    Row(
      children: [
        Text(
          "Quantity:",
          style: TextStyle(
            fontSize: isMobile ? 16 : 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
  color: Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[800]   // dark mode background
        : Colors.grey[300],           ),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  if (quantity > 1) setState(() => quantity--);
                },
                icon: Icon(Icons.remove, size: isMobile ? 20 : 24),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  quantity.toString(),
                  key: ValueKey<int>(quantity),
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => setState(() => quantity++),
                icon: Icon(Icons.add, size: isMobile ? 20 : 24),
              ),
            ],
          ),
        ),
      ],
    ),

    // Rating Stars (Right)
    Row(
      children: List.generate(5, (i) {
        final rating = widget.product.rating ?? 0.0;
        return Icon(
          i < rating.round() ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: isMobile ? 18 : 20,
        );
      }),
    ),
  ],
),


                const SizedBox(height: 10),

                // Color & Size selectors (wrap into grid on desktop/tablet)
                if (widget.product.colors != null && widget.product.colors!.isNotEmpty) ...[
                  const Text("Select Color", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.product.colors!.map((color) {
                      final isSelected = selectedColor == color;
                      return ChoiceChip(
                        label: Text(color),
                        selected: isSelected,
selectedColor: Theme.of(context).brightness == Brightness.dark
    ? const Color.fromARGB(255, 92, 175, 175)   // brighter for dark mode
    : const Color.fromARGB(255, 13, 13, 14),       // normal for light mode
                        backgroundColor: Colors.grey[200],
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        onSelected: (_) => setState(() => selectedColor = color),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                ],

                if (widget.product.sizes != null && widget.product.sizes!.isNotEmpty) ...[
                  const Text("Select Size", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.product.sizes!.map((size) {
                      final isSelected = selectedSize == size;
                      return ChoiceChip(
                        label: Text(size),
                        selected: isSelected,
selectedColor: Theme.of(context).brightness == Brightness.dark
    ? const Color.fromARGB(255, 92, 175, 175)   // brighter for dark mode
    : const Color.fromARGB(255, 13, 13, 14),                          backgroundColor: Colors.grey[200],
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        onSelected: (_) => setState(() => selectedSize = size),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                ],

                // Description
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[900]
                        : Colors.grey[200],
                  ),
                  child: Text(widget.product.description,
                      style: TextStyle(fontSize: isMobile ? 16 : 18, height: 1.4)),
                ),

                const SizedBox(height: 24),

                // Similar Products Carousel
                Text("Similar Products", style: TextStyle(fontSize: isMobile ? 18 : 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                SizedBox(
                  height: isMobile ? 250 : isTablet ? 280 : 320,
                  child: isLoadingSimilar
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 4,
                          itemBuilder: (_, __) => const SkeletonSimilarProduct(),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: similarProducts.length,
                          itemBuilder: (context, index) {
                            final product = similarProducts[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: product)),
                                );
                              },
                              child: Container(
                                width: isMobile ? 140 : isTablet ? 160 : 180,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2))],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Hero(
                                        tag: 'product_${product.id}',
                                        child: Image.network(product.image,
                                            height: isMobile ? 140 : isTablet ? 160 : 180,
                                            width: isMobile ? 140 : isTablet ? 160 : 180,
                                            fit: BoxFit.contain),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(product.title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: isMobile ? 14 : 16)),
                                    const SizedBox(height: 4),
                                    Text("\$${product.price.toStringAsFixed(2)}",
                                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        );
      },
    ),
  );
}
}
