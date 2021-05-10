import 'package:haraj/config/ps_colors.dart';
import 'package:haraj/constant/ps_dimens.dart';
import 'package:haraj/ui/common/ps_ui_widget.dart';
import 'package:haraj/utils/utils.dart';
import 'package:haraj/viewobject/product.dart';
import 'package:flutter/material.dart';

class HistoryListItem extends StatelessWidget {
  const HistoryListItem(
      {Key key,
      @required this.history,
      this.onTap,
      this.animationController,
      this.animation})
      : super(key: key);

  final Product history;
  final Function onTap;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    return AnimatedBuilder(
        animation: animationController,
        child: history != null
            ? InkWell(
                onTap: onTap,
                child: Container(
                  margin: const EdgeInsets.only(top: PsDimens.space8),
                  child: Ink(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _ImageAndTextWidget(
                        history: history,
                      ),
                    ),
                  ),
                ),
              )
            : Container(),
        builder: (BuildContext context, Widget child) {
          return FadeTransition(
              opacity: animation,
              child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, 100 * (1.0 - animation.value), 0.0),
                  child: child));
        });
  }
}

class _ImageAndTextWidget extends StatelessWidget {
  const _ImageAndTextWidget({
    Key key,
    @required this.history,
  }) : super(key: key);

  final Product history;

  @override
  Widget build(BuildContext context) {
    if (history != null && history.title != null) {
      return Row(
        children: <Widget>[
          Container(
            width: PsDimens.space60,
            height: PsDimens.space60,
            child: PsNetworkImage(
              photoKey: '',
              // width: PsDimens.space60,
              // height: PsDimens.space60,
              defaultPhoto: history.defaultPhoto,
            ),
          ),
          const SizedBox(
            width: PsDimens.space8,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: PsDimens.space8),
                  child: Text(
                    history.title,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ),
                const SizedBox(
                  height: PsDimens.space8,
                ),
                Text(
                  history.addedDate == ''
                      ? ''
                      : Utils.getDateFormat(history.addedDate),
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: PsColors.textPrimaryLightColor),
                ),
              ],
            ),
          )
        ],
      );
    } else {
      return Container();
    }
  }
}
