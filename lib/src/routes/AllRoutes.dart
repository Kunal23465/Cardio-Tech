import 'package:flutter/material.dart';
import 'package:cardio_tech/src/features/auth/screens/loginScreens/forgot_password_screen.dart';
import 'package:cardio_tech/src/features/auth/screens/loginScreens/login_screen.dart';
import 'package:cardio_tech/src/features/auth/screens/loginScreens/otp_verification_screen.dart';
import 'package:cardio_tech/src/features/auth/screens/loginScreens/setNewPasswordScreen.dart';
import 'package:cardio_tech/src/features/home/widgets/navbar.dart';
import 'package:cardio_tech/src/features/home/navbar/newOrder.dart';
import 'package:cardio_tech/src/features/home/navbar/orderDetails.dart';
import 'package:cardio_tech/src/features/home/settingScreens/aboutUs.dart';
import 'package:cardio_tech/src/features/home/settingScreens/changePassword.dart';
import 'package:cardio_tech/src/features/home/settingScreens/editProfile.dart';
import 'package:cardio_tech/src/features/home/settingScreens/helpCenter.dart';
import 'package:cardio_tech/src/features/home/settingScreens/privacyPolicy.dart';
import 'package:cardio_tech/src/features/home/settingScreens/term&Conditions.dart';
import 'package:cardio_tech/src/features/home/settingScreens/viewProfile.dart';
import 'package:cardio_tech/src/features/home/notifications/notification.dart';

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

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    forgotPassword: (context) => const ForgotPasswordScreen(),
    otpVerification: (context) => const OtpVerificationScreen(),
    setNewPassword: (context) => const SetNewPasswordScreen(),
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
  };
}
