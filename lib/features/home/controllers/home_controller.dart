import 'package:get/get.dart';

class HomeController extends GetxController implements GetxService{

  ///Hero tag
   final String _heroShowQr = 'show-qr-hero';
   String get heroShowQr => _heroShowQr;

   ///Greetings

   String greetingMessage(){

     var timeNow = DateTime.now().hour;

     if (timeNow <= 12) {
       return 'good_morning'.tr;
     } else if ((timeNow > 12) && (timeNow <= 16)) {
       return 'good_afternoon'.tr;
     } else if ((timeNow > 16) && (timeNow < 20)) {
       return 'good_evening'.tr;
     } else {
       return 'good_night'.tr;
     }
   }


}