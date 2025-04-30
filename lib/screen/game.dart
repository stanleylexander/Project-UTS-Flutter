import 'package:flutter/material.dart';
import 'dart:async';
import 'package:project_uts_flutter/screen/hasil.dart';

class Game extends StatefulWidget {
  final int level;
  final int score;

  const Game({super.key, required this.level, this.score = 0});

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
    'assets/apel.jpg', 'assets/nanas.jpg', 'assets/pisang.jpg',
    'assets/semangka.jpg', 'assets/kiwi.jpg', 'assets/pepaya.jpg'
  ];
  List<String> gridImages = [];
  List<bool> revealed = [];
  int? firstIndex;
  bool levelCompleted = false;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    score = widget.score;
    _setupGame();
    _startTimer();
  }

  void _setupGame() {
    setState(() {
      switch (widget.level) {
        case 1:
          rows = 2; cols = 2; timeLimit = 20; break;
        case 2:
          rows = 2; cols = 4; timeLimit = 40; break;
        case 3:
          rows = 3; cols = 4; timeLimit = 60; break;
        default:
          rows = 2; cols = 2; timeLimit = 20;
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
          builder: (context) => Game(level: widget.level + 1, score: score),
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
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF88CEEF),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Level ${widget.level}',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Time Remaining: $timeRemaining s',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              // Grid dan tombol
              Expanded(
                child: Center(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      double maxGridWidth = constraints.maxWidth > 500 ? 500 : constraints.maxWidth * 0.9;
                      double maxGridHeight = constraints.maxHeight > 600 ? 600 : constraints.maxHeight * 0.7;

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: maxGridWidth,
                              maxHeight: maxGridHeight,
                            ),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: rows * cols,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: cols,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                childAspectRatio: 1,
                              ),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () => _onTileTapped(index),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    decoration: BoxDecoration(
                                      color: revealed[index] ? Colors.white : Colors.blueAccent,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        if (revealed[index])
                                          const BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 4,
                                            spreadRadius: 1,
                                          )
                                      ],
                                    ),
                                    child: Center(
                                      child: revealed[index]
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.circular(8),
                                              child: Image.asset(
                                                gridImages[index],
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : const Icon(Icons.question_mark, size: 50, color: Colors.white),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          if (levelCompleted)
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: ElevatedButton(
                                onPressed: _nextLevel,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
                                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  "Next Level",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
