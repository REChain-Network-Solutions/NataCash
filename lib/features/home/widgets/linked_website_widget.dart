import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_cash/features/splash/controllers/splash_controller.dart';
import 'package:six_cash/features/home/controllers/websitelink_controller.dart';
import 'package:six_cash/util/color_resources.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/images.dart';
import 'package:six_cash/util/styles.dart';
import 'package:six_cash/common/widgets/custom_image_widget.dart';
import 'package:six_cash/common/widgets/custom_ink_well_widget.dart';
import 'package:six_cash/features/add_money/screens/web_screen.dart';
import 'package:six_cash/features/home/widgets/web_site_shimmer_widget.dart';

class LinkedWebsiteWidget extends StatelessWidget {
  const LinkedWebsiteWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      builder: (splashController) {
        return splashController.configModel!.systemFeature!.linkedWebSiteStatus! ?
        GetBuilder<WebsiteLinkController>(builder: (websiteLinkController){
          return websiteLinkController.isLoading ?
          const WebSiteShimmer() : websiteLinkController.websiteList!.isEmpty ?
          const SizedBox() :  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                child: Text(
                  'linked_website'.tr, style: rubikRegular.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: Theme.of(context).textTheme.titleLarge!.color,
                ),),
              ),


              Container(
                height: 86,
                width: double.infinity,
                margin: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [BoxShadow(
                    color: ColorResources.containerShedow.withOpacity(0.05),
                    blurRadius: 20, offset: const Offset(0, 3),
                  )],
                ),
                child: ListView.builder(
                  itemCount: websiteLinkController.websiteList!.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return CustomInkWellWidget(
                      onTap: () => Get.to(WebScreen(selectedUrl: websiteLinkController.websiteList![index].url!)),
                      radius: Dimensions.radiusSizeExtraSmall,
                      highlightColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      child: Container(width: 100,
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                        child: Column(
                          children: [
                            SizedBox(width: 50, height: 30,
                              child: CustomImageWidget(
                                image: "${Get.find<SplashController>().configModel!.baseUrls!.linkedWebsiteImageUrl
                                }/${websiteLinkController.websiteList![index].image}",
                                placeholder: Images.webLinkPlaceHolder, fit: BoxFit.cover,
                              ),
                            ),

                            const Spacer(),
                            Text(
                              websiteLinkController.websiteList![index].name!,
                              style: rubikRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: ColorResources.getWebsiteTextColor(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: Dimensions.paddingSizeSmall ,
              ),
            ],
          );
        }
        ) : const SizedBox();
      }
    );
  }
}
