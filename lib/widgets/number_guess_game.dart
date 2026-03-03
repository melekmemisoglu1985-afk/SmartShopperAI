import 'dart:math';
import 'package:flutter/material.dart';

class NumberGuessGame extends StatefulWidget {
  const NumberGuessGame({super.key});

  @override
  State<NumberGuessGame> createState() => _NumberGuessGameState();
}

class _NumberGuessGameState extends State<NumberGuessGame> {
  late int _targetNumber;
  int _attempts = 0;
  String _message = 'Bir sayı tahmin et!';
  final TextEditingController _guessController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    setState(() {
      _targetNumber = Random().nextInt(100) + 1;
      _attempts = 0;
      _message = '1 ile 100 arasında bir sayı tuttum. Tahmin et!';
      _guessController.clear();
    });
  }

  void _makeGuess() {
    final input = _guessController.text.trim();
    if (input.isEmpty) return;
    final guess = int.tryParse(input);
    if (guess == null || guess < 1 || guess > 100) return;

    setState(() {
      _attempts++;
      if (guess == _targetNumber) {
        _message = '🎉 Tebrikler! $_attempts denemede bildin!';
        _showWinDialog();
      } else if (guess < _targetNumber) {
        _message = '⬆️ Daha büyük bir sayı dene!';
      } else {
        _message = '⬇️ Daha küçük bir sayı dene!';
      }
      _guessController.clear();
    });
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Kazandın!'),
        content: Text('Sayıyı $_attempts denemede buldun!'),
        actions: [
          TextButton(onPressed: () { Navigator.pop(context); _startNewGame(); }, child: const Text('Yeni Oyun')),
          TextButton(onPressed: () { Navigator.pop(context); Navigator.pop(context); }, child: const Text('Çıkış')),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _guessController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sayı Tahmin Oyunu'), actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _startNewGame, tooltip: 'Yeni Oyun')]),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.purple.shade400, Colors.purple.shade600]), borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    const Text('Deneme Sayısı', style: TextStyle(color: Colors.white, fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('$_attempts', style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(_message, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _guessController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: 'Tahminin (1-100)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.grey[100]),
                    onSubmitted: (_) => _makeGuess(),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(onPressed: _makeGuess, style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Icon(Icons.send, size: 28)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
