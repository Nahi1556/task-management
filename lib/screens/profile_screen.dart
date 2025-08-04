import 'package:flutter/material.dart';
import '../main.dart'; // To access the isDarkMode ValueNotifier

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Avatar and User Info
          const CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blue,
            child: Text(
              "JS",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Column(
              children: [
                Text(
                  "Nahil Jemal",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "nahiljemal68@gmail.com",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          const Divider(height: 40),

          // Settings Tile
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {
              // TODO: Add settings logic
            },
          ),

          // Dark Mode Toggle
          ValueListenableBuilder(
            valueListenable: isDarkMode,
            builder: (context, bool isDark, _) {
              return SwitchListTile(
                title: const Text("Dark Mode"),
                value: isDark,
                secondary: const Icon(Icons.brightness_6),
                onChanged: (val) => isDarkMode.value = val,
              );
            },
          ),

          // About Tile
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("About"),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: "TaskFlow",
                applicationVersion: "1.0.0",
                applicationIcon: const Icon(Icons.task),
                children: [
                  const Text("This is a task management app made in Flutter."),
                ],
              );
            },
          ),

          // Logout Tile
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () {
              // TODO: Handle logout
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Logged out")),
              );
            },
          ),
        ],
      ),
    );
  }
}
