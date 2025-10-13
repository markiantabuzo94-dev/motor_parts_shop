import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'hive_service/hive_service.dart';
import 'model/user_model.dart';
import 'model/product_model.dart';
import 'bloc/cart/cart_bloc.dart';
import 'bloc/auth/auth_bloc.dart';
import 'login_pages/login_page.dart';
import 'login_pages/signup.dart';
import 'pages/home_page.dart';
import 'pages/cart_page.dart';
import 'screens/profile_page.dart';
import 'screens/splash_screen.dart';
import 'pages/payment_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUrlStrategy(const HashUrlStrategy());

  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(ProductModelAdapter());

  await HiveService.init();
  await HiveService.ensureBoxesOpen();

  if (HiveService.getAllProducts().isEmpty) {
    await HiveService.initDefaultProducts();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()..add(AppStarted())),
        BlocProvider(create: (_) => CartBloc()..add(LoadCart())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Yeji Motor Shop',
        theme: ThemeData.dark(),
        home: const SplashScreen(), // 👈 Show splash first
        routes: {
          "/loginpage": (_) => const LoginPage(),
          "/signup": (_) => const SignUpPage(),
          "/home": (_) => const HomePage(),
          "/cart": (_) => const CartPage(),
          "/profile": (_) => const ProfilePage(),
          "/payment": (_) => const PaymentPage(),
        },
      ),
    );
  }
}
