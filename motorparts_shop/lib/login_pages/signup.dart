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
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
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
              color: Colors.black.withOpacity(0.75),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Sign up to get started",
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: firstNameCtrl,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration(
                          hint: "First Name",
                          icon: Icons.person,
                        ),
                        validator: (val) => val == null || val.isEmpty
                            ? "First name required"
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: lastNameCtrl,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration(
                          hint: "Last Name",
                          icon: Icons.person_outline,
                        ),
                        validator: (val) => val == null || val.isEmpty
                            ? "Last name required"
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: usernameCtrl,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration(
                          hint: "Username",
                          icon: Icons.account_circle,
                        ),
                        validator: (val) => val == null || val.isEmpty
                            ? "Username required"
                            : null,
                      ),
                      const SizedBox(height: 12),

                      // Email
                      TextFormField(
                        controller: emailCtrl,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration(
                          hint: "Email",
                          icon: Icons.email,
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "Email required";
                          }
                          if (!val.contains("@") || !val.contains(".")) {
                            return "Invalid email";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Password
                      TextFormField(
                        controller: passwordCtrl,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration(
                          hint: "Password",
                          icon: Icons.lock,
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "Password required";
                          }
                          if (val.length < 6) {
                            return "Password must be at least 6 chars";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purpleAccent,
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
                          style: TextStyle(color: Colors.white70),
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

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white54),
      prefixIcon: Icon(icon, color: Colors.white70),
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
    );
  }
}
