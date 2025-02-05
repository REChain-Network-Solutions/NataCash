import 'package:camera/camera.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_cash/common/widgets/custom_app_bar_widget.dart';
import 'package:six_cash/features/auth/screens/sign_up_information_screen.dart';
import 'package:six_cash/features/camera_verification/controllers/camera_screen_controller.dart';
import 'package:six_cash/features/camera_verification/widgets/camera_instruction_widget.dart';
import 'package:six_cash/features/setting/screens/edit_profile_screen.dart';


class CameraScreen extends StatefulWidget {
  final bool fromEditProfile;
  final bool isBarCodeScan;
  final bool isHome;
  final String? transactionType;
  const CameraScreen({
    Key? key,
    required this.fromEditProfile,
    this.isBarCodeScan = false,
    this.isHome = false,
    this.transactionType = '',
  }) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {


  @override
  void dispose() {
    Get.find<CameraScreenController>().stopLiveFeed();
    super.dispose();
  }
  @override
  void initState() {
    Get.find<CameraScreenController>().valueInitialize(widget.fromEditProfile);
    Get.find<CameraScreenController>().startLiveFeed(
      isQrCodeScan: widget.isBarCodeScan,
      isHome: widget.isHome,
      transactionType: widget.transactionType,
    );

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CustomAppbarWidget(
        title: widget.isBarCodeScan ? 'scanner'.tr : 'face_verification'.tr,
        isSkip: (!widget.isBarCodeScan && true && !widget.fromEditProfile),
        function: () {
          if(widget.fromEditProfile) {
            Get.off(() => const EditProfileScreen());
          }else{
            Get.off(() => const SignUpInformationScreen());
          }
        },
      ),
      body:  Column(children: [
        Flexible(flex: 2, child: Stack(children: [
          GetBuilder<CameraScreenController>(
              builder: (cameraController) {
                if (cameraController.controller == null ||
                    cameraController.controller?.value.isInitialized == false) {
                  return const SizedBox();
                }

                return Container(
                  color: Colors.black,
                  height: size.height * 0.7,
                  width: size.width,
                  child: AspectRatio(
                    aspectRatio: cameraController.controller!.value.aspectRatio,
                    child: CameraPreview(cameraController.controller!),
                  ),
                );
              }
          ),

          FractionallySizedBox(
            child: Align(
              alignment: Alignment.center,
              child: DottedBorder(
                strokeWidth: 3,borderType: BorderType.Rect, dashPattern: const [10],color: Colors.white,
                child: const FractionallySizedBox(heightFactor: 0.7, widthFactor: 0.8),
              ),
            ),
          ),
        ])),

        Flexible(
          flex: 1,
          child: CameraInstructionWidget(isBarCodeScan: widget.isBarCodeScan),
        ),
      ]),
    );
  }

}

