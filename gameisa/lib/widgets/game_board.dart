// lib/widgets/game_board.dart
import 'package:flutter/material.dart';
import 'memory_card.dart';
import '../models/card_model.dart';

class GameBoard extends StatelessWidget {
  final List<CardModel> cards;
  final Function(int) onCardTap;
  final int columns;
  
  const GameBoard({
    super.key,
    required this.cards,
    required this.onCardTap,
    this.columns = 4,
  });
  
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final card = cards[index];
        return MemoryCard(
          card: card,
          onTap: () => onCardTap(card.id),
        );
      },
    );
  }
}