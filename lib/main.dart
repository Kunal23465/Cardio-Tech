import 'package:cardio_tech/src/core/config/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:cardio_tech/src/utils/storage_helper.dart';
import 'package:cardio_tech/src/core/network/dio_client.dart';
import 'package:cardio_tech/src/provider/main_providers/providers_setup.dart';
import 'package:cardio_tech/src/routes/navigation_service.dart';

import 'src/features/auth/screens/loginScreens/login_screen.dart';
import 'src/features/generalPhysicianScreens/home/widgets/navbar.dart';
import 'src/features/cardiologistScreens/home/widgets/CardiologistNavbar.dart';
import 'src/features/generalPhysicianScreens/home/widgets/theme.dart';
import 'src/routes/AllRoutes.dart';
import 'package:flutter/foundation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ---- System setup --------
  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
    await Permission.notification.request();
  }

  // ----- Load saved login state ------
  final accessToken = await StorageHelper.getAccessToken();
  final refreshToken = await StorageHelper.getRefreshToken();
  final isLoggedIn = await StorageHelper.isLoggedIn();
  final staffType = await StorageHelper.getStaffType();

  // ----- Check token validity ---------
  if (accessToken != null && accessToken.isNotEmpty) {
    bool valid = !JwtDecoder.isExpired(accessToken);

    if (valid) {
      // Access token still valid
      DioClient().setAuthToken(accessToken);
    } else {
      // Try refresh token manually at startup
      if (refreshToken != null && refreshToken.isNotEmpty) {
        print("Startup: Access token expired → refreshing...");

        final dio = DioClient().dio;

        try {
          final response = await dio.post(
            ApiConstants.refreshToken,
            data: {"refreshToken": refreshToken},
            options: Options(headers: {"Authorization": null}),
          );

          if (response.statusCode == 200 &&
              response.data["status"] == "SUCCESS") {
            final newToken = response.data["data"]["accessToken"];
            final newRefresh = response.data["data"]["refreshToken"];

            await StorageHelper.saveLoginData(
              userId: await StorageHelper.getUserId() ?? 0,
              pocId: await StorageHelper.getPocId() ?? 0,
              accessToken: newToken,
              refreshToken: newRefresh,
              staffType: staffType ?? "",
            );

            DioClient().setAuthToken(newToken);
            print("Startup refresh success!");
          } else {
            await StorageHelper.clearData();
          }
        } catch (e) {
          await StorageHelper.clearData();
        }
      } else {
        await StorageHelper.clearData();
      }
    }
  }

  runApp(MyApp(isLoggedIn: isLoggedIn, staffType: staffType));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String? staffType;

  const MyApp({super.key, required this.isLoggedIn, required this.staffType});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: appProviders,
      child: MaterialApp(
        navigatorKey: appNavigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Cardio Tech',
        theme: appTheme(),
        home: _getHomeScreen(),
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }

  Widget _getHomeScreen() {
    if (!isLoggedIn) return const LoginScreen();

    if (staffType == "Cardiologist") return const Cardiologistnavbar();
    if (staffType == "General Physician") return const Navbar();

    return const LoginScreen();
  }
}
