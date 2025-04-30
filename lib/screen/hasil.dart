import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_uts_flutter/screen/game.dart';
import 'package:project_uts_flutter/main.dart';
import 'package:project_uts_flutter/screen/score.dart';

class Hasil extends StatefulWidget {
  final int score;
  final bool won;

  const Hasil(this.score, this.won, {super.key});

  @override
  State<Hasil> createState() => _HasilState();
}

class _HasilState extends State<Hasil> {
  int highScore = 0;

  @override
  void initState() {
    super.initState();
    _loadAndUpdateHighScore();
  }

  Future<void> _loadAndUpdateHighScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? scoresData = prefs.getStringList('high_scores');

    List<Map<String, dynamic>> scores = scoresData != null
        ? scoresData.map((e) => jsonDecode(e) as Map<String, dynamic>).toList()
        : [];

    // Cari skor tertinggi user aktif
    Map<String, dynamic>? existing = scores.firstWhere(
      (e) => e['name'] == active_user,
      orElse: () => {},
    );

    int previousHighScore = existing.isNotEmpty ? existing['score'] : 0;

    if (widget.score > previousHighScore) {
      // Hapus skor lama user aktif
      scores.removeWhere((e) => e['name'] == active_user);
      // Tambahkan skor baru
      scores.add({'name': active_user, 'score': widget.score});
    }

    // Simpan kembali
    await prefs.setStringList(
        'high_scores', scores.map((e) => jsonEncode(e)).toList());

    setState(() {
      highScore = widget.score > previousHighScore ? widget.score : previousHighScore;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: const Text("Game Over"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                spreadRadius: 2,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.won ? Icons.emoji_events : Icons.sentiment_dissatisfied,
                size: 80,
                color: widget.won ? Colors.amber : Colors.redAccent,
              ),
              const SizedBox(height: 16),
              Text(
                widget.won ? "Congratulations! 🎉" : "Game Over! 😢",
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                "Your Score: ${widget.score}",
                style: const TextStyle(fontSize: 20, color: Colors.black87),
              ),
              const SizedBox(height: 4),
              Text(
                "High Score: $highScore",
                style: const TextStyle(fontSize: 18, color: Colors.redAccent),
              ),
              const SizedBox(height: 30),

              ElevatedButton.icon(
                icon: const Icon(Icons.replay, color: Colors.white),
                label: const Text("Play Again"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Game(level: 1)),
                  );
                },
              ),
              const SizedBox(height: 12),

              ElevatedButton.icon(
                icon: const Icon(Icons.leaderboard, color: Colors.white),
                label: const Text("High Scores"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Score()),
                  );
                },
              ),
              const SizedBox(height: 12),

              ElevatedButton.icon(
                icon: const Icon(Icons.home, color: Colors.white),
                label: const Text("Main Menu"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MyApp()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
