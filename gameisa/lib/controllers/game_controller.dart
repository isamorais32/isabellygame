// lib/controllers/game_controller.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/card_model.dart';

class GameController extends ChangeNotifier {
  List<CardModel> _cards = [];
  int _moves = 0;
  int _pairsFound = 0;
  bool _isProcessing = false;
  Timer? _timer;
  int _seconds = 0;
  bool _gameStarted = false;
  
  // Emojis e ícones para as cartas
  static const List<String> _emojis = [
    '🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼',
    '🐨', '🐯', '🦁', '🐮', '🐷', '🐸', '🐵', '🐔',
    '🐧', '🐦', '🐤', '🦆', '🦅', '🦉', '🦇', '🐺'
  ];
  
  // Getters
  List<CardModel> get cards => _cards;
  int get moves => _moves;
  int get pairsFound => _pairsFound;
  int get totalPairs => _cards.length ~/ 2;
  int get seconds => _seconds;
  bool get isProcessing => _isProcessing;
  bool get gameStarted => _gameStarted;
  bool get isGameComplete => _pairsFound == totalPairs && _cards.isNotEmpty;
  
  String get formattedTime {
    final minutes = _seconds ~/ 60;
    final remainingSeconds = _seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
  
  void startNewGame({int pairs = 8}) {
    _stopTimer();
    _moves = 0;
    _pairsFound = 0;
    _seconds = 0;
    _isProcessing = false;
    _gameStarted = false;
    
    // Criar pares de cartas
    _cards = [];
    final random = Random();
    final selectedEmojis = List<String>.from(_emojis)..shuffle(random);
    
    for (int i = 0; i < pairs; i++) {
      final emoji = selectedEmojis[i % selectedEmojis.length];
      _cards.add(CardModel(id: i * 2, emoji: emoji));
      _cards.add(CardModel(id: i * 2 + 1, emoji: emoji));
    }
    
    _cards.shuffle(random);
    notifyListeners();
  }
  
  void onCardTap(int cardId) {
    if (_isProcessing) return;
    
    final card = _cards.firstWhere((c) => c.id == cardId);
    if (!card.isHidden) return;
    
    if (!_gameStarted) {
      _gameStarted = true;
      _startTimer();
    }
    
    card.reveal();
    notifyListeners();
    
    // Encontrar cartas reveladas
    final revealedCards = _cards.where((c) => c.isRevealed).toList();
    
    if (revealedCards.length == 2) {
      _moves++;
      _isProcessing = true;
      
      if (revealedCards[0].emoji == revealedCards[1].emoji) {
        // Par encontrado
        Future.delayed(const Duration(milliseconds: 500), () {
          revealedCards[0].markAsMatched();
          revealedCards[1].markAsMatched();
          _pairsFound++;
          _isProcessing = false;
          
          if (isGameComplete) {
            _stopTimer();
          }
          
          notifyListeners();
        });
      } else {
        // Cartas não combinam
        Future.delayed(const Duration(milliseconds: 800), () {
          revealedCards[0].hide();
          revealedCards[1].hide();
          _isProcessing = false;
          notifyListeners();
        });
      }
    }
  }
  
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds++;
      notifyListeners();
    });
  }
  
  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }
  
  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}