import 'package:get/get.dart';

class OnBoardingController extends GetxController implements GetxService {
  int _page = 0;

  int get page => _page;

 void updatePageIndex(int a) {
    _page = a;
    update();
  }

}