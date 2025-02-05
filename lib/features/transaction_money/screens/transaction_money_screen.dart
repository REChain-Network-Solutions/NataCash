import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_cash/features/splash/controllers/splash_controller.dart';
import 'package:six_cash/features/transaction_money/controllers/contact_controller.dart';
import 'package:six_cash/features/transaction_money/controllers/transaction_controller.dart';
import 'package:six_cash/common/models/contact_model.dart';
import 'package:six_cash/helper/transaction_type.dart';
import 'package:six_cash/util/color_resources.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/images.dart';
import 'package:six_cash/util/styles.dart';
import 'package:six_cash/features/transaction_money/widgets/contact_list_widget.dart';
import 'package:six_cash/common/widgets/custom_app_bar_widget.dart';
import 'package:six_cash/common/widgets/custom_country_code_widget.dart';
import 'package:six_cash/common/widgets/custom_image_widget.dart';
import 'package:six_cash/common/widgets/custom_ink_well_widget.dart';
import 'package:six_cash/helper/custom_snackbar_helper.dart';
import 'package:six_cash/features/transaction_money/screens/transaction_balance_input_screen.dart';
import 'package:six_cash/features/transaction_money/widgets/scan_button_widget.dart';

import '../../camera_verification/screens/camera_screen.dart';

class TransactionMoneyScreen extends StatefulWidget {
  final bool? fromEdit;
  final String? phoneNumber;
  final String? transactionType;
  const TransactionMoneyScreen({Key? key, this.fromEdit, this.phoneNumber, this.transactionType}) : super(key: key);

  @override
  State<TransactionMoneyScreen> createState() => _TransactionMoneyScreenState();
}

class _TransactionMoneyScreenState extends State<TransactionMoneyScreen> {
  String? customerImageBaseUrl = Get.find<SplashController>().configModel!.baseUrls!.customerImageUrl;

  String? agentImageBaseUrl = Get.find<SplashController>().configModel!.baseUrls!.agentImageUrl;
  final ScrollController _scrollController = ScrollController();
  String? _countryCode;

  @override
  void initState() {
    super.initState();

    final ContactController contactController =  Get.find<ContactController>();

    _countryCode = CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).dialCode;

