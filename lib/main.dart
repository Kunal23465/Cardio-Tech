import 'package:cardio_tech/src/core/network/dio_client.dart'; // ✅ Add this import
import 'package:cardio_tech/src/provider/main_providers/providers_setup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/features/auth/screens/loginScreens/login_screen.dart';
import 'src/routes/AllRoutes.dart';
import 'src/features/home/widgets/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  //  Restore access token if it exists (so user stays logged in)
  final accessToken = prefs.getString('accessToken');
  if (accessToken != null && accessToken.isNotEmpty) {
    DioClient().setAuthToken(accessToken);
    print(" Token restored on app startup: $accessToken");
  }

  //  Check login state
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: appProviders,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Cardio Tech',
        theme: appTheme(),
        // Automatically route user based on login state
        initialRoute: isLoggedIn ? AppRoutes.navbar : AppRoutes.login,
        onGenerateRoute: AppRoutes.onGenerateRoute,
        onUnknownRoute: (settings) =>
            MaterialPageRoute(builder: (_) => const LoginScreen()),
      ),
    );
  }
}
