import 'package:six_cash/data/api/api_checker.dart';
import 'package:six_cash/features/home/domain/models/banner_model.dart';
import 'package:six_cash/features/home/domain/reposotories/banner_repo.dart';
import 'package:get/get.dart';

class BannerController extends GetxController implements GetxService {
  final BannerRepo bannerRepo;
  BannerController({required this.bannerRepo});


  List<BannerModel>? _bannerList;
  int _bannerActiveIndex = 0;

  List<BannerModel>? get bannerList => _bannerList;
  int get bannerActiveIndex => _bannerActiveIndex;


  Future getBannerList(bool reload, {bool isUpdate = true})async{
    if(_bannerList == null || reload) {
      _bannerList = null;
      if (isUpdate) {
        update();
      }
    }
    if (_bannerList == null) {
      Response response = await bannerRepo.getBannerList();
      if (response.statusCode == 200) {
        _bannerList = [];
        response.body.forEach((banner) {
          _bannerList!.add(BannerModel.fromJson(banner));
        });
      } else {
        _bannerList = [];
        ApiChecker.checkApi(response);
      }
      update();
    }
  }


  void updateBannerActiveIndex(int index) {
    _bannerActiveIndex = index;
    update();
  }
}