// lib/widgets/memory_card.dart
import 'package:flutter/material.dart';
import '../models/card_model.dart';

class MemoryCard extends StatelessWidget {
  final CardModel card;
  final VoidCallback onTap;
  
  const MemoryCard({
    super.key,
    required this.card,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _buildCardContent(),
        ),
      ),
    );
  }
  
  Widget _buildCardContent() {
    if (card.isMatched) {
      return Container(
        key: ValueKey('matched_${card.id}'),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.green,
            width: 2,
          ),
        ),
        child: Center(
          child: Icon(
            Icons.check_circle,
            color: Colors.green[700],
            size: 32,
          ),
        ),
      );
    }
    
    if (card.isRevealed) {
      return Container(
        key: ValueKey('revealed_${card.id}'),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.blue,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            card.emoji,
            style: const TextStyle(fontSize: 40),
          ),
        ),
      );
    }
    
    return Container(
      key: ValueKey('hidden_${card.id}'),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[400]!, Colors.blue[700]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue[800]!,
          width: 2,
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.question_mark,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }
}