import 'package:flutter/rendering.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:haraj/api/common/ps_admob_banner_widget.dart';
import 'package:haraj/config/ps_colors.dart';
import 'package:haraj/config/ps_config.dart';
import 'package:haraj/constant/ps_constants.dart';
import 'package:haraj/provider/blog/blog_provider.dart';
import 'package:haraj/provider/chat/user_unread_message_provider.dart';
import 'package:haraj/provider/home_bunner/bunner_provider.dart';
import 'package:haraj/provider/item_location/item_location_provider.dart';
import 'package:haraj/provider/manufacturer/manufacturer_provider.dart';
import 'package:haraj/provider/product/item_list_from_followers_provider.dart';
import 'package:haraj/provider/product/paid_ad_product_provider%20copy.dart';
import 'package:haraj/provider/product/recent_product_provider.dart';
import 'package:haraj/provider/product/popular_product_provider.dart';
import 'package:haraj/repository/blog_repository.dart';
import 'package:haraj/repository/bunner_repository.dart';
import 'package:haraj/repository/item_location_repository.dart';
import 'package:haraj/repository/manufacturer_repository.dart';
import 'package:haraj/repository/paid_ad_item_repository.dart';
import 'package:haraj/repository/user_unread_message_repository.dart';
import 'package:haraj/ui/common/dialog/error_dialog.dart';
import 'package:haraj/ui/common/ps_frame_loading_widget.dart';
import 'package:haraj/ui/common/ps_textfield_widget_with_icon.dart';
import 'package:haraj/ui/common/ps_ui_widget.dart';
import 'package:haraj/ui/dashboard/home/blog_product_slider.dart';
import 'package:haraj/ui/dashboard/home/home_bunner_slider.dart';
import 'package:haraj/ui/item/item/product_horizontal_list_item.dart';
import 'package:haraj/ui/manufacturer/item/manufacturer_horizontal_grid_item.dart';
import 'package:haraj/utils/utils.dart';
import 'package:haraj/viewobject/blog.dart';
import 'package:haraj/viewobject/common/ps_value_holder.dart';
import 'package:haraj/viewobject/holder/intent_holder/item_entry_intent_holder.dart';
import 'package:haraj/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:haraj/viewobject/holder/intent_holder/product_list_intent_holder.dart';
import 'package:haraj/viewobject/holder/product_parameter_holder.dart';
import 'package:haraj/viewobject/holder/user_unread_message_parameter_holder.dart';
import 'package:haraj/viewobject/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:haraj/api/common/ps_status.dart';
import 'package:haraj/constant/ps_dimens.dart';
import 'package:haraj/constant/route_paths.dart';
import 'package:haraj/repository/product_repository.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeDashboardViewWidget extends StatefulWidget {
  const HomeDashboardViewWidget(
      this.scrollController,
      this.animationController,
      this.animationControllerForFab,
      this.context,
      this.onNotiClicked,
      this.onChatNotiClicked);

  final ScrollController scrollController;
  final AnimationController animationController;
  final AnimationController animationControllerForFab;

  final BuildContext context;
  final Function onNotiClicked;
  final Function onChatNotiClicked;

  @override
  _HomeDashboardViewWidgetState createState() =>
      _HomeDashboardViewWidgetState();
}

class _HomeDashboardViewWidgetState extends State<HomeDashboardViewWidget> {
  PsValueHolder valueHolder;
  ManufacturerRepository repo1;
  ProductRepository repo2;
  BlogRepository repo3;
  BunnerRepository bunnerRepo;
  ItemLocationRepository repo4;

  ManufacturerProvider _manufacturerProvider;
  BlogProvider _blogProvider;
  ItemLocationProvider _itemLocationProvider;
  RecentProductProvider _recentProductProvider;
  PopularProductProvider _popularProductProvider;
  PaidAdProductProvider _paidAdItemProvider;
  UserUnreadMessageProvider _userUnreadMessageProvider;
  UserUnreadMessageRepository userUnreadMessageRepository;
  PaidAdItemRepository paidAdItemRepository;

