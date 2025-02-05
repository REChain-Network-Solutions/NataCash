import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_cash/features/add_money/controllers/add_money_controller.dart';
import 'package:six_cash/features/setting/controllers/profile_screen_controller.dart';
import 'package:six_cash/features/splash/controllers/splash_controller.dart';
import 'package:six_cash/features/transaction_money/controllers/contact_controller.dart';
import 'package:six_cash/features/transaction_money/controllers/transaction_controller.dart';
import 'package:six_cash/features/transaction_money/domain/models/purpose_model.dart';
import 'package:six_cash/common/models/contact_model.dart';
import 'package:six_cash/features/transaction_money/domain/models/withdraw_model.dart';
import 'package:six_cash/helper/email_checker_helper.dart';
import 'package:six_cash/helper/price_converter_helper.dart';
import 'package:six_cash/helper/transaction_type.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/styles.dart';
import 'package:six_cash/common/widgets/custom_app_bar_widget.dart';
import 'package:six_cash/common/widgets/custom_loader_widget.dart';
import 'package:six_cash/helper/custom_snackbar_helper.dart';
import 'package:six_cash/features/add_money/widgets/digital_payment_widget.dart';
import 'package:six_cash/features/transaction_money/screens/transaction_confirmation_screen.dart';
import 'package:six_cash/features/transaction_money/widgets/input_box_widget.dart';
import 'package:six_cash/features/transaction_money/widgets/purpose_widget.dart';
import '../widgets/field_item_widget.dart';
import '../widgets/for_person_widget.dart';
import '../widgets/next_button_widget.dart';

class TransactionBalanceInputScreen extends StatefulWidget {
  final String? transactionType;
  final ContactModel? contactModel;
  final String? countryCode;
   const TransactionBalanceInputScreen({Key? key, this.transactionType ,this.contactModel, this.countryCode}) : super(key: key);
  @override
  State<TransactionBalanceInputScreen> createState() => _TransactionBalanceInputScreenState();
}

class _TransactionBalanceInputScreenState extends State<TransactionBalanceInputScreen> {
  final TextEditingController _inputAmountController = TextEditingController();
  String? _selectedMethodId;
  List<MethodField>? _fieldList;
  List<MethodField>? _gridFieldList;
  Map<String?, TextEditingController> _textControllers =  {};
  Map<String?, TextEditingController> _gridTextController =  {};
  final FocusNode _inputAmountFocusNode = FocusNode();

  void setFocus() {
    _inputAmountFocusNode.requestFocus();
    Get.back();
  }

  @override
  void initState() {
    super.initState();
    if(widget.transactionType == TransactionType.withdrawRequest) {
      Get.find<TransactionMoneyController>().getWithdrawMethods();
    }
    Get.find<AddMoneyController>().setPaymentMethod(null, isUpdate: false);
  }
 
  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find<ProfileController>();
    final SplashController splashController = Get.find<SplashController>();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: CustomAppbarWidget(title: widget.transactionType!.tr),

          body: GetBuilder<TransactionMoneyController>(
              builder: (transactionMoneyController) {
                if(widget.transactionType == TransactionType.withdrawRequest &&
                    transactionMoneyController.withdrawModel == null) {
                  return CustomLoaderWidget(color: Theme.of(context).primaryColor);
                }
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(widget.transactionType != TransactionType.addMoney &&
                          widget.transactionType != TransactionType.withdrawRequest)
                        ForPersonWidget(contactModel: widget.contactModel),


                      if(widget.transactionType == TransactionType.withdrawRequest)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: Dimensions.paddingSizeDefault,
                            horizontal: Dimensions.paddingSizeSmall,
                          ),
                          child: Column(children: [
                            Container(
                              height: context.height * 0.05,
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(Dimensions.radiusSizeSmall),
                                border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.4)),
                              ),

                              child: DropdownButton<String>(
                                menuMaxHeight: Get.height * 0.5,
                                hint: Text(
                                  'please_select_a_method'.tr,
                                  style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                                ),
                                value: _selectedMethodId,
                                items: transactionMoneyController.withdrawModel!.withdrawalMethods.map((withdraw) =>
                                    DropdownMenuItem<String>(
                                      value: withdraw.id.toString(),
                                      child: Text(
                                        withdraw.methodName ?? 'no method',
                                        style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                                      ),
                                    )
                                ).toList(),

                                onChanged: (id) {
                                  _selectedMethodId = id;
                                  _gridFieldList = [];
                                  _fieldList = [];

                                  transactionMoneyController.withdrawModel!.withdrawalMethods.firstWhere((method) =>
                                  method.id.toString() == id).methodFields.forEach((method) {
                                    _gridFieldList!.addIf(method.inputName!.contains('cvv') || method.inputType == 'date', method);
                                  });


                                  transactionMoneyController.withdrawModel!.withdrawalMethods.firstWhere((method) =>
                                  method.id.toString() == id).methodFields.forEach((method) {
                                    _fieldList!.addIf(!method.inputName!.contains('cvv') && method.inputType != 'date', method);
                                  });

                                  _textControllers = _textControllers =  {};
                                  _gridTextController = _gridTextController =  {};

                                  for (var method in _fieldList!) {
                                    _textControllers[method.inputName] = TextEditingController();
                                  }
                                  for (var method in _gridFieldList!) {
                                    _gridTextController[method.inputName] = TextEditingController();
                                  }

                                  transactionMoneyController.update();
                                },

                                isExpanded: true,
                                underline: const SizedBox(),
                              ),
                            ),

