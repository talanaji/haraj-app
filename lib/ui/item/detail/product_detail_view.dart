import 'dart:async';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:haraj/api/common/ps_resource.dart';
import 'package:haraj/api/common/ps_status.dart';
import 'package:haraj/config/ps_colors.dart';
import 'package:haraj/constant/ps_constants.dart';
import 'package:haraj/constant/ps_dimens.dart';
import 'package:haraj/constant/route_paths.dart';
import 'package:haraj/provider/about_us/about_us_provider.dart';
import 'package:haraj/provider/app_info/app_info_provider.dart';
import 'package:haraj/provider/history/history_provider.dart';
import 'package:haraj/provider/product/favourite_item_provider.dart';
import 'package:haraj/provider/product/product_provider.dart';
import 'package:haraj/provider/product/touch_count_provider.dart';
import 'package:haraj/provider/user/user_provider.dart';
import 'package:haraj/repository/about_us_repository.dart';
import 'package:haraj/repository/app_info_repository.dart';
import 'package:haraj/repository/history_repsitory.dart';
import 'package:haraj/repository/product_repository.dart';
import 'package:haraj/repository/user_repository.dart';
import 'package:haraj/ui/blog/entry/comment_entry_container.dart';
import 'package:haraj/ui/blog/entry/comment_entry_view.dart';
import 'package:haraj/ui/blog/list/blog_list_container.dart';
import 'package:haraj/ui/blog/list/blog_list_view.dart';
import 'package:haraj/ui/common/base/ps_widget_with_appbar_and_multi_provider.dart';
import 'package:haraj/ui/common/base/ps_widget_with_multi_provider.dart';
import 'package:haraj/ui/common/dialog/confirm_dialog_view.dart';
import 'package:haraj/ui/common/ps_back_button_with_circle_bg_widget.dart';
import 'package:haraj/ui/common/ps_button_widget.dart';
import 'package:haraj/ui/common/ps_expansion_tile.dart';
import 'package:haraj/ui/common/ps_hero.dart';
import 'package:haraj/ui/common/ps_ui_widget.dart';
import 'package:haraj/ui/item/detail/views/location_tile_view.dart';
import 'package:haraj/ui/item/detail/views/safety_tips_tile_view.dart';
import 'package:haraj/ui/item/detail/views/seller_info_tile_view.dart';
import 'package:haraj/ui/item/detail/views/static_tile_view.dart';
import 'package:haraj/ui/rating/item/rating_list_item.dart';
import 'package:haraj/utils/utils.dart';
import 'package:haraj/viewobject/api_status.dart';
import 'package:haraj/viewobject/blog.dart';
import 'package:haraj/viewobject/common/ps_value_holder.dart';
import 'package:haraj/viewobject/holder/favourite_parameter_holder.dart';
import 'package:haraj/viewobject/holder/intent_holder/chat_history_intent_holder.dart';
import 'package:haraj/viewobject/holder/intent_holder/item_entry_intent_holder.dart';
import 'package:haraj/viewobject/holder/intent_holder/user_intent_holder.dart';
import 'package:haraj/viewobject/holder/touch_count_parameter_holder.dart';
import 'package:haraj/viewobject/holder/user_block_parameter_holder.dart';
import 'package:haraj/viewobject/holder/user_delete_item_parameter_holder.dart';
import 'package:haraj/viewobject/holder/user_report_item_parameter_holder.dart';
import 'package:haraj/viewobject/product.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:haraj/ui/common/dialog/choose_payment_type_dialog.dart';
import '../../../utils/ps_progress_dialog.dart';

class ProductDetailView extends StatefulWidget {
  const ProductDetailView(
      {@required this.productId,
      @required this.heroTagImage,
      @required this.productTitle,
      @required this.heroTagTitle});

