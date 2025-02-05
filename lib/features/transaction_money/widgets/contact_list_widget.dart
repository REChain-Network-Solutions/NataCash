import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import 'package:six_cash/common/widgets/custom_ink_well_widget.dart';
import 'package:six_cash/features/transaction_money/controllers/contact_controller.dart';
import 'package:six_cash/util/color_resources.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/images.dart';
import 'package:six_cash/util/styles.dart';
import 'package:six_cash/features/transaction_money/widgets/contact_item_widget.dart';

class ContactListWidget extends StatelessWidget{
  final String? transactionType;
  const ContactListWidget({ Key? key, this.transactionType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ContactController>(builder: (contactController) {

      if(contactController.getContactPermissionStatus) {
        return SliverToBoxAdapter(
          child: Column( children: [
            InkWell(
              onTap: () async => await contactController.getContactList(),
              child: Lottie.asset(
                  Images.contactPermissionDeniAnimation,
                  width: 120.0,
                  fit: BoxFit.contain,
                  alignment: Alignment.center),
            ),
            SizedBox(height: 50, child: Text('please_allow_permission'.tr))
          ]),
        );
      }

      if(contactController.permissionStatus == PermissionStatus.permanentlyDenied) {
        return SliverToBoxAdapter(child: Column(children: [
          Lottie.asset(
            Images.contactPermissionDeniAnimation,
            width: 120.0,
            fit: BoxFit.contain,
            alignment: Alignment.center,
          ),

          TextButton(
            onPressed: () => openAppSettings(),
            child: Text('you_have_to_grand_permission_to_see_contact'.tr),
          ),

        ]));
      }
      if(contactController.isLoading) {
        return const SliverToBoxAdapter(child: _ContactShimmer());
      }
      return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) => contactController.filteredContacts[index].contact == null ? const SizedBox() : Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if(index == 0) Container(
              margin: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
              child: Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('phone_book'.tr, style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge),),
                ],
              ),
            ),

            Padding( padding: contactController.filteredContacts[index].isShowSuspension ?
            const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall) :
            const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
              child: Offstage(offstage: !contactController.filteredContacts[index].isShowSuspension,
                child: Text(
                  contactController.filteredContacts[index].getSuspensionTag(),
                  style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: ColorResources.getGreyBaseGray1()),
                ),
              ),
            ),

            CustomInkWellWidget(
              highlightColor: Theme.of(context).textTheme.titleLarge!.color!.withOpacity(0.3),
              onTap:() => contactController.isLoading
                  ? null : contactController.onTapContact(index, transactionType),
              child: ContactItemWidget(index: index),
            ),

            Padding(
              padding: const EdgeInsets.only(left:  65.0,right: 35.0),
              child: Divider(color: Theme.of(context).dividerColor, height: Dimensions.dividerSizeExtraSmall),
            ),
          ],
        ),
          childCount: contactController.filteredContacts.length,
        ),
      );
    });
  }
}

class _ContactShimmer extends StatelessWidget {
  const _ContactShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final  size = MediaQuery.of(context).size;
    return Shimmer.fromColors(
      baseColor: ColorResources.shimmerBaseColor!,
      highlightColor:  ColorResources.shimmerLightColor!,
      child: SizedBox(height: size.height, child: ListView.builder(
        itemCount: 10,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, item) => Column(children: [
          ListTile(leading: const CircleAvatar(foregroundColor: Colors.red),
            title:  Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(color: Colors.red, height: Dimensions.paddingSizeSmall, width: size.width * 0.3),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                Container(color: Colors.red, height: Dimensions.paddingSizeExtraSmall, width: size.width * 0.5),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal:  Dimensions.paddingSizeExtraExtraLarge),
            child: Container(color: Colors.red, height: Dimensions.dividerSizeSmall),
          ),
        ]),
      )),
    );
  }
}
