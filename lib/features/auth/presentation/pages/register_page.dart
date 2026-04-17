import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: _name, decoration: const InputDecoration(labelText: 'Nama')),
            TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: _pass, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: auth.isLoading ? null : () async {
                await context.read<AuthProvider>().register(_email.text, _pass.text, _name.text);
                if (context.read<AuthProvider>().status == AuthStatus.emailNotVerified) {
                  Navigator.pushReplacementNamed(context, '/verify');
                }
              },
              child: auth.isLoading ? const CircularProgressIndicator() : const Text('Daftar'),
            )
          ],
        ),
      ),
    );
  }
}