  final int count = 8;
  // final ManufacturerParameterHolder trendingCategory = ManufacturerParameterHolder();
  // final ManufacturerParameterHolder categoryIconList = ManufacturerParameterHolder();
  // final FirebaseMessaging _fcm = FirebaseMessaging();
  final TextEditingController userInputItemNameTextEditingController =
      TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    widget.scrollController.addListener(() {
      if (widget.scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (widget.animationControllerForFab != null) {
          widget.animationControllerForFab.reverse();
        }
      }
      if (widget.scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (widget.animationControllerForFab != null) {
          widget.animationControllerForFab.forward();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    repo1 = Provider.of<ManufacturerRepository>(context);
    repo2 = Provider.of<ProductRepository>(context);
    repo3 = Provider.of<BlogRepository>(context);
    bunnerRepo = Provider.of<BunnerRepository>(context);
    repo4 = Provider.of<ItemLocationRepository>(context);
    paidAdItemRepository = Provider.of<PaidAdItemRepository>(context);
    userUnreadMessageRepository =
        Provider.of<UserUnreadMessageRepository>(context);

    valueHolder = Provider.of<PsValueHolder>(context, listen: false);

    return MultiProvider(
        providers: <SingleChildWidget>[
          ChangeNotifierProvider<BunnerProvider>(
              lazy: false,
              create: (BuildContext context) {
                final BunnerProvider provider = BunnerProvider(
                    repo: bunnerRepo,
                    limit: PsConfig.BUNNER_SLIDER_LOADING_LIMIT);
                provider.loadBunnerList();
                return provider;
              }),
          ChangeNotifierProvider<ManufacturerProvider>(
              lazy: false,
              create: (BuildContext context) {
                _manufacturerProvider ??= ManufacturerProvider(
                    repo: repo1,
                    psValueHolder: valueHolder,
                    limit: PsConfig.CATEGORY_LOADING_LIMIT);

                _manufacturerProvider
                    .loadManufacturerList()
                    .then((dynamic value) {
                  // Utils.psPrint("Is Has Internet " + value);
                  final bool isConnectedToIntenet = value ?? bool;
                  if (!isConnectedToIntenet) {
                    Fluttertoast.showToast(
                        msg: 'No Internet Connectiion. Please try again !',
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.blueGrey,
                        textColor: Colors.white);
                  }
                });
                return _manufacturerProvider;
              }),
          ChangeNotifierProvider<RecentProductProvider>(
              lazy: false,
              create: (BuildContext context) {
                _recentProductProvider = RecentProductProvider(
                    repo: repo2, limit: PsConfig.RECENT_ITEM_LOADING_LIMIT);

                final String loginUserId = Utils.checkUserLoginId(valueHolder);

                _recentProductProvider.loadProductList(loginUserId,
                    _recentProductProvider.productRecentParameterHolder);
                return _recentProductProvider;
              }),
          ChangeNotifierProvider<UserUnreadMessageProvider>(
              lazy: false,
              create: (BuildContext context) {
                _userUnreadMessageProvider = UserUnreadMessageProvider(
                    repo: userUnreadMessageRepository);

                if (valueHolder.loginUserId != null &&
                    valueHolder.loginUserId != '') {
                  final UserUnreadMessageParameterHolder
                      userUnreadMessageHolder =
                      UserUnreadMessageParameterHolder(
                          userId: valueHolder.loginUserId,
                          deviceToken: valueHolder.deviceToken);
                  _userUnreadMessageProvider
                      .userUnreadMessageCount(userUnreadMessageHolder);
                }
                return _userUnreadMessageProvider;
              }),
          ChangeNotifierProvider<ItemLocationProvider>(
              lazy: false,
              create: (BuildContext context) {
                _itemLocationProvider = ItemLocationProvider(
                    repo: repo4, psValueHolder: valueHolder);
                _itemLocationProvider.loadItemLocationList(
                    _itemLocationProvider.defaultLocationParameterHolder
                        .toMap(),
                    Utils.checkUserLoginId(
                        _itemLocationProvider.psValueHolder));
                return _itemLocationProvider;
              }),
          ChangeNotifierProvider<ItemListFromFollowersProvider>(
              lazy: false,
              create: (BuildContext context) {
                final ItemListFromFollowersProvider provider =
                    ItemListFromFollowersProvider(
                        repo: repo2,
                        psValueHolder: valueHolder,
                        limit: PsConfig.FOLLOWER_ITEM_LOADING_LIMIT);
                provider.loadItemListFromFollowersList(
                    Utils.checkUserLoginId(provider.psValueHolder));
                return provider;
              }),
        ],
        child: Scaffold(
            primary: false,
            /*
            floatingActionButton: FadeTransition(
              opacity: widget.animationControllerForFab,
              child: ScaleTransition(
                scale: widget.animationControllerForFab,
                child: FloatingActionButton.extended(
                  onPressed: () async {
                    print(
                        'Brightness: ${Utils.getBrightnessForAppBar(context)}');
                    if (await Utils.checkInternetConnectivity()) {
                      Utils.navigateOnUserVerificationView(
                          _manufacturerProvider, context, () async {
                        Navigator.pushNamed(context, RoutePaths.itemEntry,
                            arguments: ItemEntryIntentHolder(
                                flag: PsConst.ADD_NEW_ITEM, item: Product()));
                      });
                    } else {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return ErrorDialog(
                              message: Utils.getString(
                                  context, 'error_dialog__no_internet'),
                            );
                          });
                    }
                  },
                  icon: Icon(Icons.camera_alt, color: PsColors.white),
                  backgroundColor: Utils.isLightMode(context)
                      ? PsColors.mainColor
                      : Colors.black38,
                  label: Text(Utils.getString(context, 'dashboard__submit_ad'),
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .copyWith(color: PsColors.white)),
                ),
              ),
            ),*/

            // floatingActionButton: AnimatedContainer(
            //   duration: const Duration(milliseconds: 300),
            //   child: FloatingActionButton.extended(
            //     onPressed: () async {
            //       if (await Utils.checkInternetConnectivity()) {
            //         Utils.navigateOnUserVerificationView(
            //             _manufacturerProvider, context, () async {
            //           Navigator.pushNamed(context, RoutePaths.itemEntry,
            //               arguments: ItemEntryIntentHolder(
            //                   flag: PsConst.ADD_NEW_ITEM, item: Product()));
            //         });
            //       } else {
            //         showDialog<dynamic>(
            //             context: context,
            //             builder: (BuildContext context) {
            //               return ErrorDialog(
            //                 message: Utils.getString(
            //                     context, 'error_dialog__no_internet'),
            //               );
            //             });
            //       }
            //     },
            //     icon: _isVisible ? const Icon(Icons.camera_alt) : null,
            //     backgroundColor: PsColors.mainColor,
            //     label: _isVisible
            //         ? Text(Utils.getString(context, 'dashboard__submit_ad'),
            //             style: Theme.of(context)
            //                 .textTheme
            //                 .caption
            //                 .copyWith(color: PsColors.white))
            //         : const Text(''),
            //   ),
            //   height: _isVisible ? PsDimens.space52 : 0.0,
            //   width: PsDimens.space200,
            // ),

            // FloatingActionButton(child: Icon(Icons.add), onPressed: () {}),
            body: Container(
              color: PsColors.coreBackgroundColor,
              child: RefreshIndicator(
                onRefresh: () {
                  final String loginUserId =
                      Utils.checkUserLoginId(valueHolder);

                  _recentProductProvider.resetProductList(loginUserId,
                      _recentProductProvider.productRecentParameterHolder);

                  _popularProductProvider.resetProductList(loginUserId,
                      _popularProductProvider.productPopularParameterHolder);

                  _paidAdItemProvider.resetProductList(loginUserId,
                      _paidAdItemProvider.productPaidAdParameterHolder);

                  if (valueHolder.loginUserId != null &&
                      valueHolder.loginUserId != '') {
                    _userUnreadMessageProvider.userUnreadMessageCount(
                        _userUnreadMessageProvider.userUnreadMessageHolder);
                  }

                  _manufacturerProvider
                      .resetManufacturerList()
                      .then((dynamic value) {
                    final bool isConnectedToIntenet = value ?? bool;

                    if (!isConnectedToIntenet) {
                      Fluttertoast.showToast(
                          msg: 'No Internet Connectiion. Please try again !',
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.blueGrey,
                          textColor: Colors.white);
                    }
                  });

                  return _itemLocationProvider.resetItemLocationList(
                      _itemLocationProvider.defaultLocationParameterHolder
                          .toMap(),
                      Utils.checkUserLoginId(
                          _itemLocationProvider.psValueHolder));
                },
                child: CustomScrollView(
                  scrollDirection: Axis.vertical,
                  controller: widget.scrollController,
                  slivers: <Widget>[
                    // FloatingActionButton(child: Icon(Icons.add), onPressed: () {}),
                    _HomeHeaderWidget(
                      animationController:
                          widget.animationController, //animationController,
                      animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: widget.animationController,
                              curve: Interval((1 / count) * 1, 1.0,
                                  curve: Curves.fastOutSlowIn))),
                      psValueHolder: valueHolder,
                      itemNameTextEditingController:
                          userInputItemNameTextEditingController,
                    ),

                    _HomeCategoryHorizontalListWidget(
                      psValueHolder: valueHolder,
                      animationController:
                          widget.animationController, //animationController,
                      animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: widget.animationController,
                              curve: Interval((1 / count) * 2, 1.0,
                                  curve: Curves.fastOutSlowIn))), //animation
                    ),
                    _RecentProductHorizontalListWidget(
                      psValueHolder: valueHolder,
                      animationController:
                          widget.animationController, //animationController,
                      animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: widget.animationController,
                              curve: Interval((1 / count) * 3, 1.0,
                                  curve: Curves.fastOutSlowIn))), //animation
                    ),
                    /*_HomePopularProductHorizontalListWidget(
                      psValueHolder: valueHolder,
                      animationController:
                          widget.animationController, //animationController,
                      animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: widget.animationController,
                              curve: Interval((1 / count) * 4, 1.0,
                                  curve: Curves.fastOutSlowIn))), //animation
                    ),
                    _HomePaidAdProductHorizontalListWidget(
                      psValueHolder: valueHolder,
                      animationController: widget.animationController,
                      animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: widget.animationController,
                              curve: Interval((1 / count) * 4, 1.0,
                                  curve: Curves.fastOutSlowIn))),
                    ),
                    _HomeBlogProductSliderListWidget(
                      animationController:
                          widget.animationController, //animationController,
                      animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: widget.animationController,
                              curve: Interval((1 / count) * 5, 1.0,
                                  curve: Curves.fastOutSlowIn))), //animation
                    ),

                    _HomeItemListFromFollowersHorizontalListWidget(
                      animationController:
                          widget.animationController, //animationController,
                      animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: widget.animationController,
                              curve: Interval((1 / count) * 4, 1.0,
                                  curve: Curves.fastOutSlowIn))), //animation
                    ),*/
                  ],
                ),
              ),
            )));
  }
}

