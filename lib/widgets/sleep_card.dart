import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class SleepCard extends StatefulWidget {
  const SleepCard({super.key});

  @override
  State<SleepCard> createState() => _SleepCardState();
}

class _SleepCardState extends State<SleepCard> {
  @override
  void initState() {
    super.initState();
  }

  String getSleepSummary(TimeOfDay? sleepTime, TimeOfDay? wakeTime) {
    if (sleepTime == null || wakeTime == null) {
      return "Henüz giriş yapılmadı";
    }

    final now = DateTime.now();
    final sleepDateTime = DateTime(
        now.year, now.month, now.day, sleepTime.hour, sleepTime.minute);
    DateTime wakeDateTime = DateTime(
        now.year, now.month, now.day, wakeTime.hour, wakeTime.minute);

    if (wakeDateTime.isBefore(sleepDateTime)) {
      wakeDateTime = wakeDateTime.add(const Duration(days: 1));
    }

    final diff = wakeDateTime.difference(sleepDateTime);
    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;

    return "Dün gece $hours saat $minutes dakika uyudunuz\n${getSleepFeedback(hours)}";
  }

  String getSleepFeedback(int hours) {
    if (hours < 5) return "Çok az uyku 😴";
    if (hours < 7) return "Orta seviye 💤";
    return "Verimli uyku ✅";
  }

  Future<void> _pickTime(bool isSleepTime) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      
      if (isSleepTime) {
        appProvider.setSleepTime(picked);
      } else {
        appProvider.setWakeTime(picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Card(
          elevation: 4,
          child: Column(
            children: [
              const ListTile(
                leading: Icon(Icons.bedtime, size: 32, color: Colors.purple),
                title: Text("Uyku Süresi"),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(getSleepSummary(appProvider.sleepTime, appProvider.wakeTime)),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickTime(true),
                    icon: const Icon(Icons.login),
                    label: const Text("Yatma Saati"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _pickTime(false),
                    icon: const Icon(Icons.logout),
                    label: const Text("Uyanma Saati"),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}
