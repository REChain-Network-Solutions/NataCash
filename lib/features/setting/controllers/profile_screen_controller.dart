import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_cash/features/auth/controllers/auth_controller.dart';
import 'package:six_cash/features/onboarding/controllers/on_boarding_controller.dart';
import 'package:six_cash/features/splash/controllers/splash_controller.dart';
import 'package:six_cash/features/setting/controllers/theme_controller.dart';
import 'package:six_cash/data/api/api_checker.dart';
import 'package:six_cash/features/auth/domain/models/user_short_data_model.dart';
import 'package:six_cash/features/setting/domain/models/profile_model.dart';
import 'package:six_cash/features/setting/domain/reposotories/profile_repo.dart';
import 'package:six_cash/helper/dialog_helper.dart';
import 'package:six_cash/helper/route_helper.dart';
import 'package:six_cash/common/widgets/custom_country_code_widget.dart';
import 'package:six_cash/helper/custom_snackbar_helper.dart';
import 'package:six_cash/common/widgets/custom_dialog_widget.dart';

import '../../transaction_money/controllers/bootom_slider_controller.dart';

class ProfileController extends GetxController implements GetxService {
  final ProfileRepo profileRepo;
  ProfileController({required this.profileRepo});
  final BottomSliderController bottomSliderController =
      Get.find<BottomSliderController>();
  ProfileModel? _userInfo;
  bool _isLoading = false;

  ProfileModel? get userInfo => _userInfo;
  bool get isLoading => _isLoading;
  String _gender = 'Male';
  String get gender => _gender;
  // String _occupation = occupationData[1]['title'];
  // String get occupation => _occupation;
  int select = 0;

  set setUserInfo(ProfileModel value) {
    _userInfo = value;
  }


  Future<void> getProfileData({bool reload = false, bool isUpdate = false}) async {
    if(reload || _userInfo == null) {
      _userInfo = null;
      _isLoading = true;
      if(isUpdate) {
        update();
      }
    }

    if(_userInfo == null) {
      Response response = await profileRepo.getProfileDataApi();
      if (response.statusCode == 200) {
        _userInfo = ProfileModel.fromJson(response.body);

        Get.find<AuthController>().setUserData(UserShortDataModel(
          name: '${_userInfo!.fName} ${_userInfo!.lName}',
          phone: userInfo?.phone?.replaceAll('${CustomCountryCodeWidget.getCountryCode(userInfo?.phone)}', ''),
          countryCode: CustomCountryCodeWidget.getCountryCode(userInfo?.phone),
          qrCode: _userInfo?.qrCode,
        ));

      } else {
        ApiChecker.checkApi(response);
      }
      _isLoading = false;
      update();
    }

  }

  Future<void> changePin({required String oldPassword, required String newPassword, required String confirmPassword}) async {
    if ((oldPassword.length < 4) ||
        (newPassword.length < 4) ||
        (confirmPassword.length < 4)) {
      showCustomSnackBarHelper('please_input_4_digit_pin'.tr);
    } else if (newPassword != confirmPassword) {
      showCustomSnackBarHelper('pin_not_matched'.tr);
    } else {
      _isLoading = true;
      update();
      Response response = await profileRepo.changePinApi(
        oldPin: oldPassword, newPin: newPassword, confirmPin: confirmPassword,
      );

      if (response.statusCode == 200) {
        await Get.find<AuthController>().updatePin(newPassword);
        UserShortDataModel? userData = Get.find<AuthController>().getUserData();

        Get.offAllNamed(RouteHelper.getLoginRoute(
          countryCode: userData?.countryCode, phoneNumber: userData?.phone,
        ));

      } else {
        ApiChecker.checkApi(response);
      }
      _isLoading = false;
      update();
    }
  }

  Future<Response> pinVerify({required String? getPin, bool isUpdateTwoFactor = true}) async {
    bottomSliderController.setIsLoading = true;
    final Response response = await profileRepo.pinVerifyApi(pin: getPin);

    if (response.statusCode == 200) {
      bottomSliderController.isPinVerified = true;
      bottomSliderController.setIsLoading = false;
      if(isUpdateTwoFactor) {
        updateTwoFactor();
      }
      bottomSliderController.resetPinField();
    } else {
      bottomSliderController.isPinVerified = false;
      bottomSliderController.setIsLoading = false;
      bottomSliderController.resetPinField();
      Get.back();
      showCustomSnackBarHelper('message');
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

  Future<void> updateTwoFactor() async {
    _isLoading = true;
    update();
    Response response = await profileRepo.updateTwoFactorApi();
    await getProfileData(reload: true);
    if (response.statusCode == 200) {
      showCustomSnackBarHelper(response.body['message'], isError: false);
      _isLoading = false;
    } else {
      ApiChecker.checkApi(response);
      _isLoading = false;
    }
    update();
  }



  void routeToTwoFactorAuthScreen(String getPin) {
    pinVerify(getPin: getPin);
  }

  Future twoFactorOnTap() async {
    await pinVerify(getPin: bottomSliderController.pin);
  }

  void twoFactorOnChange() async {
    await updateTwoFactor();
    await getProfileData(reload: true);
  }

  ///Change theme..
  bool _isSwitched = Get.find<ThemeController>().darkTheme;
  var textValue = 'Switch is OFF';

  bool get isSwitched => _isSwitched;

  void onChangeTheme() {
    if (_isSwitched == false) {
      _isSwitched = true;
      textValue = 'Switch Button is ON';
      Get.find<ThemeController>().toggleTheme();
      update();

    } else {
      _isSwitched = false;
      textValue = 'Switch Button is OFF';
      Get.find<ThemeController>().toggleTheme();
      update();
    }
  }

  void logOut(BuildContext context) {
    DialogHelper.showAnimatedDialog(context,
        CustomDialogWidget(
          icon: Icons.logout,
          title: 'logout'.tr,
          description: 'are_you_sure_you_want_to_logout'.tr,
          onTapFalseText: 'clear_logout'.tr,
          onTapTrueText: 'logout'.tr,
          isFailed: true,
          onTapFalse: (){
            Get.find<AuthController>().removeBiometricPin().then((value) {
              Get.find<OnBoardingController>().updatePageIndex(0);
              Get.find<AuthController>().logout();
              Get.find<SplashController>().removeSharedData();
              Navigator.pop(context);
            });

          },
          onTapTrue: (){
            Get.find<AuthController>().logout();
            Navigator.of(context).pop(true);
          },
        ),
        dismissible: false,
        isFlip: true);
  }

  setGender(String select){
    _gender = select;
    update();
  }
  // setSelect(int index, String occupation){
  //   select = index;
  //   _occupation = occupation;
  //   update();
  // }
}
