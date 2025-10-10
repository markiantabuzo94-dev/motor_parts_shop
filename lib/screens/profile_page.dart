import 'package:flutter/material.dart';
import '../hive_service/hive_service.dart';
import '../model/user_model.dart';
import 'edit_profile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Kunin ang kasalukuyang naka-login na user
    final User? user = HiveService.getUser();

    // ✅ Default display kung wala pa user data
    final firstName = user?.firstName ?? "Guest";
    final lastName = user?.lastName ?? "";
    final email = user?.email ?? "No email available";

    return Scaffold(
      appBar: AppBar(title: const Text("My Profile"), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/profile.jpg'),
                ),
                const SizedBox(height: 10),

                // ✅ Display user info from Hive
                Text(
                  "$firstName $lastName",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(email, style: const TextStyle(color: Colors.grey)),

                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EditProfilePage(),
                      ),
                    );
                  },
                  child: const Text("Edit Profile"),
                ),

                const Divider(height: 40),

                // ✅ Menu section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.favorite_border),
                        title: const Text("Favourites"),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(Icons.download_outlined),
                        title: const Text("Downloads"),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(Icons.language),
                        title: const Text("Languages"),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(Icons.location_on_outlined),
                        title: const Text("Location"),
                        onTap: () {},
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(
                          Icons.logout,
                          color: Colors.redAccent,
                        ),
                        title: const Text("Log Out"),
                        onTap: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Log Out"),
                              content: const Text(
                                "Are you sure you want to log out?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text("Log Out"),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await HiveService.logout();

                            // ✅ Navigate back to login page
                            Navigator.of(
                              context,
                              rootNavigator: true,
                            ).pushNamedAndRemoveUntil(
                              '/loginpage',
                              (route) => false,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
