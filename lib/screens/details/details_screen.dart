import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre o App'),
        backgroundColor: AppColors.primary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Cashin - Controle Financeiro e de Tarefas',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 12),
          const Text(
            'Este aplicativo foi criado como parte do projeto formativo SENAI para ajudar usuários a gerenciar suas tarefas e suas finanças pessoais mês a mês, com foco em organização e simplicidade.',
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          const SizedBox(height: 24),
          _buildInfoCard(
            icon: Icons.check_circle_outline,
            title: 'Lista de Tarefas',
            description:
            'Adicione, conclua e exclua tarefas com integração em tempo real no Firebase.',
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            icon: Icons.attach_money,
            title: 'Controle Financeiro',
            description:
            'Acompanhe seus investimentos, economias e gastos por mês. Tudo salvo no Firestore.',
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            icon: Icons.pie_chart,
            title: 'Dashboard Interativo',
            description:
            'Resumo anual com gráficos de barras, pizza e tabela detalhada por mês.',
          ),
          const SizedBox(height: 24),
          const Text(
            'Desenvolvido por Leonardo Taborda',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary, size: 32),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
      ),
    );
  }
}
