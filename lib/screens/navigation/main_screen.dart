import 'package:flutter/material.dart';
import 'package:cashin_app/screens/home/home_screen.dart';
import 'package:cashin_app/screens/home/task_list_screen.dart';
import 'package:cashin_app/screens/finance/month_details_screen.dart';
import 'package:cashin_app/screens/finance/finance_screen.dart';
import 'package:cashin_app/screens/dashboard/dashboard_screen.dart';
import 'package:cashin_app/screens/details/details_screen.dart';
import 'package:cashin_app/screens/home/home_advanced_screen.dart';
import '../../../../core/constants/app_colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeAdvancedScreen(),
    const TaskListScreen(),
    const FinanceScreen(),
    const DashboardScreen(),
    const DetailsScreen(),
  ];

  final List<String> _titles = [
    'Início',
    'Tarefas',
    'Finanças',
    'Dashboard',
    'Detalhes',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: AppColors.primary,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Tarefas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Finanças',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'Detalhes',
          ),
        ],
      ),
    );
  }
}
