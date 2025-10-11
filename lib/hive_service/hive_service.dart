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

  // ✅ Initialize all Hive boxes
  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(ProductModelAdapter());

    userBox = await Hive.openBox<User>('users');
    cartBox = await Hive.openBox('cart');
    productBox = await Hive.openBox<ProductModel>('products');
    ordersBox = await Hive.openBox('orders');
    authBox = await Hive.openBox('auth');

    currentUsername = authBox.get('loggedInUser');

    // 🧠 Auto-load default products only once
    if (productBox.isEmpty) {
      await initDefaultProducts();
    }
  }

  // 🧍 USER MANAGEMENT ----------------------------------------------------

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

  static Future<void> logout() async {
    currentUsername = null;
    await authBox.delete('loggedInUser');
  }

  // ✏️ Profile editing
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

  // 🛍 PRODUCT MANAGEMENT --------------------------------------------------

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

    // 🔁 Duplicate products to look like a full list
    for (int i = 0; i < 3; i++) {
      for (var product in defaultProducts) {
        await productBox.put("${product.name}_$i", product);
      }
    }
  }

  static List<ProductModel> getAllProducts() {
    return productBox.values.toList();
  }

  // 🛒 CART MANAGEMENT ----------------------------------------------------

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

  // 🧾 ORDER MANAGEMENT ---------------------------------------------------

  static Future<void> checkout() async {
    if (currentUsername == null) return;
    final cart = getCart();
    if (cart.isEmpty) return;

    await saveOrder(cart);
    await clearCart();
  }

  static Future<void> saveOrder(List<Map<String, dynamic>> cart) async {
    if (currentUsername == null || cart.isEmpty) return;

    List<Map<String, dynamic>> orders =
        ordersBox
            .get(currentUsername!, defaultValue: [])
            ?.cast<Map<String, dynamic>>() ??
        [];

    double total = cart.fold(
      0,
      (sum, item) => sum + (item['price'] as num) * (item['quantity'] ?? 1),
    );

    final orderId = DateTime.now().millisecondsSinceEpoch;

    orders.add({
      'id': orderId,
      'date': DateTime.now().toString(),
      'items': cart,
      'total': total,
    });

    await ordersBox.put(currentUsername!, orders);
  }

  static List<Map<String, dynamic>> getOrders() {
    if (currentUsername == null) return [];
    final rawList = ordersBox.get(currentUsername!, defaultValue: []);
    return List<Map<String, dynamic>>.from(
      (rawList as List).map((e) => Map<String, dynamic>.from(e)),
    );
  }
}
