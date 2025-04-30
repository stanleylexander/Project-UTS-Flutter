import 'package:flutter/material.dart';
import 'package:project_uts_flutter/screen/game.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        color: const Color(0xFF88CEEF),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    header(),
                    const SizedBox(height: 30),
                    gameDescription(),
                    const SizedBox(height: 30),
                    buttonPlayGame(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget header() {
    return Column(
      children: const [
        Icon(
          Icons.videogame_asset_rounded,
          size: 80,
          color: Colors.white,
        ),
        SizedBox(height: 10),
        Text(
          "Memory Match Game",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  Widget buttonPlayGame(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Game(level: 1)),
        );
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        backgroundColor: Colors.deepPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 8,
        shadowColor: Colors.black54,
      ),
      child: const Text(
        "PLAY NOW",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget gameDescription() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "📖 Cara Bermain:",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          SizedBox(height: 12),
          Text(
            "🃏 Pilih 2 kartu.\n"
            "✅ Cocokkan 2 kartu yang sama.\n"
            "⏳ Jika waktu habis, maka Game Over.\n"
            "🎉 Have Fun & Good Luck!",
            style: TextStyle(
              fontSize: 18,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
