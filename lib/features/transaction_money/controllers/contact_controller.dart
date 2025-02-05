import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:six_cash/common/models/contact_model.dart';
import 'package:six_cash/common/widgets/custom_dialog_widget.dart';
import 'package:six_cash/data/api/api_checker.dart';
import 'package:six_cash/features/auth/controllers/auth_controller.dart';
import 'package:six_cash/features/setting/controllers/profile_screen_controller.dart';
import 'package:six_cash/features/transaction_money/domain/enums/suggest_type_enum.dart';
import 'package:six_cash/features/transaction_money/domain/models/contact_tag_model.dart';
import 'package:six_cash/features/transaction_money/domain/reposotories/contact_repo.dart';
import 'package:six_cash/features/transaction_money/screens/transaction_balance_input_screen.dart';
import 'package:six_cash/helper/custom_snackbar_helper.dart';
import 'package:six_cash/util/app_constants.dart';

class ContactController extends GetxController implements GetxService {
  final ContactRepo contactRepo;
  ContactController({required this.contactRepo});


  List<ContactTagModel> filteredContacts = [];
  List<ContactTagModel> azItemList = [];
  List<ContactModel> _sendMoneySuggestList = [];
  List<ContactModel> _requestMoneySuggestList = [];
  List<ContactModel> _cashOutSuggestList = [];
  PermissionStatus? permissionStatus;
  ContactModel? _contact;
  bool _isFutureSave = false;


  List<ContactModel> get sendMoneySuggestList => _sendMoneySuggestList;
  List<ContactModel> get requestMoneySuggestList => _requestMoneySuggestList;
  List<ContactModel> get cashOutSuggestList => _cashOutSuggestList;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  ContactModel? get contact => _contact;
  bool get isFutureSave => _isFutureSave;
  bool get getContactPermissionStatus => contactRepo.sharedPreferences.getString(AppConstants.contactPermission) != PermissionStatus.granted.name;


  Future<void> getContactList() async {
    _isLoading = true;
    update();
    if(getContactPermissionStatus && !GetPlatform.isIOS){
      return Get.dialog(
        CustomDialogWidget(
          description: '${AppConstants.appName} ${'use_the_information_you'.tr}',
          icon: Icons.question_mark,
          onTapFalse:() {
            _isLoading = false;
            Get.back();
          } ,
          onTapTrueText: 'accept'.tr,
          onTapFalseText: 'denied'.tr,
          onTapTrue: () {
            Get.back();
            _loadContactData();
          } ,
          title: 'contact_permission'.tr,

        ),
        barrierDismissible: false,
      ).then((value) => _isLoading = false);

    }else{

      await _loadContactData();
    }
    update();
  }

  Future<void> _loadContactData() async {
    List<Contact> contacts = [];
    permissionStatus = await Permission.contacts.request();
    contactRepo.sharedPreferences.setString(AppConstants.contactPermission, permissionStatus!.name);
    if(permissionStatus == PermissionStatus.granted || GetPlatform.isIOS) {
      contacts = await FlutterContacts.getContacts(withProperties: true, withPhoto: false);
    }
    azItemList = [];
    for(int i= 0; i < contacts.length; i++){
      if(contacts[i].phones.isNotEmpty && contacts[i].displayName.isNotEmpty) {

        azItemList.add(ContactTagModel(contact: contacts[i], tag: contacts[i].displayName[0].toUpperCase()));

      }
    }

    filteredContacts = azItemList;
    SuspensionUtil.setShowSuspensionStatus(azItemList);
    SuspensionUtil.setShowSuspensionStatus(filteredContacts);
    _isLoading = false;
    update();

  }

  void onSearchContact({required String searchTerm}) {
    if (searchTerm.isNotEmpty) {
      filteredContacts = azItemList.where((element) {
        if (element.contact!.phones.isNotEmpty) {
          if(element.contact!.displayName.toLowerCase().contains(searchTerm)
              || element.contact!.phones.first.number.replaceAll('-', '').toLowerCase().contains(searchTerm)){
            return true;
          }else{
            return false;
          }

        }else{
          return false;
        }
      }).toList();

    }else{
      filteredContacts = azItemList;
    }
    update();
  }


