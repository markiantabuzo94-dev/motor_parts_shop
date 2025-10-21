import 'package:hive_flutter/hive_flutter.dart';
import '../model/product_model.dart';
import '../model/user_model.dart';

class HiveService {
  static late Box<User> userBox;
  static late Box cartBox;
  static late Box<ProductModel> productBox;
  static late Box ordersBox;
  static late Box authBox;

  static String? currentUsername;

  static Future<void> init() async {
    userBox = await Hive.openBox<User>('users');
    cartBox = await Hive.openBox('cart');
    productBox = await Hive.openBox<ProductModel>('products');
    ordersBox = await Hive.openBox('orders');
    authBox = await Hive.openBox('auth');

    currentUsername = authBox.get('loggedInUser');

    if (productBox.isEmpty) {
      await initDefaultProducts();
    }
  }

  static Future<void> logout() async {
    await authBox.clear();
    currentUsername = null;
  }

  static Future<bool> saveUser({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String password,
    String? profilePic,
  }) async {
    if (userBox.containsKey(username)) return false;

    final user = User(
      firstName: firstName,
      lastName: lastName,
      username: username,
      email: email,
      password: password,
      profilePic: profilePic ?? 'assets/images/default_profile.jpg',
    );

    await userBox.put(username, user);
    return true;
  }

  static Future<bool> validateLogin(String username, String password) async {
    if (!userBox.containsKey(username)) return false;
    final user = userBox.get(username);
    if (user == null) return false;

    if (user.password == password) {
      currentUsername = username;
      await authBox.put('loggedInUser', username);
      return true;
    }
    return false;
  }

  static User? getUser() {
    if (currentUsername == null) return null;
    return userBox.get(currentUsername!);
  }

  static Future<void> updateUserProfile({
    required String firstName,
    required String lastName,
    required String email,
    String? newProfilePic,
  }) async {
    if (currentUsername == null) return;
    final user = getUser();
    if (user == null) return;

    final updated = User(
      firstName: firstName,
      lastName: lastName,
      username: user.username,
      email: email,
      password: user.password,
      profilePic: newProfilePic ?? user.profilePic,
      location: user.location,
    );

    await userBox.put(currentUsername!, updated);
  }

  static Future<void> updateUsername(String newUsername) async {
    if (currentUsername == null) return;
    if (userBox.containsKey(newUsername)) {
      throw Exception("Username already exists");
    }

    final user = getUser();
    if (user == null) return;

    final updated = User(
      firstName: user.firstName,
      lastName: user.lastName,
      username: newUsername,
      email: user.email,
      password: user.password,
      profilePic: user.profilePic,
      location: user.location,
    );

    await userBox.put(newUsername, updated);
    await userBox.delete(currentUsername!);

    currentUsername = newUsername;
    await authBox.put('loggedInUser', newUsername);
  }

  static Future<void> editProfile({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    String? profilePic,
  }) async {
    final oldUsername = currentUsername;
    if (oldUsername == null) return;

    if (username != oldUsername && username.isNotEmpty) {
      await updateUsername(username);
    }

    await updateUserProfile(
      firstName: firstName,
      lastName: lastName,
      email: email,
      newProfilePic: profilePic,
    );
  }

  static Future<void> updateUserLocation(String newLocation) async {
    if (currentUsername == null) return;
    final user = getUser();
    if (user == null) return;

    final updated = User(
      firstName: user.firstName,
      lastName: user.lastName,
      username: user.username,
      email: user.email,
      password: user.password,
      profilePic: user.profilePic,
      location: newLocation,
    );

    await userBox.put(currentUsername!, updated);
  }

  static Future<void> initDefaultProducts() async {
    final defaultProducts = [
      ProductModel(
        name: "Racing Helmet",
        desc: "Matibay at premium na helmet para safe rides.",
        price: 3500,
        image: "assets/images/helmet.webp",
        category: "Helmets",
      ),
      ProductModel(
        name: "Rider Gloves",
        desc: "Comfortable gloves para proteksyon sa kamay.",
        price: 1200,
        image: "assets/images/gloves.webp",
        category: "Gloves",
      ),
      ProductModel(
        name: "Rider Jacket",
        desc: "Waterproof jacket para sa maulan na biyahe.",
        price: 2800,
        image: "assets/images/jackets.webp",
        category: "Jackets",
      ),
      ProductModel(
        name: "Motorcycle Shoes",
        desc: "Matibay at stylish na pang-ride shoes.",
        price: 4200,
        image: "assets/images/shoes.jpg",
        category: "Shoes",
      ),
      ProductModel(
        name: "Alloy Wheel",
        desc: "Premium wheels para sa matatag na ride.",
        price: 6000,
        image: "assets/images/wheel.webp",
        category: "Accessories",
      ),
    ];

    for (int i = 0; i < 3; i++) {
      for (var product in defaultProducts) {
        await productBox.put("${product.name}_$i", product);
      }
    }
  }

