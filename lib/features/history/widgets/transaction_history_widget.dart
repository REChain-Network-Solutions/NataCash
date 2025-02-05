import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_cash/features/language/controllers/localization_controller.dart';
import 'package:six_cash/features/history/domain/models/transaction_model.dart';
import 'package:six_cash/helper/date_converter_helper.dart';
import 'package:six_cash/helper/price_converter_helper.dart';
import 'package:six_cash/util/app_constants.dart';
import 'package:six_cash/util/color_resources.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/images.dart';
import 'package:six_cash/util/styles.dart';

class TransactionHistoryWidget extends StatelessWidget {
  final Transactions? transactions;
  const TransactionHistoryWidget({Key? key, this.transactions}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    String? userPhone;
    String? userName;
    bool isCredit = (transactions?.credit ?? 0) > 0;

    try{

      userPhone = transactions!.transactionType == AppConstants.sendMoney
          ? transactions!.receiver!.phone : transactions!.transactionType == AppConstants.receivedMoney
          ? transactions!.sender!.phone : (transactions!.transactionType == AppConstants.addMoney
          || transactions!.transactionType == 'add_money_bonus')
          ? transactions!.sender!.phone : transactions!.transactionType == AppConstants.cashIn
          ? transactions!.sender!.phone : transactions!.transactionType == AppConstants.withdraw
          ? transactions!.receiver!.phone : transactions!.userInfo!.phone;

      userName = transactions!.transactionType == AppConstants.sendMoney
          ? transactions!.receiver!.name : transactions!.transactionType == AppConstants.receivedMoney
          ? transactions!.sender!.name : (transactions!.transactionType == AppConstants.addMoney
          || transactions!.transactionType == 'add_money_bonus')
          ? transactions!.sender!.name : transactions!.transactionType == AppConstants.cashIn
          ? transactions!.sender!.name : transactions!.transactionType == AppConstants.withdraw
          ? transactions!.receiver!.name : transactions!.userInfo!.name;
    }catch(e){
     userName = 'no_user'.tr;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
      child: Stack(
        children: [
         Column(
          children: [
            Row(
              children: [

                Container(
                  height: 50,width: 50,
                  padding: const EdgeInsets.all(8.0),
                  child: transactions!.transactionType == null
                      ? const SizedBox()
                      : Image.asset(Images.getTransactionImage(transactions!.transactionType)),
                ),

                const SizedBox(width: 5,),

                Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transactions!.transactionType!.tr,
                        style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSuperExtraSmall),

                      Text(
                        userName ?? '',
                        maxLines: 1,overflow: TextOverflow.ellipsis,
                        style: rubikRegular.copyWith(
                          fontSize: Dimensions.fontSizeExtraSmall,
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSuperExtraSmall),

                      Text(userPhone ?? '', style: rubikMedium.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                      ),),
                      const SizedBox(height: Dimensions.paddingSizeSuperExtraSmall),

                      Text(
                        'TrxID: ${transactions!.transactionId}',
                        style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall),
                      ),

                    ]),
                const Spacer(),

                Text(
                  '${isCredit ? '+' : '-'} ${PriceConverterHelper.convertPrice(double.parse(transactions!.amount.toString()))}',
                  style: rubikMedium.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: isCredit ? Colors.green : Colors.redAccent,
                  ),
                ),

              ],
            ),
            const SizedBox(height: 5),

            Divider(height: .125,color: ColorResources.getGreyColor()),
          ],
        ),

          Get.find<LocalizationController>().isLtr ?  Positioned(
            bottom:  3 ,
              right: 2,
              child: Text(
                DateConverterHelper.localDateToIsoStringAMPM(DateTime.parse(transactions!.createdAt!)),
                style: rubikRegular.copyWith(
                  fontSize: Dimensions.fontSizeExtraSmall,
                  color: ColorResources.getHintColor(),
                ),
              ),
          ) :
          Positioned(
            bottom:  3 ,
            left: 2,
            child: Text(
              DateConverterHelper.localDateToIsoStringAMPM(DateTime.parse(transactions!.createdAt!)),
              style: rubikRegular.copyWith(
                fontSize: Dimensions.fontSizeExtraSmall,
                color: ColorResources.getHintColor(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

