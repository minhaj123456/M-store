import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoe_world/model/product.dart';
import 'package:shoe_world/provider/wislist_provider.dart';
import 'package:shoe_world/screen/product_details.dart';
import 'package:shoe_world/test/skelton.dart';
import 'package:shoe_world/tools/appbar.dart';
import 'package:shoe_world/tools/drawer.dart';
import 'package:shoe_world/tools/searchbar.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Product>> _products;
  List<String> _categories = [];
  String? _selectedCategory;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _loadCategories();
  }

  void _loadProducts() {
    _products = _selectedCategory == null
        ? ApiService.fetchProducts()
        : ApiService.fetchProductsByCategory(_selectedCategory!);
  }

  void _loadCategories() async {
    final categories = await ApiService.fetchCategories();
    setState(() {
      _categories = categories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          
          SearchAndCategories(
            searchQuery: _searchQuery,
            onSearchChanged: (q) => setState(() => _searchQuery = q),
            categories: _categories,
            selectedCategory: _selectedCategory,
            onCategorySelected: (c) {
              setState(() {
                _selectedCategory = c;
                _loadProducts();
              });
            },
          ),

          Expanded(
            child: FutureBuilder<List<Product>>(
              future: _products,
              builder: (context, snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildSkeletonGrid();
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No products found"));
                }

                final filtered = snapshot.data!
                    .where((p) =>
                        p.title.toLowerCase().contains(_searchQuery.toLowerCase()))
                    .toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text("No products match your search"));
                }

                return _buildResponsiveGrid(filtered);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // SKELETON RESPONSIVE
  Widget _buildSkeletonGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossCount = _getCrossAxisCount(constraints.maxWidth);

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossCount,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.65,
          ),
          itemCount: crossCount * 2,
          itemBuilder: (_, __) => const SkeletonProductCard(),
        );
      },
    );
  }

  // ------------------------------------------------------------
  // PRODUCT GRID (RESPONSIVE)
  Widget _buildResponsiveGrid(List<Product> products) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        int crossCount = _getCrossAxisCount(width);
        double aspect = _getAspectRatio(width);

        return GridView.builder(
          padding: EdgeInsets.symmetric(
            horizontal: width >= 1024 ? 40 : 16,
            vertical: 20,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossCount,
            mainAxisSpacing: 18,
            crossAxisSpacing: 18,
            childAspectRatio: aspect,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            return _productCard(products[index]);
          },
        );
      },
    );
  }

  // ------------------------------------------------------------
  // RESPONSIVE BREAKPOINTS
  int _getCrossAxisCount(double width) {
    if (width >= 1200) return 5; // Desktop Large
    if (width >= 900) return 4;  // Desktop Normal
    if (width >= 600) return 3;  // Tablet
    return 2;                    // Mobile
  }

  double _getAspectRatio(double width) {
    if (width >= 1200) return 0.9;
    if (width >= 900) return 0.85;
    if (width >= 600) return 0.75;
    return 0.65;
  }

  // ------------------------------------------------------------
  // PRODUCT CARD
  Widget _productCard(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailsScreen(product: product),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 3,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                    child: Hero(
                      tag: "product_${product.id}",
                      child: Image.network(
                        product.image,
                        fit: BoxFit.contain,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                Text(
                  "\$${product.price.toStringAsFixed(2)}",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),

                const SizedBox(height: 4),
              ],
            ),

            Positioned(
              top: 8,
              right: 8,
              child: Consumer<WishlistProvider>(
                builder: (_, wishlist, __) {
                  final fav = wishlist.isInWishlist(product);

                  return GestureDetector(
                    onTap: () => wishlist.toggleWishlist(product),
                    child: AnimatedScale(
                      scale: fav ? 1.15 : 1.0,
                      duration: const Duration(milliseconds: 250),
                      child: CircleAvatar(
  backgroundColor: Theme.of(context).brightness == Brightness.dark
      ? Colors.grey[900]   // dark mode background
      : Colors.white,                         radius: 16,
                        child: Icon(
                          fav ? Icons.favorite : Icons.favorite_border,
                          color: fav ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