class _RecentProductHorizontalListWidget extends StatefulWidget {
  const _RecentProductHorizontalListWidget(
      {Key key,
      @required this.animationController,
      @required this.animation,
      @required this.psValueHolder})
      : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final PsValueHolder psValueHolder;

  @override
  __RecentProductHorizontalListWidgetState createState() =>
      __RecentProductHorizontalListWidgetState();
}

class __RecentProductHorizontalListWidgetState
    extends State<_RecentProductHorizontalListWidget> {
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && PsConfig.showAdMob) {
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isConnectedToInternet && PsConfig.showAdMob) {
      print('loading ads....');
      checkConnection();
    }

    return SliverToBoxAdapter(
        // fdfdf
        child: Consumer<RecentProductProvider>(builder: (BuildContext context,
            RecentProductProvider productProvider, Widget child) {
      return AnimatedBuilder(
          animation: widget.animationController,
          child: (productProvider.productList.data != null &&
                  productProvider.productList.data.isNotEmpty)
              ? Column(children: <Widget>[
                  _MyHeaderWidget(
                    headerName:
                        Utils.getString(context, 'dashboard_recent_product'),
                    headerDescription: Utils.getString(context, ''),
                    viewAllClicked: () {
                      Navigator.pushNamed(context, RoutePaths.filterProductList,
                          arguments: ProductListIntentHolder(
                              appBarTitle: Utils.getString(
                                  context, 'dashboard_recent_product'),
                              productParameterHolder: ProductParameterHolder()
                                  .getRecentParameterHolder()));
                    },
                  ),
                  Container(
                      height: MediaQuery.of(context).size.height * .5,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: productProvider.productList.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (productProvider.productList.status ==
                                PsStatus.BLOCK_LOADING) {
                              return Shimmer.fromColors(
                                  baseColor: PsColors.grey,
                                  highlightColor: PsColors.white,
                                  child: Row(children: const <Widget>[
                                    PsFrameUIForLoading(),
                                  ]));
                            } else {
                              final Product product =
                                  productProvider.productList.data[index];
                              return SizedBox(
                                //height: 200.0,

                                child: ProductHorizontalListItem(
                                  productId: productProvider
                                      .productList.data[index].id,
                                  coreTagKey:
                                      productProvider.hashCode.toString() +
                                          product.id,
                                  product:
                                      productProvider.productList.data[index],
                                  onTap: () {
                                    print(productProvider.productList
                                        .data[index].defaultPhoto.imgPath);

                                    final ProductDetailIntentHolder holder =
                                        ProductDetailIntentHolder(
                                            productTitle: productProvider
                                                .productList.data[index].title,
                                            productId: productProvider
                                                .productList.data[index].id,
                                            heroTagImage: productProvider
                                                    .hashCode
                                                    .toString() +
                                                product.id +
                                                PsConst.HERO_TAG__IMAGE,
                                            heroTagTitle: productProvider
                                                    .hashCode
                                                    .toString() +
                                                product.id +
                                                PsConst.HERO_TAG__TITLE);
                                    Navigator.pushNamed(
                                        context, RoutePaths.productDetail,
                                        arguments: holder);
                                  },
                                ),
                              );
                            }
                          })),
                  const PsAdMobBannerWidget(admobSize: NativeAdmobType.full),
                ])
              : Container(),
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
                opacity: widget.animation,
                child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 100 * (1.0 - widget.animation.value), 0.0),
                    child: child));
          });
    }));
  }
}

