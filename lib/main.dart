import 'package:cardio_tech/src/routes/navigation_service.dart';
import 'package:cardio_tech/src/utils/storage_helper.dart';
import 'package:cardio_tech/src/core/network/dio_client.dart';
import 'package:cardio_tech/src/features/cardiologistScreens/home/widgets/CardiologistNavbar.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/navbar.dart';
import 'package:cardio_tech/src/provider/main_providers/providers_setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'src/features/auth/screens/loginScreens/login_screen.dart';
import 'src/features/generalPhysicianScreens/home/widgets/theme.dart';
import 'src/routes/AllRoutes.dart';
import 'package:flutter/foundation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ---- ONLY ON MOBILE ----
  if (!kIsWeb) {
    // Portrait mode (not supported on web)
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Flutter downloader (NOT supported on web)  false
    await FlutterDownloader.initialize(debug: false, ignoreSsl: true);

    // Notification permission (NOT supported on web)
    final notificationStatus = await Permission.notification.request();
    if (notificationStatus.isGranted) {
      print(" Notification permission granted");
    } else {
      print(" Notification permission denied");
    }
  }

  // ---- COMMON CODE (WEB + MOBILE) ----
  final accessToken = await StorageHelper.getAccessToken();
  final isLoggedIn = await StorageHelper.isLoggedIn();
  final staffType = await StorageHelper.getStaffType();

  if (accessToken != null && accessToken.isNotEmpty) {
    DioClient().setAuthToken(accessToken);
    print(" Token restored: $accessToken");
  }

  runApp(MyApp(isLoggedIn: isLoggedIn, staffType: staffType));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String? staffType;

  const MyApp({super.key, required this.isLoggedIn, required this.staffType});

  @override
  Widget build(BuildContext context) {
    Widget initialScreen;

    if (isLoggedIn) {
      if (staffType == "Cardiologist") {
        initialScreen = const Cardiologistnavbar();
      } else if (staffType == "General Physician") {
        initialScreen = const Navbar();
      } else {
        initialScreen = const LoginScreen();
      }
    } else {
      initialScreen = const LoginScreen();
    }

    return MultiProvider(
      providers: appProviders,
      child: MaterialApp(
        navigatorKey: appNavigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Cardio Tech',
        theme: appTheme(),
        home: initialScreen,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}
