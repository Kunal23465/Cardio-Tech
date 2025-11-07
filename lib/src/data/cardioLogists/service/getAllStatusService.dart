import 'package:cardio_tech/src/core/config/api_constants.dart';
import 'package:cardio_tech/src/core/network/api_client.dart';
import 'package:cardio_tech/src/data/cardioLogists/model/getAllStatusModel.dart';
import 'package:dio/dio.dart';

class GetAllCardioStatusService {
  final ApiClient _apiClient = ApiClient();

  Future<List<GetAllCardioStatusModel>> getAllCardioStatus() async {
    try {
      final Response response = await _apiClient.get(
        ApiConstants.getCardioAllStatus,
      );

      if (response.statusCode == 200 &&
          response.data != null &&
          response.data['statusCode'] == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((e) => GetAllCardioStatusModel.fromJson(e)).toList();
      } else {
        throw Exception("Invalid response structure: ${response.data}");
      }
    } catch (e) {
      throw Exception("Error fetching statuses: $e");
    }
  }
}
