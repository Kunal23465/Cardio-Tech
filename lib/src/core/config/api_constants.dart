class ApiConstants {
  static const String baseUrl = "https://scardiopre.srdt.co.in";
  // static const String baseUrl = "http://10.8.20.71:9025";

  // Auth Endpoints
  static const String login = "$baseUrl/auth/login";
  static const String logout = "$baseUrl/auth/logout";
  static const String forgotPassword = "$baseUrl/auth/forgot-password";
  static const String verifyOtp = "$baseUrl/auth/verify-otp";
  static const String resetPassword = "$baseUrl/auth/reset-password";

  static const String saveOrUpdateOrder = "$baseUrl/cardio/orders/saveOrUpdate";
  static const String uploadOrderAttachments =
      "$baseUrl/cardio/orders/uploadAttachments";
  static const String getAllGender =
      "$baseUrl/commonLookupValue/getByLookupTypeCode/GENDER";
  static const String getAllOrderPriority = "$baseUrl/orderPriorities/getAll";
  static const String getAllCardiologists =
      "$baseUrl/cardio/cardiologists/getAll";
  static const String filterOrders = "$baseUrl/cardio/orders/filter";
  static const String getAllStatus = "$baseUrl/cardio/orders/all-statuses";
  static const String getOrderById = "$baseUrl/cardio/orders/getByOrderId";

  //Cardiologist Api
  static const String getAllSearchOrder =
      "$baseUrl/cardio/cardiologists/orderAssignedToCardioByGp";
  static const String changeStatus = "$baseUrl/cardio/orders/in-review";
  static const String getCardioAllStatus =
      "$baseUrl/cardio/cardiologists/allCardioScreenStatus";

  static const String submitReport = "$baseUrl/approval/cardioSubmitReport";
  static const String downloadEkgReport =
      "$baseUrl/cardio/orders/downloadAttachment";

  static const String submitOrderDetails = "$baseUrl/cardio/orders/closeOrder";
  static const String loggedInUserDetails =
      "$baseUrl/home/getLoggedUserDetails";
}
