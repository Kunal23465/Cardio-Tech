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
  final String? firstName;
  final String? lastName;
  final int? experienceId;

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
    this.firstName,
    this.lastName,
    this.experienceId,
  });

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
      totalOrders: json['totalOrders'] ?? 0,
      cardioValue: json['cardioValue'] ?? '',
      licenseNo: json['licenseNo'],
      totalExperience: json['totalExperience'],
      about: json['about'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      experienceId: json['experienceId'],
    );
  }
}
