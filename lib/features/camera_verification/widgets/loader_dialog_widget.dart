import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_cash/common/widgets/custom_dialog_widget.dart';
import 'package:six_cash/helper/route_helper.dart';
import '../controllers/camera_screen_controller.dart';

class LoaderDialogWidget extends StatelessWidget {
  const LoaderDialogWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CameraScreenController>(
        builder: (cameraScreenController) {
          return  cameraScreenController.isSuccess  == 0
              ?  const Center(child: CircularProgressIndicator())  : cameraScreenController.isSuccess == 1 ?
          CustomDialogWidget(
            icon: Icons.done,
            title: '',
            description: 'face_scanning_successful'.tr,
            onTapFalse: (){
              Navigator.pop(Get.context!);
            },
            onTapTrue: (){

            },
          ) : CustomDialogWidget(
            icon: Icons.cancel_outlined,
            title: '',
            description:'sorry_your_face_could_not_detect'.tr,
            onTapTrueText: 'retry'.tr,
            onTapFalseText: 'cancel'.tr,
            isFailed: true,
            onTapFalse: (){
              cameraScreenController.fromEditProfile
                  ? Get.offNamed(RouteHelper.getNavBarRoute()) : Get.offAllNamed(RouteHelper.getSplashRoute());
            },
            onTapTrue: (){
              cameraScreenController.valueInitialize(cameraScreenController.fromEditProfile);
              Get.back();
              cameraScreenController.startLiveFeed();
            },
          );
        }
    );
  }
}