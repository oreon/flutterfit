import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MeditateTab extends StatefulWidget {
  @override
  _MeditateTabState createState() => _MeditateTabState();
}

class _MeditateTabState extends State<MeditateTab> {
  AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.release();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playAudio(String audioUrl) async {
    await _audioPlayer.play(AssetSource(audioUrl));
  }

  void _pauseAudio() async {
    await _audioPlayer.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Meditate'),
      // ),
      body: Column(
        children: [
          Card(
            child: ListTile(
              title: Text('Breath Meditation'),
              subtitle: Text('Duration: 10 minutes'),
              leading: Icon(Icons.spa),
              trailing: _buildAudioPlayerButtons('audio/breath.mp3'),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Pre-Meals Meditation'),
              subtitle: Text('Duration: 15 minutes'),
              leading: Icon(Icons.restaurant_menu),
              trailing: _buildAudioPlayerButtons('audio/pre-meals.mp3'),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Deep Relaxation Meditation'),
              subtitle: Text('Duration: 20 minutes'),
              leading: Icon(Icons.snooze),
              trailing: _buildAudioPlayerButtons('audio/relax.mp3'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioPlayerButtons(String audioUrl) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: () {
            if (_isPlaying) {
              _pauseAudio();
            } else {
              _playAudio(audioUrl);
            }
          },
        ),
      ],
    );
  }
}
