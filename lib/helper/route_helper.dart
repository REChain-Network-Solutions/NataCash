import 'dart:convert';
import 'package:get/get.dart';
import 'package:six_cash/features/splash/controllers/splash_controller.dart';
import 'package:six_cash/common/models/signup_body_model.dart';
import 'package:six_cash/common/models/contact_model.dart';
import 'package:six_cash/features/auth/screens/create_account_screen.dart';
import 'package:six_cash/features/auth/screens/login_screen.dart';
import 'package:six_cash/features/auth/screens/sign_up_information_screen.dart';
import 'package:six_cash/features/auth/screens/pin_set_screen.dart';
import 'package:six_cash/features/camera_verification/screens/camera_screen.dart';
import 'package:six_cash/features/verification/screens/varification_screen.dart';
import 'package:six_cash/features/home/screens/nav_bar_screen.dart';
import 'package:six_cash/features/forget_pin/screens/forget_pin_screen.dart';
import 'package:six_cash/features/forget_pin/screens/reset_pin_screen.dart';
import 'package:six_cash/features/history/screens/history_screen.dart';
import 'package:six_cash/features/home/screens/home_screen.dart';
import 'package:six_cash/features/language/screens/change_language_screen.dart';
import 'package:six_cash/features/notification/screens/notification_screen.dart';
import 'package:six_cash/features/onboarding/screens/on_boarding_sceen.dart';
import 'package:six_cash/features/setting/screens/profile_screen.dart';
import 'package:six_cash/features/setting/widgets/change_pin_screen.dart';
import 'package:six_cash/features/setting/screens/edit_profile_screen.dart';
import 'package:six_cash/features/setting/widgets/faq_screen.dart';
import 'package:six_cash/features/setting/screens/html_view_screen.dart';
import 'package:six_cash/features/setting/screens/qr_code_download_or_share_screen.dart';
import 'package:six_cash/features/setting/screens/support_screen.dart';
import 'package:six_cash/features/splash/screens/splash_screen.dart';
import 'package:six_cash/features/transaction_money/screens/transaction_balance_input_screen.dart';
import 'package:six_cash/features/transaction_money/screens/transaction_confirmation_screen.dart';
import 'package:six_cash/features/transaction_money/screens/transaction_money_screen.dart';
import 'package:six_cash/features/transaction_money/widgets/share_statement_widget.dart';
import 'package:six_cash/features/splash/screens/welcome_screen.dart';

class RouteHelper {
  static const String splash = '/splash';
  static const String home = '/home';
  static const String navbar = '/navbar';
  static const String history = '/history';
  static const String notification = '/notification';
  static const String themeAndLanguage = '/themeAndLanguage';
  static const String profile = '/profile';
  static const String changePinScreen = '/change_pin_screen';
  static const String verifyOtpScreen = '/verify_otp_screen';
  static const String noInternetScreen = '/no_internet_screen';
  static const String sendMoney = '/send_money';
  static const String choseLoginOrRegScreen = '/chose_login_or_reg';
  static const String createAccountScreen = '/create_account';
  static const String verifyScreen = '/verify_account';
  static const String selfieScreen = '/selfie_screen';
  static const String otherInfoScreen = '/other_info_screen';
  static const String pinSetScreen = '/pin_set_screen';
  static const String welcomeScreen = '/welcome_screen';
  static const String loginScreen = '/login_screen';
  static const String fPhoneNumberScreen = '/f_phone_number';
  static const String fVerificationScreen = '/f_verification_screen';
  static const String resetPassScreen = '/f_reset_pass_screen';

  static const String qrCodeScannerScreen = '/qr_code_scanner_screen';
  static const String showWebViewScreen = '/show_web_view_screen';


  static const String sendMoneyBalanceInput = '/send_money_balance_inputsend_money_balance_input';
  static const String sendMoneyConfirmation = '/transaction_confirmation_screen.dart';

  static const String requestMoney = '/request_money';
  static const String requestMoneyBalanceInput = '/requestMoney_balance_input';
  static const String requestMoneyConfirmation = '/requestMoney_confirmation';

  static const String cashOut = '/cash_out';
  static const String cashOutBalanceInput = '/cash_out_balance_input';
  static const String cashOutConfirmation = '/cash_out_confirmation';

  static const String addMoney = '/add_money';
  static const String addMoneyInput = '/add_money_input';
  static const String bankSelect = '/bank_select';
  static const String bankList = '/bank_listbank_list';
  static const String addMoneySuccessful = '/add_money_successful';
  static const String editProfileScreen = '/edit_profile_screen';
  static const String faq = '/faq';
  static const String aboutUs = '/about_us';
  static const String terms = '/terms';
  static const String privacy = '/privacy_policy';
  static const String requestedMoney = '/requested_money';
  static const String shareStatement = '/share_statement';
  static const String support = '/support';
  static const String choseLanguageScreen = '/chose_language_screen';
  static const String qrCodeDownloadOrShare = '/qr_code_download_or_share';