  final String productId;
  final String heroTagImage;
  final String productTitle;
  final String heroTagTitle;
  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetailView>
    with SingleTickerProviderStateMixin {
  ProductRepository productRepo;
  HistoryRepository historyRepo;
  HistoryProvider historyProvider;
  AppInfoProvider appInfoProvider;
  AppInfoRepository appInfoRepository;
  TouchCountProvider touchCountProvider;
  PsValueHolder psValueHolder;
  AnimationController animationController;
  AboutUsRepository aboutUsRepo;
  AboutUsProvider aboutUsProvider;
  UserProvider userProvider;
  UserRepository userRepo;
  bool isReadyToShowAppBarIcons = false;
  bool isAddedToHistory = false;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!isReadyToShowAppBarIcons) {
      Timer(const Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() {
            isReadyToShowAppBarIcons = true;
          });
        }
      });
    }

    // print('Detail ***Tag*** ${widget.heroTagImage}');
    psValueHolder = Provider.of<PsValueHolder>(context);
    productRepo = Provider.of<ProductRepository>(context);
    historyRepo = Provider.of<HistoryRepository>(context);
    aboutUsRepo = Provider.of<AboutUsRepository>(context);
    userRepo = Provider.of<UserRepository>(context);
    appInfoRepository = Provider.of<AppInfoRepository>(context);

    return PsWidgetWithAppBarAndMultiProvider(
        appBarTitle: widget.productTitle,
        child: MultiProvider(
            providers: <SingleChildWidget>[
              ChangeNotifierProvider<ItemDetailProvider>(
                lazy: false,
                create: (BuildContext context) {
                  final ItemDetailProvider itemDetailProvider =
                      ItemDetailProvider(
                          repo: productRepo, psValueHolder: psValueHolder);

                  final String loginUserId =
                      Utils.checkUserLoginId(psValueHolder);
                  itemDetailProvider.loadProduct(widget.productId, loginUserId);
                  print(widget.productId);

                  return itemDetailProvider;
                },
              ),
              ChangeNotifierProvider<HistoryProvider>(
                lazy: false,
                create: (BuildContext context) {
                  historyProvider = HistoryProvider(repo: historyRepo);
                  return historyProvider;
                },
              ),
              ChangeNotifierProvider<AboutUsProvider>(
                lazy: false,
                create: (BuildContext context) {
                  aboutUsProvider = AboutUsProvider(
                      repo: aboutUsRepo, psValueHolder: psValueHolder);
                  aboutUsProvider.loadAboutUsList();
                  return aboutUsProvider;
                },
              ),
              ChangeNotifierProvider<UserProvider>(
                lazy: false,
                create: (BuildContext context) {
                  userProvider = UserProvider(
                      repo: userRepo, psValueHolder: psValueHolder);
                  return userProvider;
                },
              ),
              ChangeNotifierProvider<TouchCountProvider>(
                lazy: false,
                create: (BuildContext context) {
                  touchCountProvider = TouchCountProvider(
                      repo: productRepo, psValueHolder: psValueHolder);
                  final String loginUserId =
                      Utils.checkUserLoginId(psValueHolder);

                  final TouchCountParameterHolder touchCountParameterHolder =
                      TouchCountParameterHolder(
                          itemId: widget.productId, userId: loginUserId);
                  touchCountProvider
                      .postTouchCount(touchCountParameterHolder.toMap());
                  return touchCountProvider;
                },
              ),
              ChangeNotifierProvider<AppInfoProvider>(
                  lazy: false,
                  create: (BuildContext context) {
                    appInfoProvider = AppInfoProvider(
                        repo: appInfoRepository, psValueHolder: psValueHolder);

                    appInfoProvider.loadDeleteHistorywithNotifier();

                    return appInfoProvider;
                  }),
            ],
            child: Consumer<ItemDetailProvider>(
              builder: (BuildContext context, ItemDetailProvider provider,
                  Widget child) {
                if (provider.itemDetail != null &&
                    provider.itemDetail.data != null &&
                    userProvider != null) {
                  if (!isAddedToHistory) {
                    ///
                    /// Add to History
                    ///
                    historyProvider.addHistoryList(provider.itemDetail.data);
                    isAddedToHistory = true;
                  }
                  return Stack(
                    children: <Widget>[
                      CustomScrollView(slivers: <Widget>[
                        SliverAppBar(
                          automaticallyImplyLeading: false,
                          brightness: Utils.getBrightnessForAppBar(context),
                          expandedHeight: PsDimens.space300,
                          iconTheme: Theme.of(context)
                              .iconTheme
                              .copyWith(color: PsColors.mainColorWithWhite),
                          leading: PsBackButtonWithCircleBgWidget(
                              isReadyToShow: isReadyToShowAppBarIcons),
                          floating: false,
                          pinned: false,
                          stretch: true,
                          actions: <Widget>[
                            Visibility(
                              visible: isReadyToShowAppBarIcons,
                              child: _PopUpMenuWidget(
                                  context: context,
                                  itemDetailProvider: provider,
                                  userProvider: userProvider,
                                  itemId: provider.itemDetail.data.id,
                                  addedUserId:
                                      provider.itemDetail.data.addedUserId,
                                  loginUserId: psValueHolder.loginUserId,
                                  itemUserId:
                                      provider.itemDetail.data.user.userId,
                                  reportedUserId: psValueHolder.loginUserId,
                                  itemTitle: provider.itemDetail.data.title,
                                  itemImage: provider
                                      .itemDetail.data.defaultPhoto.imgPath),
                            ),
                          ],
                          backgroundColor: PsColors.mainColorWithBlack,
                          flexibleSpace: FlexibleSpaceBar(
                            background: Container(
                              color: PsColors.baseColor,
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: <Widget>[
                                  Container(
                                    width: double.infinity,
                                    height: PsDimens.space300,
                                    child: PsNetworkImage(
                                      photoKey: widget.heroTagImage,
                                      defaultPhoto:
                                          provider.itemDetail.data.defaultPhoto,
                                      // width: double.infinity,
                                      // height: PsDimens.space300,
                                      boxfit: BoxFit.cover,
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, RoutePaths.galleryGrid,
                                            arguments:
                                                provider.itemDetail.data);
                                      },
                                    ),
                                  ),
                                  if (provider.itemDetail.data.addedUserId ==
                                          provider.psValueHolder.loginUserId ||
                                      provider.itemDetail.data.addedUserId !=
                                          provider.psValueHolder.loginUserId)
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: PsDimens.space8,
                                          right: PsDimens.space8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          if (provider
                                                  .itemDetail.data.paidStatus ==
                                              PsConst.ADSPROGRESS)
                                            if (provider.itemDetail.data
                                                    .addedUserId ==
                                                provider
                                                    .psValueHolder.loginUserId)
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            PsDimens.space4),
                                                    color:
                                                        PsColors.paidAdsColor),
                                                padding: const EdgeInsets.all(
                                                    PsDimens.space8),
                                                child: Text(
                                                  Utils.getString(context,
                                                      'paid__ads_in_progress'),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(
                                                          color:
                                                              PsColors.white),
                                                ),
                                              )
                                            else if (provider.itemDetail.data
                                                        .paidStatus ==
                                                    PsConst.ADSFINISHED &&
                                                provider.itemDetail.data
                                                        .addedUserId ==
                                                    provider.psValueHolder
                                                        .loginUserId) ...<
                                                Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            PsDimens.space4),
                                                    color: PsColors.black),
                                                padding: const EdgeInsets.all(
                                                    PsDimens.space8),
                                                child: Text(
                                                  Utils.getString(context,
                                                      'paid__ads_in_completed'),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(
                                                          color:
                                                              PsColors.white),
                                                ),
                                              )
                                            ] else if (provider.itemDetail.data
                                                    .paidStatus ==
                                                PsConst
                                                    .ADSNOTYETSTART) ...<
                                                Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            PsDimens.space4),
                                                    color: Colors.yellow),
                                                padding: const EdgeInsets.all(
                                                    PsDimens.space8),
                                                child: Text(
                                                  Utils.getString(context,
                                                      'paid__ads_is_not_yet_start'),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(
                                                          color:
                                                              PsColors.white),
                                                ),
                                              )
                                            ] else ...<Widget>[
                                              Container(),
                                            ],
                                          Container(
                                            margin: const EdgeInsets.only(
                                                top: PsDimens.space4,
                                                bottom: PsDimens.space4),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                InkWell(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    PsDimens
                                                                        .space4),
                                                        color: Colors.black45),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            PsDimens.space8),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        Icon(
                                                          Ionicons.md_images,
                                                          color: PsColors.white,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    Navigator.pushNamed(context,
                                                        RoutePaths.galleryGrid,
                                                        arguments: provider
                                                            .itemDetail.data);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  else
                                    Padding(
                                      padding:
                                          const EdgeInsets.all(PsDimens.space8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          if (provider
                                                  .itemDetail.data.paidStatus ==
                                              PsConst.ADSPROGRESS)
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          PsDimens.space4),
                                                  color: PsColors.paidAdsColor),
                                              padding: const EdgeInsets.all(
                                                  PsDimens.space8),
                                              child: Text(
                                                Utils.getString(context,
                                                    'paid__ads_in_progress'),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                        color: PsColors.white),
                                              ),
                                            )
                                          else if (provider.itemDetail.data
                                                      .paidStatus ==
                                                  PsConst.ADSFINISHED &&
                                              provider.itemDetail.data
                                                      .addedUserId ==
                                                  provider.psValueHolder
                                                      .loginUserId)
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          PsDimens.space4),
                                                  color: PsColors.black),
                                              padding: const EdgeInsets.all(
                                                  PsDimens.space8),
                                              child: Text(
                                                Utils.getString(context,
                                                    'paid__ads_in_completed'),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                        color: PsColors.white),
                                              ),
                                            )
                                          else if (provider
                                                  .itemDetail.data.paidStatus ==
                                              PsConst.ADSNOTYETSTART)
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          PsDimens.space4),
                                                  color: Colors.yellow),
                                              padding: const EdgeInsets.all(
                                                  PsDimens.space8),
                                              child: Text(
                                                Utils.getString(context,
                                                    'paid__ads_is_not_yet_start'),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                        color: PsColors.white),
                                              ),
                                            )
                                          else
                                            Container(),
                                          InkWell(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          PsDimens.space4),
                                                  color: Colors.black45),
                                              padding: const EdgeInsets.all(
                                                  PsDimens.space8),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Icon(
                                                    Ionicons.md_images,
                                                    color: PsColors.white,
                                                  ),
                                                  const SizedBox(
                                                      width: PsDimens.space8),
                                                  Text(
                                                    '${provider.itemDetail.data.photoCount}  ${Utils.getString(context, 'item_detail__photo')}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        .copyWith(
                                                            color:
                                                                PsColors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.pushNamed(context,
                                                  RoutePaths.galleryGrid,
                                                  arguments:
                                                      provider.itemDetail.data);
                                            },
                                          ),
                                        ],
                                      ),
                                    )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildListDelegate(<Widget>[
                            Container(
                              color: PsColors.baseColor,
                              child: Column(children: <Widget>[
                                _HeaderBoxWidget(
                                  itemDetail: provider,
                                  product: provider.itemDetail.data,
                                  heroTagTitle: widget.heroTagTitle,
                                  favouriteItemRepo: productRepo,
                                ),
                                SellerInfoTileView(
                                  itemDetail: provider,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    (psValueHolder.loginUserId != null)?
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .38,
                                        margin: EdgeInsets.all(8),
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: PsColors.mainColor,
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                                color: PsColors.mainShadowColor,
                                                offset: const Offset(0, 2),
                                                blurRadius: 4.0,
                                                spreadRadius: 1.5),
                                          ],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        child: InkWell(
                                            onTap: () {
                                              showModalBottomSheet<Widget>(
                                                  context: context,
                                                  builder: (BuildContext bc) {
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.only(
                                                              topLeft: const Radius.circular(10),
                                                              topRight:
                                                              const Radius.circular(10))),
                                                      child:
                                                      CommentEntryView(
                                                      itemId: provider
                                                          .itemDetail
                                                        .data
                                                        .id,
                                                        blog: Blog(),
                                                        flag: PsConst.ADD_NEW_ITEM,
                                                      )

                                                    );
                                                  });


                                            },
                                            child:Text(
                                          "أضف تعليق",
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ))):Container(),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .38,
                                        margin: EdgeInsets.all(8),
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: PsColors.mainColor,
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                                color: PsColors.mainShadowColor,
                                                offset: const Offset(0, 2),
                                                blurRadius: 4.0,
                                                spreadRadius: 1.5),
                                          ],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        child: InkWell(
                                            onTap: () {
                                              Navigator.push<MaterialPageRoute>(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          BlogListContainerView(
                                                            itemId: provider
                                                                .itemDetail
                                                                .data
                                                                .id,
                                                          )));
                                            },
                                            child: Text("عرض التعليقات",
                                                style: TextStyle(
                                                    color: Colors.white),
                                                textAlign: TextAlign.center)))
                                  ],
                                ),
                                const SizedBox(
                                  height: PsDimens.space92,
                                ),
                              ]),
                            )
                          ]),
                        )
                      ]),
                      if (provider.itemDetail.data.addedUserId != null &&
                          provider.itemDetail.data.addedUserId ==
                              psValueHolder.loginUserId)
                        _EditAndDeleteButtonWidget(
                          provider: provider,
                        )
                      else
                        _CallAndChatButtonWidget(
                          provider: provider,
                          favouriteItemRepo: productRepo,
                          psValueHolder: psValueHolder,
                        )
                    ],
                  );
                } else {
                  return Container();
                }
              },
            )));
  }
}

