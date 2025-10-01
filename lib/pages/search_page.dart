import 'package:flutter/material.dart';
import '../hive_service/hive_service.dart';
import '../model/product_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  List<ProductModel> allProducts = [];
  List<ProductModel> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    allProducts = HiveService.getAllProducts();
    filteredProducts = allProducts;
    _searchCtrl.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    String query = _searchCtrl.text.toLowerCase();
    setState(() {
      filteredProducts = allProducts
          .where(
            (p) =>
                p.name.toLowerCase().contains(query) ||
                p.category.toLowerCase().contains(query),
          )
          .toList();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchCtrl,
          decoration: const InputDecoration(
            hintText: "Search products...",
            border: InputBorder.none,
          ),
          style: const TextStyle(fontSize: 18),
          autofocus: true,
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: filteredProducts.isEmpty
          ? const Center(child: Text("No products found"))
          : ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: ListTile(
                    leading: Image.asset(
                      product.image,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(product.name),
                    subtitle: Text("₱${product.price}"),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("${product.name} selected")),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
