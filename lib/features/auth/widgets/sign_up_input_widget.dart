import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_cash/features/setting/controllers/profile_screen_controller.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/styles.dart';
import 'package:six_cash/common/widgets/custom_text_field_widget.dart';

class SignUpInputWidget extends StatefulWidget {
  final TextEditingController? occupationController, fNameController,lNameController,emailController;
   const SignUpInputWidget({
     Key? key,
     this.occupationController,
     this.fNameController,
     this.lNameController,
     this.emailController,
   }) : super(key: key);

  @override
  State<SignUpInputWidget> createState() => _SignUpInputWidgetState();
}

class _SignUpInputWidgetState extends State<SignUpInputWidget> {
  final FocusNode occupationFocus = FocusNode();
  final FocusNode firstNameFocus = FocusNode();
  final FocusNode lastNameFocus = FocusNode();
  final FocusNode emailNameFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(builder: (controller){
      return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeLarge,
          vertical: Dimensions.paddingSizeLarge),
      child: Column(
        children: [
          CustomTextFieldWidget(
            fillColor: Theme.of(context).cardColor,
            hintText: 'occupation'.tr,
            isShowBorder: true,
            controller: widget.occupationController,
            focusNode: occupationFocus,
            nextFocus: firstNameFocus,
            inputType: TextInputType.name,
            capitalization: TextCapitalization.words,
          ),
          const SizedBox(
            height: Dimensions.paddingSizeLarge,
          ),

          CustomTextFieldWidget(
            fillColor: Theme.of(context).cardColor,
            hintText: 'first_name'.tr,
            isShowBorder: true,
            controller: widget.fNameController,
            focusNode: firstNameFocus,
            nextFocus: lastNameFocus,
            inputType: TextInputType.name,
            capitalization: TextCapitalization.words,
          ),
          const SizedBox(
            height: Dimensions.paddingSizeLarge,
          ),

          CustomTextFieldWidget(
            fillColor: Theme.of(context).cardColor,
            hintText: 'last_name'.tr,
            isShowBorder: true,
            controller: widget.lNameController,
            focusNode: lastNameFocus,
            nextFocus: emailNameFocus,
            inputType: TextInputType.name,
            capitalization: TextCapitalization.words,
          ),
          const SizedBox(
            height: Dimensions.paddingSizeExtraExtraLarge,
          ),

        Column(
            children: [

              Row(
                children: [
                  Text('email_address'.tr, style: rubikMedium.copyWith(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                      fontSize: Dimensions.fontSizeDefault,
                    ),
                  ),

                  Text('(${'optional'.tr})', style: rubikRegular.copyWith(
                      color: Theme.of(context).textTheme.titleLarge!.color,
                      fontSize: Dimensions.fontSizeDefault,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: Dimensions.paddingSizeExtraExtraLarge,
              ),

              CustomTextFieldWidget(
                fillColor: Theme.of(context).cardColor,
                hintText: 'type_email_address'.tr,
                isShowBorder: true,
                controller: widget.emailController,
                focusNode: emailNameFocus,
                inputType: TextInputType.emailAddress,
              ),
            ],
          ) ,

        ],
      ),
    );
    });
  }
}
