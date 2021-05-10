import 'package:fluttertoast/fluttertoast.dart';
import 'package:haraj/api/common/ps_resource.dart';
import 'package:haraj/config/ps_colors.dart';
import 'package:haraj/constant/ps_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haraj/constant/ps_dimens.dart';
import 'package:haraj/constant/route_paths.dart';
import 'package:haraj/provider/history/history_provider.dart';
import 'package:haraj/provider/product/added_item_provider.dart';
import 'package:haraj/provider/product/product_provider.dart';
import 'package:haraj/ui/common/dialog/confirm_dialog_view.dart';
import 'package:haraj/ui/common/ps_hero.dart';
import 'package:haraj/ui/common/ps_ui_widget.dart';
import 'package:haraj/utils/utils.dart';
import 'package:haraj/viewobject/api_status.dart';
import 'package:haraj/viewobject/color.dart';
import 'package:haraj/viewobject/holder/intent_holder/item_entry_intent_holder.dart';
import 'package:haraj/viewobject/holder/user_delete_item_parameter_holder.dart';
import 'package:haraj/viewobject/product.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

import '../../../provider/blog/blog_provider.dart';
import '../../../repository/blog_repository.dart';

class ProductVeticalListItemForProfile extends StatefulWidget {
  const ProductVeticalListItemForProfile(
      {Key key,
      @required this.product,
      @required this.productId,
      this.onTap,
      this.provider,
      this.animationController,
      this.animation,
      this.coreTagKey})
      : super(key: key);
  final Product product;
  final AddedItemProvider provider;
  final Function onTap;
  final AnimationController animationController;
  final Animation<double> animation;
  final String coreTagKey;
  final String productId;

  @override
  _ProductVeticalListItemForProfileView createState() =>
      _ProductVeticalListItemForProfileView();
}

