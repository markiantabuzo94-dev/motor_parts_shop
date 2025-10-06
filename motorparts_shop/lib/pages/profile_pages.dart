import 'dart:io';
import 'package:flutter/material.dart';
import '../hive_service/hive_service.dart';
import 'edit_profile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = HiveService.getUser();

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Profile")),
        body: const Center(child: Text("No user data available.")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            Text(
              "@${'user.username'}",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditProfilePage()),
                );
              },
              icon: const Icon(Icons.edit),
              label: const Text("Edit Profile"),
            ),

            const SizedBox(height: 15),

            // Logout Button
            ElevatedButton.icon(
              onPressed: () async {
                await HiveService.logout();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
