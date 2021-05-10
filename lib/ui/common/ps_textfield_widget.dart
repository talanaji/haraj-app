import 'package:haraj/config/ps_colors.dart';
import 'package:haraj/constant/ps_dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PsTextFieldWidget extends StatelessWidget {
  const PsTextFieldWidget(
      {this.textEditingController,
      this.titleText = '',
      this.hintText,
      this.textAboutMe = false,
      this.height = PsDimens.space44,
      this.showTitle = true,
      this.keyboardType = TextInputType.text,
      this.isStar = false});

  final TextEditingController textEditingController;
  final String titleText;
  final String hintText;
  final double height;
  final bool textAboutMe;
  final TextInputType keyboardType;
  final bool showTitle;

  final bool isStar;

  @override
  Widget build(BuildContext context) {
    final Widget _productTextWidget =
        Text(titleText, style: Theme.of(context).textTheme.bodyText2);

    return Column(
      children: <Widget>[
        if (showTitle)
          Container(
            margin: const EdgeInsets.only(
                left: PsDimens.space8,
                top: PsDimens.space8,
                right: PsDimens.space8),
            child: Row(
              children: <Widget>[
                if (isStar)
                  Row(
                    children: <Widget>[
                      Text(titleText,
                          style: Theme.of(context).textTheme.bodyText2),
                      Text(' *',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(color: PsColors.mainColor))
                    ],
                  )
                else
                  _productTextWidget
              ],
            ),
          )
        else
          Container(
            height: 0,
          ),
        Container(
            width: double.infinity,
            height: height,
            margin: const EdgeInsets.all(PsDimens.space8),
            decoration: BoxDecoration(
              color: PsColors.backgroundColor,
              borderRadius: BorderRadius.circular(PsDimens.space4),
              border: Border.all(color: PsColors.mainDividerColor),
            ),
            child: TextField(
                keyboardType: keyboardType,
                maxLines: null,
                textDirection: TextDirection.ltr,
                textAlign: Directionality.of(context) == TextDirection.ltr
                    ? TextAlign.left
                    : TextAlign.right,
                controller: textEditingController,
                style: Theme.of(context).textTheme.bodyText1,
                decoration: textAboutMe
                    ? InputDecoration(
                        contentPadding: const EdgeInsets.only(
                          left: PsDimens.space8,
                          bottom: PsDimens.space8,
                          top: PsDimens.space10,
                        ),
                        border: InputBorder.none,
                        hintText: hintText,
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: PsColors.textPrimaryLightColor),
                      )
                    : InputDecoration(
                        contentPadding: const EdgeInsets.only(
                          left: PsDimens.space8,
                          bottom: PsDimens.space8,
                        ),
                        border: InputBorder.none,
                        hintText: hintText,
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: PsColors.textPrimaryLightColor),
                      ))),
      ],
    );
  }
}
