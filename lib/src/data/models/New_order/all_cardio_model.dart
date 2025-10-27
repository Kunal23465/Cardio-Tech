class Cardiologist {
  final int id;
  final String fullName;

  Cardiologist({required this.id, required this.fullName});

  factory Cardiologist.fromJson(Map<String, dynamic> json) {
    return Cardiologist(
      id: json['pointsOfContactDetailsId'],
      fullName: json['fullName'] ?? '',
    );
  }
}
