
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_cash/common/widgets/custom_app_bar_widget.dart';
import 'package:six_cash/features/notification/controllers/notification_controller.dart';
import 'package:six_cash/features/splash/controllers/splash_controller.dart';
import 'package:six_cash/util/color_resources.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/images.dart';
import 'package:six_cash/util/styles.dart';
import 'package:six_cash/common/widgets/custom_image_widget.dart';
import 'package:six_cash/common/widgets/custom_ink_well_widget.dart';
import 'package:six_cash/common/widgets/no_data_widget.dart';
import 'package:six_cash/common/widgets/paginated_list_widget.dart';
import 'package:six_cash/features/notification/widgets/notification_dialog_widget.dart';
import 'package:six_cash/features/notification/widgets/notification_shimmer_widget.dart';
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({ Key? key }) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}


class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return Scaffold(
      appBar: CustomAppbarWidget(title: 'notification'.tr, onlyTitle: true),
      body: RefreshIndicator(
        onRefresh: () async{
          await Get.find<NotificationController>().getNotificationList(true);
        },
        child: GetBuilder<NotificationController>(
          builder: (notification) {
            return notification.notificationModel == null ? const NotificationShimmerWidget() :  notification.notificationList.isNotEmpty ?
            PaginatedListWidget(
              scrollController: scrollController,
              totalSize: notification.notificationModel?.totalSize,
              onPaginate: (int offset) async => await notification.getNotificationList(false, offset: offset),
              offset: notification.notificationModel?.offset,

              itemView: ListView.builder(
                controller : scrollController,
                itemCount: notification.notificationList.length,
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                itemBuilder: (context, index) {
                  return Container(
                    color: Theme.of(context).cardColor,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: CustomInkWellWidget(
                      onTap: (){
                        showDialog(context: context, builder: (context) => NotificationDialogWidget(notificationModel: notification.notificationList[index]));
                      },
                      highlightColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall,horizontal:  Dimensions.paddingSizeExtraLarge),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(notification.notificationList[index].title!, style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: ColorResources.getTextColor())),
                                const SizedBox(height: Dimensions.paddingSizeSmall,),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.6,
                                  child: Text(notification.notificationList[index].description!, maxLines: 2, overflow: TextOverflow.ellipsis, style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: ColorResources.getTextColor())),
                                ),

                              ],
                            ),

                            const Spacer(),
                            SizedBox(
                              height: 64.0,
                              width: 64.0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(Dimensions.radiusSizeExtraSmall),
                                child: CustomImageWidget(
                                  placeholder: Images.placeholder,
                                  height: 50, width: 50, fit: BoxFit.cover,
                                  image: '${Get.find<SplashController>().configModel!.baseUrls!.notificationImageUrl
                                  }/${notification.notificationList[index].image}',
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );

                },
              ),
            ) : const NoDataFoundWidget();
          },
        ),
      ),
    );
  }
}
