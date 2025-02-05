import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:six_cash/features/home/controllers/home_controller.dart';
import 'package:six_cash/features/home/controllers/menu_controller.dart';
import 'package:six_cash/features/setting/controllers/profile_screen_controller.dart';
import 'package:six_cash/features/splash/controllers/splash_controller.dart';
import 'package:six_cash/helper/price_converter_helper.dart';
import 'package:six_cash/helper/transaction_type.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/images.dart';
import 'package:six_cash/common/widgets/custom_image_widget.dart';
import 'package:six_cash/helper/tween_helper.dart';
import 'package:six_cash/common/widgets/hero_dialogue_route_widget.dart';
import 'package:six_cash/features/home/widgets/user_name_widget.dart';
import 'package:six_cash/features/transaction_money/screens/transaction_balance_input_screen.dart';
import 'package:six_cash/features/home/widgets/animated_button_widget.dart';
import 'package:six_cash/util/styles.dart';

class HomeAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return GetBuilder<ProfileController>(
      builder: (profileController) {
        return Container(
          color: Theme.of(context).primaryColor,
          child: Container(
            padding: const EdgeInsets.only(
              top: 54, left: Dimensions.paddingSizeLarge,
              right: Dimensions.paddingSizeLarge,
              bottom: Dimensions.paddingSizeSmall,
            ),

            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(Dimensions.radiusSizeExtraLarge),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  GestureDetector(
                    onTap: () => Get.find<MenuItemController>().selectProfilePage(),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: Dimensions.radiusSizeOverLarge,
                      width: Dimensions.radiusSizeOverLarge,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: profileController.userInfo == null ? Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(Images.avatar,fit: BoxFit.cover),
                          ),
                        ) : CustomImageWidget(
                          image: '${Get.find<SplashController>().configModel!.baseUrls!.customerImageUrl}/${profileController.userInfo!.image ?? ''}',
                          fit: BoxFit.cover,
                          placeholder: Images.avatar,
                        ),

                      ),
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Get.find<SplashController>().configModel!.themeIndex == 1
                      ? const UserNameWidget()
                      : const _BalanceWidget(),
                ],),

                // const Spacer(),

                Row(children: [
                  GetBuilder<SplashController>(builder: (splashController) {
                    bool isRequestMoney = splashController.configModel!.systemFeature!.withdrawRequestStatus!;
                    return isRequestMoney ? AnimatedButtonWidget(
                      onTap: ()=> Get.to(()=> const TransactionBalanceInputScreen(
                        transactionType: TransactionType.withdrawRequest,
                      )),
                    ) : const SizedBox();
                  }
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall,),


                  GestureDetector(
                    onTap: () => Navigator.of(context).push(HeroDialogRouteWidget(builder:(_) =>const _QrPopupCardWidget())),

                    child: Hero(
                      tag: Get.find<HomeController>().heroShowQr,
                      createRectTween: (begin, end) => TweenHelper(begin: begin, end: end),

                      child: Container(
                        width: Get.width * 0.11,
                        height: Get.width * 0.11,
                        padding: EdgeInsets.all(Get.width * 0.025),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Theme.of(context).cardColor.withOpacity(Get.isDarkMode ?  0.7 : 1),
                        ),
                        child: profileController.userInfo != null ? SvgPicture.string(
                          profileController.userInfo!.qrCode!,
                          height: Dimensions.paddingSizeLarge,
                          width: Dimensions.paddingSizeLarge,
                        ) :
                        SizedBox(
                          height: Dimensions.paddingSizeLarge,
                          width: Dimensions.paddingSizeLarge,
                          child: Image.asset(Images.qrCode),
                        ),
                      ),
                    ),
                  ),
                ],)
              ],
            ),
          ),
        );
      }
    );
  }

  @override
  Size get preferredSize => const Size(double.maxFinite, 200);
}


class _QrPopupCardWidget extends StatelessWidget {
  const _QrPopupCardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: Get.find<HomeController>().heroShowQr,
          createRectTween: (begin, end) {
            return TweenHelper(begin: begin, end: end);
          },
          child: Material(
            color: Colors.white,
            elevation: 2,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: GetBuilder<ProfileController>(
                  builder: (controller) {
                    return SizedBox(
                      child: SvgPicture.string(
                        controller.userInfo!.qrCode!,
                        fit: BoxFit.contain,
                        width: size.width * 0.8,
                        // height: size.width * 0.8,
                      ),
                    );
                  },
                )),
          ),
        ),
      ),
    );
  }
}


class _BalanceWidget extends StatelessWidget {
  const _BalanceWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
        builder: (profileController) {
          return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min,
            children: [
              Text(PriceConverterHelper.balanceWithSymbol(balance: '${profileController.userInfo?.balance ?? 0}'), style: rubikMedium.copyWith(
                color: Colors.white, fontSize: Dimensions.fontSizeExtraLarge,
              )),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              Text('available_balance'.tr, style: rubikLight.copyWith(
                fontSize: Dimensions.fontSizeDefault, color: Colors.white,
              )),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall,),

              if(profileController.userInfo != null) Text(
                '(${'sent'.tr} ${PriceConverterHelper.balanceWithSymbol(balance: '${profileController.userInfo?.pendingBalance ?? 0}')} ${'withdraw_req'.tr})',
                style: rubikMedium.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall),
              ),

            ],
          );
        }
    );
  }
}

