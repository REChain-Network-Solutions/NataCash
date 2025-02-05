import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:six_cash/features/camera_verification/controllers/camera_screen_controller.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/images.dart';
import 'package:six_cash/util/styles.dart';


class CameraInstructionWidget extends StatelessWidget {
  const CameraInstructionWidget({
    Key? key, required this.isBarCodeScan,
  }) : super(key: key);

  final bool isBarCodeScan;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CameraScreenController>(
        builder: (cameraScreenController) {
          return SingleChildScrollView(
            child: isBarCodeScan ? Center(
              child: Image.asset(
                  Images.qrScanAnimation,
                  width: 200,
                  fit: BoxFit.contain,
                  alignment: Alignment.center
              ),
            ) :
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: Dimensions.paddingSizeDefault,),

                CircularPercentIndicator(
                  radius: 50.0,
                  lineWidth: 5.0,
                  percent: cameraScreenController.eyeBlink / 3,
                  center: Image.asset(Images.eyeIcon, width: 40),
                  progressColor: Theme.of(context).primaryColor,
                ),

                const SizedBox(height: Dimensions.paddingSizeDefault),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                  child: Text(cameraScreenController.eyeBlink < 3 ? 'straighten_your_face'.tr : 'processing_image'.tr,
                    style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeDefault), maxLines: 2, textAlign: TextAlign.center,
                  ),
                ),

              ],
            ),
          );
        }
    );
  }
}
