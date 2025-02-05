import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_cash/features/requested_money/controllers/requested_money_controller.dart';
import 'package:six_cash/util/color_resources.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/styles.dart';
import 'package:six_cash/common/widgets/custom_button_widget.dart';
import 'package:six_cash/common/widgets/custom_password_field_widget.dart';

class ConfirmationDialog extends StatefulWidget {
  final String icon;
  final String? title;
  final String description;
  final Function onYesPressed;
  final bool isAccept;
  final TextEditingController passController;
  const ConfirmationDialog({Key? key, required this.icon, this.title, required this.description, required this.onYesPressed, this.isAccept = false,required this.passController}) : super(key: key);

  @override
  State<ConfirmationDialog> createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {
  @override
  Widget build(BuildContext context) {

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: Stack(clipBehavior: Clip.none, children: [

        Positioned(
          left: 0, right: 0, top: -55,
          child: Container(
            height: 80,
            width: 80,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: widget.isAccept ? ColorResources.getAcceptBtn() : Theme.of(context).colorScheme.error.withOpacity(0.7) , shape: BoxShape.circle),
            child: Transform.rotate(angle: 0, child:Image.asset(widget.icon, width: 50, height: 50)),
          ),
        ),

        GetBuilder<RequestedMoneyController>(builder: (reqController){
          return Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  widget.title != null ? Text(widget.title!, style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge)) :  const SizedBox(),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Text(widget.description, textAlign: TextAlign.center, style: rubikRegular),
                  const SizedBox(height: Dimensions.paddingSizeLarge),
                  CustomPasswordFieldWidget(
                    hint: '＊＊＊＊',
                    controller: widget.passController,
                    isShowSuffixIcon: false,
                    isPassword: true,
                    isIcon: false,
                    textAlign: TextAlign.center,
                  ),

                  !reqController.isLoading? Row(
                    children: [

                      Expanded(child: CustomButtonWidget(buttonText: 'no'.tr,color: Theme.of(context).colorScheme.error.withOpacity(0.7), onTap: (){
                        widget.passController.text = '';
                        Navigator.pop(context);
                      })),
                      const SizedBox(width: 10,),
                      Expanded(child: CustomButtonWidget(buttonText: 'yes'.tr, onTap: widget.onYesPressed,color: ColorResources.getAcceptBtn(),)),
                    ],
                  ) : Center(child: CircularProgressIndicator(color: Theme.of(context).textTheme.titleLarge!.color)),
                ]),
          );
        })

    ]),
      ),);
  }
}