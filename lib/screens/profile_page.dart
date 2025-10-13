import 'package:flutter/material.dart';
import '../hive_service/hive_service.dart';
import 'edit_profile.dart';
import '../pages/order_history_page.dart';
import '../pages/downloads_page.dart';
import '../pages/payment_page.dart';

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
      backgroundColor: const Color(0xFFF5DEB3),
      appBar: AppBar(
        title: const Text("My Profile"),
        centerTitle: true,
        backgroundColor: const Color(0xFFB98E5F),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 🧑‍🦱 Profile Picture
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(
                  user?.profilePic ?? 'assets/images/default_profile.jpg',
                ),
                backgroundColor: const Color(0xFFE6C9A8),
              ),
              const SizedBox(height: 12),

              // 👤 User Name
              Text(
                displayName,
                style: const TextStyle(
                  color: Colors.brown,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),

              // 📧 Email
              Text(email, style: const TextStyle(color: Colors.brown)),
              const SizedBox(height: 18),

              // ✏️ Edit Profile Button
              ElevatedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditProfilePage()),
                  );
                  setState(() {}); // refresh after editing
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB98E5F),
                ),
                child: const Text("Edit Profile"),
              ),
              const SizedBox(height: 20),
              const Divider(color: Colors.brown),

              // 📱 Menu Options
              ListTile(
                leading: const Icon(Icons.payment, color: Colors.brown),
                title: const Text(
                  "Payment",
                  style: TextStyle(color: Colors.brown),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PaymentPage()),
                  );
                },
              ),

              ListTile(
                leading: const Icon(
                  Icons.download_outlined,
                  color: Colors.brown,
                ),
                title: const Text(
                  "Downloads",
                  style: TextStyle(color: Colors.brown),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DownloadsPage()),
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.location_on, color: Colors.brown),
                title: const Text(
                  "Location",
                  style: TextStyle(color: Colors.brown),
                ),
                subtitle: Text(
                  user?.location ?? "Tap to set location",
                  style: const TextStyle(color: Colors.black87),
                ),
                onTap: () async {
                  final newLocation = await showDialog<String>(
                    context: context,
                    builder: (context) {
                      final locationCtrl = TextEditingController(
                        text: user?.location ?? "",
                      );
                      return AlertDialog(
                        title: const Text("Set Location"),
                        content: TextField(
                          controller: locationCtrl,
                          decoration: const InputDecoration(
                            hintText:
                                "Enter your city, e.g. Cebu City, Philippines",
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(
                              context,
                              locationCtrl.text.trim(),
                            ),
                            child: const Text("Save"),
                          ),
                        ],
                      );
                    },
                  );

                  if (newLocation != null && newLocation.isNotEmpty) {
                    await HiveService.updateUserLocation(newLocation);
                    setState(() {});
                  }
                },
              ),

              // 🧾 Order History
              ListTile(
                leading: const Icon(Icons.history, color: Colors.brown),
                title: const Text(
                  "Order History",
                  style: TextStyle(color: Colors.brown),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OrderHistoryPage()),
                  );
                },
              ),
              const Divider(color: Colors.brown),

              // 🚪 Log Out
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: const Text(
                  "Log Out",
                  style: TextStyle(color: Colors.brown),
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
