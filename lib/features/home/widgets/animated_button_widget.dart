import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/images.dart';
import 'package:six_cash/util/styles.dart';

class AnimatedButtonWidget extends StatefulWidget {
  final Function onTap;
  const AnimatedButtonWidget({Key? key,required this.onTap}) : super(key: key);

  @override
  State<AnimatedButtonWidget> createState() => _AnimatedButtonWidgetState();
}

class _AnimatedButtonWidgetState extends State<AnimatedButtonWidget> {

  double _width = Get.width * 0.11;
  double _textWidth = 0;
  final double _height = Get.width * 0.11;

  @override
  void initState() {

    Future.delayed(const Duration(milliseconds: 500)).then((value){
      setState(() {
        _width = Get.width * 0.25;

      });
    });
    Future.delayed(const Duration(milliseconds: 700)).then((value){
      setState(() {
        _textWidth = Get.width * 0.16;

      });
    });

    Future.delayed(const Duration(seconds: 4)).then((value) {
      setState(() {
        _width = Get.width * 0.12;
        _textWidth = 0;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap as void Function()?,
      child: AnimatedContainer(
        width: _width,
        height: _height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(_height/2)),
          color: Theme.of(context).cardColor.withOpacity(Get.isDarkMode ?  0.7 : 1),
        ),
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          const SizedBox(),
          Image.asset(
            Images.withdraw, height: IconTheme.of(context).size,
          ),

          AnimatedContainer(
            width: _textWidth,
            duration: const Duration(milliseconds: 500),
            child: Text(
              'withdraw_request'.tr, maxLines: 2,
              textAlign: TextAlign.center,
              style: rubikLight.copyWith(fontSize: Dimensions.fontSizeSmall),
            ),
          ),

        ]),
      ),
    );
  }
}