class _PopUpMenuWidget extends StatelessWidget {
  const _PopUpMenuWidget(
      {@required this.userProvider,
      @required this.itemId,
      @required this.reportedUserId,
      @required this.itemUserId,
      @required this.addedUserId,
      @required this.loginUserId,
      @required this.itemTitle,
      @required this.itemImage,
      @required this.context,
      @required this.itemDetailProvider});

  final UserProvider userProvider;
  final String itemId;
  final String reportedUserId;
  final String itemUserId;
  final String addedUserId;
  final String loginUserId;
  final String itemTitle;
  final String itemImage;
  final BuildContext context;
  final ItemDetailProvider itemDetailProvider;

  Future<void> _onSelect(String value) async {
    switch (value) {
      case '1':
        showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ConfirmDialogView(
                description: Utils.getString(
                    context, 'item_detail__confirm_dialog_report_item'),
                leftButtonText: Utils.getString(context, 'dialog__cancel'),
                rightButtonText: Utils.getString(context, 'dialog__ok'),
                onAgreeTap: () async {
                  await PsProgressDialog.showDialog(context);

                  final UserReportItemParameterHolder
                      userReportItemParameterHolder =
                      UserReportItemParameterHolder(
                          itemId: itemId, reportedUserId: reportedUserId);

                  final PsResource<ApiStatus> _apiStatus = await userProvider
                      .userReportItem(userReportItemParameterHolder.toMap());

                  if (_apiStatus != null &&
                      _apiStatus.data != null &&
                      _apiStatus.data.status != null) {
                    await itemDetailProvider.deleteLocalProductCacheById(
                        itemId, reportedUserId);
                  }

                  PsProgressDialog.dismissDialog();

                  Navigator.of(context)
                      .popUntil(ModalRoute.withName(RoutePaths.home));
                });
          },
        );
        break;

