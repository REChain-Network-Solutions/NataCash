import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:six_cash/common/widgets/custom_image_widget.dart';
import 'package:six_cash/common/widgets/custom_ink_well_widget.dart';
import 'package:six_cash/common/widgets/custom_loader_widget.dart';
import 'package:six_cash/features/language/controllers/localization_controller.dart';
import 'package:six_cash/features/splash/controllers/splash_controller.dart';
import 'package:six_cash/features/transaction_money/controllers/transaction_controller.dart';
import 'package:six_cash/features/transaction_money/domain/models/hex_color_model.dart';
import 'package:six_cash/util/color_resources.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/images.dart';
import 'package:six_cash/util/styles.dart';

class PurposeWidget extends StatelessWidget {
  const PurposeWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizationController = Get.find<LocalizationController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge,vertical: Dimensions.paddingSizeSmall),
          child: Text('select_your_purpose'.tr,style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge),),
        ),
    GetBuilder<TransactionMoneyController>(
      builder: (controller) {
        return controller.purposeList == null ? CustomLoaderWidget(color: Theme.of(context).primaryColor) : Container(
          height: 150,padding: localizationController.isLtr ?  const EdgeInsets.only(left: Dimensions.paddingSizeDefault) : const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: controller.purposeList!.length,scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  _PurposeItem(
                    onTap: ()=> controller.itemSelect(index: index),
                    image: controller.purposeList![index].logo,
                    title: controller.purposeList![index].title,
                    color: HexColorModel(controller.purposeList![index].color!),
                  ),

                  Visibility(
                    visible: controller.selectedItem == index ? true : false,
                    child: Positioned(
                      top: Dimensions.paddingSizeDefault,
                      right: Dimensions.paddingSizeDefault,
                      child: Image.asset(Images.onSelect, height: 12,width: 12),
                    ),
                  ),
                ],
              );},
          ),
        );
      }
    )



      ],
    );
  }
}


class _PurposeItem extends StatelessWidget {
  const _PurposeItem({Key? key, required this.image, required this.title, required this.color,required this.onTap}) : super(key: key);
  final String? image;
  final String? title;
  final Color color;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8.0,bottom: 20,top: 10),height: 120,width: 95,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.0),
          color: Colors.white,
          boxShadow: [BoxShadow(blurRadius: 20.0,color: ColorResources.blackColor.withOpacity(0.05),spreadRadius: 0.0,offset: const Offset(0.0, 4.0)),]
      ),
      child: CustomInkWellWidget(
        onTap: onTap as void Function()?,
        child: Column(
          children: [
            Expanded(
              flex: 7,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusSizeVerySmall),topRight: Radius.circular(Dimensions.radiusSizeVerySmall),),),
                child: Center(
                    child: Padding(//height: 36,width: 36,
                        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                        child: CustomImageWidget(
                            placeholder: Images.placeholder,
                            image: '${Get.find<SplashController>().configModel!.baseUrls!.purposeImageUrl}/$image', fit: BoxFit.cover))
                  // ),
                ),
              ),

            ),
            Expanded(
              flex: 3,
              child: Center(
                child: Text(title!,textAlign: TextAlign.center,style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeDefault,color: ColorResources.getGreyColor()),),
              ),
            )

          ],
        ),
      ),

    );
  }
}