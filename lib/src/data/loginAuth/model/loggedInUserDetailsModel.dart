import 'package:intl/intl.dart';

class Loggedinuserdetailsmodel {
  final String email;
  final String mobile;
  final String? profilePic;
  final String clinicName;
  final String name;
  final String clinicAddress;
  final String username;
  final int clinicDetailsId;

  Loggedinuserdetailsmodel({
    required this.email,
    required this.mobile,
    this.profilePic,
    required this.clinicName,
    required this.name,
    required this.clinicAddress,
    required this.username,
    required this.clinicDetailsId,
  });

  // ✅ Optional: factory constructor for creating model from JSON
  factory Loggedinuserdetailsmodel.fromJson(Map<String, dynamic> json) {
    return Loggedinuserdetailsmodel(
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      profilePic: json['profilePic'],
      clinicName: json['clinicName'] ?? '',
      name: json['name'] ?? '',
      clinicAddress: json['clinicAddress'] ?? '',
      username: json['username'] ?? '',
      clinicDetailsId: json['clinicDetailsId'] ?? 0,
    );
  }

  // ✅ Optional: method to convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'mobile': mobile,
      'profilePic': profilePic,
      'clinicName': clinicName,
      'name': name,
      'clinicAddress': clinicAddress,
      'username': username,
      'clinicDetailsId': clinicDetailsId,
    };
  }
}
