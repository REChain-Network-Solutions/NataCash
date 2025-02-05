import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:six_cash/data/api/api_checker.dart';
import 'package:six_cash/features/auth/controllers/auth_controller.dart';
import 'package:six_cash/features/forget_pin/domain/reposotories/forget_pin_repo.dart';
import 'package:six_cash/helper/custom_snackbar_helper.dart';
import 'package:get/get.dart';
import 'package:six_cash/helper/route_helper.dart';

class ForgetPinController extends GetxController implements GetxService{
  final ForgetPinRepo forgetPinRepo;
  ForgetPinController({required this.forgetPinRepo});

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void resetPin(String newPin, String confirmPin, String? phoneNumber, String? otp){
    if(newPin.isEmpty || confirmPin.isEmpty){
      showCustomSnackBarHelper('please_enter_your_valid_pin'.tr, isError: true);
    }
    else if(newPin.length < 4){
      showCustomSnackBarHelper('pin_should_be_4_digit'.tr, isError: true);
    }
    else if(newPin == confirmPin){
      String? number = phoneNumber;
      _resetPinApi(number, otp, newPin, confirmPin);
    }
    else{
      showCustomSnackBarHelper('pin_not_matched'.tr, isError: true);
    }
  }


  void sendOtp({required String phoneNumber}) async {
    if (phoneNumber.isEmpty) {
      showCustomSnackBarHelper('please_give_your_phone_number'.tr, isError: true);
    } else{
      Get.find<AuthController>().otpForForgetPass(phoneNumber);

    }
  }


  Future<Response> _resetPinApi(String? phone, String? otp, String newPass, String confirmPass) async{
    final AuthController authController = Get.find<AuthController>();

    _isLoading = true;
    update();
    Response response = await forgetPinRepo.forgetPassReset(phoneNumber: phone,otp: otp,password: newPass,confirmPass: confirmPass);
    if(response.statusCode == 200){
      _isLoading = false;
      PhoneNumber phoneNumber = PhoneNumber.parse(phone ?? '');
      bool isValid = phoneNumber.isValid(type: PhoneNumberType.mobile);
      String countryCode = phoneNumber.countryCode;
      String nationalNumber = phoneNumber.international.replaceAll(countryCode, '');

      if(isValid) {
        await authController.updatePin(newPass);
        Get.offAllNamed(RouteHelper.getLoginRoute(countryCode: countryCode,phoneNumber: nationalNumber));
      }else {
        showCustomSnackBarHelper('something_error_in_your_phone_number'.tr, isError: false);

      }
    }
    else{
      _isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

}