                            const SizedBox(height: Dimensions.paddingSizeDefault),

                            if(_fieldList != null && _fieldList!.isNotEmpty) ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _fieldList!.length,
                              padding: const EdgeInsets.symmetric(
                                vertical: Dimensions.paddingSizeExtraSmall, horizontal: 10,
                              ),

                              itemBuilder: (context, index) => FieldItemWidget(
                                methodField:_fieldList![index],
                                textControllers: _textControllers,
                              ),
                            ),

                            if(_gridFieldList != null && _gridFieldList!.isNotEmpty)

                              GridView.builder(
                                padding: const EdgeInsets.symmetric(
                                  vertical: Dimensions.paddingSizeExtraSmall, horizontal: 10,
                                ),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 2,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20,
                                ),
                                itemCount: _gridFieldList!.length,

                                itemBuilder: (context, index) => FieldItemWidget(
                                  methodField: _gridFieldList![index],
                                  textControllers: _gridTextController,
                                ),
                              ),

                          ],),
                        ),

                      InputBoxWidget(
                        inputAmountController: _inputAmountController,
                        focusNode: _inputAmountFocusNode,
                        transactionType: widget.transactionType,
                      ),


                      if(widget.transactionType == TransactionType.cashOut)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeLarge,
                            vertical:Dimensions.paddingSizeDefault,
                          ),
                          child: Row( children: [
                            Text(
                              'save_future_cash_out'.tr,
                              style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                            ),
                            const Spacer(),

                            GetBuilder<ContactController>(
                              builder: (contactController) {
                                return Padding(
                                  padding: EdgeInsets.zero,
                                  child: CupertinoSwitch(
                                    value: contactController.isFutureSave,
                                    onChanged: contactController.onSaveChange,
                                  ),
                                );
                              }
                            ),

                          ],),
                        ),


                      widget.transactionType == TransactionType.sendMoney
                          ? transactionMoneyController.purposeList == null
                          ? CustomLoaderWidget(color: Theme.of(context).primaryColor)
                          :  transactionMoneyController.purposeList!.isEmpty
                          ? const SizedBox()
                          : MediaQuery.of(context).viewInsets.bottom > 10
                          ?
                      Container(
                        color: Theme.of(context).cardColor.withOpacity(0.92),
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeLarge,
                          vertical: Dimensions.paddingSizeSmall,
                        ),
                        child: Row(children: [
                          transactionMoneyController.purposeList!.isEmpty ?
                          Center(child: CircularProgressIndicator(
                            color: Theme.of(context).textTheme.titleLarge!.color,
                          )) : const SizedBox(),

                          const SizedBox(width: Dimensions.paddingSizeSmall),

                          Text('change_purpose'.tr, style: rubikRegular.copyWith(
                            fontSize: Dimensions.fontSizeLarge,
                          ))
                        ],),

                      ): const PurposeWidget() : const SizedBox(),

                      if(widget.transactionType == TransactionType.addMoney)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                          child: DigitalPaymentWidget(),
                        ),

                    ],
                  ),
                );
              }
          ),

          floatingActionButton: GetBuilder<TransactionMoneyController>(
              builder: (transactionMoneyController) {
                return  FloatingActionButton(

                  onPressed:() {
                    double amount;
                    if(_inputAmountController.text.isEmpty){
                      showCustomSnackBarHelper('please_input_amount'.tr,isError: true);
                    }else{
                      String balance =  _inputAmountController.text;
                      if(balance.contains('${splashController.configModel!.currencySymbol}')) {
                        balance = balance.replaceAll('${splashController.configModel!.currencySymbol}', '');
                      }
                      if(balance.contains(',')){
                        balance = balance.replaceAll(',', '');
                      }
                      if(balance.contains(' ')){
                        balance = balance.replaceAll(' ', '');
                      }
                      amount = double.parse(balance);
                      if(amount <= 0) {
                        showCustomSnackBarHelper('transaction_amount_must_be'.tr,isError: true);
                      }else {
                        bool inSufficientBalance = false;
                        bool isPaymentSelect = Get.find<AddMoneyController>().paymentMethod != null;

                        final bool isCheck = widget.transactionType != TransactionType.requestMoney
                            && widget.transactionType != TransactionType.addMoney;

                        if(isCheck && widget.transactionType == TransactionType.sendMoney) {
                          inSufficientBalance = PriceConverterHelper.balanceWithCharge(amount, splashController.configModel!.sendMoneyChargeFlat, false) > profileController.userInfo!.balance!;
                        }else if(isCheck && widget.transactionType == TransactionType.cashOut) {
                          inSufficientBalance = PriceConverterHelper.balanceWithCharge(amount, splashController.configModel!.cashOutChargePercent, true) > profileController.userInfo!.balance!;
                        }else if(isCheck && widget.transactionType == TransactionType.withdrawRequest) {
                          inSufficientBalance = PriceConverterHelper.balanceWithCharge(amount, splashController.configModel!.withdrawChargePercent, true) > profileController.userInfo!.balance!;
                        }else if(isCheck){
                          inSufficientBalance = amount > profileController.userInfo!.balance!;
                        }


                        if(inSufficientBalance) {
                          showCustomSnackBarHelper('insufficient_balance'.tr, isError: true);
                        }else if(widget.transactionType == TransactionType.addMoney && !isPaymentSelect){
                          showCustomSnackBarHelper('please_select_a_payment'.tr, isError: true);
                        } else {
                         _confirmationRoute(amount);
                        }
                      }

                    }
                  },
                  backgroundColor: Theme.of(context).secondaryHeaderColor,
                  child: GetBuilder<AddMoneyController>(builder: (addMoneyController) {
                    return addMoneyController.isLoading ||
                        transactionMoneyController.isLoading
                        ? const CircularProgressIndicator()
                        : const NextButtonWidget(isSubmittable: true);
                  }),
                );
              }
          )

      ),
    );
  }


  void _confirmationRoute(double amount) {
    final transactionMoneyController = Get.find<TransactionMoneyController>();
    if(widget.transactionType == TransactionType.addMoney){
      Get.find<AddMoneyController>().addMoney(amount);
    }
    else if(widget.transactionType == TransactionType.withdrawRequest) {
      String? message;
      WithdrawalMethod? withdrawMethod = transactionMoneyController.withdrawModel!.withdrawalMethods.
      firstWhereOrNull((method) => _selectedMethodId == method.id.toString());


      List<MethodField> list = [];
      String? validationKey;

      if(withdrawMethod != null) {
        for (var method in withdrawMethod.methodFields) {
          if(method.inputType == 'email') {
            validationKey  = method.inputName;
          }
          if(method.inputType == 'date') {
            validationKey  = method.inputName;
          }

        }
      }else{
        message = 'please_select_a_method'.tr;
      }


      _textControllers.forEach((key, textController) {
        list.add(MethodField(
          inputName: key, inputType: null,
          inputValue: textController.text,
          placeHolder: null,
        ));

        if((validationKey == key) && EmailCheckerHelper.isNotValid(textController.text)) {
          message = 'please_provide_valid_email'.tr;
        }else if((validationKey == key) && textController.text.contains('-')) {
          message = 'please_provide_valid_date'.tr;
        }

        if(textController.text.isEmpty && message == null) {
          message = 'please fill ${key!.replaceAll('_', ' ')} field';
        }
      });

      _gridTextController.forEach((key, textController) {
        list.add(MethodField(
          inputName: key, inputType: null,
          inputValue: textController.text,
          placeHolder: null,
        ));

        if((validationKey == key) && textController.text.contains('-')) {
          message = 'please_provide_valid_date'.tr;
        }
      });

      if(message != null) {
        showCustomSnackBarHelper(message);
        message = null;

      }
      else{


        Get.to(() => TransactionConfirmationScreen(
          inputBalance: amount,
          transactionType: TransactionType.withdrawRequest,
          contactModel: null,
          withdrawMethod: WithdrawalMethod(
            methodFields: list,
            methodName: withdrawMethod!.methodName,
            id: withdrawMethod.id,
          ),
          callBack: setFocus,
        ));
      }

    }

    else{
      Get.to(()=> TransactionConfirmationScreen(
        inputBalance: amount,
        transactionType:widget.transactionType,
        purpose:  widget.transactionType == TransactionType.sendMoney ?
        transactionMoneyController.purposeList != null && transactionMoneyController.purposeList!.isNotEmpty
            ? transactionMoneyController.purposeList![transactionMoneyController.selectedItem].title
            : PurposeModel().title
            : TransactionType.requestMoney.tr,

        contactModel: widget.contactModel,
        callBack: setFocus,

      ));
    }


  }
}




