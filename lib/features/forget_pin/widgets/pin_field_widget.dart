import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_cash/features/forget_pin/controllers/forget_pin_controller.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/styles.dart';
import 'package:six_cash/common/widgets/custom_password_field_widget.dart';
class PinFieldWidget extends StatefulWidget {
  final TextEditingController newPassController, confirmPassController;

  const PinFieldWidget({Key? key,required this.newPassController,required this.confirmPassController}) : super(key: key);

  @override
  State<PinFieldWidget> createState() => _PinFieldWidgetState();
}

class _PinFieldWidgetState extends State<PinFieldWidget> {
  final FocusNode confirmFocus = FocusNode();

   @override
  Widget build(BuildContext context) {
    return GetBuilder<ForgetPinController>(builder: (controller){
      return Container(
        margin: const EdgeInsets.only(
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeExtraExtraLarge,
          vertical: Dimensions.paddingSizeExtraExtraLarge,
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(Dimensions.radiusSizeExtraExtraLarge),
            topRight: Radius.circular(Dimensions.radiusSizeExtraExtraLarge),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.radiusSizeExtraExtraLarge),
                child: Text(
                  'Set_new_4_digit_pin'.tr,
                  textAlign: TextAlign.center,
                  style: rubikMedium.copyWith(
                    color: Theme.of(context).textTheme.titleLarge!.color,
                    fontSize: Dimensions.fontSizeExtraOverLarge,
                  ),
                ),
              ),
              const SizedBox(
                height: Dimensions.paddingSizeExtraOverLarge,
              ),
              CustomPasswordFieldWidget(
                controller: widget.newPassController,
                nextFocus: confirmFocus,
                isPassword: true,
                isShowSuffixIcon: true,
                isIcon: false,
                hint: 'pin'.tr,
                letterSpacing: 10.0,
              ),
              const SizedBox(
                height: Dimensions.paddingSizeExtraLarge,
              ),
              CustomPasswordFieldWidget(
                controller: widget.confirmPassController,
                focusNode: confirmFocus,
                hint: 'Confirm_Password'.tr,
                isShowSuffixIcon: true,
                isPassword: true,
                isIcon: false,
                textAlign: TextAlign.start,
                letterSpacing: 10.0,
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraOverLarge),

            ],
          ),
        ),
      );
    });
  }
}
