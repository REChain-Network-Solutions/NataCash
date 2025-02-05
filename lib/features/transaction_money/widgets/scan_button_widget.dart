import 'package:dotted_border/dotted_border.dart';
import 'package:six_cash/util/color_resources.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/images.dart';
import 'package:six_cash/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:six_cash/common/widgets/custom_ink_well_widget.dart';

class ScanButtonWidget extends StatelessWidget {
  final VoidCallback onTap;
  const ScanButtonWidget({Key? key,required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusSizeOverLarge),
        color: Theme.of(context).secondaryHeaderColor,
      ),
      child: CustomInkWellWidget(
        onTap: onTap,
        radius: Dimensions.radiusSizeOverLarge,
        child: DottedBorder(
          strokeWidth: 1.0,
          color: Theme.of(context).primaryColor,
          borderType: BorderType.RRect,
          radius: const Radius.circular(Dimensions.radiusSizeOverLarge),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset(Images.qrCode, width: Dimensions.paddingSizeDefault),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                  child: Text('scan_qr_code'.tr, style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: ColorResources.blackColor),),
                )
              ],
            ),
          )),
      ),
    );
  }
}