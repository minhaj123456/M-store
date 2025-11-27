📱 M-STORE – Flutter E-Commerce App

M-STORE is a modern Flutter-based e-commerce application designed to provide users with a smooth shopping experience for shoes and other fashion items. The app follows clean architecture, responsive UI design, and includes dark/light themes for better usability.

🚀 Features

🛍️ Product listings with image, price, rating
🔍 Search functionality
🖼️ Carousel banner
❤️ Wishlist / Favrites
🧾 Add to Cart
🌙 Dark & Light theme toggle
📦 Detailed product page
🔑 Login UI
⚙️ Settings page
🛒 Category selection (Shoes, Dress, Electronics, etc.)

🧠 Design Choices 

1️⃣ UI/UX Design
Clean and minimal UI
Smooth animations for better user experience
Consistent spacing, color, typography
Modern card layouts for products

2️⃣ State Management
The app uses Provider for:
Theme control
Cart management
Wishlist/Favorites
User settings

3️⃣ Project Architecture (Organized Structure)
lib/
 ├── model/            # Data models (Product, User, etc.)
 ├── provider/         # State management (ThemeProvider, CartProvider)
 ├── service/          # API services & backend calls
 ├── tools/            # Common widgets, utilities, animations
 ├── screen/           # Screens (Home, Login, Product Details, etc.)
 └── main.dart         # App entry point

4️⃣ API Integration
Uses Fake Store API to fetch product data
HTTP package handles GET requests
Proper error handling and loading indicators

5️⃣ Theming
Light + Dark theme
Theme stored using Provider
Dynamic AppBar, text, icon, and background colors

⏱️ Time Taken to Build
Task	Duration
UI Design + Planning	1 hours
Home Page + Product UI	1 hours
Provider State Setup	1 hours
Login + Settings UI	2 hours
API Integration	30 minutes
Dark Mode Setup	1 hour
Testing + Bug Fixes	1 hours
Total Time	~8.30 hours

🛠️ Tech Stack
Flutter 3.x
Dart
Provider State Management
HTTP Package
Google Fonts
Material Design 3
