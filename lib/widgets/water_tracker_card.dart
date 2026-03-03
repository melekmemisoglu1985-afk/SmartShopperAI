import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WaterTrackerCard extends StatefulWidget {
  const WaterTrackerCard({super.key});

  @override
  State<WaterTrackerCard> createState() => _WaterTrackerCardState();
}

class _WaterTrackerCardState extends State<WaterTrackerCard> {
  int _waterCount = 0;
  final int _dailyGoal = 8;

  @override
  void initState() {
    super.initState();
    _loadWaterCount();
  }

  Future<void> _loadWaterCount() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toString().split(' ')[0];
    final savedDate = prefs.getString('water_date') ?? '';
    
    if (savedDate == today) {
      setState(() => _waterCount = prefs.getInt('water_count') ?? 0);
    } else {
      await prefs.setString('water_date', today);
      await prefs.setInt('water_count', 0);
      setState(() => _waterCount = 0);
    }
  }

  Future<void> _incrementWater() async {
    if (_waterCount < _dailyGoal) {
      setState(() => _waterCount++);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('water_count', _waterCount);
      if (_waterCount == _dailyGoal) _showCongratsDialog();
    }
  }

  void _showCongratsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Tebrikler!'),
        content: const Text('Günlük su hedefini tamamladın!'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Harika!'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = _waterCount / _dailyGoal;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.blue.shade300, Colors.blue.shade500]), borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(children: [Icon(Icons.water_drop, color: Colors.white, size: 28), SizedBox(width: 8), Text('Su Takibi', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))]),
                  Text('$_waterCount/$_dailyGoal', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(value: progress, minHeight: 12, backgroundColor: Colors.white.withOpacity(0.3), valueColor: const AlwaysStoppedAnimation<Color>(Colors.white))),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Günlük hedef: ${(_dailyGoal * 250).toStringAsFixed(0)} ml', style: const TextStyle(color: Colors.white, fontSize: 14)),
                  IconButton(onPressed: _incrementWater, icon: const Icon(Icons.add_circle), color: Colors.white, iconSize: 32),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
