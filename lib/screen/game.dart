import 'package:flutter/material.dart';
import 'dart:async';
import 'package:project_uts_flutter/screen/hasil.dart';

class Game extends StatefulWidget {
  final int level;

  const Game({super.key, required this.level});

  @override
  State<Game> createState() => _GameScreenState();
}

class _GameScreenState extends State<Game> {
  late int rows;
  late int cols;
  late int timeLimit;
  int score = 0;
  Timer? timer;
  int timeRemaining = 0;
  List<String> images = [
    'assets/apel.jpg', 'assets/nanas.jpg', 'assets/pisang.jpg', 'assets/semangka.jpg', 'assets/kiwi.jpg', 'assets/pepaya.jpg'
  ];
  List<String> gridImages = [];
  List<bool> revealed = [];
  int? firstIndex;
  bool levelCompleted = false;
  bool isProcessing = false; //Untuk mengunci inputan user ketika 2 kartu sebelumnya sudah dibuka

  double tileSize = 70; // Ukuran tile grid

  @override
  void initState() {
    super.initState();
    _setupGame();
    _startTimer();
  }

  void _setupGame() {
    setState(() {
      switch (widget.level) {
        case 1:
          rows = 2;
          cols = 2;
          timeLimit = 20;
          break;
        case 2:
          rows = 2;
          cols = 4;
          timeLimit = 40;
          break;
        case 3:
          rows = 3;
          cols = 4;
          timeLimit = 60;
          break;
        default:
          rows = 2;
          cols = 2;
          timeLimit = 20;
      }

      timeRemaining = timeLimit;
      levelCompleted = false;
      isProcessing = false;
      _generateGrid();
    });
  }

  void _generateGrid() {
    int pairsNeeded = (rows * cols) ~/ 2;
    List<String> selectedImages = images.take(pairsNeeded).toList();
    List<String> tempList = [...selectedImages, ...selectedImages];
    tempList.shuffle();
    gridImages = tempList;
    revealed = List.generate(gridImages.length, (index) => false);
  }

  void _startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeRemaining > 0) {
        setState(() {
          timeRemaining--;
        });
      } else {
        timer.cancel();
        _endGame(false);
      }
    });
  }

  void _onTileTapped(int index) {
    if (revealed[index] || isProcessing || levelCompleted) return; 

    setState(() {
      revealed[index] = true;
    });

    if (firstIndex == null) {
      firstIndex = index;
    } else {
      isProcessing = true; 

      if (gridImages[firstIndex!] == gridImages[index]) {
        score += 10;
        firstIndex = null;
        isProcessing = false; 
        _checkWin();
      } else {
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            revealed[firstIndex!] = false;
            revealed[index] = false;
            firstIndex = null;
            isProcessing = false; 
          });
        });
      }
    }
  }

  void _checkWin() {
    if (revealed.every((element) => element)) {
      timer?.cancel();
      setState(() {
        levelCompleted = true;
      });
    }
  }

  void _nextLevel() {
    if (widget.level < 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Game(level: widget.level + 1),
        ),
      );
    } else {
      _goToResult(true);
    }
  }

  void _endGame(bool won) {
    _goToResult(false);
  }

  void _goToResult(bool won) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Hasil(score, won),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double gridWidth = cols * (tileSize + 80);
    double gridHeight = rows * (tileSize + 80);

    return Scaffold(
      appBar: AppBar(title: Text('Level ${widget.level} - Time: $timeRemaining')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: gridWidth,
              height: gridHeight,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: rows * cols,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _onTileTapped(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: revealed[index]
                          ? Image.asset(gridImages[index], fit: BoxFit.cover)
                          : const Icon(Icons.question_mark, size: 40, color: Colors.white),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            if (levelCompleted)
              ElevatedButton(
                onPressed: _nextLevel,
                child: const Text("Next Level"),
              ),
          ],
        ),
      ),
    );
  }
}
