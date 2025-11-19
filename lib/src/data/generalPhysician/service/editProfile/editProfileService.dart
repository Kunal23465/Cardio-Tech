import 'package:cardio_tech/src/core/config/api_constants.dart';
import 'package:cardio_tech/src/core/network/api_client.dart';
import 'package:cardio_tech/src/data/generalPhysician/models/editProfile/editProfileModel.dart';

class EditProfileService {
  final ApiClient _apiClient = ApiClient();

  Future<int> updateProfile(EditProfileModel model) async {
    final response = await _apiClient.put(
      ApiConstants.editProfile,
      model.toJson(),
    );

    if (response.statusCode == 200 && response.data["status"] == "SUCCESS") {
      return response.data["data"]["userDetailsId"];
    } else {
      throw Exception(response.data["message"] ?? "Something went wrong");
    }
  }
}
