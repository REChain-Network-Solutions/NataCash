
import 'package:flutter/cupertino.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

class PhoneCheckerHelper {
  static Future<PhoneNumber?> isNumberValid(String phone) async {
    PhoneNumber? num;
    try{
      num = PhoneNumber.parse(phone);

    }catch(e){
      debugPrint('error ---> $e');
    }
    return num ;
  }
}