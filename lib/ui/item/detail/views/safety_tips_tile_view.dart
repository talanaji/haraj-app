import 'package:flutter_icons/flutter_icons.dart';
import 'package:haraj/config/ps_colors.dart';
import 'package:haraj/constant/ps_dimens.dart';
import 'package:haraj/constant/route_paths.dart';
import 'package:haraj/provider/about_us/about_us_provider.dart';
import 'package:haraj/ui/common/ps_expansion_tile.dart';
import 'package:haraj/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:haraj/viewobject/holder/intent_holder/safety_tips_intent_holder.dart';
import 'package:provider/provider.dart';

class SafetyTipsTileView extends StatelessWidget {
  const SafetyTipsTileView({
    Key key,
    @required this.animationController,
  }) : super(key: key);

  final AnimationController animationController;
  @override
  Widget build(BuildContext context) {
    final Widget _expansionTileTitleWidget = Text(
        Utils.getString(context, 'safety_tips_tile__title'),
        style: Theme.of(context).textTheme.subtitle1);

    final Widget _expansionTileLeadingIconWidget = Icon(
      FontAwesome.shield,
      color: PsColors.mainColor,
    );

    return Consumer<AboutUsProvider>(builder:
        (BuildContext context, AboutUsProvider aboutUsProvider, Widget gchild) {
      if (aboutUsProvider != null &&
          aboutUsProvider.aboutUsList != null &&
          aboutUsProvider.aboutUsList.data.isNotEmpty) {
        return Container(
          margin: const EdgeInsets.only(
              left: PsDimens.space8,
              right: PsDimens.space8,
              bottom: PsDimens.space8),
          decoration: BoxDecoration(
            color: PsColors.backgroundColor,
            borderRadius:
                const BorderRadius.all(Radius.circular(PsDimens.space8)),
          ),
          child: PsExpansionTile(
            initiallyExpanded: true,
            leading: _expansionTileLeadingIconWidget,
            title: _expansionTileTitleWidget,
            children: <Widget>[
              Column(
                children: <Widget>[
                  const Divider(
                    height: PsDimens.space1,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(PsDimens.space8),
                    child: Text(aboutUsProvider.aboutUsList.data[0].safetyTips,
                        maxLines: 3,
                        style: Theme.of(context).textTheme.bodyText1),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(PsDimens.space8),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, RoutePaths.safetyTips,
                            arguments: SafetyTipsIntentHolder(
                                animationController: animationController,
                                safetyTips: aboutUsProvider
                                    .aboutUsList.data[0].safetyTips));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            Utils.getString(
                                context, 'safety_tips_tile__read_more_button'),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(color: PsColors.mainColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      } else {
        return Container();
      }
    });
  }
}
