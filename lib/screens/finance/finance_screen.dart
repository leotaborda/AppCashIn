import 'package:flutter/material.dart';
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
    _financeService.createInitialMonthsIfNeeded();
  }

  void _openMonth(FinanceModel model) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MonthDetailsScreen(model: model)),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Controle Financeiro'),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        elevation: 4,
      ),
      body: StreamBuilder<List<FinanceModel>>(
        stream: _financeService.getAllMonths(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          final months = snapshot.data ?? [];

          if (months.isEmpty) {
            return Center(
              child: Text(
                'Nenhum dado disponível.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: months.length,
            separatorBuilder: (_, __) => Divider(color: AppColors.border, height: 1),
            itemBuilder: (context, index) {
              final m = months[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Text(
                  m.month,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                ),
                subtitle: Text(
                  'Investido: R\$ ${m.invested.toStringAsFixed(2)} • '
                      'Guardado: R\$ ${m.saved.toStringAsFixed(2)} • '
                      'Gastos: R\$ ${m.personal.toStringAsFixed(2)}',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.secondary),
                onTap: () => _openMonth(m),
              );
            },
          );
        },
      ),
    );
  }
}
