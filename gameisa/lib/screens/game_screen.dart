// lib/screens/game_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import '../widgets/game_board.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Jogo da Memória',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[700],
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => _showNewGameDialog(context),
            tooltip: 'Novo Jogo',
          ),
        ],
      ),
      body: Consumer<GameController>(
        builder: (context, controller, child) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildStatsBar(controller),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GameBoard(
                      cards: controller.cards,
                      onCardTap: controller.onCardTap,
                      columns: 4,
                    ),
                  ),
                  if (controller.isGameComplete) _buildVictoryMessage(controller),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildStatsBar(GameController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatItem(
            icon: Icons.touch_app,
            label: 'Jogadas',
            value: '${controller.moves}',
            color: Colors.orange,
          ),
          _buildStatItem(
            icon: Icons.star,
            label: 'Pares',
            value: '${controller.pairsFound}/${controller.totalPairs}',
            color: Colors.green,
          ),
          _buildStatItem(
            icon: Icons.timer,
            label: 'Tempo',
            value: controller.formattedTime,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
  
  Widget _buildVictoryMessage(GameController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[400]!, Colors.green[600]!],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.emoji_events,
            color: Colors.white,
            size: 40,
          ),
          const SizedBox(height: 6),
          const Text(
            'Parabéns! 🎉',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Você completou em ${controller.moves} jogadas e ${controller.formattedTime}!',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _showNewGameDialog(context),
            icon: const Icon(Icons.replay, size: 18),
            label: const Text('Jogar Novamente'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.green[700],
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showNewGameDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Novo Jogo'),
          content: const Text('Escolha o nível de dificuldade:'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<GameController>().startNewGame(pairs: 4);
              },
              child: const Text('Fácil (4 pares)'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<GameController>().startNewGame(pairs: 8);
              },
              child: const Text('Médio (8 pares)'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<GameController>().startNewGame(pairs: 12);
              },
              child: const Text('Difícil (12 pares)'),
            ),
          ],
        );
      },
    );
  }
}