class _HomeBlogProductSliderListWidget extends StatelessWidget {
  const _HomeBlogProductSliderListWidget({
    Key key,
    @required this.animationController,
    @required this.animation,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    const int count = 6;
    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: animationController,
            curve: const Interval((1 / count) * 1, 1.0,
                curve: Curves.fastOutSlowIn)));

    return SliverToBoxAdapter(
      child: Consumer<BlogProvider>(builder:
          (BuildContext context, BlogProvider blogProvider, Widget child) {
        return AnimatedBuilder(
            animation: animationController,
            child: (blogProvider.blogList != null &&
                    blogProvider.blogList.data.isNotEmpty)
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _MyHeaderWidget(
                        headerName:
                            Utils.getString(context, 'home__menu_drawer_blog'),
                        headerDescription: Utils.getString(context, ''),
                        viewAllClicked: () {
                          Navigator.pushNamed(
                            context,
                            RoutePaths.blogList,
                          );
                        },
                      ),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: PsColors.mainLightShadowColor,
                                offset: const Offset(1.1, 1.1),
                                blurRadius: 20.0),
                          ],
                        ),
                        margin: const EdgeInsets.only(
                            top: PsDimens.space8, bottom: PsDimens.space20),
                        width: double.infinity,
                        child: BlogSliderView(
                          blogList: blogProvider.blogList.data,
                          onTap: (Blog blog) {
                            Navigator.pushNamed(context, RoutePaths.blogDetail,
                                arguments: blog);
                          },
                        ),
                      )
                    ],
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
      }),
    );
  }
}

