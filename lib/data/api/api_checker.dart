import 'dart:io';
import 'package:get/get.dart';
import 'package:six_cash/common/models/error_model.dart';
import 'package:six_cash/features/auth/controllers/auth_controller.dart';
import 'package:six_cash/features/auth/domain/models/user_short_data_model.dart';
import 'package:six_cash/helper/route_helper.dart';
import 'package:six_cash/helper/custom_snackbar_helper.dart';

class ApiChecker {
  static void checkApi(Response response) {
    UserShortDataModel? userData =  Get.find<AuthController>().getUserData();


    if((response.statusCode == 401 || response.statusCode == 429) && !(Get.currentRoute.contains(RouteHelper.loginScreen))) {
      Get.find<AuthController>().removeCustomerToken();
      Get.offAllNamed(RouteHelper.getLoginRoute(
        countryCode: userData?.countryCode,
        phoneNumber: userData?.phone,
      ));

      showCustomSnackBarHelper(response.body != null
          ? response.body['message'] ?? ErrorResponseModel.fromJson(response.body).errors?.first.message ?? ''
          : response.statusText, isError: true,
      );

    }else if(response.statusCode == -1){
      Get.find<AuthController>().removeCustomerToken();
      Get.offAllNamed(RouteHelper.getLoginRoute(
        countryCode: userData?.countryCode,
        phoneNumber: userData?.phone,
      ));
      showCustomSnackBarHelper('you are using vpn', isVpn: true, duration: const Duration(minutes: 10));

    }
    else {
      showCustomSnackBarHelper(response.body != null
          ? response.body['message'] ?? ErrorResponseModel.fromJson(response.body).errors?.first.message ?? ''
          : response.statusText, isError: true);
    }
  }

  static Future<bool> isVpnActive() async {
    bool isVpnActive;
    List<NetworkInterface> interfaces = await NetworkInterface.list(
        includeLoopback: false, type: InternetAddressType.any);
    interfaces.isNotEmpty
        ? isVpnActive = interfaces.any((interface) =>
    interface.name.contains("tun") ||
        interface.name.contains("ppp") ||
        interface.name.contains("pptp"))
        : isVpnActive = false;

    return isVpnActive;
  }
}
