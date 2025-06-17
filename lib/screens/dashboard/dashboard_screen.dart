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

  double get totalInvested => months.fold(0, (sum, m) => sum + m.invested);
  double get totalSaved => months.fold(0, (sum, m) => sum + m.saved);
  double get totalPersonal => months.fold(0, (sum, m) => sum + m.personal);

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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Dashboard Financeiro'),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        elevation: 4,
      ),
      body: loading
          ? const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTotalSection(),
            const SizedBox(height: 32),
            _buildBarChartSection(),
            const SizedBox(height: 32),
            _buildPieChartSection(),
            const SizedBox(height: 32),
            _buildMonthlyTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildTotalCard(
            'Total Investido',
            totalInvested,
            AppColors.greenDark,
            Icons.trending_up,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildTotalCard(
            'Total Guardado',
            totalSaved,
            AppColors.blueDark,
            Icons.savings,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildTotalCard(
            'Gastos Pessoais',
            totalPersonal,
            AppColors.alert,
            Icons.money_off,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalCard(String label, double value, Color color, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 5,
      shadowColor: color.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 36),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'R\$ ${value.toStringAsFixed(2)}',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChartSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Comparativo Mensal (Barras)',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        AspectRatio(
          aspectRatio: 1.3,
          child: BarChart(
            BarChartData(
              maxY: _getMaxY() * 1.1,
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    getTitlesWidget: (value, _) {
                      final index = value.toInt();
                      if (index < months.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            months[index].month.substring(0, 3),
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    interval: _getInterval(),
                    getTitlesWidget: (value, _) {
                      return Text(
                        value.toInt().toString(),
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: FlGridData(
                show: true,
                drawHorizontalLine: true,
                horizontalInterval: _getInterval(),
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: AppColors.border.withOpacity(0.5),
                    strokeWidth: 1,
                  );
                },
                drawVerticalLine: false,
              ),
              barGroups: List.generate(months.length, (index) {
                final m = months[index];
                return BarChartGroupData(
                  x: index,
                  barsSpace: 4,
                  barRods: [
                    BarChartRodData(
                      toY: m.invested,
                      color: AppColors.greenDark,
                      width: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    BarChartRodData(
                      toY: m.saved,
                      color: AppColors.blueDark,
                      width: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    BarChartRodData(
                      toY: m.personal,
                      color: AppColors.alert,
                      width: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                );
              }),
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: Colors.grey.shade700.withOpacity(0.9),
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    String label;
                    switch (rodIndex) {
                      case 0:
                        label = 'Investido';
                        break;
                      case 1:
                        label = 'Guardado';
                        break;
                      case 2:
                        label = 'Gastos';
                        break;
                      default:
                        label = '';
                    }
                    return BarTooltipItem(
                      '$label\nR\$ ${rod.toY.toStringAsFixed(2)}',
                      const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  double _getMaxY() {
    double max = 0;
    for (var m in months) {
      max = [
        max,
        m.invested,
        m.saved,
        m.personal,
      ].reduce((a, b) => a > b ? a : b);
    }
    return (max * 1.2).ceilToDouble();
  }

  double _getInterval() {
    final max = _getMaxY();
    if (max <= 50) return 10;
    if (max <= 200) return 50;
    if (max <= 500) return 100;
    return 200;
  }

  Widget _buildPieChartSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Distribuição (Pizza)',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        AspectRatio(
          aspectRatio: 1.4,
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  value: totalInvested,
                  title: 'Investido',
                  color: AppColors.greenDark,
                  radius: 60,
                  titleStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                PieChartSectionData(
                  value: totalSaved,
                  title: 'Guardado',
                  color: AppColors.blueDark,
                  radius: 60,
                  titleStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                PieChartSectionData(
                  value: totalPersonal,
                  title: 'Gastos',
                  color: AppColors.alert,
                  radius: 60,
                  titleStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
              sectionsSpace: 4,
              centerSpaceRadius: 50,
              pieTouchData: PieTouchData(
                touchCallback: (event, response) {
                  // Pode adicionar interação futura
                },
              ),
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
        Text(
          'Resumo por Mês (Tabela)',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 24,
            headingRowColor:
            MaterialStateProperty.all(AppColors.blueLight.withOpacity(0.3)),
            columns: [
              DataColumn(
                label: Text(
                  'Mês',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
              ),
              DataColumn(
                label: Text(
                  'Investido',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
              ),
              DataColumn(
                label: Text(
                  'Guardado',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
              ),
              DataColumn(
                label: Text(
                  'Gastos',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
              ),
            ],
            rows: months.map((m) {
              return DataRow(cells: [
                DataCell(Text(m.month)),
                DataCell(Text('R\$ ${m.invested.toStringAsFixed(2)}')),
                DataCell(Text('R\$ ${m.saved.toStringAsFixed(2)}')),
                DataCell(Text('R\$ ${m.personal.toStringAsFixed(2)}')),
              ]);
            }).toList(),
          ),
        ),
      ],
    );
  }
}
