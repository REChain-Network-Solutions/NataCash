import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_cash/features/kyc_verification/controllers/kyc_verify_controller.dart';
import 'package:six_cash/features/kyc_verification/widgets/dotted_border_widget.dart';
import 'package:six_cash/features/setting/controllers/profile_screen_controller.dart';
import 'package:six_cash/util/styles.dart';
import 'package:six_cash/common/widgets/custom_app_bar_widget.dart';
import 'package:six_cash/common/widgets/custom_button_widget.dart';
import 'package:six_cash/common/widgets/custom_drop_down_button_widget.dart';
import 'package:six_cash/helper/custom_snackbar_helper.dart';
import 'package:six_cash/common/widgets/custom_text_field_widget.dart';
import '../../../util/dimensions.dart';

class KycVerifyScreen extends StatefulWidget {
  const KycVerifyScreen({Key? key}) : super(key: key);

  @override
  State<KycVerifyScreen> createState() => _KycVerifyScreenState();
}

class _KycVerifyScreenState extends State<KycVerifyScreen> {
  final TextEditingController _identityNumberController = TextEditingController();

  @override
  void initState() {
    Get.find<KycVerifyController>().initialSelect();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbarWidget(title: 'kyc_verification'.tr),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.fontSizeDefault, vertical: Dimensions.paddingSizeLarge),
        child: GetBuilder<KycVerifyController>(
          builder: (kycVerifyController) {
            return SingleChildScrollView(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                CustomDropDownButtonWidget(
                  value: kycVerifyController.dropDownSelectedValue,
                  itemList: kycVerifyController.dropList,
                  onChanged: (value)=> kycVerifyController.dropDownChange(value!),
                ),
                const SizedBox(height: Dimensions.fontSizeDefault),

                CustomTextFieldWidget(
                  controller: _identityNumberController,
                  fillColor: Theme.of(context).cardColor,isShowBorder: true,
                  maxLines: 1,
                  hintText: 'identity_number'.tr,
                ),
                const SizedBox(height: Dimensions.fontSizeDefault),

                Text('upload_your_image'.tr, style: rubikRegular),
                const SizedBox(height: Dimensions.paddingSizeDefault,),

                Container(height: 100,padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: kycVerifyController.identityImage.length + 1,
                    itemBuilder: (BuildContext context, index){
                      if(index + 1 == kycVerifyController.identityImage.length + 1) {
                        return const DottedBorderWidget(path: null);
                      }
                      return  kycVerifyController.identityImage.isNotEmpty ?
                      Row(
                        children: [
                          Stack(
                            children: [
                              DottedBorderWidget(path: kycVerifyController.identityImage[index].path),

                              Positioned(
                                bottom:0,right:0,
                                child: InkWell(
                                  onTap :() => kycVerifyController.removeImage(index),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.2),
                                          borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault))
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Icon(Icons.delete_outline,color: Colors.red,size: 16,),
                                      )),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: Dimensions.paddingSizeDefault),
                        ],
                      ):const SizedBox();

                    },),
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                Center(child: kycVerifyController.isLoading ? const CircularProgressIndicator() :  SizedBox(
                  width: 200, height: 50,
                  child: CustomButtonWidget(buttonText: 'upload'.tr, onTap: (){
                    if(_identityNumberController.text.isEmpty) {
                      showCustomSnackBarHelper('identity_number_is_empty'.tr);
                    }else if(kycVerifyController.identityImage.isEmpty) {
                      showCustomSnackBarHelper('please_upload_identity_image'.tr);
                    }else if(kycVerifyController.dropDownSelectedValue == kycVerifyController.dropList[0]) {
                      showCustomSnackBarHelper('select_identity_type'.tr);
                    }else{
                      kycVerifyController.kycVerify(_identityNumberController.text).then((value)
                      => Get.find<ProfileController>().getProfileData(isUpdate: true, reload: true));
                    }
                  }, color: Theme.of(context).primaryColor),
                  ),
                ),




              ]),
            );
          }
        ),
      ),
    );
  }
}
