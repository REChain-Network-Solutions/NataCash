
import 'package:get/get.dart';
import 'package:six_cash/features/transaction_money/controllers/contact_controller.dart';
import 'package:six_cash/util/color_resources.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/styles.dart';
import 'package:flutter/material.dart';

class ContactItemWidget extends StatelessWidget {
  final int index;
  const ContactItemWidget({Key? key, required this.index}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final ContactController contactController = Get.find<ContactController>();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
      child: Row(children: [ Padding(padding: const EdgeInsets.symmetric( horizontal: Dimensions.paddingSizeDefault),
          child: contactController.filteredContacts[index].contact!.thumbnail != null ?
          CircleAvatar(backgroundImage: MemoryImage(contactController.filteredContacts[index].contact!.thumbnail!)) :
          contactController.filteredContacts[index].contact!.displayName == '' ? const CircleAvatar() :
          CircleAvatar(child:  Text(contactController.filteredContacts[index].contact!.displayName[0].toUpperCase())),
        ),

        Column(
          mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              contactController.filteredContacts[index].contact!.displayName,
              style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
            ),

            contactController.filteredContacts[index].contact!.phones.isEmpty ? const SizedBox() :
            Text(contactController.filteredContacts[index].contact!.phones.first.number,
              style: rubikLight.copyWith(fontSize: Dimensions.fontSizeLarge, color: ColorResources.getGreyBaseGray1()),
            ),
          ],
        ),

      ],),
    );
  }
}



