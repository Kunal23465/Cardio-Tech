class ApiConstants {
  static const String baseUrl = "http://10.8.20.71:9025";

  // Auth Endpoints
  static const String login = "$baseUrl/auth/login";
  static const String logout = "$baseUrl/auth/logout";
  static const String forgotPassword = "$baseUrl/auth/forgot-password";
  static const String verifyOtp = "$baseUrl/auth/verify-otp";
  static const String resetPassword = "$baseUrl/auth/reset-password";

  // Other Endpoints
  static const String saveOrUpdateOrder = "$baseUrl/cardio/orders/saveOrUpdate";
  static const String getAllCardiologists = "$baseUrl/cardio/cardiologists/getAll";
  static const String getAllOrderPriority = "$baseUrl/orderPriorities/getAll";


}
