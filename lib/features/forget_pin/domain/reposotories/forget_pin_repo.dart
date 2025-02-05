import 'package:get/get_connect/http/src/response/response.dart';
import 'package:six_cash/data/api/api_client.dart';
import 'package:six_cash/util/app_constants.dart';

class ForgetPinRepo {
  final ApiClient apiClient;
  ForgetPinRepo({required this.apiClient});

  Future<Response> forgetPassReset({String? phoneNumber, String? otp, String? password, String? confirmPass}) async {
    return apiClient.putData(AppConstants.customerForgetPassReset, {
      "phone": phoneNumber, "otp": otp,
      "password": password,
      "confirm_password": confirmPass,
    });
  }




}