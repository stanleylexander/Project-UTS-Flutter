import 'package:flutter/material.dart';

class Hasil extends StatelessWidget {
  const Hasil(int score, bool won, {super.key});

  @override
  Widget build(BuildContext context) { //Widget build digunakan untuk menampilkan UI 
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil'),
      ),
      body: const Center(
        child: Text("This is hasil"),
      ),
    );
  }
}
