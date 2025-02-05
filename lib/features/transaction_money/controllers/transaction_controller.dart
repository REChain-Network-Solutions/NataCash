import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:six_cash/common/models/contact_model.dart';
import 'package:six_cash/data/api/api_checker.dart';
import 'package:six_cash/features/auth/domain/reposotories/auth_repo.dart';
import 'package:six_cash/features/setting/controllers/profile_screen_controller.dart';
import 'package:six_cash/features/transaction_money/domain/models/contact_tag_model.dart';
import 'package:six_cash/features/transaction_money/domain/models/purpose_model.dart';
import 'package:six_cash/features/transaction_money/domain/models/withdraw_model.dart';
import 'package:six_cash/features/transaction_money/domain/reposotories/transaction_repo.dart';
import 'package:six_cash/features/transaction_money/screens/transaction_confirmation_screen.dart';
import 'package:six_cash/helper/custom_snackbar_helper.dart';
import 'package:six_cash/helper/route_helper.dart';

class TransactionMoneyController extends GetxController implements GetxService {
  final TransactionRepo transactionRepo;
  final AuthRepo authRepo;
  TransactionMoneyController({required this.transactionRepo, required this.authRepo});


  List<ContactTagModel> filteredContacts = [];
  List<ContactTagModel> azItemList = [];
  List<PurposeModel>? _purposeList;
  PurposeModel? _selectedPurpose;
  int _selectItem = 0;
  bool _isLoading = false;
  // bool _isFutureSave = false;
  bool _isNextBottomSheet = false;
  PermissionStatus? permissionStatus;
  final String _searchControllerValue = '';
  double? _inputAmountControllerValue;
  WithdrawModel? _withdrawModel;

  List<PurposeModel>? get purposeList => _purposeList;
  PurposeModel? get selectedPurpose => _selectedPurpose;
  int get selectedItem => _selectItem;
  String get searchControllerValue => _searchControllerValue;
  double? get inputAmountControllerValue => _inputAmountControllerValue;
  bool get isLoading => _isLoading;
  bool get isNextBottomSheet => _isNextBottomSheet;
  String? _pin;
  String? get pin => _pin;
  WithdrawModel? get withdrawModel => _withdrawModel;



  // void cupertinoSwitchOnChange(bool value) {
  //   _isFutureSave = value;
  //   update();
  // }


  Future<void> getPurposeList(bool reload, {bool isUpdate = true})async{
    if(_purposeList == null || reload){
      _purposeList = null;
      _isLoading = true;
      if(isUpdate){
        update();
      }
    }

    if(_purposeList == null){
      Response response = await transactionRepo.getPurposeListApi();

      if(response.body != null && response.statusCode == 200){
        _purposeList = [];
        var data =  response.body.map((a)=> PurposeModel.fromJson(a)).toList();
        for (var purpose in data) {
          _purposeList?.add( PurposeModel(title: purpose.title,logo: purpose.logo, color: purpose.color));
        }
        _selectedPurpose = _purposeList!.isEmpty ? PurposeModel() : _purposeList![0];
      }else{
        ApiChecker.checkApi(response);
      }
      _isLoading = false;
      update();
    }

  }

//todo need to remove
  // Future<void> fetchContactFromDevice() async {
  //   _contactIsLoading = true;
  //   update();
  //   if(getContactPermissionStatus && !GetPlatform.isIOS){
  //     return Get.dialog(
  //       CustomDialogWidget(
  //         description: '${AppConstants.appName} ${'use_the_information_you'.tr}',
  //         icon: Icons.question_mark,
  //         onTapFalse:() {
  //           _contactIsLoading = false;
  //           Get.back();
  //         } ,
  //         onTapTrueText: 'accept'.tr,
  //         onTapFalseText: 'denied'.tr,
  //         onTapTrue: () {
  //           Get.back();
  //           _loadContactData();
  //         } ,
  //         title: 'contact_permission'.tr,
  //
  //       ),
  //       barrierDismissible: false,
  //     ).then((value) => _contactIsLoading = false);
  //
  //   }else{
  //
  //     await _loadContactData();
  //   }
  //   update();
  // }


  // Future<void> _loadContactData() async {
  //   List<Contact> contacts = [];
  //   permissionStatus = await Permission.contacts.request();
  //   authRepo.sharedPreferences.setString(AppConstants.contactPermission, permissionStatus!.name);
  //   if(permissionStatus == PermissionStatus.granted || GetPlatform.isIOS) {
  //     contacts = await FlutterContacts.getContacts(withProperties: true, withPhoto: false);
  //   }
  //   azItemList = [];
  //   for(int i= 0; i < contacts.length; i++){
  //     if(contacts[i].phones.isNotEmpty && contacts[i].displayName.isNotEmpty) {
  //
  //       azItemList.add(ContactTagModel(contact: contacts[i], tag: contacts[i].displayName[0].toUpperCase()));
  //
  //     }
  //   }
  //
  //   filteredContacts = azItemList;
  //   SuspensionUtil.setShowSuspensionStatus(azItemList);
  //   SuspensionUtil.setShowSuspensionStatus(filteredContacts);
  //   _contactIsLoading = false;
  //   update();
  //
  // }

