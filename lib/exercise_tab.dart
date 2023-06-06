import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExerciseTab extends StatefulWidget {
  @override
  _ExerciseTabState createState() => _ExerciseTabState();
}

class _ExerciseTabState extends State<ExerciseTab> {
  final List<String> exercises = [
    'Exercise 1',
    'Exercise 2',
    'Exercise 3',
    'Exercise 4',
    'Exercise 5',
    'Exercise 6',
  ];

  AudioPlayer exercisePlayer = AudioPlayer();
  AudioPlayer audioPlayer = AudioPlayer();

  void initState() {
    super.initState();
  }

  final int sets = 3;
  final int exerciseDuration = 10;
  final int restDuration = 4;

  int currentExerciseIndex = 0;
  int currentSet = 1;
  int secondsRemaining = 10;
  bool isRunning = false;
  bool isPaused = false;
  Timer? timer;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    isRunning = true;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (secondsRemaining > 0) {
          if (secondsRemaining == exerciseDuration) {
            audioPlayer.play(AssetSource('audio/go.wav'));
          } else if (secondsRemaining == 0 && currentSet < sets) {
            audioPlayer.play(AssetSource('audio/rest.mp3'));
          }

          secondsRemaining--;
        } else {
          if (currentSet < sets) {
            if (currentExerciseIndex < exercises.length - 1) {
              currentExerciseIndex++;
              secondsRemaining = exerciseDuration;
            } else {
              currentSet++;
              currentExerciseIndex = 0;
              secondsRemaining = restDuration;
            }
          } else {
            if (currentExerciseIndex < exercises.length - 1) {
              currentExerciseIndex++;
              secondsRemaining = exerciseDuration;
            } else {
              stopTimer();
            }
          }
        }
      });
    });
  }

  void stopTimer() {
    isRunning = false;
    timer?.cancel();
  }

  void resetTimer() {
    currentExerciseIndex = 0;
    currentSet = 1;
    secondsRemaining = exerciseDuration;
    stopTimer();
  }

  Future<void> saveExercise() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await prefs.setString(today, 'Exercise Completed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isRunning && secondsRemaining <= exerciseDuration
                  ? exercises[currentExerciseIndex]
                  : 'REST',
              style: TextStyle(
                fontSize: 24,
                fontWeight: isRunning && secondsRemaining <= exerciseDuration
                    ? FontWeight.normal
                    : FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              isRunning
                  ? 'Set: $currentSet/$sets | Remaining: $secondsRemaining seconds'
                  : 'Set: $currentSet/$sets',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isRunning
                ? IconButton(
                    icon: Icon(isPaused ? Icons.play_arrow : Icons.pause),
                    onPressed: () {
                      setState(() {
                        if (isPaused) {
                          startTimer();
                          isPaused = false;
                        } else {
                          stopTimer();
                          isPaused = true;
                        }
                      });
                    },
                  )
                : IconButton(
                    icon: Icon(Icons.play_arrow),
                    onPressed: () {
                      resetTimer();
                      startTimer();
                    },
                  ),
            IconButton(
              icon: Icon(Icons.done),
              onPressed: isRunning
                  ? null
                  : () {
                      saveExercise();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Exercise saved for today.'),
                        ),
                      );
                    },
            ),
          ],
        ),
      ),
    );
  }
}
