import 'package:cardio_tech/src/features/cardiologistScreens/home/otherScreens/allOrderOrderDetails.dart';
import 'package:cardio_tech/src/features/cardiologistScreens/home/otherScreens/cardioFinalizedOrdeDetailsCard.dart';
import 'package:cardio_tech/src/features/cardiologistScreens/home/otherScreens/cardiologistOrderDetails.dart';
import 'package:cardio_tech/src/features/cardiologistScreens/home/otherScreens/reportOrder.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/navbar/allPatient.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/navbar/setting.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/settingScreens/clinicDetails.dart';
import 'package:flutter/material.dart';
import '../features/auth/screens/loginScreens/forgot_password_screen.dart';
import '../features/auth/screens/loginScreens/login_screen.dart';
import '../features/auth/screens/loginScreens/otp_verification_screen.dart';
import '../features/auth/screens/loginScreens/setNewPasswordScreen.dart';
import '../features/generalPhysicianScreens/home/widgets/navbar.dart';
import '../features/generalPhysicianScreens/home/navbar/newOrder.dart';
import '../features/generalPhysicianScreens/home/navbar/orderDetails.dart';
import '../features/generalPhysicianScreens/home/settingScreens/aboutUs.dart';
import '../features/generalPhysicianScreens/home/settingScreens/changePassword.dart';
import '../features/generalPhysicianScreens/home/settingScreens/editProfile.dart';
import '../features/generalPhysicianScreens/home/settingScreens/helpCenter.dart';
import '../features/generalPhysicianScreens/home/settingScreens/privacyPolicy.dart';
import '../features/generalPhysicianScreens/home/settingScreens/term&Conditions.dart';
import '../features/generalPhysicianScreens/home/settingScreens/viewProfile.dart';
import '../features/generalPhysicianScreens/home/notifications/notification.dart';

class AppRoutes {
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String otpVerification = '/otp-verification';
  static const String setNewPassword = '/set-new-password';
  static const String changePassword = '/change-password';
  static const String viewProfile = '/view-profile';
  static const String editProfile = '/edit-profile';
  static const String aboutUs = '/about-us';
  static const String privacyPolicy = '/privacy-policy';
  static const String termConditions = '/terms-conditions';
  static const String helpCenter = '/help-center';
  static const String navbar = '/navbar';
  static const String notification = '/notification';
  static const String newOrder = '/new-order';
  static const String orderDetails = '/order-details';
  static const String allPatients = '/all-details';
  static const String genNavbar = '/gen-navbar';
  static const String genSetting = '/gen-setting';
  static const String clinicDetails = '/clinic-Details';

  // for cardiologist
  static const String reportOrder = '/report-order';
  static const String cardioOrderDetails = '/cardioOrder-details';
  static const String cardioFinalizedOrderDetails =
      '/cardioFinalizedOrder-details';
  static const String allOrderOrderDetails = '/AllOrderOrder-details';

  // ======= static routes map =======
  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    forgotPassword: (context) => const ForgotPasswordScreen(),
    otpVerification: (context) => const OtpVerificationScreen(
      emailOrMobile: '',
    ), // default empty, will override with arguments
    setNewPassword: (context) => const SetNewPasswordScreen(
      emailOrMobile: '',
    ), // default empty, will override with arguments
    navbar: (context) => const Navbar(),
    newOrder: (context) => const NewOrder(),
    orderDetails: (context) => const Orderdetails(),
    changePassword: (context) => const Changepassword(),
    viewProfile: (context) => const ViewProfile(),
    editProfile: (context) => const Editprofile(),
    aboutUs: (context) => const Aboutus(),
    privacyPolicy: (context) => const Privacypolicy(),
    termConditions: (context) => const TermConditions(),
    helpCenter: (context) => const HelpCenter(),
    notification: (context) => const NotificationScreeen(),
    allPatients: (context) => const AllPatient(),
    genNavbar: (context) => const Navbar(),
    genSetting: (context) => const Setting(),
    clinicDetails: (context) => const ClinicDetails(),

    //for cardiologist
    reportOrder: (context) => ReportOrder(),
    cardioOrderDetails: (context) => CardiologistOrderDetails(),
    cardioFinalizedOrderDetails: (context) =>
        CardiologistFinalizedOrderDetails(),
    allOrderOrderDetails: (context) => AllOrderOrderDetails(),
  };

  // ======= helper for named routes with arguments =======
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case otpVerification:
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => OtpVerificationScreen(emailOrMobile: args),
            settings: settings,
          );
        }
        return null;

      case setNewPassword:
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => SetNewPasswordScreen(emailOrMobile: args),
            settings: settings,
          );
        }
        return null;

      default:
        final builder = routes[settings.name];
        if (builder != null) {
          return MaterialPageRoute(builder: builder, settings: settings);
        }
        return null;
    }
  }
}
