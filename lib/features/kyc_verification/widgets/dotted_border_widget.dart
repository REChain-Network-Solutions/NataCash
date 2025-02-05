import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:six_cash/common/widgets/custom_ink_well_widget.dart';
import 'package:six_cash/features/kyc_verification/controllers/kyc_verify_controller.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/images.dart';

class DottedBorderWidget extends StatelessWidget {
  final String? path;
  const DottedBorderWidget({Key? key, this.path}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      dashPattern: const [10],
      borderType: BorderType.RRect,
      strokeWidth: 0.5,
      color: Theme.of(context).hintColor,
      child: CustomInkWellWidget(
        onTap: path != null ? null :()=> Get.find<KycVerifyController>().pickImage(false),
        child: path != null ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeSmall)),
            child: Image.file(
              File(path ?? ''),
              width: 160, height: 100, fit: BoxFit.cover,
            ),
          ),
        ) :
        SizedBox(
          height: 100, width: 160, child: Padding(
          padding: const EdgeInsets.all(30),
          child: Image.asset(Images.cameraIcon),
        ),
        ),
      ),
    );
  }
}