class _HomeCategoryHorizontalListWidget extends StatefulWidget {
  const _HomeCategoryHorizontalListWidget(
      {Key key,
      @required this.animationController,
      @required this.animation,
      @required this.psValueHolder})
      : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final PsValueHolder psValueHolder;

  @override
  __HomeCategoryHorizontalListWidgetState createState() =>
      __HomeCategoryHorizontalListWidgetState();
}

class __HomeCategoryHorizontalListWidgetState
    extends State<_HomeCategoryHorizontalListWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: Consumer<ManufacturerProvider>(
      builder: (BuildContext context, ManufacturerProvider manufacturerProvider,
          Widget child) {
        return AnimatedBuilder(
            animation: widget.animationController,
            child: (manufacturerProvider.manufacturerList.data != null &&
                    manufacturerProvider.manufacturerList.data.isNotEmpty)
                ? Padding(
                    padding: EdgeInsets.fromLTRB(
                        0,
                        MediaQuery.of(context).size.height * .015,
                        0,
                        MediaQuery.of(context).size.height * .015),
                    child: Card(
                      shadowColor: Colors.grey.shade200,
                      elevation: 10,
                      color: Colors.transparent,
                      child:
                          /*_MyHeaderWidget(
                      headerName:
                          Utils.getString(context, 'dashboard__manufacturer'),
                      headerDescription:
                          Utils.getString(context, 'dashboard__category_desc'),
                      viewAllClicked: () {
                        Navigator.pushNamed(
                            context, RoutePaths.manufacturerList,
                            arguments: Utils.getString(
                                context, 'dashboard__manufacturer'));
                      },
                    ),*/
                          /*SingleChildScrollView(child:  ListView.builder(
                       itemCount: manufacturerProvider
                           .manufacturerList.data.length,
                       itemBuilder: (context, position) {
                         return Text('ggg');
                       },
                     ),),*/
                          CustomScrollView(
                              //physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              slivers: <Widget>[
                            SliverToBoxAdapter(
                              child: Container(
                                height: 100.0,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: manufacturerProvider
                                      .manufacturerList.data.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                        onTap: () {
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          print(manufacturerProvider
                                              .manufacturerList
                                              .data[index]
                                              .defaultPhoto
                                              .imgPath);
                                          final ProductParameterHolder
                                              productParameterHolder =
                                              ProductParameterHolder()
                                                  .getLatestParameterHolder();
                                          productParameterHolder
                                                  .manufacturerId =
                                              manufacturerProvider
                                                  .manufacturerList
                                                  .data[index]
                                                  .id;

                                          if (PsConfig.isShowModel) {
                                            Navigator.pushNamed(
                                                context, RoutePaths.modelGrid,
                                                arguments: manufacturerProvider
                                                    .manufacturerList
                                                    .data[index]);
                                          } else {
                                            final ProductParameterHolder
                                                productParameterHolder =
                                                ProductParameterHolder()
                                                    .getLatestParameterHolder();
                                            productParameterHolder
                                                    .manufacturerId =
                                                manufacturerProvider
                                                    .manufacturerList
                                                    .data[index]
                                                    .id;
                                            Navigator.pushNamed(context,
                                                RoutePaths.filterProductList,
                                                arguments:
                                                    ProductListIntentHolder(
                                                  appBarTitle:
                                                      manufacturerProvider
                                                          .manufacturerList
                                                          .data[index]
                                                          .name,
                                                  productParameterHolder:
                                                      productParameterHolder,
                                                ));
                                          }
                                        },
                                        child: Container(

                                          margin: EdgeInsets.fromLTRB(
                                            MediaQuery.of(context).size.width *
                                                .01,
                                          0,
                                            MediaQuery.of(context).size.width *
                                                .01,
                                           0,
                                          ),
                                          padding: EdgeInsets.all(8),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: PsColors.mainColor,
                                              borderRadius: BorderRadius.all(Radius.circular(5)),
                                              //border:
                                              ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                width: PsDimens.space52,
                                                height: PsDimens.space52,
                                                child: PsNetworkCircleIconImage(
                                                  photoKey: '',
                                                  defaultIcon:
                                                      manufacturerProvider
                                                          .manufacturerList
                                                          .data[index]
                                                          .defaultIcon,
                                                  // width: PsDimens.space52,
                                                  // height: PsDimens.space52,
                                                  boxfit: BoxFit.fitHeight,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: PsDimens.space8,
                                              ),
                                              Text(
                                                manufacturerProvider
                                                    .manufacturerList
                                                    .data[index]
                                                    .name,
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2
                                                    .copyWith(fontSize: 12,
                                                  color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                            ],
                                          ), /* Text(manufacturerProvider
                                        .manufacturerList.data[index].name, ),*/
                                        ));
                                  },
                                ),
                              ),
                            ),
                            /*SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4),
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                if (manufacturerProvider
                                        .manufacturerList.status ==
                                    PsStatus.BLOCK_LOADING) {
                                  return Shimmer.fromColors(
                                      baseColor: PsColors.grey,
                                      highlightColor: PsColors.white,
                                      child: Row(children: const <Widget>[
                                        PsFrameUIForLoading(),
                                      ]));
                                } else {
                                  return ManufacturerHorizontalGridItem(
                                      manufacturer: manufacturerProvider
                                          .manufacturerList.data[index],
                                      onTap: () {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        print(manufacturerProvider
                                            .manufacturerList
                                            .data[index]
                                            .defaultPhoto
                                            .imgPath);
                                        final ProductParameterHolder
                                            productParameterHolder =
                                            ProductParameterHolder()
                                                .getLatestParameterHolder();
                                        productParameterHolder.manufacturerId =
                                            manufacturerProvider
                                                .manufacturerList
                                                .data[index]
                                                .id;

                                        if (PsConfig.isShowModel) {
                                          Navigator.pushNamed(
                                              context, RoutePaths.modelGrid,
                                              arguments: manufacturerProvider
                                                  .manufacturerList
                                                  .data[index]);
                                        } else {
                                          final ProductParameterHolder
                                              productParameterHolder =
                                              ProductParameterHolder()
                                                  .getLatestParameterHolder();
                                          productParameterHolder
                                                  .manufacturerId =
                                              manufacturerProvider
                                                  .manufacturerList
                                                  .data[index]
                                                  .id;
                                          Navigator.pushNamed(context,
                                              RoutePaths.filterProductList,
                                              arguments:
                                                  ProductListIntentHolder(
                                                appBarTitle:
                                                    manufacturerProvider
                                                        .manufacturerList
                                                        .data[index]
                                                        .name,
                                                productParameterHolder:
                                                    productParameterHolder,
                                              ));
                                        }
                                      } // )
                                      );
                                }
                              },
                              childCount: manufacturerProvider
                                  .manufacturerList.data.length,
                            ),
                          ),*/
                          ]),
                    ))
                : Container(),
            builder: (BuildContext context, Widget child) {
              return FadeTransition(
                  opacity: widget.animation,
                  child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 30 * (1.0 - widget.animation.value), 0.0),
                      child: child));
            });
      },
    ));
  }
}

