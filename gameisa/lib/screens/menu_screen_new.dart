// lib/screens/menu_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import 'game_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin {
  late AnimationController _titleController;
  late AnimationController _buttonController;
  late List<AnimationController> _cardControllers;

  @override
  void initState() {
    super.initState();
    _titleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();

    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward(from: 0.0);

    _cardControllers = List.generate(
      3,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this,
      )..forward(from: 0.0),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _buttonController.dispose();
    for (var controller in _cardControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _startGame(int pairs) {
    context.read<GameController>().startNewGame(pairs: pairs);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GameScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.indigo[400]!,
              Colors.blue[600]!,
              Colors.cyan[500]!,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  // Animação do Título
                  FadeTransition(
                    opacity: _titleController,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, -0.5),
                        end: Offset.zero,
                      ).animate(_titleController),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.15),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.2),
                                  blurRadius: 20,
                                ),
                              ],
                            ),
                            child: const Text(
                              '🧠',
                              style: TextStyle(fontSize: 80),
                            ),
                          ),
                          const SizedBox(height: 24),
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [Colors.white, Colors.cyan[200]!],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(bounds),
                            child: const Text(
                              'MEMORY GAME',
                              style: TextStyle(
                                fontSize: 44,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Desafie sua memória',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.8),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                  // Botões de Dificuldade com Animação
                  ..._buildAnimatedDifficultyButtons(),
                  const SizedBox(height: 50),
                  // Rodapé com Informações
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Divider(
                          color: Colors.white.withOpacity(0.3),
                          thickness: 1,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildInfoItem('⚡', 'Rápido'),
                            _buildInfoItem('🎯', 'Divertido'),
                            _buildInfoItem('🏆', 'Desafiador'),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildAnimatedDifficultyButtons() {
    return [
      SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.5),
          end: Offset.zero,
        ).animate(_cardControllers[0]),
        child: GestureDetector(
          onTap: () => _startGame(4),
          child: _buildModernButton(
            title: 'FÁCIL',
            subtitle: '4 pares',
            color: Colors.green,
            emoji: '😊',
          ),
        ),
      ),
      const SizedBox(height: 16),
      SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.5),
          end: Offset.zero,
        ).animate(_cardControllers[1]),
        child: GestureDetector(
          onTap: () => _startGame(8),
          child: _buildModernButton(
            title: 'MÉDIO',
            subtitle: '8 pares',
            color: Colors.orange,
            emoji: '😎',
          ),
        ),
      ),
      const SizedBox(height: 16),
      SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.5),
          end: Offset.zero,
        ).animate(_cardControllers[2]),
        child: GestureDetector(
          onTap: () => _startGame(12),
          child: _buildModernButton(
            title: 'DIFÍCIL',
            subtitle: '12 pares',
            color: Colors.red,
            emoji: '🔥',
          ),
        ),
      ),
    ];
  }

  Widget _buildModernButton({
    required String title,
    required String subtitle,
    required Color color,
    required String emoji,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.6),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.85),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.25),
              ),
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 40),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String emoji, String label) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
