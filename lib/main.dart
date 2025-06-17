import 'package:flutter/material.dart';
import 'core/constants/app_colors.dart';
import 'screens/navigation/main_screen.dart';
import 'screens/login/login_screen.dart'; // importa sua tela de login
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      // Aqui registramos as rotas nomeadas, incluindo a login
      routes: {
        '/login': (context) => const LoginScreen(),
        // pode adicionar outras rotas aqui, se precisar
      },
      home: const MainScreen(),
    );
  }
}