class _ProductVeticalListItemForProfileView
    extends State<ProductVeticalListItemForProfile>
    with TickerProviderStateMixin {
  int flagClicked = 0;
  bool isAddedToHistory = false;
  HistoryProvider historyProvider;
  BlogProvider blogProvider;
  BlogRepository repo1;
  @override
  Widget build(BuildContext context) {
    //print("${PsConfig.ps_app_image_thumbs_url}${subCategory.defaultPhoto.imgPath}");
    widget.animationController.forward();
    repo1 = Provider.of<BlogRepository>(context);
    blogProvider = BlogProvider(repo: repo1);
    return InkWell(
      onTap: () {
        setState(() {
          if (flagClicked == 0)
            flagClicked = 1;
          else
            flagClicked = 0;
        });
      },
      child: Card(
        elevation: 3.0,
        //color: PsColors.transparent,

        child: Container(
          decoration: BoxDecoration(
            color: PsColors.backgroundColor,
            borderRadius:
                const BorderRadius.all(Radius.circular(PsDimens.space8)),
          ),
          width: MediaQuery.of(context).size.width * .9,
          height: 150,
          padding: EdgeInsets.all(0),
          // child:
          //  ClipPath(
          // child: Container(
          //   // color: Colors.white,
          //   width: PsDimens.space180,
          child: Stack(
            children: <Widget>[
              Container(
                width: (flagClicked == 1)
                    ? MediaQuery.of(context).size.width * .8
                    : null,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        left: PsDimens.space4,
                        top: PsDimens.space4,
                        right: PsDimens.space8,
                        bottom: PsDimens.space4,
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: PsDimens.space80,
                            height: PsDimens.space80,
                            child: PsNetworkCircleImageForUser(
                              photoKey:
                                  '$widget.coreTagKey${PsConst.HERO_TAG__IMAGE}',
                              imagePath: widget.product.defaultPhoto.imgPath,
                              // width: PsDimens.space40,
                              // height: PsDimens.space40,
                              boxfit: BoxFit.cover,
                              onTap: () {
                                Utils.psPrint(
                                    widget.product.defaultPhoto.imgParentId);
                                widget.onTap();
                              },
                            ),
                          ),
                          const SizedBox(width: PsDimens.space8),
                          Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: PsDimens.space8,
                                      top: PsDimens.space8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(widget.product.title,
                                          textAlign: TextAlign.start,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1),
                                      Text('${widget.product.description}',
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption)
                                    ],
                                  )))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: PsDimens.space4,
                        top: PsDimens.space4,
                        right: PsDimens.space8,
                        bottom: PsDimens.space4,
                      ),
                      child: Row(
                        children: <Widget>[
                          if (flagClicked == 0)
                            Container(
                              width: MediaQuery.of(context).size.width * .20,
                              child: Row(
                                children: [
                                  Icon(
                                    PsColors.location,
                                    color: PsColors.mainColor,
                                    size: 16,
                                  ),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          MediaQuery.of(context).size.width *
                                              .01,
                                          0,
                                          0,
                                          0)),
                                  Text(widget.product.itemLocation.name,style: TextStyle(fontSize: 12)),
                                ],
                              ),
                            )
                          else
                            Container(),
                          Container(
                            width: MediaQuery.of(context).size.width * .20,
                            child: Row(
                              children: [
                                Icon(PsColors.group__2,
                                    color: PsColors.mainColor, size: 20),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        MediaQuery.of(context).size.width * .01,
                                        0,
                                        0,
                                        0)),
                                Text(widget.product.price,style: TextStyle(fontSize: 12)),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * .35,
                            child: Row(
                              children: [
                                Icon(FlutterIcons.tag_outline_mco,
                                    color: PsColors.mainColor, size: 20),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        MediaQuery.of(context).size.width * .01,
                                        0,
                                        0,
                                        0)),
                                Text(
                                  widget.product.manufacturer.name,
                                  overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 12)
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * .15,
                            child: Row(
                              children: [
                                Icon(PsColors.messages_icon,
                                    color: PsColors.mainColor, size: 20),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        MediaQuery.of(context).size.width * .01,
                                        0,
                                        0,
                                        0)),
                                ChangeNotifierProvider<BlogProvider>(
                                  lazy: false,
                                  create: (BuildContext context) {
                                    final BlogProvider provider =
                                        BlogProvider(repo: repo1);
                                    provider.loadBlogList(widget.productId);
                                    blogProvider = provider;
                                    return blogProvider;
                                  },
                                  child: Consumer<BlogProvider>(builder:
                                      (BuildContext context,
                                          BlogProvider blogProvider,
                                          Widget child) {
                                    return Text(
                                        "${blogProvider.blogList.data.length}",style: TextStyle(fontSize: 12));
                                  }),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (flagClicked == 1)
                Positioned(
                  top: 0,
                  left: 0,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                            child: Container(
                                color: Color(0xff06B1A5),
                                height: 150,
                                width: MediaQuery.of(context).size.width * .13,
                                alignment: Alignment.center,
                                child: Text("تعديل",
                                    style: TextStyle(color: PsColors.white))),
                            onTap: () {
                              Navigator.pushNamed(context, RoutePaths.itemEntry,
                                  arguments: ItemEntryIntentHolder(
                                      flag: PsConst.EDIT_ITEM,
                                      item: widget.product));
                            }),
                        InkWell(
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Color(0xff0EA298),
                                borderRadius: const BorderRadius.only(
                                    topLeft: const Radius.circular(5),
                                    bottomLeft: const Radius.circular(5))),
                            height: 150,
                            width: MediaQuery.of(context).size.width * .13,
                            child: Text(
                              "حذف",
                              style: TextStyle(color: PsColors.white),
                            ),
                          ),
                          onTap: () async {
                            showDialog<dynamic>(
                                context: context,
                                builder: (BuildContext context) {
                                  return ConfirmDialogView(
                                      description: Utils.getString(
                                          context, 'item_detail__delete_desc'),
                                      leftButtonText: Utils.getString(
                                          context, 'dialog__cancel'),
                                      rightButtonText: Utils.getString(
                                          context, 'dialog__ok'),
                                      onAgreeTap: () async {
                                        final UserDeleteItemParameterHolder
                                            userDeleteItemParameterHolder =
                                            UserDeleteItemParameterHolder(
                                          itemId: widget.product.id,
                                        );

                                        final PsResource<ApiStatus> _apiStatus =
                                            await widget.provider.userDeleteItem(
                                                userDeleteItemParameterHolder
                                                    .toMap());
                                        if (_apiStatus.data.status ==
                                            'success') {
                                          Fluttertoast.showToast(
                                              msg: 'Item Deleated',
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor:
                                                  Color(0xFF607D8B),
                                              textColor: PsColors.white);
                                          // Navigator.pop(context, true);
                                          Navigator.pushReplacementNamed(
                                            context,
                                            RoutePaths.home,
                                          );
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: 'Item is not Deleated',
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor:
                                                  Color(0xFF607D8B),
                                              textColor: PsColors.white);
                                        }
                                      });
                                });
                          },
                        ),
                      ]),
                )
              else
                Container(),
            ],
          ),
          // ),
          // clipper: ShapeBorderClipper(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
        ),
      ),
    );
    /*return AnimatedBuilder(
        animation: animationController,
        child: InkWell(
          onTap: onTap,
          child: GridTile(
            header: Container(
              padding: const EdgeInsets.all(PsDimens.space8),
              child: Ink(
                color: PsColors.backgroundColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ),
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: PsDimens.space8, vertical: PsDimens.space8),
              decoration: BoxDecoration(
                color: PsColors.backgroundColor,
                borderRadius:
                    const BorderRadius.all(Radius.circular(PsDimens.space8)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        left: PsDimens.space4,
                        top: PsDimens.space4,
                        right: PsDimens.space8,
                        bottom: PsDimens.space4,
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: PsDimens.space40,
                            height: PsDimens.space40,
                            child: PsNetworkCircleImageForUser(
                              photoKey: '',
                              imagePath: product.user.userProfilePhoto,
                              // width: PsDimens.space40,
                              // height: PsDimens.space40,
                              boxfit: BoxFit.cover,
                              onTap: () {
                                Utils.psPrint(product.defaultPhoto.imgParentId);
                                onTap();
                              },
                            ),
                          ),
                          const SizedBox(width : PsDimens.space8),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: PsDimens.space8,
                                  top: PsDimens.space8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(product.user.userName == ''?
                                    Utils.getString(context, 'default__user_name'):
                                    '${product.user.userName}',
                                      textAlign: TextAlign.start,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1),
                                    Text('${product.addedDateStr}',
                                        textAlign: TextAlign.start,
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    // Stack(
                    //   children: <Widget>[
                    Expanded(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            width: PsDimens.space180,
                            height: double.infinity,
                            child: PsNetworkImage(
                              photoKey: '$coreTagKey${PsConst.HERO_TAG__IMAGE}',
                              defaultPhoto: product.defaultPhoto,
                              // width: PsDimens.space180,
                              // height: double.infinity,
                              boxfit: BoxFit.cover,
                              onTap: () {
                                Utils.psPrint(product.defaultPhoto.imgParentId);
                                onTap();
                              },
                            ),
                          ),
                          Positioned(
                              bottom: 0,
                              child: product.isSoldOut == '1'
                                  ? Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: PsDimens.space8),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                              Utils.getString(context,
                                                  'dashboard__sold_out'),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                                  .copyWith(
                                                      color: PsColors.white)),
                                        ),
                                      ),
                                      height: 30,
                                      width: PsDimens.space180,
                                      decoration: BoxDecoration(
                                          color: PsColors.soldOutUIColor),
                                    )
                                  : Container()
                              //   )
                              // ],
                              ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                          left: PsDimens.space8,
                          top: PsDimens.space8,
                          right: PsDimens.space8,
                          bottom: PsDimens.space4),
                      child: PsHero(
                        tag: '$coreTagKey$PsConst.HERO_TAG__TITLE',
                        child: Text(
                          product.title,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyText2,
                          maxLines: 1,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: PsDimens.space8,
                          top: PsDimens.space4,
                          right: PsDimens.space8),
                      child: Row(
                        children: <Widget>[
                          PsHero(
                            tag: '$coreTagKey$PsConst.HERO_TAG__UNIT_PRICE',
                            flightShuttleBuilder: Utils.flightShuttleBuilder,
                            child: Material(
                              type: MaterialType.transparency,
                              child: Text(
                                 product != null &&  product.price != '0' && product.price != ''
                                      ? '${product.itemCurrency.currencySymbol}${Utils.getPriceFormat(product.price)}'
                                      : Utils.getString(
                                          context, 'item_price_free'),
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .copyWith(color: PsColors.mainColor)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: PsDimens.space8,
                          top: PsDimens.space8,
                          right: PsDimens.space8,
                          bottom: PsDimens.space4),
                      child: Row(
                        children: <Widget>[
                          Image.asset(
                            'assets/images/baseline_pin_black_24.png',
                            width: PsDimens.space10,
                            height: PsDimens.space10,
                            fit: BoxFit.contain,

                            // ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: PsDimens.space8,
                                  right: PsDimens.space8),
                              child: Text('${product.itemLocation.name}',
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context).textTheme.caption))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: PsDimens.space8,
                          right: PsDimens.space8,
                          bottom: PsDimens.space16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                width: PsDimens.space8,
                                height: PsDimens.space8,
                                decoration: BoxDecoration(
                                    color: PsColors.itemTypeColor,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(PsDimens.space4))),
                              ),
                              */
    /*Padding(
                                  padding: const EdgeInsets.only(
                                      left: PsDimens.space8,
                                      right: PsDimens.space4),
                                  child: Text('${product.itemType.name}',
                                      textAlign: TextAlign.start,
                                      style:
                                          Theme.of(context).textTheme.caption))*/
    /*
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Image.asset(
                                'assets/images/baseline_favourite_grey_24.png',
                                width: PsDimens.space10,
                                height: PsDimens.space10,
                                fit: BoxFit.contain,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: PsDimens.space4,
                                ),
                                child: Text('${product.favouriteCount}',
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context).textTheme.caption),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        builder: (BuildContext context, Widget child) {
          return FadeTransition(
              opacity: animation,
              child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, 100 * (1.0 - animation.value), 0.0),
                  child: child));
        });*/
  }
}
