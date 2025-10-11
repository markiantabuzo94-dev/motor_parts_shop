// lib/pages/profile_page.dart
import 'package:flutter/material.dart';
import '../hive_service/hive_service.dart';
import 'edit_profile.dart';
import '../pages/order_history_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final user = HiveService.getUser();

    final displayName = user != null
        ? "${user.firstName} ${user.lastName}"
        : "Guest";
    final email = user?.email ?? "No email";

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text("My Profile"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(
                  user?.profilePic ?? 'assets/images/default_profile.jpg',
                ),
                backgroundColor: Colors.grey[800],
              ),
              const SizedBox(height: 12),
              Text(
                displayName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(email, style: const TextStyle(color: Colors.white70)),

              const SizedBox(height: 18),

              ElevatedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditProfilePage()),
                  );
                  setState(() {}); // refresh after edit
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purpleAccent,
                ),
                child: const Text("Edit Profile"),
              ),

              const SizedBox(height: 20),
              const Divider(color: Colors.white12),

              // Menu
              ListTile(
                leading: const Icon(Icons.favorite_border, color: Colors.white),
                title: const Text(
                  "Favourites",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(
                  Icons.download_outlined,
                  color: Colors.white,
                ),
                title: const Text(
                  "Downloads",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {},
              ),

              // (Languages removed per request)
              ListTile(
                leading: const Icon(
                  Icons.location_on_outlined,
                  color: Colors.white,
                ),
                title: const Text(
                  "Location",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {},
              ),

              ListTile(
                leading: const Icon(Icons.history, color: Colors.white),
                title: const Text(
                  "Order History",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OrderHistoryPage()),
                  );
                },
              ),

              const Divider(color: Colors.white12),

              ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: const Text(
                  "Log Out",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Log Out"),
                      content: const Text("Are you sure you want to log out?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
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
                    // navigate to login page (replace stack)
                    Navigator.of(
                      context,
                      rootNavigator: true,
                    ).pushNamedAndRemoveUntil('/loginpage', (r) => false);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