  static List<ProductModel> getAllProducts() {
    return productBox.values.toList();
  }

  static List<Map<String, dynamic>> getCart() {
    if (currentUsername == null) return [];
    final rawList = cartBox.get(currentUsername!, defaultValue: []);
    return List<Map<String, dynamic>>.from(
      (rawList as List).map((e) => Map<String, dynamic>.from(e)),
    );
  }

  static Future<void> addToCart(Map<String, dynamic> product) async {
    if (currentUsername == null) return;
    final cart = getCart();

    final existingIndex = cart.indexWhere(
      (item) => item['name'] == product['name'],
    );
    if (existingIndex >= 0) {
      cart[existingIndex]['quantity'] =
          (cart[existingIndex]['quantity'] ?? 1) + 1;
    } else {
      cart.add({...product, 'quantity': 1});
    }

    await cartBox.put(currentUsername!, cart);
  }

  static Future<void> updateCartItem(String productName, int quantity) async {
    if (currentUsername == null) return;
    List<Map<String, dynamic>> cart = getCart();
    int index = cart.indexWhere((p) => p['name'] == productName);
    if (index != -1) {
      cart[index]['quantity'] = quantity;
      await cartBox.put(currentUsername!, cart);
    }
  }

  static Future<void> removeFromCart(String productName) async {
    if (currentUsername == null) return;
    List<Map<String, dynamic>> cart = getCart();
    cart.removeWhere((p) => p['name'] == productName);
    await cartBox.put(currentUsername!, cart);
  }

  static Future<void> clearCart() async {
    if (currentUsername == null) return;
    await cartBox.put(currentUsername!, []);
  }

  static Future<void> checkout() async {
    if (currentUsername == null) return;

    final cartItems = getCart();
    if (cartItems.isEmpty) return;

    final total = cartItems.fold<double>(0, (sum, item) {
      final price = (item['price'] as num?)?.toDouble() ?? 0.0;
      final qty = (item['quantity'] as int?) ?? 1;
      return sum + price * qty;
    });

    final rawOrders = ordersBox.get(currentUsername!, defaultValue: []);
    final existingOrders = List<Map<String, dynamic>>.from(
      (rawOrders as List).map((e) => Map<String, dynamic>.from(e)),
    );

    final newOrder = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'items': List<Map<String, dynamic>>.from(
        cartItems.map((e) => Map<String, dynamic>.from(e)),
      ),
      'total': total,
      'date': DateTime.now().toString(),
    };

    existingOrders.add(newOrder);
    await ordersBox.put(currentUsername!, existingOrders);
    await clearCart();
  }


  static List<Map<String, dynamic>> getOrders() {
    if (currentUsername == null) return [];

    final rawOrders = ordersBox.get(currentUsername!, defaultValue: []);
    if (rawOrders is! List) return [];

    return List<Map<String, dynamic>>.from(
      rawOrders.map((order) => Map<String, dynamic>.from(order)),
    );
  }


  static Future<void> ensureBoxesOpen() async {
    if (!Hive.isBoxOpen('users')) {
      userBox = await Hive.openBox<User>('users');
    }
    if (!Hive.isBoxOpen('cart')) {
      cartBox = await Hive.openBox('cart');
    }
    if (!Hive.isBoxOpen('products')) {
      productBox = await Hive.openBox<ProductModel>('products');
    }
    if (!Hive.isBoxOpen('orders')) {
      ordersBox = await Hive.openBox('orders');
    }
    if (!Hive.isBoxOpen('auth')) {
      authBox = await Hive.openBox('auth');
    }
  }

  static Future<void> refreshSession() async {
    await ensureBoxesOpen();
    currentUsername = authBox.get('loggedInUser');
    print(' HiveService.refreshSession() -> currentUsername: $currentUsername');
  }

  static bool isLoggedIn() {
    return currentUsername != null && currentUsername!.isNotEmpty;
  }
}
