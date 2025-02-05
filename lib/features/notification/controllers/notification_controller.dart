import 'package:six_cash/data/api/api_checker.dart';
import 'package:six_cash/features/notification/domain/models/notification_model.dart';
import 'package:get/get.dart';
import 'package:six_cash/features/notification/domain/reposotories/notification_repo.dart';

class NotificationController extends GetxController implements GetxService {
  final NotificationRepo notificationRepo;
  NotificationController({required this.notificationRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Notifications> _notificationList = [];
  List<Notifications> get notificationList => _notificationList;

  NotificationModel? _notificationModel;
  NotificationModel? get notificationModel => _notificationModel;

  Future getNotificationList(bool reload, {int offset = 1}) async{

    if(reload){
      _notificationModel = null;
      _notificationList = [];
    }

    if(_notificationModel == null || offset != 1){
      Response response = await notificationRepo.getNotificationList(offset);
      if(response.body != null && response.body != {} && response.statusCode == 200){
        _notificationModel = NotificationModel.fromJson(response.body);

        if(offset != 1){
          _notificationList.addAll( _notificationModel?.notifications ?? [] );
        }else{
          _notificationList = [];
          _notificationList.addAll( _notificationModel?.notifications ?? [] );
        }
      }else {
        ApiChecker.checkApi(response);
      }
      _isLoading = false;
      update();
    }

  }
}