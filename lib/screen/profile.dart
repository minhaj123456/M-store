import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  
      body: SingleChildScrollView(
        child: Column(
          children: [
            // User info
            Container(
              // color: Colors.blue, // Add background for header
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                children: const [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 50, ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'John Doe',
                    style: TextStyle(
                        fontSize: 22,
                        // color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'johndoe@example.com',
                    style: TextStyle(fontSize: 16, ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Profile Options
            ListTile(
              leading: const Icon(Icons.shopping_bag),
              title: const Text('My Orders'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to Orders Page
              },
            ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Shipping Address'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to Address Page
              },
            ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.payment),
              title: const Text('Payment Methods'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to Payment Methods Page
              },
            ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Change Password'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to Change Password Page
              },
            ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to Settings Page
              },
            ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help & Support'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to Help & Support Page
              },
            ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () {
                // Logout logic
              },
            ),
          ],
        ),
      ),
    );
  }
}
