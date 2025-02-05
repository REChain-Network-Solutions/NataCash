import 'package:flutter/material.dart';


class RotationTransitionWidget extends AnimatedWidget {
  const RotationTransitionWidget({
    Key? key,
    required Animation<double> turns,
    this.alignment = Alignment.center,
    this.child,
  })  : super(key: key, listenable: turns);

  Animation<double> get turns => listenable as Animation<double>;

  final Alignment alignment;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final double turnsValue = turns.value;
    final Matrix4 transform = Matrix4.identity()
      ..setEntry(3, 2, 0.0006)
      ..rotateY(turnsValue);
    return Transform(
      transform: transform,
      alignment: const FractionalOffset(0.5, 0.5),
      child: child,
    );
  }
}