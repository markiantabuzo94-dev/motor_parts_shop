import 'package:flutter/material.dart';
import '../hive_service/hive_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String? firstName;
  String? lastName;
  String? email;

  @override
  void initState() {
    super.initState();
    final user = HiveService.getUser();
    firstName = user?.firstName ?? '';
    lastName = user?.lastName ?? '';
    email = user?.email ?? '';
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    await HiveService.updateUserProfile(
      firstName: firstName ?? '',
      lastName: lastName ?? '',
      email: email ?? '',
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated'),
        backgroundColor: Color(0xFFB98E5F), 
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5DEB3), 
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: const Color(0xFFB98E5F), 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: firstName,
                style: const TextStyle(color: Colors.brown),
                decoration: const InputDecoration(
                  labelText: 'First name',
                  labelStyle: TextStyle(color: Colors.brown),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.brown),
                  ),
                ),
                onChanged: (v) => firstName = v,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Enter first name' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: lastName,
                style: const TextStyle(color: Colors.brown),
                decoration: const InputDecoration(
                  labelText: 'Last name',
                  labelStyle: TextStyle(color: Colors.brown),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.brown),
                  ),
                ),
                onChanged: (v) => lastName = v,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Enter last name' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: email,
                style: const TextStyle(color: Colors.brown),
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.brown),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.brown),
                  ),
                ),
                onChanged: (v) => email = v,
                validator: (v) => (v == null || !v.contains('@'))
                    ? 'Enter a valid email'
                    : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB98E5F),
                  minimumSize: const Size.fromHeight(45),
                ),
                onPressed: _save,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