  void onTapContact(int index, String? transactionType){
    String phoneNumber = filteredContacts[index].contact!.phones.first.number.trim();
    if(phoneNumber.contains('-')){
      phoneNumber = phoneNumber.replaceAll('-', '');
    }
    if(!phoneNumber.contains('+')){
      phoneNumber = (Get.find<AuthController>().getUserData()!.countryCode!+phoneNumber.substring(1).trim());
    }
    if(phoneNumber.contains(' ')){
      phoneNumber = phoneNumber.replaceAll(' ', '');
    }
    if(transactionType == "cash_out"){
      checkAgentNumber(phoneNumber: phoneNumber).then((value) {
        if(value.isOk){
          String? agentName = value.body['data']['name'];
          String? agentImage = value.body['data']['image'];

          Get.to(()=> TransactionBalanceInputScreen(transactionType: transactionType,contactModel: ContactModel(phoneNumber: phoneNumber,name: agentName,avatarImage: agentImage)));
        }
      });
    }else{
      checkCustomerNumber(phoneNumber: phoneNumber).then((value) {
        if(value!.isOk){
          String? customerName = value.body['data']['name'];
          String? customerImage = value.body['data']['image'];
          Get.to(()=> TransactionBalanceInputScreen(transactionType: transactionType,contactModel: ContactModel(phoneNumber: phoneNumber,name: customerName,avatarImage: customerImage)));
        }
      });
    }
  }

  void onTapSuggest(int index, String? transactionType){
    if(transactionType == 'send_money'){
      _contact = ContactModel(
          phoneNumber: _sendMoneySuggestList[index].phoneNumber,
          avatarImage: _sendMoneySuggestList[index].avatarImage,
          name: _sendMoneySuggestList[index].name
      );
    }
    else if(transactionType == 'request_money'){
      _contact = ContactModel(
          phoneNumber: _requestMoneySuggestList[index].phoneNumber,
          avatarImage: _requestMoneySuggestList[index].avatarImage,
          name: _requestMoneySuggestList[index].name
      );
    }
    else if(transactionType == 'cash_out'){
      _contact =  ContactModel(
          phoneNumber: _cashOutSuggestList[index].phoneNumber,
          avatarImage: _cashOutSuggestList[index].avatarImage,
          name: _cashOutSuggestList[index].name
      );
    }

    Get.to(()=>TransactionBalanceInputScreen(transactionType: transactionType,contactModel: _contact));

  }

  void addToSuggestContact(ContactModel? contact, {required SuggestType type}) {

    if(contact != null) {
      switch(type) {
        case SuggestType.sendMoney:
          _sendMoneySuggestList.removeWhere((element) => element.phoneNumber == contact.phoneNumber);
          _sendMoneySuggestList.add(contact) ;
          contactRepo.addToSuggestList(_sendMoneySuggestList, type: type);
          break;

        case SuggestType.cashOut:
          _cashOutSuggestList.removeWhere((element) => element.phoneNumber == contact.phoneNumber);
          _cashOutSuggestList.add(contact) ;
          contactRepo.addToSuggestList(_cashOutSuggestList, type: type);
          break;

        case SuggestType.requestMoney:
          _requestMoneySuggestList.removeWhere((element) => element.phoneNumber == contact.phoneNumber);
          _requestMoneySuggestList.add(contact) ;
          contactRepo.addToSuggestList(_requestMoneySuggestList, type: type);
          break;
      }
    }

    update();


  }

  void onSaveChange(bool value) {
    _isFutureSave = value;
    update();
  }


  void getSuggestList({required String? type})async{

    _cashOutSuggestList = [];
    _sendMoneySuggestList = [];
    _requestMoneySuggestList = [];

    try{
      if(type == AppConstants.sendMoney) {
        _sendMoneySuggestList.addAll(contactRepo.getRecentList(type: type)!);

      }else if(type == AppConstants.cashOut) {
        _cashOutSuggestList.addAll(contactRepo.getRecentList(type: type)!);

      }else{
        _requestMoneySuggestList.addAll(contactRepo.getRecentList(type: type)!);

      }

    }catch(error){
      _cashOutSuggestList = [];
      _sendMoneySuggestList = [];
      _requestMoneySuggestList = [];

    }

  }

  Future<Response?> checkCustomerNumber({required String phoneNumber})async{
    Response? response0;
    if(phoneNumber == Get.find<ProfileController>().userInfo!.phone) {
      showCustomSnackBarHelper('Please_enter_a_different_customer_number'.tr);
    }else {
      _isLoading = true;
      update();
      Response response = await contactRepo.checkCustomerNumber(phoneNumber: phoneNumber);
      if(response.statusCode == 200){
        _isLoading = false;
      }else{
        _isLoading = false;
        ApiChecker.checkApi(response);
      }
      update();
      response0 =  response;
    }
    return response0;

  }


  Future<Response> checkAgentNumber({required String phoneNumber})async{
    _isLoading = true;
    update();
    Response response = await contactRepo.checkAgentNumber(phoneNumber: phoneNumber);
    if(response.statusCode == 200){
      _isLoading = false;
    }else{
      _isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

}