class Loggedinuserdetailsmodel {
  final String email;
  final String mobile;
  final String? profilePic;
  final String clinicName;
  final String name;
  final String userAddress;
  final String username;
  final String CardioName;
  final int clinicDetailsId;
  final int totalOrders;
  final String cardioValue;
  final String? licenseNo;
  final String? totalExperience;
  final String? about;

  Loggedinuserdetailsmodel({
    required this.email,
    required this.mobile,
    this.profilePic,
    required this.clinicName,
    required this.name,
    required this.userAddress,
    required this.username,
    required this.CardioName,
    required this.clinicDetailsId,
    required this.totalOrders,
    required this.cardioValue,
    this.licenseNo,
    this.totalExperience,
    this.about,
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
      CardioName: json['CardioName'] ?? '',
      clinicDetailsId: json['clinicDetailsId'] ?? 0,
      totalOrders: json['totalOrders'] ?? '',
      cardioValue: json['cardioValue'] ?? '',
      licenseNo: json['licenseNo'] ?? '',
      totalExperience: json['totalExperience'] ?? '',
      about: json['about'] ?? '',
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
      'licenseNo': licenseNo,
      'about': about,
      'username': username,
    };
  }
}
