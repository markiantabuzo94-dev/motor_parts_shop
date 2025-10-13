import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushReplacementNamed(context, "/home");
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFF8E7), Color(0xFFEBD5B3)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 600;
              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isWide ? 400 : double.infinity,
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 8,
                      color: const Color(0xFFF5DEB3).withOpacity(0.9),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.motorcycle,
                              color: Color(0xFFB98E5F),
                              size: 60,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Welcome Back",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Login to continue",
                              style: TextStyle(color: Colors.brown),
                            ),
                            const SizedBox(height: 24),
                            TextField(
                              controller: usernameCtrl,
                              style: const TextStyle(color: Colors.brown),
                              decoration: InputDecoration(
                                hintText: "Username",
                                hintStyle: const TextStyle(color: Colors.brown),
                                prefixIcon: const Icon(
                                  Icons.person,
                                  color: Colors.brown,
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.6),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: passwordCtrl,
                              obscureText: true,
                              style: const TextStyle(color: Colors.brown),
                              decoration: InputDecoration(
                                hintText: "Password",
                                hintStyle: const TextStyle(color: Colors.brown),
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color: Colors.brown,
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.6),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                final isLoading = state is AuthLoading;
                                return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFB98E5F),
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size.fromHeight(50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  onPressed: isLoading
                                      ? null
                                      : () {
                                          context.read<AuthBloc>().add(
                                            LoginRequested(
                                              username: usernameCtrl.text
                                                  .trim(),
                                              password: passwordCtrl.text
                                                  .trim(),
                                            ),
                                          );
                                        },
                                  child: isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text(
                                          "Login",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  "/signup",
                                );
                              },
                              child: const Text(
                                "Don’t have an account? Sign up",
                                style: TextStyle(color: Colors.brown),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
