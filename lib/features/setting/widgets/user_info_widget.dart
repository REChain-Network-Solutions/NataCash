import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:six_cash/features/setting/controllers/profile_screen_controller.dart';
import 'package:six_cash/features/setting/domain/enums/kyc_verificaiton.dart';
import 'package:six_cash/features/splash/controllers/splash_controller.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/images.dart';
import 'package:six_cash/util/styles.dart';
import 'package:six_cash/common/widgets/custom_image_widget.dart';
import 'package:six_cash/common/widgets/custom_ink_well_widget.dart';
import 'package:six_cash/features/kyc_verification/screens/kyc_verify_screen.dart';
import 'package:six_cash/features/setting/widgets/profile_qr_code_bottomsheet_widget.dart';

import 'profile_shimmer_widget.dart';

class UserInfoWidget extends StatelessWidget {
  const UserInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  GetBuilder<ProfileController>(
      builder: (profileController) =>
      profileController.isLoading ? const ProfileShimmerWidget() : Container(
        color: Theme.of(context).cardColor,
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeLarge,
          vertical: Dimensions.paddingSizeLarge,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                profileController.userInfo != null?
                Row(
                  children: [
                    Container(
                      width: Dimensions.radiusSizeOverLarge,
                      height: Dimensions.radiusSizeOverLarge,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusProfileAvatar)),
                        border: Border.all(width: 1, color: Theme.of(context).highlightColor),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusProfileAvatar)),
                        child: CustomImageWidget(
                          fit: BoxFit.cover,
                          image: "${Get.find<SplashController>().configModel!.baseUrls!.customerImageUrl}/${
                              profileController.userInfo!.image}",
                          placeholder: Images.avatar,
                        ),
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Text(
                            '${profileController.userInfo!.fName} ${profileController.userInfo!.lName}',
                            style: rubikMedium.copyWith(
                              color: Theme.of(context).textTheme.bodyLarge!.color,
                              fontSize: Dimensions.fontSizeLarge,
                            ),
                            textAlign: TextAlign.start,
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        SizedBox(
                          child: Text(
                            '${profileController.userInfo!.phone}',
                            style: rubikMedium.copyWith(
                              color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(Get.isDarkMode ? 0.8 :0.5),
                              fontSize: Dimensions.fontSizeLarge,
                            ),
                            textAlign: TextAlign.start, maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textDirection: TextDirection.ltr,
                          ),
                        ),
                      ],
                    ),
                  ],
                ):const SizedBox(),

                InkWell(
                  onTap: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    isDismissible: false,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(Dimensions.radiusSizeLarge)),
                    ),
                    builder: (context) => const ProfileQRCodeBottomSheetWidget(),
                  ),
                  child: GetBuilder<ProfileController>(builder: (controller) {
                    return Container(
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).secondaryHeaderColor),
                      padding: const EdgeInsets.all(10.0),
                      child: SvgPicture.string(controller.userInfo!.qrCode!, height: 24, width: 24,),
                    );
                  }),
                )
              ],
            ),

            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            if(profileController.userInfo!.kycStatus != KycVerification.approve) Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    profileController.userInfo!.kycStatus == KycVerification.needApply ?
                    'kyc_verification_is_not'.tr : profileController.userInfo!.kycStatus == KycVerification.pending ?
                    'your_verification_request_is'.tr : 'your_verification_is_denied'.tr,
                    style: rubikRegular.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                    maxLines: 2,

                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault,),

                CustomInkWellWidget(
                  onTap: () => Get.to(()=> const KycVerifyScreen()),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeDefault,
                      vertical: Dimensions.paddingSizeExtraSmall,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                      color: Theme.of(context).colorScheme.error.withOpacity(0.8),
                    ),
                    child: Text(
                      profileController.userInfo!.kycStatus == KycVerification.needApply ?
                      'click_to_verify'.tr : profileController.userInfo!.kycStatus == KycVerification.pending ?
                      'edit'.tr : 're_apply'.tr,
                      style: rubikMedium.copyWith(color: Theme.of(context).cardColor),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
