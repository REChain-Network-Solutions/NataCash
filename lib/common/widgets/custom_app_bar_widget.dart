import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/styles.dart';
import 'package:six_cash/common/widgets/custom_ink_well_widget.dart';
import 'package:six_cash/common/widgets/rounded_button_widget.dart';

class CustomAppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Function? onTap;
  final bool isSkip;
  final Function? function;
  final bool onlyTitle;
  const CustomAppbarWidget({Key? key, required this.title, this.onTap,this.isSkip = false, this.function, this.onlyTitle = false}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return onlyTitle ? Container(
      color: Theme.of(context).primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(title, style: rubikSemiBold.copyWith(
            fontSize: Dimensions.fontSizeExtraLarge,color: Colors.white,),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault,)

        ],
      ),

    ) : Container(
      color: Theme.of(context).primaryColor,
      child: SafeArea(
        child: Container(
          color: Theme.of(context).primaryColor,
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomInkWellWidget(
                  onTap: onTap == null ? () {
                    Get.back();
                  } : onTap as void Function()?,
                  radius: Dimensions.radiusSizeSmall,
                  child: Container(
                    height: 40,width: 40,
                    // padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white.withOpacity(0.7), width: 0.5),
                      borderRadius: BorderRadius.circular(Dimensions.radiusSizeSmall),
                    ),
                    child: const Center(
                      child: Icon(Icons.arrow_back_ios_new, size: Dimensions.paddingSizeSmall, color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                Text(title, style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Colors.white),
                ),

                isSkip ? const Spacer() : const SizedBox(),

                isSkip ? SizedBox(child: RoundedButtonWidget(buttonText: 'skip'.tr, onTap: function, isSkip: true,)) : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size(double.maxFinite, 70);
}


