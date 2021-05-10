import 'package:flutter_icons/flutter_icons.dart';
import 'package:haraj/config/ps_colors.dart';
import 'package:haraj/constant/ps_constants.dart';
import 'package:haraj/constant/ps_dimens.dart';
import 'package:haraj/constant/route_paths.dart';
import 'package:haraj/ui/common/ps_expansion_tile.dart';
import 'package:haraj/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:haraj/viewobject/holder/intent_holder/map_pin_intent_holder.dart';
import 'package:haraj/viewobject/product.dart';

class LocationTileView extends StatefulWidget {
  const LocationTileView({
    Key key,
    @required this.item,
  }) : super(key: key);

  final Product item;

  @override
  _LocationTileViewState createState() => _LocationTileViewState();
}

class _LocationTileViewState extends State<LocationTileView> {
  @override
  Widget build(BuildContext context) {
    final Widget _expansionTileTitleWidget = Text(
        Utils.getString(context, 'location_tile__title'),
        style: Theme.of(context).textTheme.subtitle1);

    final Widget _expansionTileLeadingWidget = Icon(
      SimpleLineIcons.location_pin,
      color: PsColors.mainColor,
    );
    // if (productDetail != null && productDetail.description != null) {
    return Container(
      margin: const EdgeInsets.only(
          left: PsDimens.space8,
          right: PsDimens.space8,
          bottom: PsDimens.space8),
      decoration: BoxDecoration(
        color: PsColors.backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(PsDimens.space8)),
      ),
      child: PsExpansionTile(
        initiallyExpanded: true,
        leading: _expansionTileLeadingWidget,
        title: _expansionTileTitleWidget,
        children: <Widget>[
          Column(
            children: <Widget>[
              const Divider(
                height: PsDimens.space1,
              ),
              // const SizedBox(height: PsDimens.space16),
             /* Padding(
                padding: const EdgeInsets.all(PsDimens.space16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Entypo.address,
                      size: PsDimens.space20,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    const SizedBox(width: PsDimens.space8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(Utils.getString(context, 'item_detail__address'),
                              style: Theme.of(context).textTheme.bodyText1),
                          const SizedBox(height: PsDimens.space8),
                          Text(widget.item.address,
                              style: Theme.of(context).textTheme.bodyText1),
                        ],
                      ),
                    )
                  ],
                ),
              ),
*/
              // const Divider(
              //   height: PsDimens.space1,
              // ),
            ],
          ),
        ],
      ),
    );
    // } else {
    //   return const Card();
    // }
  }
}
