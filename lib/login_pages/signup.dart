import 'package:flutter/material.dart';
import '../hive_service/hive_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final usernameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 8,
              color: const Color(0xFFF5DEB3).withOpacity(0.9),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.person_add_alt_1,
                        color: Color(0xFFB98E5F),
                        size: 60,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Sign up to get started",
                        style: TextStyle(color: Colors.brown),
                      ),
                      const SizedBox(height: 24),
                      _buildInputField(
                        controller: firstNameCtrl,
                        hint: "First Name",
                        icon: Icons.person,
                      ),
                      const SizedBox(height: 12),
                      _buildInputField(
                        controller: lastNameCtrl,
                        hint: "Last Name",
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 12),
                      _buildInputField(
                        controller: usernameCtrl,
                        hint: "Username",
                        icon: Icons.account_circle,
                      ),
                      const SizedBox(height: 12),
                      _buildInputField(
                        controller: emailCtrl,
                        hint: "Email",
                        icon: Icons.email,
                      ),
                      const SizedBox(height: 12),
                      _buildInputField(
                        controller: passwordCtrl,
                        hint: "Password",
                        icon: Icons.lock,
                        isPassword: true,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB98E5F),
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: _loading
                            ? null
                            : () async {
                                if (!_formKey.currentState!.validate()) return;

                                setState(() => _loading = true);

                                final success = await HiveService.saveUser(
                                  firstName: firstNameCtrl.text.trim(),
                                  lastName: lastNameCtrl.text.trim(),
                                  username: usernameCtrl.text.trim(),
                                  email: emailCtrl.text.trim(),
                                  password: passwordCtrl.text.trim(),
                                );

                                setState(() => _loading = false);

                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Account created! Please login.",
                                      ),
                                    ),
                                  );
                                  Navigator.pushReplacementNamed(
                                    context,
                                    "/loginpage",
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Username already exists"),
                                    ),
                                  );
                                }
                              },
                        child: _loading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text("Sign Up"),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, "/loginpage");
                        },
                        child: const Text(
                          "Already have an account? Login",
                          style: TextStyle(color: Colors.brown),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.brown),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.brown),
        prefixIcon: Icon(icon, color: Colors.brown),
        filled: true,
        fillColor: Colors.white.withOpacity(0.6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return "$hint required";
        }
        return null;
      },
    );
  }
}
