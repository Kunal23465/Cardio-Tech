import 'package:cardio_tech/src/core/config/api_constants.dart';
import 'package:cardio_tech/src/core/network/api_client.dart';
import 'package:cardio_tech/src/data/generalPhysician/models/commons/allStatusModel.dart';
import 'package:dio/dio.dart';

class AllStatusService {
  final ApiClient _apiClient = ApiClient();

  Future<List<GetAllGPStatusModel>> getAllStatus() async {
    try {
      final Response response = await _apiClient.get(
        "${ApiConstants.getAllStatus}/ORDERSTATUSGP",
      );

      if (response.statusCode == 200 &&
          response.data != null &&
          response.data['statusCode'] == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((e) => GetAllGPStatusModel.fromJson(e)).toList();
      } else {
        throw Exception("Invalid response structure: ${response.data}");
      }
    } catch (e) {
      throw Exception("Error fetching statuses: $e");
    }
  }
}