class _HomeItemListFromFollowersHorizontalListWidget extends StatelessWidget {
  const _HomeItemListFromFollowersHorizontalListWidget({
    Key key,
    @required this.animationController,
    @required this.animation,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<ItemListFromFollowersProvider>(
        builder: (BuildContext context,
            ItemListFromFollowersProvider itemListFromFollowersProvider,
            Widget child) {
          return AnimatedBuilder(
            animation: animationController,
            child: (itemListFromFollowersProvider.psValueHolder.loginUserId !=
                        '' &&
                    itemListFromFollowersProvider
                            .itemListFromFollowersList.data !=
                        null &&
                    itemListFromFollowersProvider
                        .itemListFromFollowersList.data.isNotEmpty)
                ? Column(
                    children: <Widget>[
                      _MyHeaderWidget(
                        headerName: Utils.getString(
                            context, 'dashboard__item_list_from_followers'),
                        headerDescription: Utils.getString(
                            context, 'dashboard_follow_item_desc'),
                        viewAllClicked: () {
                          Navigator.pushNamed(
                              context, RoutePaths.itemListFromFollower,
                              arguments: itemListFromFollowersProvider
                                  .psValueHolder.loginUserId);
                        },
                      ),
                      Container(
                          height: PsDimens.space340,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: itemListFromFollowersProvider
                                  .itemListFromFollowersList.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (itemListFromFollowersProvider
                                        .itemListFromFollowersList.status ==
                                    PsStatus.BLOCK_LOADING) {
                                  return Shimmer.fromColors(
                                      baseColor: PsColors.grey,
                                      highlightColor: PsColors.white,
                                      child: Row(children: const <Widget>[
                                        PsFrameUIForLoading(),
                                      ]));
                                } else {
                                  return ProductHorizontalListItem(
                                    productId: itemListFromFollowersProvider
                                        .itemListFromFollowersList
                                        .data[index]
                                        .id,
                                    coreTagKey: itemListFromFollowersProvider
                                            .hashCode
                                            .toString() +
                                        itemListFromFollowersProvider
                                            .itemListFromFollowersList
                                            .data[index]
                                            .id,
                                    product: itemListFromFollowersProvider
                                        .itemListFromFollowersList.data[index],
                                    onTap: () {
                                      print(itemListFromFollowersProvider
                                          .itemListFromFollowersList
                                          .data[index]
                                          .defaultPhoto
                                          .imgPath);
                                      final Product product =
                                          itemListFromFollowersProvider
                                              .itemListFromFollowersList
                                              .data
                                              .reversed
                                              .toList()[index];
                                      final ProductDetailIntentHolder holder =
                                          ProductDetailIntentHolder(
                                              productTitle:
                                                  itemListFromFollowersProvider
                                                      .itemListFromFollowersList
                                                      .data[index]
                                                      .title,
                                              productId:
                                                  itemListFromFollowersProvider
                                                      .itemListFromFollowersList
                                                      .data[index]
                                                      .id,
                                              heroTagImage:
                                                  itemListFromFollowersProvider
                                                          .hashCode
                                                          .toString() +
                                                      product.id +
                                                      PsConst.HERO_TAG__IMAGE,
                                              heroTagTitle:
                                                  itemListFromFollowersProvider
                                                          .hashCode
                                                          .toString() +
                                                      product.id +
                                                      PsConst.HERO_TAG__TITLE);
                                      Navigator.pushNamed(
                                          context, RoutePaths.productDetail,
                                          arguments: holder);
                                    },
                                  );
                                }
                              }))
                    ],
                  )
                : Container(),
            builder: (BuildContext context, Widget child) {
              return FadeTransition(
                opacity: animation,
                child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 100 * (1.0 - animation.value), 0.0),
                    child: child),
              );
            },
          );
        },
      ),
    );
  }
}

