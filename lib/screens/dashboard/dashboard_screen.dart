import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/finance_service.dart';
import '../../models/finance_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FinanceService _financeService = FinanceService();

  List<FinanceModel> months = [];
  bool loading = true;

  double get totalInvested =>
      months.fold(0, (sum, m) => sum + m.invested);
  double get totalSaved =>
      months.fold(0, (sum, m) => sum + m.saved);
  double get totalPersonal =>
      months.fold(0, (sum, m) => sum + m.personal);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final snapshot = await _financeService.getAllMonths().first;
    setState(() {
      months = snapshot;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Financeiro'),
        backgroundColor: AppColors.primary,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTotalSection(),
            const SizedBox(height: 24),
            _buildBarChartSection(),
            const SizedBox(height: 24),
            _buildPieChartSection(),
            const SizedBox(height: 24),
            _buildMonthlyTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalSection() {
    return Column(
      children: [
        _buildTotalCard('Total Investido', totalInvested, AppColors.greenDark),
        _buildTotalCard('Total Guardado', totalSaved, AppColors.blueDark),
        _buildTotalCard('Gastos Pessoais', totalPersonal, AppColors.alert),
      ],
    );
  }

  Widget _buildTotalCard(String label, double value, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(Icons.circle, color: color, size: 20),
        title: Text(label),
        trailing: Text(
          'R\$ ${value.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildBarChartSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Comparativo Mensal (Barras)',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        AspectRatio(
          aspectRatio: 1.8,
          child: BarChart(
            BarChartData(
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      final index = value.toInt();
                      if (index < months.length) {
                        return Text(
                          months[index].month.substring(0, 3),
                          style: const TextStyle(fontSize: 10),
                        );
                      }
                      return const Text('');
                    },
                    reservedSize: 28,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 36),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              barGroups: List.generate(months.length, (index) {
                final m = months[index];
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(toY: m.invested, color: AppColors.greenDark, width: 6),
                    BarChartRodData(toY: m.saved, color: AppColors.blueDark, width: 6),
                    BarChartRodData(toY: m.personal, color: AppColors.alert, width: 6),
                  ],
                  showingTooltipIndicators: [0, 1, 2],
                );
              }),
              gridData: FlGridData(show: true),
              barTouchData: BarTouchData(enabled: true),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPieChartSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Distribuição Anual (Pizza)',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        AspectRatio(
          aspectRatio: 1.4,
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  value: totalInvested,
                  title: 'Investido',
                  color: AppColors.greenDark,
                  radius: 50,
                  titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                PieChartSectionData(
                  value: totalSaved,
                  title: 'Guardado',
                  color: AppColors.blueDark,
                  radius: 50,
                  titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                PieChartSectionData(
                  value: totalPersonal,
                  title: 'Gastos',
                  color: AppColors.alert,
                  radius: 50,
                  titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
              sectionsSpace: 2,
              centerSpaceRadius: 40,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Resumo por Mês (Tabela)',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DataTable(
          columnSpacing: 16,
          columns: const [
            DataColumn(label: Text('Mês')),
            DataColumn(label: Text('Investido')),
            DataColumn(label: Text('Guardado')),
            DataColumn(label: Text('Gastos')),
          ],
          rows: months.map((m) {
            return DataRow(
              cells: [
                DataCell(Text(m.month)),
                DataCell(Text('R\$ ${m.invested.toStringAsFixed(2)}')),
                DataCell(Text('R\$ ${m.saved.toStringAsFixed(2)}')),
                DataCell(Text('R\$ ${m.personal.toStringAsFixed(2)}')),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}