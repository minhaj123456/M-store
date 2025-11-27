class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
    final double? rating; // optional, if available
  List<String>? colors; // available colors
  List<String>? sizes; // available sizes
    int quantity; // <--- ADD THIS


  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
      this.rating,
    this.colors,
    this.sizes,
        this.quantity = 1,

  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      category: json['category'],
      image: json['image'],
       rating: json['rating'] != null ? (json['rating']['rate'] as num).toDouble() : null,
      colors: json['colors'] != null
          ? List<String>.from(json['colors'])
          : ['Red', 'Blue', 'Green'], // default mock colors
      sizes: json['sizes'] != null
          ? List<String>.from(json['sizes'])
          : ['S', 'M', 'L', 'XL'], // default mock sizes
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'image': image,
      'category': category,
      'rating': rating,
      'colors': colors,
      'sizes': sizes,
      'quantity': quantity,
    };
  }
}