class _MyHeaderWidget extends StatefulWidget {
  const _MyHeaderWidget({
    Key key,
    @required this.headerName,
    this.headerDescription,
    @required this.viewAllClicked,
  }) : super(key: key);

  final String headerName;
  final String headerDescription;
  final Function viewAllClicked;

  @override
  __MyHeaderWidgetState createState() => __MyHeaderWidgetState();
}

class __MyHeaderWidgetState extends State<_MyHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.viewAllClicked,
      child: Padding(
        padding: const EdgeInsets.only(
            top: PsDimens.space10,
            left: PsDimens.space16,
            right: PsDimens.space16,
            bottom: PsDimens.space10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  //   fit: FlexFit.loose,
                  child: Text(widget.headerName,
                      style: Theme.of(context).textTheme.headline6.copyWith(
                          fontWeight: FontWeight.bold,
                          color: PsColors.textPrimaryDarkColor)),
                ),
                Text(
                  Utils.getString(context, 'dashboard__view_all'),
                  textAlign: TextAlign.start,
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: PsColors.mainColor),
                ),
              ],
            ),
            if (widget.headerDescription == '')
              Container()
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: PsDimens.space10),
                      child: Text(
                        widget.headerDescription,
                        textAlign: TextAlign.left,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: PsColors.textPrimaryLightColor),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _HomeHeaderWidget extends StatefulWidget {
  const _HomeHeaderWidget(
      {Key key,
      @required this.animationController,
      @required this.animation,
      @required this.psValueHolder,
      @required this.itemNameTextEditingController})
      : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final PsValueHolder psValueHolder;
  final TextEditingController itemNameTextEditingController;

  @override
  __HomeHeaderWidgetState createState() => __HomeHeaderWidgetState();
}

