import 'package:digest_auth/connection/digest.dart';
import 'package:flutter/material.dart';

class Testing extends StatefulWidget {
  const Testing({super.key});

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  DigestAuth digest = DigestAuth(
    url: 'http://192.168.180.3',
    uri: '/!dhost.b',
    username: 'admin',
    password: '',
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Testing'),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                digest.get();
              },
              child: const Text('Test'),
            ),
          ],
        ),
      ),
    );
  }
}
