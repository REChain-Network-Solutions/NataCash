import 'package:flutter/material.dart';

import '../../util/dimensions.dart';
import '../../util/styles.dart';
import 'custom_ink_well_widget.dart';

class RoundedButtonWidget extends StatelessWidget {
  final String? buttonText;
  final Function? onTap;
  final bool isSkip;
  const RoundedButtonWidget({Key? key, this.buttonText = '', this.onTap, this.isSkip = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).secondaryHeaderColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusSizeExtraLarge),
      ),
      child: CustomInkWellWidget(
        onTap: onTap as void Function()?,
        radius: Dimensions.radiusSizeExtraLarge,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: isSkip ? Dimensions.paddingSizeExtraSmall : Dimensions.paddingSizeSmall),
          child: Text(
            buttonText!,
            style: rubikRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
            ),
          ),
        ),
      ),
    );
  }
}