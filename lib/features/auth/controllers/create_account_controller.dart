import 'package:country_code_picker/country_code_picker.dart';
import 'package:six_cash/features/auth/controllers/auth_controller.dart';
import 'package:six_cash/features/splash/controllers/splash_controller.dart';
import 'package:six_cash/helper/custom_snackbar_helper.dart';
import 'package:get/get.dart';

class CreateAccountController extends GetxController implements GetxService{
  String _countryCode = CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).dialCode!;
  String? _phoneNumber;
  String get countryCode => _countryCode;
  String? get phoneNumber => _phoneNumber;

  setCountryCode(String dialCode) {
    _countryCode = dialCode;
    update();
  }

  setPhoneNumber(String phone) {
    _phoneNumber = phone;
    update();
  }
  setInitCountryCode(String code) {
    _countryCode = code;
  }
  sendOtpResponse({required String number}){
    String number0 = number;
    if (number0.isEmpty) {
      showCustomSnackBarHelper('please_give_your_phone_number'.tr, isError: true);
    }
    else if(number0.contains(RegExp(r'[A-Z]'))){
      showCustomSnackBarHelper('phone_number_not_contain_characters'.tr, isError: true);
    }
    else if(number0.contains(RegExp(r'[a-z]'))){
      showCustomSnackBarHelper('phone_number_not_contain_characters'.tr, isError: true);
    }
    else if(number0.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))){
      showCustomSnackBarHelper('phone_number_not_contain_spatial_characters'.tr, isError: true);
    }
    else{
      setPhoneNumber(number);
      Get.find<AuthController>().checkPhone(number);
    }
  }
}