  static getSplashRoute() => splash;
  static String getHomeRoute(String name) => '$home?name=$name';

  static  getLoginRoute({required String? countryCode, required String? phoneNumber}) {
    return '$loginScreen?country-code=$countryCode&phone-number=$phoneNumber';
  }
  static  getRegistrationRoute() => createAccountScreen;
  static  getVerifyRoute({String? phoneNumber}) => '$verifyScreen?phone_number=${Uri.encodeComponent(phoneNumber ?? 'null')}';

  static  getWelcomeRoute({String? countryCode,String? phoneNumber, String? password}) {
    return '$welcomeScreen?country-code=$countryCode&phone-number=$phoneNumber&password=$password';
  }
  static  getSelfieRoute({required bool fromEditProfile}) => '$selfieScreen?page=${fromEditProfile?'edit-profile':'verify'}';
  static  getNavBarRoute() => navbar;
  static  getOtherInformationRoute() => otherInfoScreen;
  static  getPinSetRoute({required SignUpBodyModel signUpBody}) {
    String signUpData =  base64Url.encode(utf8.encode(jsonEncode(signUpBody.toJson())));
    return '$pinSetScreen?signup=$signUpData';
  }
  static  getRequestMoneyRoute({String? phoneNumber,required bool fromEdit}) => '$requestMoney?phone-number=$phoneNumber&from-edit=${fromEdit?'edit-number':'home'}';
  static  getForgetPassRoute({required String? countryCode, required String phoneNumber}) => '$fPhoneNumberScreen?country-code=$countryCode&phone-number=$phoneNumber';
  static  getRequestMoneyBalanceInputRoute() => requestMoneyBalanceInput;
  static  getRequestMoneyConfirmationRoute({required String inputBalanceText}) => '$requestMoneyConfirmation?input-balance=$inputBalanceText';
  static  getNoInternetRoute() => noInternetScreen;
  static  getChoseLoginRegRoute() => choseLoginOrRegScreen;
  static  getSendMoneyRoute({String? phoneNumber,required bool fromEdit}) => '$sendMoney?phone-number=$phoneNumber&from-edit=${fromEdit?'edit-number':'home'}';
  static  getSendMoneyInputRoute({required String transactionType}) => '$sendMoneyBalanceInput?transaction-type=$transactionType';
  static  getSendMoneyConfirmationRoute({required String inputBalanceText,required String transactionType}) => '$sendMoneyConfirmation?input-balance=$inputBalanceText&transaction-type=$transactionType';
  static  getChoseLanguageRoute() => choseLanguageScreen;
  static  getCashOutScreenRoute({String? phoneNumber,required bool fromEdit}) => '$cashOut?phone-number=$phoneNumber&from-edit=${fromEdit?'edit-number':'home'}';
  static  getCashOutBalanceInputRoute() => cashOutBalanceInput;
  static  getFResetPassRoute({String? phoneNumber, String? otp}) => '$resetPassScreen?phone-number=$phoneNumber&otp=$otp';
  static  getEditProfileRoute() => editProfileScreen;
  static  getChangePinRoute() => changePinScreen;
  static  getAddMoneyInputRoute() => addMoneyInput;
  // static  getFVerificationRoute({required String phoneNumber}) => '$fVerificationScreen?phone-number=$phoneNumber';

  static getSupportRoute() => support;
  static getCashOutConfirmationRoute({required String inputBalanceText}) => '$cashOutConfirmation?input-balance=$inputBalanceText';
  static  getShareStatementRoute({ required String amount,  required String transactionType, required ContactModel contactModel}) {
    String data =  base64Url.encode(utf8.encode(jsonEncode(contactModel.toJson())));
    String transactionType0 = base64Url.encode(utf8.encode(transactionType));
    return '$shareStatement?amount=$amount&transaction-type=$transactionType0&contact=$data';
  }
  static getQrCodeDownloadOrShareRoute({required String qrCode, required String phoneNumber}) {
    String qrCode0 = base64Url.encode(utf8.encode(qrCode));
    String phoneNumber0 = base64Url.encode(utf8.encode(phoneNumber));

    return '$qrCodeDownloadOrShare?qr-code=$qrCode0&phone-number=$phoneNumber0';
  }


