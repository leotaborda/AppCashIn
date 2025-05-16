import 'package:flutter/material.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/finance/finance_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/home/task_list_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/details/details_screen.dart';
import 'app_routes.dart';
import '../core/services/auth_service.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case AppRoutes.details:
        return MaterialPageRoute(
          builder: (_) => FutureBuilder<bool>(
            future: AuthService().isLoggedIn(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              return snapshot.data!
                  ? const DetailsScreen()
                  : const LoginScreen();
            },
          ),
        );

      case AppRoutes.tasks:
        return MaterialPageRoute(
          builder: (_) => FutureBuilder<bool>(
            future: AuthService().isLoggedIn(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              return snapshot.data!
                  ? const TaskListScreen()
                  : const LoginScreen();
            },
          ),
        );
      case AppRoutes.finance:
        return MaterialPageRoute(
          builder: (_) => const FinanceScreen(),
        );
      case AppRoutes.dashboard:
        return MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
        );

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(child: Text('Rota não encontrada')),
      ),
    );
  }
}

