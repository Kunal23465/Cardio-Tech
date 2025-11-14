class Loggedinuserdetailsmodel {
  final String email;
  final String mobile;
  final String? profilePic;
  final String clinicName;
  final String name;
  final String userAddress;
  final String username;
  final int clinicDetailsId;
  final int totalOrders;
  final String cardioValue;

  Loggedinuserdetailsmodel({
    required this.email,
    required this.mobile,
    this.profilePic,
    required this.clinicName,
    required this.name,
    required this.userAddress,
    required this.username,
    required this.clinicDetailsId,
    required this.totalOrders,
    required this.cardioValue,
  });

  //  Optional: factory constructor for creating model from JSON
  factory Loggedinuserdetailsmodel.fromJson(Map<String, dynamic> json) {
    return Loggedinuserdetailsmodel(
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      profilePic: json['profilePic'],
      clinicName: json['clinicName'] ?? '',
      name: json['name'] ?? '',
      userAddress: json['userAddress'] ?? '',
      username: json['username'] ?? '',
      clinicDetailsId: json['clinicDetailsId'] ?? 0,
      totalOrders: json['totalOrders'] ?? '',
      cardioValue: json['cardioValue'] ?? '',
    );
  }

  //  Optional: method to convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'mobile': mobile,
      'profilePic': profilePic,
      'clinicName': clinicName,
      'name': name,
      'userAddress': userAddress,
      'username': username,
      'clinicDetailsId': clinicDetailsId,
      'totalOrders': totalOrders,
      'cardioValue': cardioValue,
    };
  }
}
