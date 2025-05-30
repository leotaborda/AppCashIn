import 'package:flutter/material.dart';
import 'dart:math';

import '../../core/constants/app_colors.dart';

// Simulação de chamadas de API ou banco de dados local
Future<List<Map<String, String>>> fetchNews() async {
  await Future.delayed(const Duration(seconds: 1));
  return [
    {
      'title': 'Alta no dólar preocupa investidores',
      'summary': 'O dólar volta a subir e pressiona a inflação em diversos setores.',
    },
    {
      'title': 'Bitcoin atinge nova máxima',
      'summary': 'A criptomoeda alcança patamar histórico após anúncio de regulação.',
    },
    {
      'title': 'Selic se mantém em 10,75%',
      'summary': 'O Banco Central opta por manter os juros básicos da economia.',
    },
  ];
}

Future<Map<String, String>> fetchExchangeRates() async {
  await Future.delayed(const Duration(seconds: 1));
  return {
    'USD': '5,27',
    'EUR': '5,63',
    'BTC': '354.000,00',
  };
}

String getDailyTip() {
  final tips = [
    'Pague-se primeiro: guarde ao menos 10% de tudo que ganhar.',
    'Evite dívidas de cartão de crédito: os juros são altos!',
    'Estude sobre investimentos de baixo risco como CDB e Tesouro Direto.',
    'Tenha um fundo de emergência de pelo menos 3 meses de despesas.',
  ];
  return tips[Random().nextInt(tips.length)];
}

String getRandomFact() {
  final facts = [
    'O primeiro cartão de crédito foi criado em 1950.',
    'A palavra "salário" vem do latim "salarium", que significava pagamento com sal.',
    'Cédulas de dinheiro são feitas de algodão, não papel.',
    'O maior banco do mundo em ativos é o ICBC, da China.',
  ];
  return facts[Random().nextInt(facts.length)];
}

class HomeAdvancedScreen extends StatefulWidget {
  const HomeAdvancedScreen({super.key});

  @override
  State<HomeAdvancedScreen> createState() => _HomeAdvancedScreenState();
}

class _HomeAdvancedScreenState extends State<HomeAdvancedScreen> {
  late Future<List<Map<String, String>>> _newsFuture;
  late Future<Map<String, String>> _ratesFuture;

  @override
  void initState() {
    super.initState();
    _newsFuture = fetchNews();
    _ratesFuture = fetchExchangeRates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visão Geral'),
        backgroundColor: AppColors.primary,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _newsFuture = fetchNews();
            _ratesFuture = fetchExchangeRates();
          });
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionTitle('📈 Cotações Atuais'),
            _buildExchangeRates(),

            const SizedBox(height: 24),
            _buildSectionTitle('📢 Lembrete do Dia'),
            _buildCard('Lembre-se de registrar seus gastos diários!'),

            const SizedBox(height: 24),
            _buildSectionTitle('💡 Dica Financeira'),
            _buildCard(getDailyTip()),

            const SizedBox(height: 24),
            _buildSectionTitle('🧠 Curiosidade'),
            _buildCard(getRandomFact()),

            const SizedBox(height: 24),
            _buildSectionTitle('🗞️ Notícias Recentes'),
            _buildNews(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildCard(String content) {
    return Card(
      color: Colors.white,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          content,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildExchangeRates() {
    return FutureBuilder<Map<String, String>>(
      future: _ratesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          return const Text('Erro ao carregar dados.');
        }

        final rates = snapshot.data!;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: rates.entries.map((e) {
            return Column(
              children: [
                Text(e.key,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                Text('R\$ ${e.value}',
                    style: const TextStyle(color: AppColors.textSecondary)),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildNews() {
    return FutureBuilder<List<Map<String, String>>>(
      future: _newsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          return const Text('Erro ao carregar notícias.');
        }

        final newsList = snapshot.data!;
        return Column(
          children: newsList.map((news) {
            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(news['title']!),
                subtitle: Text(news['summary']!),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
