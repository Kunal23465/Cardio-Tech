class ChangePasswordModel {
  final int? statusCode;
  final String? status;
  final String? message;

  ChangePasswordModel({this.message, this.status, this.statusCode});

  factory ChangePasswordModel.fromJson(Map<String, dynamic> json) {
    return ChangePasswordModel(
      statusCode: json["statusCode"],
      status: json["status"],
      message: json["message"],
    );
  }
}
