import 'dart:io';

import 'package:haraj/config/ps_colors.dart';
import 'package:haraj/constant/ps_dimens.dart';
import 'package:flutter/material.dart';

class PsBackButtonWithCircleBgWidget extends StatelessWidget {
  const PsBackButtonWithCircleBgWidget({Key key, this.isReadyToShow})
      : super(key: key);

  final bool isReadyToShow;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isReadyToShow,
      child: Container(
        margin: const EdgeInsets.only(
            left: PsDimens.space8, right: PsDimens.space4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: PsColors.black.withAlpha(100),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Platform.isIOS ? 
          Padding(
            padding: EdgeInsets.only(left: Platform.isIOS ? PsDimens.space8 : PsDimens.space1),
            child: InkWell(
                child: Icon(
                  Icons.arrow_back_ios,
                  color: PsColors.white,
                ),
                onTap: () {
                  Navigator.pop(context);
                }),
          ):
          Padding(
            padding: const EdgeInsets.only(right: PsDimens.space4),
            child: InkWell(
                child: Icon(
                  Icons.arrow_back,
                  color: PsColors.white,
                ),
                onTap: () {
                  Navigator.pop(context);
                }),
          ),
        ),
      ),
    );
  }
}
