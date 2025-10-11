import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../hive_service/hive_service.dart';
import '../model/product_model.dart';
import '../bloc/cart/cart_bloc.dart';
import 'cart_page.dart';
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
      _buildProductsPage(context, kIsWeb),
      const CartPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[900],

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Yeji Motor Shop",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        actions: kIsWeb
            ? [
                _navButton(Icons.home, "Home", 0),
                _navButton(Icons.shopping_cart, "Cart", 1),
                _navButton(Icons.person, "Profile", 2),
                const SizedBox(width: 20),
              ]
            : null,
      ),

      body: pages[_currentIndex],

      bottomNavigationBar: !kIsWeb
          ? BottomNavigationBar(
              backgroundColor: Colors.black,
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              selectedItemColor: Colors.purpleAccent,
              unselectedItemColor: Colors.white54,
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

  Widget _navButton(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    return TextButton.icon(
      onPressed: () => setState(() => _currentIndex = index),
      icon: Icon(
        icon,
        color: isSelected ? Colors.purpleAccent : Colors.white,
        size: 22,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.purpleAccent : Colors.white,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildProductsPage(BuildContext context, bool isWeb) {
    List<ProductModel> allProducts = HiveService.getAllProducts();
    List<ProductModel> filtered = allProducts.where((p) {
      final matchCategory =
          _selectedCategory == "All" || p.category == _selectedCategory;
      final matchSearch =
          _searchQuery.isEmpty ||
          p.name.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchCategory && matchSearch;
    }).toList();

    final horizontalPadding = isWeb ? 80.0 : 16.0;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 16,
              ),
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
                onChanged: (v) => setState(() => _searchQuery = v),
              ),
            ),
            SizedBox(
              height: isWeb ? 250 : 180,
              child: PageView(
                children: [
                  _banner("assets/images/helmet.webp", "Big Sale on Helmets!"),
                  _banner("assets/images/jackets.webp", "Rider Jackets Sale!"),
                  _banner("assets/images/wheel.webp", "Premium Wheels Here!"),
                ],
              ),
            ),

            const SizedBox(height: 30),
            _buildCategoryChips(),
            const SizedBox(height: 20),
            _sectionTitle("Products"),
            _buildProductGrid(filtered, isWeb),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChips() => SizedBox(
    height: 40,
    child: ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: ["All", "Shoes", "Helmets", "Gloves", "Accessories"]
          .map(
            (label) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(label),
                selected: _selectedCategory == label,
                selectedColor: Colors.purple,
                labelStyle: TextStyle(
                  color: _selectedCategory == label
                      ? Colors.white
                      : Colors.white70,
                ),
                backgroundColor: Colors.grey[850],
                onSelected: (_) => setState(() => _selectedCategory = label),
              ),
            ),
          )
          .toList(),
    ),
  );

  Widget _buildProductGrid(List<ProductModel> products, bool isWeb) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = isWeb
            ? (constraints.maxWidth ~/ 250).clamp(3, 6)
            : (constraints.maxWidth ~/ 180).clamp(2, 3);

        return GridView.builder(
          padding: EdgeInsets.symmetric(
            horizontal: isWeb ? 80 : 16,
            vertical: 16,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: isWeb ? 0.8 : 0.72,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) =>
              _buildProductCard(products[index], isWeb),
        );
      },
    );
  }

  Widget _buildProductCard(ProductModel product, bool isWeb) {
    bool hovered = false;

    return StatefulBuilder(
      builder: (context, setLocalState) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setLocalState(() => hovered = true),
          onExit: (_) => setLocalState(() => hovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            transform: Matrix4.identity()
              ..translate(0.0, hovered && isWeb ? -6.0 : 0.0)
              ..scale(hovered && isWeb ? 1.02 : 1.0),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                if (hovered && isWeb)
                  BoxShadow(
                    color: Colors.purpleAccent.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 6),
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
                      errorBuilder: (_, __, ___) => Image.asset(
                        'assets/images/helmet.webp',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
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
          ),
        );
      },
    );
  }

  Widget _gradientButton(String text, VoidCallback onPressed) => Container(
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
      child: Text(text, style: const TextStyle(color: Colors.white)),
    ),
  );

  Widget _banner(String img, String text) => Stack(
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

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  );
}
