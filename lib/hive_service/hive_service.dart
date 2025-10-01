import 'package:hive/hive.dart';
import '../model/product_model.dart';

class HiveService {
  static late Box userBox;
  static late Box cartBox;
  static late Box<ProductModel> productBox;
  static late Box ordersBox;
  static late Box authBox;

  static String? currentUsername;
  static Future<void> init() async {
    userBox = await Hive.openBox('users');
    cartBox = await Hive.openBox('cart');
    productBox = await Hive.openBox<ProductModel>('products');
    ordersBox = await Hive.openBox('orders');
    authBox = await Hive.openBox('auth');
    currentUsername = authBox.get('loggedInUser');
  }

  static Future<void> initDefaultProducts() async {
    List<ProductModel> defaultProducts = [
      ProductModel(
        name: "Helmet",
        desc: "Safety helmet for motorbikes",
        price: 1200,
        image: "assets/images/helmet.webp",
        category: "Helmets",
      ),
      ProductModel(
        name: "Motor Gloves",
        desc: "Protective gloves for riding",
        price: 350,
        image: "assets/images/gloves.webp",
        category: "Gloves",
      ),
      ProductModel(
        name: "Riding Jacket",
        desc: "Leather riding jacket",
        price: 2500,
        image: "assets/images/jackets.webp",
        category: "Accessories",
      ),
      ProductModel(
        name: "Motorcycle Grip",
        desc: "Handle grip universal",
        price: 140,
        image: "assets/images/grip.webp",
        category: "Accessories",
      ),
      ProductModel(
        name: "Motor Cycle Cover",
        desc: "Motowolf motor cycle cover",
        price: 400,
        image: "assets/images/cover.webp",
        category: "Accessories",
      ),
      ProductModel(
        name: "Seat",
        desc: "Leather riding seat",
        price: 1500,
        image: "assets/images/seat.webp",
        category: "Accessories",
      ),
      ProductModel(
        name: "Side Mirror",
        desc: "Carbon case glass",
        price: 200,
        image: "assets/images/mirror.webp",
        category: "Accessories",
      ),
      ProductModel(
        name: "Wheel",
        desc: "Wheels made to cope with radial and axial forces",
        price: 5000,
        image: "assets/images/wheel.webp",
        category: "Accessories",
      ),
      ProductModel(
        name: "Shoes",
        desc: "Made to cope leather",
        price: 2000,
        image: "assets/images/shoes.jpg",
        category: "Shoes",
      ),
    ];

    for (var product in defaultProducts) {
      bool exists = productBox.values.any((p) => p.name == product.name);
      if (!exists) {
        await productBox.add(product);
      }
    }
  }

  static List<ProductModel> getAllProducts() => productBox.values.toList();
  static Future<bool> saveUser({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String password,
  }) async {
    if (userBox.containsKey(username)) return false;

    await userBox.put(username, {
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'email': email,
      'password': password,
    });

    return true;
  }

  static Future<bool> validateLogin(String username, String password) async {
    if (!userBox.containsKey(username)) return false;

    final user = Map<String, dynamic>.from(userBox.get(username));
    if (user['password'] == password) {
      currentUsername = username;
      await authBox.put('loggedInUser', username);
      return true;
    }
    return false;
  }

  static Future<void> logout() async {
    currentUsername = null;
    await authBox.delete('loggedInUser');
  }

  static Map<String, dynamic>? getUser() {
    if (currentUsername == null) return null;
    final raw = userBox.get(currentUsername!);
    if (raw == null) return null;
    return Map<String, dynamic>.from(raw);
  }

  static Future<void> updateUsername(String newUsername) async {
    if (currentUsername == null) return;
    if (userBox.containsKey(newUsername)) {
      throw Exception("Username already exists");
    }

    final user = getUser();
    if (user == null) return;

    await userBox.put(newUsername, {...user, 'username': newUsername});
    await userBox.delete(currentUsername!);

    currentUsername = newUsername;
    await authBox.put('loggedInUser', newUsername);
  }

  static Future<void> updateUserProfile({
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    if (currentUsername == null) return;
    final user = getUser();
    if (user == null) return;

    user['firstName'] = firstName;
    user['lastName'] = lastName;
    user['email'] = email;

    await userBox.put(currentUsername!, user);
  }

  static Future<void> editProfile({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
  }) async {
    final oldUsername = currentUsername;
    if (oldUsername == null) return;

    final user = getUser();
    if (user == null) return;

    if (username != oldUsername && username.isNotEmpty) {
      await updateUsername(username);
    }

    await updateUserProfile(
      firstName: firstName,
      lastName: lastName,
      email: email,
    );
  }

  static List<Map<String, dynamic>> getCart() {
    if (currentUsername == null) return [];
    final rawList = cartBox.get(currentUsername!, defaultValue: []);
    return rawList != null
        ? List<Map<String, dynamic>>.from(
            (rawList as List).map((e) => Map<String, dynamic>.from(e)),
          )
        : [];
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
    return rawList != null
        ? List<Map<String, dynamic>>.from(
            (rawList as List).map((e) => Map<String, dynamic>.from(e)),
          )
        : [];
  }
}
