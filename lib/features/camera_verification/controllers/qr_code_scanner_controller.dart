import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:six_cash/common/models/contact_model.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/features/transaction_money/screens/transaction_balance_input_screen.dart';

class QrCodeScannerController extends GetxController implements GetxService{

  bool _isBusy = false;
  bool _isDetect = false;

  String? _name;
  String? _phone;
  String? _type;
  String? _image;

  String? get name => _name;
  String? get phone => _phone;
  String? get type => _type;
  String? get image => _image;
  String? _transactionType;
  String? get transactionType => _transactionType;



  Future<void> processImage(InputImage inputImage,  bool isHome, String? transactionType) async {
    final BarcodeScanner barcodeScanner = BarcodeScanner();
    if (_isBusy) return;
    _isBusy = true;

    final barcodes = await barcodeScanner.processImage(inputImage);
    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      for (final barcode in barcodes) {
        _name = jsonDecode(barcode.rawValue!)['name'];
        _phone = jsonDecode(barcode.rawValue!)['phone'];
        _type = jsonDecode(barcode.rawValue!)['type'];
        _image = jsonDecode(barcode.rawValue!)['image'];
        if(_name != null && _phone != null && _type != null && _image != null) {
          if(_type == "customer"){
            _transactionType = transactionType;
          }else if(_type == "agent"){
            _transactionType = "cash_out";
          }
          if(isHome && _type != "agent"){
            if(!_isDetect) {
              Get.defaultDialog(
                title: 'select_a_transaction'.tr,
                content: TransactionSelect(contactModel: ContactModel(phoneNumber: _phone, name: _name,avatarImage: _image)),
                barrierDismissible: false,
                radius: Dimensions.radiusSizeDefault,
              ).then((value) {
                _isDetect = false;
              });
            }
            _isDetect = true;

          }else {
            Get.to(()=>  TransactionBalanceInputScreen(transactionType: _transactionType,contactModel: ContactModel(phoneNumber: _phone, name: _name, avatarImage: _image)));
          }

        }
      }

    } else {
    }
    _isBusy = false;
  }

}

class TransactionSelect extends StatelessWidget {
  final ContactModel? contactModel;
  const TransactionSelect({Key? key, this.contactModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ListTile(title: Text('send_money'.tr), minVerticalPadding: 0,
          onTap: () =>  Get.off(()=>  TransactionBalanceInputScreen(transactionType: 'send_money',contactModel: contactModel))),

        ListTile(title: Text('request_money'.tr), minVerticalPadding: 0,
          onTap: () =>  Get.off(()=>  TransactionBalanceInputScreen(transactionType: 'request_money',contactModel: contactModel))),
      ],
    );
  }
}
