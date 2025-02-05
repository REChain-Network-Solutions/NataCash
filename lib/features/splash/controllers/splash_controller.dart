import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:six_cash/data/api/api_checker.dart';
import 'package:six_cash/common/models/config_model.dart';
import 'package:six_cash/features/splash/domain/reposotories/splash_repo.dart';

class SplashController extends GetxController implements GetxService{
   final SplashRepo splashRepo;
  SplashController({required this.splashRepo});

  ConfigModel? _configModel;

  final DateTime _currentTime = DateTime.now();

  DateTime get currentTime => _currentTime;
  bool _firstTimeConnectionCheck = true;
  bool get firstTimeConnectionCheck => _firstTimeConnectionCheck;

  ConfigModel? get configModel => _configModel;

  Future<Response> getConfigData() async {
    Response response = await splashRepo.getConfigData();
    if(response.statusCode == 200){
      _configModel =  ConfigModel.fromJson(response.body);
    }
   else {
     ApiChecker.checkApi(response);
   }
    update();
    return response;

  }

  Future<bool> initSharedData() {
    return splashRepo.initSharedData();
  }

   void removeSharedData() {
    return splashRepo.removeSharedData();
  }

  bool isRestaurantClosed() {
    DateTime open = DateFormat('hh:mm').parse('');
    DateTime close = DateFormat('hh:mm').parse('');
    DateTime openTime = DateTime(_currentTime.year, _currentTime.month, _currentTime.day, open.hour, open.minute);
    DateTime closeTime = DateTime(_currentTime.year, _currentTime.month, _currentTime.day, close.hour, close.minute);
    if(closeTime.isBefore(openTime)) {
      closeTime = closeTime.add(const Duration(days: 1));
    }
    if(_currentTime.isAfter(openTime) && _currentTime.isBefore(closeTime)) {
      return false;
    }else {
      return true;
    }
  }


  void setFirstTimeConnectionCheck(bool isChecked) {
    _firstTimeConnectionCheck = isChecked;
  }

}
