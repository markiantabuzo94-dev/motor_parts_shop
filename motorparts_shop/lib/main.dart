import 'package:flutter/material.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init Hive
  await Hive.initFlutter();

  // Register Adapters BEFORE opening any box
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(ProductModelAdapter());

  // Open boxes here
  await HiveService.init();

  // Seed default products kung empty
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
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (state is AuthAuthenticated) {
              return const LoginPage();
            } else {
              return const HomePage();
            }
          },
        ),
        routes: {
          "/loginpage": (_) => const LoginPage(),
          "/signup": (_) => const SignUpPage(),
          "/home": (_) => const HomePage(),
          "/cart": (_) => const CartPage(),
        },
      ),
    );
  }
}