  // void searchContact({required String searchTerm}) {
  //   if (searchTerm.isNotEmpty) {
  //     filteredContacts = azItemList.where((element) {
  //       if (element.contact!.phones.isNotEmpty) {
  //         if(element.contact!.displayName.toLowerCase().contains(searchTerm)
  //             || element.contact!.phones.first.number.replaceAll('-', '').toLowerCase().contains(searchTerm)){
  //           return true;
  //         }else{
  //           return false;
  //         }
  //
  //       }else{
  //         return false;
  //       }
  //     }).toList();
  //
  //   }else{
  //     filteredContacts = azItemList;
  //   }
  //   update();
  // }



  Future<Response> sendMoney({required ContactModel contactModel, required double amount, String? purpose, String? pinCode, required Function onSuggest}) async{

    _isLoading = true;
    _isNextBottomSheet = false;
    update();
   Response response = await transactionRepo.sendMoneyApi(phoneNumber: contactModel.phoneNumber, amount: amount, purpose: purpose, pin: pinCode);
   if(response.statusCode == 200){
     _isLoading = false;
     _isNextBottomSheet = true;

     onSuggest();

   }else{
     _isLoading = false;
     ApiChecker.checkApi(response);
   }
   update();
   return response;
  }


  Future<Response> requestMoney({required ContactModel contactModel, required double amount, required Function onSuggest})async{
    _isLoading = true;
    _isNextBottomSheet = false;
    update();
    Response response = await transactionRepo.requestMoneyApi(phoneNumber: contactModel.phoneNumber, amount: amount);
    if(response.statusCode == 200){
      _isLoading = false;
      _isNextBottomSheet = true;

      onSuggest();

    }else{
      _isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }


  Future<Response> cashOutMoney({required ContactModel contactModel, required double amount, String? pinCode, required Function? onSuggest})async{
    _isLoading = true;
    _isNextBottomSheet = false;
    update();
    Response response = await transactionRepo.cashOutApi(phoneNumber: contactModel.phoneNumber, amount: amount,pin: pinCode);
    if(response.statusCode == 200){
      _isLoading = false;
      _isNextBottomSheet = true;

      if(onSuggest != null) {
        onSuggest();
      }


    }else{
      _isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }



  // Future<Response?> checkCustomerNumber({required String phoneNumber})async{
  //   Response? response0;
  //   if(phoneNumber == Get.find<ProfileController>().userInfo!.phone) {
  //     showCustomSnackBarHelper('Please_enter_a_different_customer_number'.tr);
  //   }else {
  //     _isButtonClick = true;
  //     update();
  //     Response response = await transactionRepo.checkCustomerNumber(phoneNumber: phoneNumber);
  //     if(response.statusCode == 200){
  //       _isButtonClick = false;
  //     }else{
  //       _isButtonClick = false;
  //       ApiChecker.checkApi(response);
  //     }
  //     update();
  //     response0 =  response;
  //   }
  //   return response0;
  //
  // }
  //
  //
  // Future<Response> checkAgentNumber({required String phoneNumber})async{
  //   _isButtonClick = true;
  //   update();
  //   Response response = await transactionRepo.checkAgentNumber(phoneNumber: phoneNumber);
  //   if(response.statusCode == 200){
  //     _isButtonClick = false;
  //   }else{
  //     _isButtonClick = false;
  //     ApiChecker.checkApi(response);
  //   }
  //   update();
  //   return response;
  // }





  void itemSelect({required int index}){
    _selectItem = index;
    _selectedPurpose = purposeList![index];

    update();
  }

  ContactModel? _contact;
  ContactModel? get contact => _contact;

  // void  contactOnTap(int index, String? transactionType){
  //   String phoneNumber = filteredContacts[index].contact!.phones.first.number.trim();
  //   if(phoneNumber.contains('-')){
  //     phoneNumber = phoneNumber.replaceAll('-', '');
  //   }
  //   if(!phoneNumber.contains('+')){
  //     //todo need check country code
  //     phoneNumber = (Get.find<AuthController>().getUserData()!.countryCode!+phoneNumber.substring(1).trim());
  //   }
  //   if(phoneNumber.contains(' ')){
  //     phoneNumber = phoneNumber.replaceAll(' ', '');
  //   }
  //   if(transactionType == "cash_out"){
  //     Get.find<TransactionMoneyController>().checkAgentNumber(phoneNumber: phoneNumber).then((value) {
  //       if(value.isOk){
  //         String? agentName = value.body['data']['name'];
  //         String? agentImage = value.body['data']['image'];
  //
  //         Get.to(()=> TransactionBalanceInputScreen(transactionType: transactionType,contactModel: ContactModel(phoneNumber: phoneNumber,name: agentName,avatarImage: agentImage)));
  //       }
  //     });
  //   }else{
  //     Get.find<TransactionMoneyController>().checkCustomerNumber(phoneNumber: phoneNumber).then((value) {
  //       if(value!.isOk){
  //         String? customerName = value.body['data']['name'];
  //         String? customerImage = value.body['data']['image'];
  //         Get.to(()=> TransactionBalanceInputScreen(transactionType: transactionType,contactModel: ContactModel(phoneNumber: phoneNumber,name: customerName,avatarImage: customerImage)));
  //       }
  //     });
  //   }
  // }

  // void suggestOnTap(int index, String? transactionType){
  //   if(transactionType == 'send_money'){
  //     setContactModel(ContactModel(
  //         phoneNumber: _sendMoneySuggestList[index].phoneNumber,
  //         avatarImage: _sendMoneySuggestList[index].avatarImage,
  //         name: _sendMoneySuggestList[index].name
  //     ));
  //   }
  //   else if(transactionType == 'request_money'){
  //     setContactModel(ContactModel(
  //         phoneNumber: _requestMoneySuggestList[index].phoneNumber,
  //         avatarImage: _requestMoneySuggestList[index].avatarImage,
  //         name: _requestMoneySuggestList[index].name
  //     ));
  //   }
  //   else if(transactionType == 'cash_out'){
  //     setContactModel(ContactModel(
  //         phoneNumber: _cashOutSuggestList[index].phoneNumber,
  //         avatarImage: _cashOutSuggestList[index].avatarImage,
  //         name: _cashOutSuggestList[index].name
  //     ));
  //   }
  //
  //   Get.to(()=>TransactionBalanceInputScreen(transactionType: transactionType,contactModel: _contact));
  //
  //   }

  void balanceConfirmationOnTap({double? amount, String? transactionType, String? purpose, ContactModel? contactModel}) {
    Get.to(()=> TransactionConfirmationScreen(
        inputBalance: amount, transactionType: transactionType, purpose: purpose,contactModel: contactModel));
  }



  // void getSuggestList({required String? type})async{
  //   _cashOutSuggestList = [];
  //   _sendMoneySuggestList = [];
  //   _requestMoneySuggestList = [];
  //   try{
  //     if(type == AppConstants.sendMoney) {
  //       _sendMoneySuggestList.addAll(transactionRepo.getRecentList(type: type)!);
  //     }else if(type == AppConstants.cashOut) {
  //       _cashOutSuggestList.addAll(transactionRepo.getRecentList(type: type)!);
  //     }else{
  //       _requestMoneySuggestList.addAll(transactionRepo.getRecentList(type: type)!);
  //     }
  //
  //   }catch(error){
  //     _cashOutSuggestList = [];
  //     _sendMoneySuggestList = [];
  //     _requestMoneySuggestList = [];
  //   }
  //
  // }

  void changeTrueFalse(){
    _isNextBottomSheet = false;
  }

  Future<bool> pinVerify({required String pin})async{
    bool isVerify = false;
    _isLoading = true;
     update();
    final Response response =  await authRepo.pinVerifyApi(pin: pin);
    if(response.statusCode == 200){
      isVerify = true;
      _isLoading = false;
    }else{
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
    return isVerify;
  }


  Future<bool?> getBackScreen()async{
    Get.offAndToNamed(RouteHelper.navbar, arguments: false);
    return null;
  }

  Future<void> getWithdrawMethods({bool isReload = false}) async{
    if(_withdrawModel == null || isReload) {
      Response response = await transactionRepo.getWithdrawMethods();

      if(response.body['response_code'] == 'default_200' && response.body['content'] != null) {
        _withdrawModel = WithdrawModel.fromJson(response.body);
      }else{
        _withdrawModel = WithdrawModel(withdrawalMethods: [],);
        ApiChecker.checkApi(response);
      }
      update();
    }

  }

  Future<void> withDrawRequest({Map<String, String?>? placeBody})async{

    final ProfileController profileController = Get.find<ProfileController>();
    _isLoading = true;

    Response response = await transactionRepo.withdrawRequest(placeBody: placeBody);

    if(response.statusCode == 200 && response.body['response_code'] == 'default_store_200'){

      profileController.getProfileData(reload: true);

      Get.offAllNamed(RouteHelper.getNavBarRoute());
      showCustomSnackBarHelper('request_send_successful'.tr, isError: false);
    }else{

      showCustomSnackBarHelper(response.body['message'] ?? 'error', isError: true);
    }
    _isLoading = false;
    update();

  }


}