final ProductParameterHolder productParameterHolder =
    ProductParameterHolder().getLatestParameterHolder();

class __HomeHeaderWidgetState extends State<_HomeHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: Consumer<ItemLocationProvider>(
      builder: (BuildContext context, ItemLocationProvider itemLocationProvider,
          Widget child) {
        return _MyHomeHeaderWidget(
          userInputItemNameTextEditingController:
              widget.itemNameTextEditingController,
          selectedLocation: () {
            Navigator.pushNamed(context, RoutePaths.itemLocationList);
          },
          locationName: itemLocationProvider.psValueHolder.locactionName,
          psValueHolder: widget.psValueHolder,
        );
        /*AnimatedBuilder(
            animation: widget.animationController,
            child: Stack(
              children: <Widget>[
               /* _HomeBunnerSliderListWidget(),*/
                _MyHomeHeaderWidget(
                  userInputItemNameTextEditingController:
                      widget.itemNameTextEditingController,
                  selectedLocation: () {
                    Navigator.pushNamed(context, RoutePaths.itemLocationList);
                  },
                  locationName:
                      itemLocationProvider.psValueHolder.locactionName,
                  psValueHolder: widget.psValueHolder,
                )
              ],
            ),
            builder: (BuildContext context, Widget child) {
              return FadeTransition(
                  opacity: widget.animation,
                  child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 30 * (1.0 - widget.animation.value), 0.0),
                      child: child));
            });*/
      },
    ));
  }
}

class _MyHomeHeaderWidget extends StatefulWidget {
  const _MyHomeHeaderWidget(
      {Key key,
      @required this.userInputItemNameTextEditingController,
      @required this.selectedLocation,
      @required this.locationName,
      @required this.psValueHolder})
      : super(key: key);

  final Function selectedLocation;
  final String locationName;
  final TextEditingController userInputItemNameTextEditingController;
  final PsValueHolder psValueHolder;
  @override
  __MyHomeHeaderWidgetState createState() => __MyHomeHeaderWidgetState();
}

class __MyHomeHeaderWidgetState extends State<_MyHomeHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    const Widget _spacingWidget = SizedBox(
      height: PsDimens.space8,
    );
    return Container(
      alignment: Alignment.center,
      /*margin: const EdgeInsets.only(
          left: PsDimens.space32,
          right: PsDimens.space32,
          //top: PsDimens.space80
      ),*/
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(PsDimens.space8),
        // color:  Colors.white54
        color: Utils.isLightMode(context) ? Colors.white : Colors.black54,
      ),
      child: Column(
        children: <Widget>[
          _spacingWidget,
          _spacingWidget,
          /*Text(
            Utils.getString(context, 'dashboard__your_location'),
            style: Theme.of(context).textTheme.bodyText1,
          ),*/
          /*_spacingWidget,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InkWell(
                onTap: widget.selectedLocation,
                child: Text(
                  widget.locationName,
                  textAlign: TextAlign.right,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(color: PsColors.mainColor),
                ),
              ),
              MySeparator(color: PsColors.grey),
            ],
          ),
          _spacingWidget,*/

          PsTextFieldWidgetWithIcon(
              hintText: Utils.getString(context, 'home__bottom_app_bar_search'),
              textEditingController:
                  widget.userInputItemNameTextEditingController,
              psValueHolder: widget.psValueHolder,
              clickSearchButton: () {
                productParameterHolder.searchTerm =
                    widget.userInputItemNameTextEditingController.text;
                Navigator.pushNamed(context, RoutePaths.filterProductList,
                    arguments: ProductListIntentHolder(
                        appBarTitle: Utils.getString(
                            context, 'home_search__app_bar_title'),
                        productParameterHolder: productParameterHolder));
              },
              clickEnterFunction: () {
                productParameterHolder.searchTerm =
                    widget.userInputItemNameTextEditingController.text;
                Navigator.pushNamed(context, RoutePaths.filterProductList,
                    arguments: ProductListIntentHolder(
                        appBarTitle: Utils.getString(
                            context, 'home_search__app_bar_title'),
                        productParameterHolder: productParameterHolder));
              }),
          _spacingWidget
        ],
      ),
    );
  }
}

class MySeparator extends StatelessWidget {
  const MySeparator({this.height = 1, this.color});
  final double height;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // final double boxWidth = constraints.constrainWidth();
        const double dashWidth = 10.0;
        final double dashHeight = height;
        const int dashCount = 10; //(boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List<Widget>.generate(dashCount, (_) {
            return Padding(
              padding: const EdgeInsets.only(right: PsDimens.space2),
              child: SizedBox(
                width: dashWidth,
                height: dashHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: color),
                ),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.center,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
