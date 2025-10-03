import 'package:flutter/material.dart';
import '../hive_service/hive_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final usernameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = HiveService.getUser();
    if (user != null) {
      firstNameCtrl.text = user?.firstName ?? '';
      lastNameCtrl.text = user?.lastName ?? '';
      usernameCtrl.text = user?.username ?? '';
      emailCtrl.text = user?.email ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text("Edit Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: firstNameCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: "First Name"),
                  validator: (val) => val!.isEmpty ? "Enter first name" : null,
                ),
                TextFormField(
                  controller: lastNameCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: "Last Name"),
                  validator: (val) => val!.isEmpty ? "Enter last name" : null,
                ),
                TextFormField(
                  controller: usernameCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: "Username"),
                  validator: (val) => val!.isEmpty ? "Enter username" : null,
                ),
                TextFormField(
                  controller: emailCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: "Email"),
                  validator: (val) => val!.isEmpty ? "Enter email" : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        await HiveService.editProfile(
                          firstName: firstNameCtrl.text.trim(),
                          lastName: lastNameCtrl.text.trim(),
                          username: usernameCtrl.text.trim(),
                          email: emailCtrl.text.trim(),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Profile updated!")),
                        );

                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error updating profile: $e")),
                        );
                      }
                    }
                  },
                  child: const Text("Save Changes"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
