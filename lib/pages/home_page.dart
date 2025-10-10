import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../hive_service/hive_service.dart';
import '../model/product_model.dart';
import 'order_history_page.dart';
import '../screens/edit_profile.dart';
import 'cart_page.dart';
import '../bloc/cart/cart_bloc.dart';
import '../screens/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  String _selectedCategory = "All";
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildProductsPage(context),
      const CartPage(),
      SafeArea(child: const ProfilePage()),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text(
          "Yeji Motor Shop",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[900],
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              if (constraints.maxWidth > 900)
                NavigationRail(
                  backgroundColor: Colors.grey[850],
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (index) =>
                      setState(() => _currentIndex = index),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text("Home"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.shopping_cart),
                      label: Text("Cart"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person),
                      label: Text("Profile"),
                    ),
                  ],
                ),
              Expanded(child: pages[_currentIndex]),
            ],
          );
        },
      ),
      bottomNavigationBar: MediaQuery.of(context).size.width <= 900
          ? BottomNavigationBar(
              backgroundColor: Colors.grey[900],
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              selectedItemColor: Colors.purpleAccent,
              unselectedItemColor: Colors.white54,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart),
                  label: "Cart",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: "Profile",
                ),
              ],
            )
          : null,
    );
  }

  Widget _buildProductsPage(BuildContext context) {
    List<ProductModel> allProducts = HiveService.getAllProducts();

    List<ProductModel> filteredProducts = allProducts.where((p) {
      final matchCategory =
          _selectedCategory == "All" || p.category == _selectedCategory;
      final matchSearch =
          _searchQuery.isEmpty ||
          p.name.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchCategory && matchSearch;
    }).toList();

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search products...",
                  hintStyle: const TextStyle(color: Colors.white54),
                  prefixIcon: const Icon(Icons.search, color: Colors.white70),
                  filled: true,
                  fillColor: Colors.grey[850],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
            ),
            SizedBox(
              height: 180,
              child: PageView(
                children: [
                  _banner("assets/images/helmet.webp", "Big Sale on Helmets!"),
                  _banner("assets/images/jackets.webp", "Rider Jackets Sale!"),
                  _banner("assets/images/wheel.webp", "Premium Wheels Here!"),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildCategoryChip("All"),
                  _buildCategoryChip("Shoes"),
                  _buildCategoryChip("Helmets"),
                  _buildCategoryChip("Gloves"),
                  _buildCategoryChip("Accessories"),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _sectionTitle("Products"),
            LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = constraints.maxWidth > 1200
                    ? 5
                    : constraints.maxWidth > 900
                    ? 4
                    : constraints.maxWidth > 600
                    ? 3
                    : 2;
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) =>
                      _buildProductCard(filteredProducts[index]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(ProductModel product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: Image.asset(
                product.image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Image.asset('assets/images/helmet.webp', fit: BoxFit.cover),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product.desc,
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
                const SizedBox(height: 6),
                Text(
                  "₱${product.price}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.purpleAccent,
                  ),
                ),
                const SizedBox(height: 8),
                _gradientButton("Add to Cart", () {
                  context.read<CartBloc>().add(
                    AddToCartEvent({
                      'name': product.name,
                      'desc': product.desc,
                      'price': product.price,
                      'image': product.image,
                      'quantity': 1,
                    }),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Added to cart!",
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.black87,
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    bool selected = _selectedCategory == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        selectedColor: Colors.purple,
        labelStyle: TextStyle(color: selected ? Colors.white : Colors.white70),
        backgroundColor: Colors.grey[850],
        onSelected: (_) => setState(() => _selectedCategory = label),
      ),
    );
  }

  Widget _gradientButton(String text, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          minimumSize: const Size.fromHeight(40),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }

  Widget _banner(String img, String text) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(img, fit: BoxFit.cover),
        Container(
          color: Colors.black.withOpacity(0.4),
          alignment: Alignment.center,
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
