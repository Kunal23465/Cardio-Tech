import 'package:cardio_tech/src/core/config/api_constants.dart';
import 'package:cardio_tech/src/core/network/api_client.dart';
import 'package:cardio_tech/src/data/loginAuth/model/loggedInUserDetailsModel.dart';

class LoggedInUserDetailsService {
  final ApiClient _apiClient = ApiClient();

  /// ✅ Fetch logged-in user details using userId in path params
  Future<Loggedinuserdetailsmodel?> getLoggedInUserDetails({
    required int userId,
  }) async {
    try {
      final String url = "${ApiConstants.loggedInUserDetails}/$userId";

      final response = await _apiClient.get(url);

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> dataList = response.data['data'];
        if (dataList.isNotEmpty) {
          final Map<String, dynamic> data = dataList.first;
          return Loggedinuserdetailsmodel.fromJson(data);
        } else {
          return null; // no user data found
        }
      } else {
        throw Exception('Failed to fetch logged-in user details');
      }
    } catch (e) {
      print("❌ Error fetching logged-in user details: $e");
      rethrow;
    }
  }
}
