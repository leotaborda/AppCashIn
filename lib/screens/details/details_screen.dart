import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes'),
        backgroundColor: AppColors.primary,
      ),
      body: const Center(
        child: Text(
          'Conteúdo protegido da tela de detalhes!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
