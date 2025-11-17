import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              auth.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome ${auth.user ?? 'Guest'}',
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            Card(
              child: ListTile(
                leading: const Icon(Icons.send),
                title: const Text('Send Money'),
                subtitle: const Text('Quickly send money to recipients'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => Navigator.pushNamed(context, '/send'),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Center(
                child: Text(
                  'Recent activity will show here',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