    contactController.getSuggestList(type: widget.transactionType);
    contactController.onSearchContact(searchTerm: '');

  }

  @override
  Widget build(BuildContext context) {
     final TextEditingController searchController = TextEditingController();
     widget.fromEdit!? searchController.text = widget.phoneNumber!: const SizedBox();


     return Scaffold(
      appBar:  CustomAppbarWidget(title: widget.transactionType!.tr),

      body: GetBuilder<ContactController>(builder: (contactController)=> Builder(
        builder: (context) {
          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverPersistentHeader(pinned: true, delegate: SliverDelegate(
                  child: Column(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault), color: ColorResources.getGreyBaseGray3(),
                      child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: searchController,
                                onChanged: (inputText) => contactController.onSearchContact(
                                  searchTerm: inputText.toLowerCase(),
                                ),
                                keyboardType: widget.transactionType == TransactionType.cashOut
                                    ? TextInputType.phone : TextInputType.name,
                                decoration: InputDecoration(
                                  border: InputBorder.none, contentPadding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
                                  hintText: widget.transactionType == TransactionType.cashOut
                                      ? 'enter_agent_number'.tr : 'enter_name_or_number'.tr,
                                  hintStyle: rubikRegular.copyWith(
                                    fontSize: Dimensions.fontSizeLarge,
                                    color: ColorResources.getGreyBaseGray1(),
                                  ),
                                  prefixIcon: CustomCountryCodeWidget(
                                    onChanged: (countryCode) => _countryCode = countryCode.dialCode!,
                                  ),
                                ),
                              ),),

                            Icon(Icons.search, color: ColorResources.getGreyBaseGray1()),
                          ]),
                    ),
                    Divider(height: Dimensions.dividerSizeSmall, color: Theme.of(context).cardColor),

                    Container(
                      color: Theme.of(context).cardColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ScanButtonWidget(onTap: ()=> Get.to(()=> CameraScreen(
                              fromEditProfile: false,
                              isBarCodeScan: true,
                              transactionType: widget.transactionType,
                            ))),

                            InkWell(
                              onTap: () {
                                if(searchController.text.isEmpty){
                                  showCustomSnackBarHelper('input_field_is_empty'.tr,isError: true);
                                }else {
                                  String phoneNumber = '$_countryCode${searchController.text.trim()}';
                                  if (widget.transactionType == "cash_out") {
                                    contactController.checkAgentNumber(phoneNumber: phoneNumber).then((value) {
                                      if (value.isOk) {
                                        String? agentName = value.body['data']['name'];
                                        String? agentImage = value.body['data']['image'];
                                        Get.to(() => TransactionBalanceInputScreen(transactionType: widget.transactionType,
                                            contactModel: ContactModel(
                                                phoneNumber: '$_countryCode${searchController.text.trim()}',
                                                name: agentName,
                                                avatarImage: agentImage))
                                        );
                                      }
                                    });
                                  } else {
                                    contactController.checkCustomerNumber(phoneNumber: phoneNumber).then((value) {
                                      if (value!.isOk) {
                                        String? customerName = value.body['data']['name'];
                                        String? customerImage = value.body['data']['image'];
                                        Get.to(() =>  TransactionBalanceInputScreen(
                                            transactionType: widget.transactionType,
                                            contactModel: ContactModel(
                                                phoneNumber:'$_countryCode${searchController.text.trim()}',
                                                name: customerName,
                                                avatarImage: customerImage))
                                        );
                                      }
                                    });
                                  }
                                }

                              },

                              child: GetBuilder<ContactController>(builder: (checkController) {
                                return checkController.isLoading ? SizedBox(
                                  width: Dimensions.radiusSizeOverLarge,height:  Dimensions.radiusSizeOverLarge,
                                  child: Center(child: CircularProgressIndicator(color: Theme.of(context).textTheme.titleLarge!.color)),
                                ) : Container(
                                  width: Dimensions.radiusSizeOverLarge,
                                  height:  Dimensions.radiusSizeOverLarge,
                                  decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).secondaryHeaderColor),
                                  child: Icon(Icons.arrow_forward, color: ColorResources.blackColor),
                                );

                              }),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                  )
              )),

              SliverToBoxAdapter(
                child: Column( children: [
                  contactController.sendMoneySuggestList.isNotEmpty &&  widget.transactionType == 'send_money'?
                  GetBuilder<TransactionMoneyController>(builder: (sendMoneyController) {
                    return  Padding(
                      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeLarge),
                      child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                            child: Text('suggested'.tr, style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                          ),
                          SizedBox(height: 80.0,
                            child: ListView.builder(itemCount: contactController.sendMoneySuggestList.length, scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index)=> CustomInkWellWidget(
                                  radius : Dimensions.radiusSizeVerySmall,
                                  highlightColor: Theme.of(context).textTheme.titleLarge!.color!.withOpacity(0.3),
                                  onTap: () => contactController.onTapSuggest(index, widget.transactionType),
                                  child: Container(
                                    margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                                    child: Column(children: [
                                      SizedBox(
                                        height: Dimensions.radiusSizeExtraExtraLarge,width:Dimensions.radiusSizeExtraExtraLarge,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(Dimensions.radiusSizeOverLarge),
                                          child: CustomImageWidget(
                                            fit: BoxFit.cover,
                                            image: "$customerImageBaseUrl/${contactController.sendMoneySuggestList[index].avatarImage.toString()}",
                                            placeholder: Images.avatar,
                                          ),
                                        ),
                                      ), Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                                        child: Text(contactController.sendMoneySuggestList[index].name == null ? contactController.sendMoneySuggestList[index].phoneNumber! : contactController.sendMoneySuggestList[index].name! ,
                                            style: contactController.sendMoneySuggestList[index].name == null ? rubikLight.copyWith(fontSize: Dimensions.fontSizeSmall) : rubikRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                                      )
                                    ],
                                    ),
                                  ),
                                )
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  ) :
                  ((contactController.requestMoneySuggestList.isNotEmpty) && widget.transactionType == 'request_money') ?
                  GetBuilder<TransactionMoneyController>(builder: (requestMoneyController) {
                    return requestMoneyController.isLoading ? const Center(child: CircularProgressIndicator()) : Padding(
                      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeLarge),
                      child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                            child: Text('suggested'.tr, style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                          ),
                          SizedBox(height: 80.0,
                            child: ListView.builder(itemCount: contactController.requestMoneySuggestList.length, scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index)=> CustomInkWellWidget(
                                  radius : Dimensions.radiusSizeVerySmall,
                                  highlightColor: Theme.of(context).textTheme.titleLarge!.color!.withOpacity(0.3),
                                  onTap: ()=> contactController.onTapSuggest(index, widget.transactionType),
                                  child: Container(
                                    margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                                    child: Column(children: [
                                      SizedBox(
                                        height: Dimensions.radiusSizeExtraExtraLarge,width:Dimensions.radiusSizeExtraExtraLarge,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(Dimensions.radiusSizeOverLarge),
                                          child: CustomImageWidget(image: "$customerImageBaseUrl/${contactController.requestMoneySuggestList[index].avatarImage.toString()}",
                                              fit: BoxFit.cover, placeholder: Images.avatar),
                                        ),
                                      ),

                                      Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                                        child: Text(contactController.requestMoneySuggestList[index].name == null ? contactController.requestMoneySuggestList[index].phoneNumber! : contactController.requestMoneySuggestList[index].name! ,
                                            style: contactController.requestMoneySuggestList[index].name == null ? rubikLight.copyWith(fontSize: Dimensions.fontSizeLarge) : rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                                      )
                                    ],
                                    ),
                                  ),
                                )
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  ) :
                  ((contactController.cashOutSuggestList.isNotEmpty) && widget.transactionType == TransactionType.cashOut)?
                  GetBuilder<TransactionMoneyController>(builder: (cashOutController) {
                    return cashOutController.isLoading ? const Center(child: CircularProgressIndicator()) : Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeLarge),
                          child: Text('recent_agent'.tr, style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                        ),
                        ListView.builder(
                            itemCount: contactController.cashOutSuggestList.length, scrollDirection: Axis.vertical, shrinkWrap:true,physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index)=> CustomInkWellWidget(
                              highlightColor: Theme.of(context).textTheme.titleLarge!.color!.withOpacity(0.3),
                              onTap: () => contactController.onTapSuggest(index, widget.transactionType),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge,vertical: Dimensions.paddingSizeSmall),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: Dimensions.radiusSizeExtraExtraLarge,width:Dimensions.radiusSizeExtraExtraLarge,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(Dimensions.radiusSizeOverLarge),
                                        child: CustomImageWidget(
                                          fit: BoxFit.cover,
                                          image: "$agentImageBaseUrl/${
                                              contactController.cashOutSuggestList[index].avatarImage.toString()}",
                                          placeholder: Images.avatar,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: Dimensions.paddingSizeSmall,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(contactController.cashOutSuggestList[index].name == null ?'Unknown':contactController.cashOutSuggestList[index].name!,style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge,color: Theme.of(context).textTheme.bodyLarge!.color)),
                                        Text(contactController.cashOutSuggestList[index].phoneNumber != null ? contactController.cashOutSuggestList[index].phoneNumber! : 'No Number',style: rubikLight.copyWith(fontSize: Dimensions.fontSizeDefault,color: ColorResources.getGreyBaseGray1()),),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )

                        ),
                      ],
                    );
                  }
                  ) : const SizedBox(),


                ],),

              ),

              ContactListWidget(transactionType: widget.transactionType)
            ],
          );
        }
      )
      ),
    );
  }
}



class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;
  SliverDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 120;

  @override
  double get minExtent => 120;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 120 || oldDelegate.minExtent != 120 || child != oldDelegate.child;
  }
}
