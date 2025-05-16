import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/finance_model.dart';
import '../../core/services/finance_service.dart';

class MonthDetailsScreen extends StatefulWidget {
  final FinanceModel model;

  const MonthDetailsScreen({super.key, required this.model});

  @override
  State<MonthDetailsScreen> createState() => _MonthDetailsScreenState();
}

class _MonthDetailsScreenState extends State<MonthDetailsScreen> {
  late TextEditingController investedCtrl;
  late TextEditingController savedCtrl;
  late TextEditingController personalCtrl;

  final _service = FinanceService();

  @override
  void initState() {
    super.initState();
    investedCtrl = TextEditingController(text: widget.model.invested.toString());
    savedCtrl = TextEditingController(text: widget.model.saved.toString());
    personalCtrl = TextEditingController(text: widget.model.personal.toString());
  }

  void _save() async {
    final updated = FinanceModel(
      id: widget.model.id,
      month: widget.model.month,
      monthNumber: widget.model.monthNumber, // 👈 aqui está o que faltava
      invested: double.tryParse(investedCtrl.text) ?? 0.0,
      saved: double.tryParse(savedCtrl.text) ?? 0.0,
      personal: double.tryParse(personalCtrl.text) ?? 0.0,
    );
    await _service.saveMonth(updated);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.model.month),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: investedCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Investido (R\$)'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: savedCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Guardado (R\$)'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: personalCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Gastos pessoais (R\$)'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _save,
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
