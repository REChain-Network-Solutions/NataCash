import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:six_cash/common/widgets/rotation_transition_widget.dart';


class DialogHelper {
  static void showAnimatedDialog(BuildContext context, Widget dialog, {bool isFlip = false, bool dismissible = true}) {
    showGeneralDialog(
      context: context,
      barrierDismissible: dismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      pageBuilder: (context, animation1, animation2) => dialog,
      transitionDuration: const Duration(milliseconds: 500),
      transitionBuilder: (context, a1, a2, widget) {
        if(isFlip) {
          return RotationTransitionWidget(
            alignment: Alignment.center,
            turns: Tween<double>(begin: math.pi, end: 2.0 * math.pi).animate(CurvedAnimation(parent: a1, curve: const Interval(0.0, 1.0, curve: Curves.linear))),
            child: FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: a1, curve: const Interval(0.5, 1.0, curve: Curves.elasticOut))),
              child: widget,
            ),
          );
        }else {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: widget,
            ),
          );
        }
      },
    );
  }

}