
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_cash/common/widgets/custom_ink_well_widget.dart';
import 'package:six_cash/features/splash/controllers/splash_controller.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/images.dart';
import 'package:six_cash/features/home/widgets/banner_widget.dart';
import 'package:six_cash/features/transaction_money/screens/transaction_balance_input_screen.dart';
import 'package:six_cash/features/transaction_money/screens/transaction_money_screen.dart';
import 'package:six_cash/util/styles.dart';

class ThemeThreeWidget extends StatelessWidget {
  const ThemeThreeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
        builder: (splashController) {
          return Stack(children: [
            Container(height: 180.0, color: Theme.of(context).primaryColor,),

            Positioned(child: Column(children: [
              Container(
                  margin: const EdgeInsets.only(
                    top: Dimensions.paddingSizeLarge,
                    bottom: Dimensions.paddingSizeDefault,
                  ),
                  child: Row(children: [
                    splashController.configModel!.systemFeature!.sendMoneyStatus! ?
                      Expanded(child: _CardWidget(
                        image: Images.sendMoneyLogo3,
                        text: 'send_money'.tr,
                        height: 38, width: 38,
                        onTap: ()=> Get.to(()=> const TransactionMoneyScreen(fromEdit: false,transactionType: 'send_money')),
                      )) : const SizedBox(height: 38),

                    if(splashController.configModel!.systemFeature!.cashOutStatus!)
                      Expanded(child: _CardWidget(
                        image: Images.cashOutLogo3,
                        text: 'cash_out'.tr, height: 37, width: 37,
                        onTap: ()=> Get.to(()=> const TransactionMoneyScreen(fromEdit: false,transactionType: 'cash_out')),
                      )),

                    if(splashController.configModel!.systemFeature!.addMoneyStatus!) Expanded(
                      child: _CardWidget(
                        image: Images.addMoneyLogo3,
                        text: 'add_money'.tr, height: 35, width: 30,
                        onTap: () => Get.to(const TransactionBalanceInputScreen(transactionType: 'add_money')),
                      ),
                    ),

                    if(splashController.configModel!.systemFeature!.sendMoneyRequestStatus!) Expanded(child: _CardWidget(
                      image: Images.receivedMoneyLogo,
                      text: 'request_money'.tr, height: 32, width: 48,
                      onTap: ()=> Get.to(()=> const TransactionMoneyScreen(fromEdit: false,transactionType: 'request_money')),
                    )),


                  ])),





              /// Banner..
              const BannerWidget(),
            ],
            )),
          ]);
        }
    );

  }

}

class _CardWidget extends StatelessWidget {
  final String? image;
  final String? text;
  final VoidCallback? onTap;
  final double? height;
  final double? width;
  const _CardWidget({Key? key, this.image, this.text, this.onTap,this.height,this.width}) : super(key: key) ;

  @override
  Widget build(BuildContext context) {
    return CustomInkWellWidget(onTap: onTap,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault)),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: height, width: width, child: Image.asset(image!, fit: BoxFit.contain)),

            const SizedBox(height: 10),
            Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),

              child: Text(text!, textAlign: TextAlign.center, maxLines: 2,
                style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
