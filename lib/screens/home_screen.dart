import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          Row(
            children: [
              Icon(
                userProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                size: 20,
              ),
              Switch(
                value: userProvider.isDarkMode,
                onChanged: (value) {
                  userProvider.toggleDarkMode(value);
                },
                activeColor: Colors.amber,
              ),
            ],
          ),
        ],
      ),
      body: userProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.home,
                      size: 80,
                      color: Colors.deepPurple,
                    ),
                    const SizedBox(height: 16),
                    Chip(
                      avatar: Icon(
                        Icons.touch_app,
                        size: 18,
                        color: userProvider.isDarkMode
                            ? Colors.deepPurple.shade200
                            : Colors.deepPurple,
                      ),
                      label: Text(
                        'Aplikasi dibuka: ${userProvider.visitCount} kali',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: userProvider.isDarkMode
                              ? Colors.white
                              : Colors.deepPurple.shade900,
                        ),
                      ),
                      backgroundColor: userProvider.isDarkMode
                          ? Colors.deepPurple.shade800
                          : Colors.deepPurple.shade50,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      userProvider.user.isLoggedIn
                          ? 'Selamat datang, ${userProvider.user.name}!'
                          : 'Selamat datang, Tamu!',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    if (userProvider.user.isLoggedIn) ...[
                      Text(
                        'Email: ${userProvider.user.email}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.person),
                        label: const Text('Lihat Profil'),
                      ),
                    ] else ...[
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.login),
                        label: const Text('Login / Daftar'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }
}
