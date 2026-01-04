import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class StepCard extends StatefulWidget {
  const StepCard({super.key});

  @override
  State<StepCard> createState() => _StepCardState();
}

class _StepCardState extends State<StepCard> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _playedSound = false;

  @override
  void initState() {
    super.initState();
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    _playedSound = appProvider.steps >= 7000;
  }

  void _incrementSteps() {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.incrementSteps();

    if (appProvider.steps >= 7000 && !_playedSound) {
      _playedSound = true;
      _audioPlayer.play(AssetSource('audio/motivation.mp3'));
    }
  }

  String getActivityLevel(int steps) {
    if (steps < 3000) return "Pasif";
    if (steps < 7000) return "Orta Aktif";
    return "Aktif";
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Card(
          elevation: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: const Icon(Icons.directions_walk, size: 32, color: Colors.green),
                title: const Text("Adım Sayısı"),
                subtitle: Text("Bugün ${appProvider.steps} adım attınız"),
                trailing: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _incrementSteps,
                  color: Colors.green,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 12),
                child: Text(
                  "Aktivite Durumu: ${getActivityLevel(appProvider.steps)}",
                  style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
