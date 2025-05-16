import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // 👈 novo
import 'routes/app_routes.dart';
import 'routes/route_generator.dart';
import 'screens/home/home_screen.dart';
import 'core/constants/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 👈 importante
  await Firebase.initializeApp(); // 👈 inicialização Firebase
  runApp(const CashinApp());
}

class CashinApp extends StatelessWidget {
  const CashinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cashin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.textPrimary),
          bodyMedium: TextStyle(color: AppColors.textSecondary),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
        ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      initialRoute: AppRoutes.home,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
