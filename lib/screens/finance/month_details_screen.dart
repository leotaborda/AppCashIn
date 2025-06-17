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
    investedCtrl = TextEditingController(text: widget.model.invested.toStringAsFixed(2));
    savedCtrl = TextEditingController(text: widget.model.saved.toStringAsFixed(2));
    personalCtrl = TextEditingController(text: widget.model.personal.toStringAsFixed(2));
  }

  @override
  void dispose() {
    investedCtrl.dispose();
    savedCtrl.dispose();
    personalCtrl.dispose();
    super.dispose();
  }

  void _save() async {
    final updated = FinanceModel(
      id: widget.model.id,
      month: widget.model.month,
      monthNumber: widget.model.monthNumber,
      invested: double.tryParse(investedCtrl.text.replaceAll(',', '.')) ?? 0.0,
      saved: double.tryParse(savedCtrl.text.replaceAll(',', '.')) ?? 0.0,
      personal: double.tryParse(personalCtrl.text.replaceAll(',', '.')) ?? 0.0,
    );
    await _service.saveMonth(updated);
    if (mounted) Navigator.pop(context);
  }

  Widget _buildNumberField(String label, TextEditingController ctrl) {
    return TextField(
      controller: ctrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppColors.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.model.month),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildNumberField('Investido (R\$)', investedCtrl),
            const SizedBox(height: 16),
            _buildNumberField('Guardado (R\$)', savedCtrl),
            const SizedBox(height: 16),
            _buildNumberField('Gastos pessoais (R\$)', personalCtrl),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Salvar',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
