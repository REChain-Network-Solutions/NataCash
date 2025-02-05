import 'package:six_cash/features/forget_pin/controllers/forget_pin_controller.dart';
import 'package:six_cash/util/color_resources.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/common/widgets/appbar_header_widget.dart';
import 'package:six_cash/features/forget_pin/widgets/pin_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class ResetPinScreen extends StatefulWidget {
  final String? phoneNumber;
  final String? otp;
  const ResetPinScreen({Key? key, this.phoneNumber, this.otp}) : super(key: key);

  @override
  State<ResetPinScreen>  createState() => _ResetPinScreenState();
}

class _ResetPinScreenState extends State<ResetPinScreen> {
  final TextEditingController newPassController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(children: [
            Expanded(flex: 5, child: Container(color: Theme.of(context).primaryColor)),

            Expanded(flex: 5, child: Container(color: Theme.of(context).cardColor))
          ]),

          const Positioned(
            top: Dimensions.paddingSizeOverLarge,
            left: 0, right: 0,
            child: AppBarHeaderWidget(),
          ),

          Positioned(top: context.height * 0.18, left: 0, right: 0, bottom: 0, child: PinFieldWidget(
            newPassController: newPassController,
            confirmPassController: confirmPassController,
          )),
        ],
      ),

      floatingActionButton: GetBuilder<ForgetPinController>(builder: (forgetPinController)=> Padding(
        padding: const EdgeInsets.only(bottom: 20,right: 10),
        child: FloatingActionButton(
          onPressed: ()=> forgetPinController.resetPin(
            newPassController.text,
            confirmPassController.text,
            widget.phoneNumber,
            widget.otp,
          ),
          elevation: 0,
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          child: !forgetPinController.isLoading ? Center(child: Icon(
            Icons.arrow_forward,color: ColorResources.blackColor,size: 28,
          )) : SizedBox(height: 20.33, width: 20.33, child: CircularProgressIndicator(
            color: Theme.of(context).textTheme.titleLarge!.color,
          )),
        ),
      )),


    );
  }
}
