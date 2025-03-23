import 'package:flutter/material.dart';

class Score extends StatelessWidget {
  const Score({super.key});

  @override
  Widget build(BuildContext context) { //Widget build digunakan untuk menampilkan UI 
    return Scaffold(
      appBar: AppBar(
        title: const Text('Score'),
      ),
      body: const Center(
        child: Text("This is Score "),
      ),
    );
  }
}