  static List<GetPage> routes = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: home, page: () => const HomeScreen()),
    GetPage(name: navbar, page: () => const NavBarScreen()),
    GetPage(name: shareStatement, page: () => ShareStatementWidget(amount: Get.parameters['amount'], charge: null, trxId: null,
            transactionType: utf8.decode(base64Url.decode(Get.parameters['transaction-type']!.replaceAll(' ', '+'))), contactModel: ContactModel.fromJson(jsonDecode(utf8.decode(base64Url.decode(Get.parameters['contact']!)))))),

    GetPage(name: history, page: () => HistoryScreen()),
    GetPage(name: notification, page: () => const NotificationScreen()),
    // GetPage(name: themeAndLanguage, page: () => ThemeAndLanguage()),
    GetPage(name: profile, page: () => const ProfileScreen()),
    GetPage(name: changePinScreen, page: () => const ChangePinScreen()),
    GetPage(name: sendMoney, page: () => TransactionMoneyScreen(phoneNumber: Get.parameters['phone-number'],fromEdit: Get.parameters['from-edit']== 'edit-number')),
    GetPage(name: sendMoneyBalanceInput, page: () => TransactionBalanceInputScreen(transactionType: Get.parameters['transaction-type'])),
    GetPage(name: sendMoneyConfirmation, page: () => TransactionConfirmationScreen(inputBalance:double.tryParse(Get.parameters['input-balance']!),transactionType: Get.parameters['transaction-type'])),

    GetPage(name: choseLoginOrRegScreen, page: () => const OnBoardingScreen()),
    GetPage(name: createAccountScreen, page: () => const CreateAccountScreen()),
    GetPage(name: verifyScreen, page: () {
      final String? phoneNumber = Uri.decodeComponent(Get.parameters['phone_number']!)
          != 'null' ? Uri.decodeComponent(Get.parameters['phone_number']!) : null ;
      return VerificationScreen(
        phoneNumber: phoneNumber,
      );
    }),
    GetPage(name: selfieScreen, page: () => CameraScreen(fromEditProfile: Get.parameters['page'] == 'edit-profile')),
    GetPage(name: otherInfoScreen, page: () => const SignUpInformationScreen()),
    GetPage(name: pinSetScreen, page: () => PinSetScreen(
      signUpBody: SignUpBodyModel.fromJson(jsonDecode(utf8.decode(base64Url.decode(Get.parameters['signup']!)))),
    )),

    GetPage(name: welcomeScreen, page: () => WelcomeScreen(
      countryCode: Get.parameters['country-code']!.replaceAll(' ', '+'),
      phoneNumber: Get.parameters['phone-number'],
      password: Get.parameters['password'],
    )),
    GetPage(name: loginScreen, page: () => LoginScreen(
        countryCode: Get.parameters['country-code']!.replaceAll(' ', '+'),
        phoneNumber: Get.parameters['phone-number']),
    ),
    GetPage(name: fPhoneNumberScreen, page: () => ForgetPinScreen(countryCode: Get.parameters['country-code']!.replaceAll(' ', '+'),phoneNumber: Get.parameters['phone-number'],)),
    // GetPage(name: fVerificationScreen, page: () => PhoneVerification(phoneNumber: Get.parameters['phone-number']!.replaceAll(' ', '+'),)),
    GetPage(name: resetPassScreen, page: () => ResetPinScreen(
      phoneNumber: Get.parameters['phone-number']!.replaceAll(' ', '+'),
      otp: Get.parameters['otp']!.replaceAll(' ', '+'),
    )),
    GetPage(name: choseLanguageScreen, page: () => const ChooseLanguageScreen()),
    GetPage(name: editProfileScreen, page: () => const EditProfileScreen()),
    GetPage(name: faq, page: () => FaqScreen(title: 'faq'.tr)),
    GetPage(name: terms, page: () => HtmlViewScreen(title: 'terms'.tr, url: Get.find<SplashController>().configModel!.termsAndConditions)),
    GetPage(name: aboutUs, page: () => HtmlViewScreen(title: 'about_us'.tr, url: Get.find<SplashController>().configModel!.aboutUs)),
    GetPage(name: privacy, page: () => HtmlViewScreen(title: 'privacy_policy'.tr, url: Get.find<SplashController>().configModel!.privacyPolicy)),
    GetPage(name: support, page: () => const SupportScreen()),
    GetPage(name: qrCodeDownloadOrShare, page: () => QrCodeDownloadOrShareScreen(qrCode:  utf8.decode(base64Url.decode(Get.parameters['qr-code']!.replaceAll(' ', '+'))),
        phoneNumber: utf8.decode(base64Url.decode(Get.parameters['phone-number']!.replaceAll(' ', '+'))),)),

    ];

}