// lib/models/card_model.dart
enum CardState { hidden, revealed, matched }

class CardModel {
  final int id;
  final String emoji;
  CardState state;
  
  CardModel({
    required this.id,
    required this.emoji,
    this.state = CardState.hidden,
  });
  
  bool get isHidden => state == CardState.hidden;
  bool get isRevealed => state == CardState.revealed;
  bool get isMatched => state == CardState.matched;
  
  void reveal() {
    if (state == CardState.hidden) {
      state = CardState.revealed;
    }
  }
  
  void hide() {
    if (state == CardState.revealed) {
      state = CardState.hidden;
    }
  }
  
  void markAsMatched() {
    state = CardState.matched;
  }
}