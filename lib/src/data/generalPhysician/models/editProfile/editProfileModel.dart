class EditProfileModel {
  int? userDetailsId;
  String? firstName;
  String? lastName;
  String? pocPhone;
  String? pocEmail;
  String? address;
  String? licenseNo;
  String? about;
  int? experienceLookupId;

  EditProfileModel({
    this.userDetailsId,
    this.firstName,
    this.lastName,
    this.pocPhone,
    this.pocEmail,
    this.address,
    this.licenseNo,
    this.about,
    this.experienceLookupId,
  });

  Map<String, dynamic> toJson() {
    return {
      "userDetailsId": userDetailsId,
      "firstName": firstName,
      "lastName": lastName,
      "pocPhone": pocPhone,
      "pocEmail": pocEmail,
      "address": address,
      "licenseNo": licenseNo,
      "about": about,
      "experienceLookupId": experienceLookupId,
    };
  }

  factory EditProfileModel.fromJson(Map<String, dynamic> json) {
    return EditProfileModel(
      userDetailsId: json["userDetailsId"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      pocPhone: json["pocPhone"],
      pocEmail: json["pocEmail"],
      address: json["address"],
      licenseNo: json["licenseNo"],
      about: json["about"],
      experienceLookupId: json["experienceLookupId"],
    );
  }
}
