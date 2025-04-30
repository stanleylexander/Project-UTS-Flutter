import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Score extends StatefulWidget {
  const Score({super.key});

  @override
  State<Score> createState() => _ScoreState();
}

class _ScoreState extends State<Score> {
  List<Map<String, dynamic>> highScores = [];

  @override
  void initState() {
    super.initState();
    _loadHighScores();
  }

  Future<void> _loadHighScores() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? scoresData = prefs.getStringList('high_scores');

    if (scoresData != null) {
      highScores = scoresData
          .map((e) => jsonDecode(e) as Map<String, dynamic>)
          .toList();

      // Urutkan skor secara descending
      highScores.sort((a, b) => b['score'].compareTo(a['score']));

      // Ambil hanya 3 skor tertinggi
      if (highScores.length > 3) {
        highScores = highScores.sublist(0, 3);
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('High Scores'),
        backgroundColor: Color(0xFFCBB4F4),
        centerTitle: true,
      ),
      body:Container(
        color: Color(0xFF88CEEF),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: highScores.isEmpty
            ? const Center(
                child: Text(
                  "Belum ada skor tersimpan",
                  style: TextStyle(fontSize: 18),
                ),
              )
            : ListView.builder(
                itemCount: highScores.length,
                itemBuilder: (context, index) {
                  IconData iconData;
                  Color iconColor;

                  switch (index) {
                    case 0:
                      iconData = Icons.emoji_events;
                      iconColor = Colors.amber;
                      break;
                    case 1:
                      iconData = Icons.emoji_events;
                      iconColor = Colors.grey;
                      break;
                    case 2:
                      iconData = Icons.emoji_events;
                      iconColor = Colors.brown;
                      break;
                    default:
                      iconData = Icons.star;
                      iconColor = Colors.blueGrey;
                  }

                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: iconColor.withOpacity(0.2),
                        radius: 26,
                        child: Icon(iconData, color: iconColor),
                      ),
                      title: Text(
                        highScores[index]['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("Skor: ${highScores[index]['score']}"),
                    ),
                  );
                },
              ),
        ),
      ) 
    );
  }
}
