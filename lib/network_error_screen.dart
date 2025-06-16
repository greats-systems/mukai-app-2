import 'package:flutter/material.dart';

class NetworkErrorScreen extends StatelessWidget {
  const NetworkErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Error'),
      ),
      body: const Center(
        child:
            Text('No internet connection. Please check your network settings.'),
      ),
    );
  }
}