      case '2':
        showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ConfirmDialogView(
                description: Utils.getString(
                    context, 'item_detail__confirm_dialog_block_user'),
                leftButtonText: Utils.getString(context, 'dialog__cancel'),
                rightButtonText: Utils.getString(context, 'dialog__ok'),
                onAgreeTap: () async {
                  await PsProgressDialog.showDialog(context);

                  final UserBlockParameterHolder userBlockItemParameterHolder =
                      UserBlockParameterHolder(
                          loginUserId: loginUserId, addedUserId: addedUserId);

                  final PsResource<ApiStatus> _apiStatus = await userProvider
                      .blockUser(userBlockItemParameterHolder.toMap());

                  if (_apiStatus != null &&
                      _apiStatus.data != null &&
                      _apiStatus.data.status != null) {
                    await itemDetailProvider.deleteLocalProductCacheByUserId(
                        loginUserId, addedUserId);
                  }

                  PsProgressDialog.dismissDialog();

                  Navigator.of(context)
                      .popUntil(ModalRoute.withName(RoutePaths.home));
                });
          },
        );
        break;

      case '3':
        //Share.share('http://www.panacea-soft.com');

        final Size size = MediaQuery.of(context).size;
        if (itemDetailProvider.itemDetail.data.dynamicLink != null) {
          Share.share(
            'Go to App:\n' + itemDetailProvider.itemDetail.data.dynamicLink,
            // +'Image:\n' + PsConfig.ps_app_image_url + itemImage,
            sharePositionOrigin:
                Rect.fromLTWH(0, 0, size.width, size.height / 2),
          );
        }

        // else{
        //   Share.share(
        //     'Go to App:\n Image:\n' + PsConfig.ps_app_image_url + itemImage,
        //     sharePositionOrigin: Rect.fromLTWH(0, 0, size.width, size.height / 2),
        //   );
        // }

        // await FlutterShare.share(
        //     title: itemTitle,
        //     text: 'Go to App:\n' +
        //             itemDetailProvider.itemDetail.data.dynamicLink ??
        //         '',
        //     linkUrl: 'Image:\n' + PsConfig.ps_app_image_url + itemImage);

        // final HttpClientRequest request = await HttpClient()
        //     .getUrl(Uri.parse(PsConfig.ps_app_image_url + itemImage));
        // final HttpClientResponse response = await request.close();
        // final Uint8List bytes =
        //     await consolidateHttpClientResponseBytes(response);
        // await Share.file(itemTitle, itemTitle + '.jpg', bytes, 'image/jpg',
        //     text: itemTitle+ '\n' + itemDetailProvider.itemDetail.data.dynamicLink);

        break;
      default:
        print('English');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: _onSelect,
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<String>>[
          if (itemDetailProvider.psValueHolder.loginUserId != itemUserId &&
              itemDetailProvider.psValueHolder.loginUserId != null &&
              itemDetailProvider.psValueHolder.loginUserId != '')
            PopupMenuItem<String>(
              value: '1',
              child: Visibility(
                visible: true,
                child: Text(
                  Utils.getString(context, 'item_detail__report_item'),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ),
          if (itemDetailProvider.psValueHolder.loginUserId != itemUserId &&
              itemDetailProvider.psValueHolder.loginUserId != null &&
              itemDetailProvider.psValueHolder.loginUserId != '')
            PopupMenuItem<String>(
              value: '2',
              child: Visibility(
                visible: true,
                child: Text(
                  Utils.getString(context, 'item_detail__block_user'),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ),
          PopupMenuItem<String>(
            value: '3',
            child: Text(Utils.getString(context, 'item_detail__share'),
                style: Theme.of(context).textTheme.bodyText1),
          ),
        ];
      },
      elevation: 4,
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}

class _HeaderBoxWidget extends StatefulWidget {
  const _HeaderBoxWidget(
      {Key key,
      @required this.itemDetail,
      @required this.product,
      @required this.favouriteItemRepo,
      @required this.heroTagTitle})
      : super(key: key);

  final ItemDetailProvider itemDetail;
  final Product product;
  final String heroTagTitle;

  final ProductRepository favouriteItemRepo;

  @override
  __HeaderBoxWidgetState createState() => __HeaderBoxWidgetState();
}

class __HeaderBoxWidgetState extends State<_HeaderBoxWidget> {
  @override
  FavouriteItemProvider favouriteProvider;

  Widget build(BuildContext context) {
    Widget icon;
    favouriteProvider = FavouriteItemProvider(
        repo: widget.favouriteItemRepo, psValueHolder: psValueHolder);
    if (widget.product != null &&
        widget.itemDetail != null &&
        widget.itemDetail.itemDetail != null &&
        widget.itemDetail.itemDetail.data != null) {
      return Container(
        margin: const EdgeInsets.all(PsDimens.space8),
        decoration: BoxDecoration(
          color: PsColors.baseColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(PsDimens.space8)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: PsDimens.space16,
            ),
            PsHero(
                tag: widget.heroTagTitle,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        widget.itemDetail.itemDetail.data.title,
                        overflow: TextOverflow.clip,
                        textDirection: TextDirection.rtl,
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(color: PsColors.black),
                        textAlign: TextAlign.right,
                      ),
                      width: MediaQuery.of(context).size.width * .8,
                      alignment: Alignment.topRight,
                    ),
                    Container(
                      child: PSButtonWithIconWidget(
                        hasShadow: false,
                        colorData: PsColors.baseColor,
                        icon: (widget.itemDetail != null &&
                                widget.itemDetail.itemDetail != null &&
                                widget.itemDetail.itemDetail.data != null)
                            ? widget.itemDetail.itemDetail.data.isFavourited ==
                                    PsConst.ZERO
                                ? Icons.favorite_border
                                : Icons.favorite
                            : null,
                        iconColor: Colors.red,
                        width: 60,
                        titleText: '',
                        onPressed: () async {
                          if (await Utils.checkInternetConnectivity()) {
                            Utils.navigateOnUserVerificationView(
                                widget.itemDetail, context, () async {
                              if (widget.itemDetail.itemDetail.data
                                      .isFavourited ==
                                  '0') {
                                if (mounted) {
                                  setState(() {
                                    widget.itemDetail.itemDetail.data
                                        .isFavourited = '1';
                                  });
                                }
                              } else {
                                if (mounted) {
                                  setState(() {
                                    widget.itemDetail.itemDetail.data
                                        .isFavourited = '0';
                                  });
                                }
                              }

                              final FavouriteParameterHolder
                                  favouriteParameterHolder =
                                  FavouriteParameterHolder(
                                      itemId:
                                          widget.itemDetail.itemDetail.data.id,
                                      userId: psValueHolder.loginUserId);

                              final PsResource<Product> _apiStatus =
                                  await favouriteProvider.postFavourite(
                                      favouriteParameterHolder.toMap());

                              if (_apiStatus.data != null) {
                                if (_apiStatus.status == PsStatus.SUCCESS) {
                                  await widget.itemDetail.loadItemForFav(
                                      widget.itemDetail.itemDetail.data.id,
                                      psValueHolder.loginUserId);
                                }
                                if (widget.itemDetail != null &&
                                    widget.itemDetail.itemDetail != null &&
                                    widget.itemDetail.itemDetail.data != null) {
                                  if (widget.itemDetail.itemDetail.data
                                          .isFavourited ==
                                      PsConst.ONE) {
                                    icon = Icon(Icons.favorite,
                                        color: PsColors.mainColor);
                                  } else {
                                    icon = Icon(Icons.favorite_border,
                                        color: PsColors.mainColor);
                                  }
                                }
                              } else {
                                print('There is no comment');
                              }
                            });
                          }
                        },
                      ),
                      width: MediaQuery.of(context).size.width * .1,
                      alignment: Alignment.topLeft,
                    ),
                  ],
                )),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: PsDimens.space16),
                  child: Text(
                    widget.itemDetail.itemDetail.data != null &&
                            widget.itemDetail.itemDetail.data.price != '0' &&
                            widget.itemDetail.itemDetail.data.price != ''
                        ? '${Utils.getPriceFormat(widget.itemDetail.itemDetail.data.price)} ر.س. '
                        : Utils.getString(context, 'item_price_free'),
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(color: PsColors.mainColor),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: PsDimens.space16,
            ),
            /*
            _IconsAndTwoTitleTextWidget(
                title: 'آخر التحديثات  ${widget.itemDetail.itemDetail.data.addedDateStr}',
                color: PsColors.grey,
                itemProvider: widget.itemDetail),
*/
            Text(
              'آخر التحديثات  ${widget.itemDetail.itemDetail.data.addedDateStr}',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(color: Colors.grey),
            ),
            Text(
              "عدد المشاهدات ${widget.itemDetail.itemDetail.data.touchCount}",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(color: Colors.grey),
            ),
            Text(
              "المنطقة ${widget.itemDetail.itemDetail.data.itemLocation.name}",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(color: Colors.grey),
            ),
            Row(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width * .45,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: PsColors.white,
                      border: Border(
                        top: BorderSide(width: 1.0, color: Colors.grey),
                        bottom: BorderSide(width: 1.0, color: Colors.grey),
                        left: BorderSide(width: 1.0, color: Colors.grey),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          FlutterIcons.tag_outline_mco,
                          color: PsColors.mainColor,
                        ),
                        Text("القسم ")
                      ],
                    )),
                Container(
                    padding: EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.width * .45,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: PsColors.white,
                      border: Border(
                        top: BorderSide(width: 1.0, color: Colors.grey),
                        bottom: BorderSide(width: 1.0, color: Colors.grey),
                      ),
                    ),
                    child: Text(
                        widget.itemDetail.itemDetail.data.manufacturer.name)),
              ],
            ),

            const SizedBox(
              height: PsDimens.space16,
            ),
            if (widget.itemDetail.itemDetail.data.description != '')
              _DescriptionWedget(
                description: widget.itemDetail.itemDetail.data.description,
              )
            else
              Container(),
            // _IconsAndTitleTextWidget(
            //   title: Utils.getString(context, 'item_detail__manufacturer'),
            //   subTitle: widget.itemDetail.itemDetail.data.manufacturer.name,
            // ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}

