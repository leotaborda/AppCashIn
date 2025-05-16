import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/finance_model.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/finance_service.dart';
import 'month_details_screen.dart';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  final FinanceService _financeService = FinanceService();

  @override
  void initState() {
    super.initState();
    _financeService.createInitialMonthsIfNeeded(); // cria os meses só se ainda não existir
  }

  void _openMonth(FinanceModel model) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MonthDetailsScreen(model: model),
      ),
    );
    setState(() {}); // atualiza depois de voltar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Controle Financeiro'),
        backgroundColor: AppColors.primary,
      ),
      body: StreamBuilder<List<FinanceModel>>(
        stream: _financeService.getAllMonths(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final months = snapshot.data ?? [];

          return ListView.builder(
            itemCount: months.length,
            itemBuilder: (context, index) {
              final m = months[index];
              return ListTile(
                title: Text(m.month),
                subtitle: Text(
                  'Investido: R\$ ${m.invested.toStringAsFixed(2)} | '
                      'Guardado: R\$ ${m.saved.toStringAsFixed(2)} | '
                      'Gastos: R\$ ${m.personal.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 13),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _openMonth(m),
              );
            },
          );
        },
      ),
    );
  }
}
