import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/app_provider.dart';

class WaterCard extends StatefulWidget {
  const WaterCard({super.key});

  @override
  State<WaterCard> createState() => _WaterCardState();
}

class _WaterCardState extends State<WaterCard> {
  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    // SharedPreferences'dan hedefi yükle
    final prefs = await SharedPreferences.getInstance();
    final goal = prefs.getInt('dailyGoal') ?? 8;
    
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.setDailyWaterGoal(goal);
  }

  void _incrementCup() {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.incrementWater();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        double progress = appProvider.dailyWaterGoal == 0 ? 0 : appProvider.currentWaterCount / appProvider.dailyWaterGoal;

        return Card(
          elevation: 4,
          child: InkWell(
            onTap: _incrementCup,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ListTile(
                    leading: Icon(Icons.local_drink, size: 32, color: Colors.blue),
                    title: Text("Su Tüketimi"),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[300],
                      color: Colors.blue,
                      minHeight: 10,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text("İçilen: ${appProvider.currentWaterCount} / ${appProvider.dailyWaterGoal} bardak"),
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text("🖐️ Tıklayarak içtiğini kaydet"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
