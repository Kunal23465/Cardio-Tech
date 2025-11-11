import 'package:cardio_tech/src/core/config/api_constants.dart';
import 'package:cardio_tech/src/core/network/api_client.dart';
import 'package:cardio_tech/src/data/cardioLogists/model/assignClinicModel.dart';
import 'package:dio/dio.dart';

class AssignClinicService {
  final ApiClient _apiClient = ApiClient();

  Future<List<AssignClinicModel>> fetchAllAssignClinics() async {
    try {
      final Response response = await _apiClient.get(
        ApiConstants.forAssignAllClinic,
      );

      if (response.statusCode == 200 &&
          response.data != null &&
          response.data['statusCode'] == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((e) => AssignClinicModel.fromJson(e)).toList();
      } else {
        throw Exception("Invalid response structure: ${response.data}");
      }
    } catch (e) {
      throw Exception("Error fetching clinics: $e");
    }
  }
}
