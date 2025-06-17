import 'package:flutter/material.dart';
import 'dart:math';

import '../../core/constants/app_colors.dart';

// Models para melhor estrutura de dados
class NewsItem {
  final String title;
  final String summary;
  final DateTime publishedAt;
  final String? imageUrl;

  const NewsItem({
    required this.title,
    required this.summary,
    required this.publishedAt,
    this.imageUrl,
  });
}

class ExchangeRate {
  final String currency;
  final String symbol;
  final double rate;
  final double change;
  final bool isPositive;

  const ExchangeRate({
    required this.currency,
    required this.symbol,
    required this.rate,
    required this.change,
    required this.isPositive,
  });
}

// Service classes para separar lógica de negócio
class NewsService {
  static Future<List<NewsItem>> fetchNews() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      NewsItem(
        title: 'Alta no dólar preocupa investidores',
        summary: 'O dólar volta a subir e pressiona a inflação em diversos setores da economia brasileira.',
        publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      NewsItem(
        title: 'Bitcoin atinge nova máxima histórica',
        summary: 'A criptomoeda alcança patamar recorde após anúncio de nova regulação favorável.',
        publishedAt: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      NewsItem(
        title: 'Selic mantida em 10,75% pelo Copom',
        summary: 'O Banco Central opta por manter os juros básicos da economia pelo terceiro mês consecutivo.',
        publishedAt: DateTime.now().subtract(const Duration(hours: 6)),
      ),
    ];
  }
}

class ExchangeService {
  static Future<List<ExchangeRate>> fetchExchangeRates() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      const ExchangeRate(
        currency: 'USD',
        symbol: 'US\$',
        rate: 5.27,
        change: 0.12,
        isPositive: true,
      ),
      const ExchangeRate(
        currency: 'EUR',
        symbol: '€',
        rate: 5.63,
        change: -0.08,
        isPositive: false,
      ),
      const ExchangeRate(
        currency: 'BTC',
        symbol: '₿',
        rate: 354000.00,
        change: 2500.00,
        isPositive: true,
      ),
    ];
  }
}

class TipsService {
  static const List<String> _tips = [
    'Pague-se primeiro: guarde ao menos 10% de tudo que ganhar antes de qualquer gasto.',
    'Evite dívidas de cartão de crédito: os juros compostos podem chegar a mais de 400% ao ano!',
    'Diversifique seus investimentos entre CDB, Tesouro Direto e fundos de investimento.',
    'Mantenha um fundo de emergência equivalente a 6 meses de despesas básicas.',
    'Acompanhe seus gastos diariamente usando aplicativos de controle financeiro.',
  ];

  static const List<String> _facts = [
    'O primeiro cartão de crédito foi criado em 1950 pelo Diners Club nos Estados Unidos.',
    'A palavra "salário" vem do latim "salarium", que significava pagamento feito com sal na Roma Antiga.',
    'As cédulas de dinheiro são feitas principalmente de algodão e linho, não de papel comum.',
    'O maior banco do mundo em ativos é o Industrial and Commercial Bank of China (ICBC).',
    'A primeira moeda brasileira foi o Real de Ouro, criada em 1500 pelos portugueses.',
  ];

  static String getDailyTip() => _tips[Random().nextInt(_tips.length)];
  static String getRandomFact() => _facts[Random().nextInt(_facts.length)];
}

class HomeAdvancedScreen extends StatefulWidget {
  const HomeAdvancedScreen({super.key});

  @override
  State<HomeAdvancedScreen> createState() => _HomeAdvancedScreenState();
}

class _HomeAdvancedScreenState extends State<HomeAdvancedScreen>
    with AutomaticKeepAliveClientMixin {
  late Future<List<NewsItem>> _newsFuture;
  late Future<List<ExchangeRate>> _ratesFuture;
  String _currentTip = '';
  String _currentFact = '';

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    _newsFuture = NewsService.fetchNews();
    _ratesFuture = ExchangeService.fetchExchangeRates();
    _currentTip = TipsService.getDailyTip();
    _currentFact = TipsService.getRandomFact();
  }

  Future<void> _refreshData() async {
    setState(() {
      _newsFuture = NewsService.fetchNews();
      _ratesFuture = ExchangeService.fetchExchangeRates();
      _currentTip = TipsService.getDailyTip();
      _currentFact = TipsService.getRandomFact();
    });

    try {
      await Future.wait([_newsFuture, _ratesFuture]);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Dados atualizados com sucesso!'),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao atualizar dados. Tente novamente.'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Visão Geral',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'Atualizar dados',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: AppColors.primary,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildWelcomeCard(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('📈 Cotações em Tempo Real'),
                  const SizedBox(height: 12),
                  _buildExchangeRates(),
                  const SizedBox(height: 32),
                  _buildSectionTitle('💡 Dica Financeira do Dia'),
                  const SizedBox(height: 12),
                  _buildTipCard(_currentTip),
                  const SizedBox(height: 32),
                  _buildSectionTitle('🧠 Você Sabia?'),
                  const SizedBox(height: 12),
                  _buildFactCard(_currentFact),
                  const SizedBox(height: 32),
                  _buildSectionTitle('🗞️ Últimas Notícias'),
                  const SizedBox(height: 12),
                  _buildNews(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    final hour = DateTime.now().hour;
    String greeting;
    IconData icon;

    if (hour < 12) {
      greeting = 'Bom dia!';
      icon = Icons.wb_sunny;
    } else if (hour < 18) {
      greeting = 'Boa tarde!';
      icon = Icons.wb_cloudy;
    } else {
      greeting = 'Boa noite!';
      icon = Icons.brightness_3;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Como estão suas finanças hoje?',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildTipCard(String content) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.lightbulb, color: Colors.blue.shade700, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              content,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.blue.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFactCard(String content) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.purple.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.psychology, color: Colors.purple.shade700, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              content,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.purple.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExchangeRates() {
    return FutureBuilder<List<ExchangeRate>>(
      future: _ratesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(Icons.error_outline, color: Colors.red.shade400, size: 48),
                  const SizedBox(height: 8),
                  Text(
                    'Erro ao carregar cotações',
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _refreshData,
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text('Tentar Novamente'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final rates = snapshot.data!;
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: rates.map((rate) => _buildExchangeRateItem(rate)).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildExchangeRateItem(ExchangeRate rate) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                rate.symbol,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rate.currency,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'R\$ ${rate.rate.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: rate.isPositive ? Colors.green.shade50 : Colors.red.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  rate.isPositive ? Icons.trending_up : Icons.trending_down,
                  size: 16,
                  color: rate.isPositive ? Colors.green.shade700 : Colors.red.shade700,
                ),
                const SizedBox(width: 4),
                Text(
                  '${rate.isPositive ? '+' : ''}${rate.change.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: rate.isPositive ? Colors.green.shade700 : Colors.red.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNews() {
    return FutureBuilder<List<NewsItem>>(
      future: _newsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(Icons.error_outline, color: Colors.red.shade400, size: 48),
                  const SizedBox(height: 8),
                  Text(
                    'Erro ao carregar notícias',
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _refreshData,
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text('Tentar Novamente'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final newsList = snapshot.data!;
        return Column(
          children: newsList.map((news) => _buildNewsItem(news)).toList(),
        );
      },
    );
  }

  Widget _buildNewsItem(NewsItem news) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Implementar navegação para detalhes da notícia
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Abrindo: ${news.title}'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      news.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                news.summary,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _formatTimeAgo(news.publishedAt),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inHours < 1) {
      return '${difference.inMinutes} min atrás';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h atrás';
    } else {
      return '${difference.inDays} dia(s) atrás';
    }
  }
}