import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/features/home/widgets/theme.dart';
import 'src/routes/AllRoutes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cardio Tech',
      theme: appTheme(),
      initialRoute: isLoggedIn ? AppRoutes.navbar : AppRoutes.login,
      routes: AppRoutes.routes,
    );
  }
}
  