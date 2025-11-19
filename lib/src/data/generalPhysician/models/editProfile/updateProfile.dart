class UploadProfileResponse {
  final int statusCode;
  final String status;
  final String message;
  final String? imageUrl;

  UploadProfileResponse({
    required this.statusCode,
    required this.status,
    required this.message,
    this.imageUrl,
  });

  factory UploadProfileResponse.fromJson(Map<String, dynamic> json) {
    return UploadProfileResponse(
      statusCode: json['statusCode'],
      status: json['status'],
      message: json['message'],
      imageUrl: json['data'],
    );
  }
}