class _DescriptionWedget extends StatelessWidget {
  const _DescriptionWedget({Key key, @required this.description})
      : super(key: key);
  final String description;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              Utils.getString(context, 'product_detail__product_description'),
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: PsDimens.space8),
            Text(description,
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                    height: 1.3,
                    letterSpacing: 0.5,
                    color: Colors.black,
                    fontWeight: FontWeight.normal))
          ]),
    );
  }
}

class _IconsAndDescriptionTextWidget extends StatelessWidget {
  const _IconsAndDescriptionTextWidget({
    Key key,
    @required this.title,
    @required this.icon,
    @required this.desctiption,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final String desctiption;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          icon,
          size: PsDimens.space36,
          // color: Colors.black38,
        ),
        // const SizedBox(
        //   height: PsDimens.space8,
        // ),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        const SizedBox(
          height: PsDimens.space8,
        ),
        Text(
          desctiption,
          overflow: TextOverflow.clip,
          maxLines: 1,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ],
    );
  }
}

class _IconsAndTitleTextWidget extends StatelessWidget {
  const _IconsAndTitleTextWidget({
    Key key,
    @required this.title,
    @required this.subTitle,
  }) : super(key: key);

  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: PsDimens.space16,
          right: PsDimens.space16,
          bottom: PsDimens.space16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(
            SimpleLineIcons.arrow_right_circle,
            size: PsDimens.space18,
          ),
          const SizedBox(
            width: PsDimens.space16,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const SizedBox(
                  height: PsDimens.space8,
                ),
                Text(
                  subTitle,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IconsAndTwoTitleTextWidget extends StatelessWidget {
  const _IconsAndTwoTitleTextWidget({
    Key key,
    @required this.title,
    @required this.itemProvider,
    @required this.color,
  }) : super(key: key);

  final String title;
  final ItemDetailProvider itemProvider;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: PsDimens.space16,
          right: PsDimens.space16,
          bottom: PsDimens.space16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, RoutePaths.userDetail,
                  // arguments: itemProvider.itemDetail.data.addedUserId
                  arguments: UserIntentHolder(
                      userId: itemProvider.itemDetail.data.addedUserId,
                      userName: itemProvider.itemDetail.data.user.userName));
            },
            child: Text(
              itemProvider.itemDetail.data.user.userName == ''
                  ? Utils.getString(context, 'default__user_name')
                  : '${itemProvider.itemDetail.data.user.userName}',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(color: PsColors.black),
            ),
          ),
          const SizedBox(
            width: PsDimens.space8,
          ),
          Text(
            title,
            style: color == null
                ? Theme.of(context).textTheme.bodyText1
                : Theme.of(context).textTheme.bodyText1.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _CallAndChatButtonWidget extends StatefulWidget {
  const _CallAndChatButtonWidget({
    Key key,
    @required this.provider,
    @required this.favouriteItemRepo,
    @required this.psValueHolder,
  }) : super(key: key);

  final ItemDetailProvider provider;
  final ProductRepository favouriteItemRepo;
  final PsValueHolder psValueHolder;

  @override
  __CallAndChatButtonWidgetState createState() =>
      __CallAndChatButtonWidgetState();
}

class __CallAndChatButtonWidgetState extends State<_CallAndChatButtonWidget> {
  FavouriteItemProvider favouriteProvider;
  Widget icon;
  @override
  Widget build(BuildContext context) {
    if (widget.provider != null &&
        widget.provider.itemDetail != null &&
        widget.provider.itemDetail.data != null) {
      return ChangeNotifierProvider<FavouriteItemProvider>(
          lazy: false,
          create: (BuildContext context) {
            favouriteProvider = FavouriteItemProvider(
                repo: widget.favouriteItemRepo,
                psValueHolder: widget.psValueHolder);
            // provider.loadFavouriteList('prd9a3bfa2b7ab0f0693e84d834e73224bb');
            return favouriteProvider;
          },
          child: Consumer<FavouriteItemProvider>(builder: (BuildContext context,
              FavouriteItemProvider provider, Widget child) {
            return Container(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: double.infinity,
                height: PsDimens.space72,
                child: Container(
                  decoration: BoxDecoration(
                    color: PsColors.backgroundColor,
                    border: Border.all(color: PsColors.backgroundColor),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(PsDimens.space8),
                        topRight: Radius.circular(PsDimens.space8)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: PsColors.backgroundColor,
                        blurRadius:
                            10.0, // has the effect of softening the shadow
                        spreadRadius:
                            0, // has the effect of extending the shadow
                        offset: const Offset(
                          0.0, // horizontal, move right 10
                          0.0, // vertical, move down 10
                        ),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(PsDimens.space16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        PSButtonWithIconWidget(
                          hasShadow: false,
                          colorData: PsColors.black.withOpacity(0.1),
                          icon: (widget.provider != null &&
                                  widget.provider.itemDetail != null &&
                                  widget.provider.itemDetail.data != null)
                              ? widget.provider.itemDetail.data.isFavourited ==
                                      PsConst.ZERO
                                  ? Icons.favorite_border
                                  : Icons.favorite
                              : null,
                          iconColor: PsColors.mainColor,
                          width: 60,
                          titleText: '',
                          onPressed: () async {
                            if (await Utils.checkInternetConnectivity()) {
                              Utils.navigateOnUserVerificationView(
                                  widget.provider, context, () async {
                                if (widget.provider.itemDetail.data
                                        .isFavourited ==
                                    '0') {
                                  if (mounted) {
                                    setState(() {
                                      widget.provider.itemDetail.data
                                          .isFavourited = '1';
                                    });
                                  }
                                } else {
                                  if (mounted) {
                                    setState(() {
                                      widget.provider.itemDetail.data
                                          .isFavourited = '0';
                                    });
                                  }
                                }

                                final FavouriteParameterHolder
                                    favouriteParameterHolder =
                                    FavouriteParameterHolder(
                                        itemId:
                                            widget.provider.itemDetail.data.id,
                                        userId:
                                            widget.psValueHolder.loginUserId);

                                final PsResource<Product> _apiStatus =
                                    await favouriteProvider.postFavourite(
                                        favouriteParameterHolder.toMap());

                                if (_apiStatus.data != null) {
                                  if (_apiStatus.status == PsStatus.SUCCESS) {
                                    await widget.provider.loadItemForFav(
                                        widget.provider.itemDetail.data.id,
                                        widget.psValueHolder.loginUserId);
                                  }
                                  if (widget.provider != null &&
                                      widget.provider.itemDetail != null &&
                                      widget.provider.itemDetail.data != null) {
                                    if (widget.provider.itemDetail.data
                                            .isFavourited ==
                                        PsConst.ONE) {
                                      icon = Icon(Icons.favorite,
                                          color: PsColors.mainColor);
                                    } else {
                                      icon = Icon(Icons.favorite_border,
                                          color: PsColors.mainColor);
                                    }
                                  }
                                } else {
                                  print('There is no comment');
                                }
                              });
                            }
                          },
                        ),
                        const SizedBox(
                          width: PsDimens.space10,
                        ),
                        if (widget.provider.itemDetail.data.user.userPhone !=
                                null &&
                            widget.provider.itemDetail.data.user.userPhone !=
                                '' &&
                            widget.provider.itemDetail.data.user.isShowPhone ==
                                '1')
                          Visibility(
                              visible: true,
                              child: PSButtonWithIconWidget(
                                hasShadow: true,
                                icon: Icons.call,
                                width: 100,
                                titleText: Utils.getString(
                                    context, 'item_detail__call'),
                                onPressed: () async {
                                  if (await canLaunch(
                                      'tel://${widget.provider.itemDetail.data.user.userPhone}')) {
                                    await launch(
                                        'tel://${widget.provider.itemDetail.data.user.userPhone}');
                                  } else {
                                    throw 'Could not Call Phone';
                                  }
                                },
                              ))
                        else
                          Container(),
                        const SizedBox(
                          width: PsDimens.space10,
                        ),
                        Expanded(
                          child:
                              // RaisedButton(
                              //   child: Text(
                              //     Utils.getString(context, 'item_detail__chat'),
                              //     overflow: TextOverflow.ellipsis,
                              //     maxLines: 1,
                              //     textAlign: TextAlign.center,
                              //     softWrap: false,
                              //   ),
                              //   color: PsColors.mainColor,
                              //   shape: const BeveledRectangleBorder(
                              //       borderRadius: BorderRadius.all(
                              //     Radius.circular(PsDimens.space8),
                              //   )),
                              //   textColor: Theme.of(context).textTheme.button.copyWith(color: PsColors.white).color,
                              //   onPressed: () {
                              PSButtonWithIconWidget(
                            hasShadow: true,
                            icon: Icons.chat,
                            width: double.infinity,
                            titleText:
                                Utils.getString(context, 'item_detail__chat'),
                            onPressed: () async {
                              if (await Utils.checkInternetConnectivity()) {
                                Utils.navigateOnUserVerificationView(
                                    widget.provider, context, () async {
                                  Navigator.pushNamed(
                                      context, RoutePaths.chatView,
                                      arguments: ChatHistoryIntentHolder(
                                        chatFlag: PsConst.CHAT_FROM_SELLER,
                                        itemId:
                                            widget.provider.itemDetail.data.id,
                                        buyerUserId:
                                            widget.psValueHolder.loginUserId,
                                        sellerUserId: widget.provider.itemDetail
                                            .data.addedUserId,
                                      ));
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }));
    } else {
      return Container();
    }
  }
}

class _EditAndDeleteButtonWidget extends StatelessWidget {
  const _EditAndDeleteButtonWidget({
    Key key,
    @required this.provider,
  }) : super(key: key);

  final ItemDetailProvider provider;
  @override
  Widget build(BuildContext context) {
    if (provider != null &&
        provider.itemDetail != null &&
        provider.itemDetail.data != null) {
      return Container(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: PsDimens.space8),
            SizedBox(
              width: double.infinity,
              height: PsDimens.space72,
              child: Container(
                decoration: BoxDecoration(
                  color: PsColors.backgroundColor,
                  border: Border.all(color: PsColors.backgroundColor),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(PsDimens.space8),
                      topRight: Radius.circular(PsDimens.space8)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: PsColors.backgroundColor,
                      blurRadius:
                          10.0, // has the effect of softening the shadow
                      spreadRadius: 0, // has the effect of extending the shadow
                      offset: const Offset(
                        0.0, // horizontal, move right 10
                        0.0, // vertical, move down 10
                      ),
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(PsDimens.space8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child:
                            // RaisedButton(
                            //   child: Text(
                            //     Utils.getString(context, 'item_detail__delete'),
                            //     overflow: TextOverflow.ellipsis,
                            //     maxLines: 1,
                            //     softWrap: false,
                            //   ),
                            //   color: PsColors.grey,
                            //   shape: const BeveledRectangleBorder(
                            //       borderRadius: BorderRadius.all(
                            //     Radius.circular(PsDimens.space8),
                            //   )),
                            //   textColor: Theme.of(context).textTheme.button.copyWith(color: PsColors.white).color,
                            //   onPressed: () async {
                            PSButtonWithIconWidget(
                          hasShadow: true,
                          width: double.infinity,
                          icon: Icons.delete,
                          colorData: PsColors.mainColor,
                          titleText:
                              Utils.getString(context, 'item_detail__delete'),
                          onPressed: () async {
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
                                          itemId: provider.itemDetail.data.id,
                                        );

                                        final PsResource<ApiStatus> _apiStatus =
                                            await provider.userDeleteItem(
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
                                              textColor: Colors.white);
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
                                              textColor: Colors.white);
                                        }
                                      });
                                });
                          },
                        ),
                      ),
                      const SizedBox(
                        width: PsDimens.space10,
                      ),
                      Expanded(
                        child:
                            //  RaisedButton(
                            //   child: Text(
                            //     Utils.getString(context, 'item_detail__edit'),
                            //     overflow: TextOverflow.ellipsis,
                            //     maxLines: 1,
                            //     textAlign: TextAlign.center,
                            //     softWrap: false,
                            //   ),
                            //   color: PsColors.mainColor,
                            //   shape: const BeveledRectangleBorder(
                            //       borderRadius: BorderRadius.all(
                            //     Radius.circular(PsDimens.space8),
                            //   )),
                            //   textColor: Theme.of(context).textTheme.button.copyWith(color: PsColors.white).color,
                            //   onPressed: () async {
                            PSButtonWithIconWidget(
                          hasShadow: true,
                          width: double.infinity,
                          icon: Icons.edit,
                          titleText:
                              Utils.getString(context, 'item_detail__edit'),
                          onPressed: () async {
                            Navigator.pushNamed(context, RoutePaths.itemEntry,
                                arguments: ItemEntryIntentHolder(
                                    flag: PsConst.EDIT_ITEM,
                                    item: provider.itemDetail.data));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}

class PromoteTileView extends StatefulWidget {
  const PromoteTileView(
      {Key key,
      @required this.animationController,
      @required this.product,
      @required this.provider})
      : super(key: key);

  final AnimationController animationController;
  final Product product;
  final ItemDetailProvider provider;

  @override
  _PromoteTileViewState createState() => _PromoteTileViewState();
}

class _PromoteTileViewState extends State<PromoteTileView> {
  @override
  Widget build(BuildContext context) {
    final Widget _expansionTileTitleWidget = Text(
        Utils.getString(context, 'item_detail__promote_your_item'),
        style: Theme.of(context).textTheme.subtitle1);

    final Widget _expansionTileLeadingIconWidget =
        Icon(Ionicons.ios_megaphone, color: PsColors.mainColor);

    return Consumer<AppInfoProvider>(builder:
        (BuildContext context, AppInfoProvider appInfoprovider, Widget child) {
      if (appInfoprovider.appInfo.data == null) {
        return Container();
      } else {
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Divider(
                    height: PsDimens.space1,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(PsDimens.space8),
                    child: Text(Utils.getString(
                        context, 'item_detail__promote_sub_title')),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: PsDimens.space8,
                        right: PsDimens.space8,
                        bottom: PsDimens.space8),
                    child: Text(Utils.getString(
                        context, 'item_detail__promote_description')),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const SizedBox(width: PsDimens.space2),
                      SizedBox(
                          width: PsDimens.space220,
                          child: PSButtonWithIconWidget(
                              hasShadow: false,
                              width: double.infinity,
                              icon: Ionicons.ios_megaphone,
                              titleText: Utils.getString(
                                  context, 'item_detail__promte'),
                              onPressed: () async {
                                if (appInfoprovider.appInfo.data
                                            .inAppPurchasedEnabled ==
                                        PsConst.ONE &&
                                    appInfoprovider.appInfo.data.stripeEnable ==
                                        PsConst.ZERO &&
                                    appInfoprovider.appInfo.data.paypalEnable ==
                                        PsConst.ZERO &&
                                    appInfoprovider
                                            .appInfo.data.payStackEnabled ==
                                        PsConst.ZERO &&
                                    appInfoprovider.appInfo.data.razorEnable ==
                                        PsConst.ZERO &&
                                    appInfoprovider
                                            .appInfo.data.offlineEnabled ==
                                        PsConst.ZERO) {
                                  // InAppPurchase View
                                  final dynamic returnData =
                                      await Navigator.pushNamed(
                                          context, RoutePaths.inAppPurchase,
                                          arguments: <String, dynamic>{
                                        'productId': widget.product.id,
                                        'appInfo': appInfoprovider.appInfo.data
                                      });
                                  if (returnData == true ||
                                      returnData == null) {
                                    final String loginUserId =
                                        Utils.checkUserLoginId(
                                            widget.provider.psValueHolder);
                                    widget.provider.loadProduct(
                                        widget.product.id, loginUserId);
                                  }
                                } else if (appInfoprovider
                                        .appInfo.data.inAppPurchasedEnabled ==
                                    PsConst.ZERO) {
                                  //Original Item Promote View
                                  final dynamic returnData =
                                      await Navigator.pushNamed(
                                          context, RoutePaths.itemPromote,
                                          arguments: widget.product);
                                  if (returnData == true) {
                                    final String loginUserId =
                                        Utils.checkUserLoginId(
                                            widget.provider.psValueHolder);
                                    widget.provider.loadProduct(
                                        widget.product.id, loginUserId);
                                  }
                                } else {
                                  //choose payment
                                  showDialog<dynamic>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ChoosePaymentTypeDialog(
                                            onInAppPurchaseTap: () async {
                                          final dynamic returnData =
                                              await Navigator.pushNamed(context,
                                                  RoutePaths.inAppPurchase,
                                                  arguments: <String, dynamic>{
                                                'productId': widget.product.id,
                                                'appInfo':
                                                    appInfoprovider.appInfo.data
                                              });
                                          if (returnData == true ||
                                              returnData == null) {
                                            final String loginUserId =
                                                Utils.checkUserLoginId(widget
                                                    .provider.psValueHolder);
                                            widget.provider.loadProduct(
                                                widget.product.id, loginUserId);
                                          }
                                        }, onOtherPaymentTap: () async {
                                          final dynamic returnData =
                                              await Navigator.pushNamed(context,
                                                  RoutePaths.itemPromote,
                                                  arguments: widget.product);
                                          if (returnData == true ||
                                              returnData == null) {
                                            final String loginUserId =
                                                Utils.checkUserLoginId(widget
                                                    .provider.psValueHolder);
                                            widget.provider.loadProduct(
                                                widget.product.id, loginUserId);
                                          }
                                        });
                                      });
                                  //   final dynamic returnData =
                                  //       await Navigator.pushNamed(
                                  //           context, RoutePaths.choosePayment,
                                  //           arguments: <String, dynamic>{
                                  //         'product': widget.product,
                                  //         'appInfo': appInfoprovider.appInfo.data
                                  //       });
                                  //   if (returnData == true ||
                                  //       returnData == null) {
                                  //     final String loginUserId =
                                  //         Utils.checkUserLoginId(
                                  //             widget.provider.psValueHolder);
                                  //     widget.provider.loadProduct(
                                  //         widget.product.id, loginUserId);
                                  //   }
                                }
                              })),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: PsDimens.space18, bottom: PsDimens.space8),
                        child: Image.asset(
                          'assets/images/baseline_promotion_color_74.png',
                          width: PsDimens.space80,
                          height: PsDimens.space80,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        );
      }
    });
  }
}
