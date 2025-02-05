import 'package:get/get.dart';
import 'package:six_cash/helper/route_helper.dart';

class BottomSliderController extends GetxController implements GetxService {
  bool _isPinCompleted = false;
  bool _isAlignmentRightIndicator = false;
  bool _isStopAnimation = false;
  bool _isLoading = false;
  bool isPinVerified = false;
  String? _pin;

  bool get isPinCompleted => _isPinCompleted;
  bool get isAlignmentRightIndicator => _isAlignmentRightIndicator;
  bool get isLoading => _isLoading;

  String? get pin => _pin;

  set setIsLoading(bool value){
    _isLoading =  value;
    update();
  }


  void setIsPinCompleted({required bool isCompleted, required bool isNotify}){
    _isPinCompleted =  isCompleted;
    if(isNotify) {
      update();
    }
  }


  void updatePinCompleteStatus(String value){
    if (value.length==4) {
      _isPinCompleted = true;
      _pin = value;

    }else{
      _isPinCompleted = false;

    }

    update();
  }

  void changeAnimationStatus()=> _isStopAnimation = !_isStopAnimation;

  void resetPinField(){
    _pin = '';
    _isPinCompleted = false;
    update();
    Get.back(closeOverlays: true);
  }

  void changeAlignmentValue(){
    if (_isStopAnimation) {
      Future.delayed(const Duration(seconds: 1)).then((value){
        _isAlignmentRightIndicator = !_isAlignmentRightIndicator;
        update();
        changeAlignmentValue();
      });

    }
  }

  void goBackButton(){
    _isPinCompleted = false;
    Get.offAllNamed(RouteHelper.getNavBarRoute(), arguments:  true);
  }

}