import 'package:flutter/material.dart';

class SearchAndCategories extends StatelessWidget {
  final String searchQuery;
  final Function(String) onSearchChanged;
  final List<String> categories;
  final String? selectedCategory;
  final Function(String?) onCategorySelected;

  const SearchAndCategories({
    super.key,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isDesktop = constraints.maxWidth >= 1024;

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 40 : 16,
            vertical: 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar centered on desktop
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: isDesktop ? 500 : double.infinity,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search products...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: onSearchChanged,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                height: 38,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _categoryChip("All", selectedCategory == null, () {
                      onCategorySelected(null);
                    }),

                    ...categories.map((cat) => _categoryChip(
                          cat,
                          selectedCategory == cat,
                          () => onCategorySelected(cat),
                        ))
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _categoryChip(String label, bool selected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
      ),
    );
  }
}
