import 'dart:async';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:haraj/api/common/ps_resource.dart';
import 'package:haraj/config/ps_config.dart';
import 'package:haraj/constant/ps_constants.dart';
import 'package:haraj/constant/ps_dimens.dart';
import 'package:haraj/constant/route_paths.dart';
import 'package:haraj/provider/chat/user_unread_message_provider.dart';
import 'package:haraj/provider/common/notification_provider.dart';
import 'package:haraj/provider/delete_task/delete_task_provider.dart';
import 'package:haraj/provider/product/added_item_provider.dart';
import 'package:haraj/provider/user/user_provider.dart';
import 'package:haraj/repository/Common/notification_repository.dart';
import 'package:haraj/repository/manufacturer_repository.dart';
import 'package:haraj/repository/delete_task_repository.dart';
import 'package:haraj/repository/product_repository.dart';
import 'package:haraj/repository/user_repository.dart';
import 'package:haraj/repository/user_unread_message_repository.dart';
import 'package:haraj/ui/chat/list/chat_list_view.dart';
import 'package:haraj/ui/common/dialog/chat_noti_dialog.dart';
import 'package:haraj/ui/contact/contact_us_view.dart';
import 'package:haraj/ui/common/dialog/confirm_dialog_view.dart';
import 'package:haraj/ui/common/dialog/noti_dialog.dart';
import 'package:haraj/ui/dashboard/home/home_dashboard_view.dart';
import 'package:haraj/ui/history/list/history_list_view.dart';
import 'package:haraj/ui/item/entry/item_entry_view.dart';
import 'package:haraj/ui/item/favourite/favourite_product_list_view.dart';
import 'package:haraj/ui/item/item/user_item_list_for_profile_view.dart';
import 'package:haraj/ui/item/list_with_filter/product_list_with_filter_view.dart';
import 'package:haraj/ui/item/paid_ad/paid_ad_item_list_view.dart';
import 'package:haraj/ui/item/paid_ad_product/paid_ad_product_list_view.dart';
import 'package:haraj/ui/item/reported_item/reported_item_list_view.dart';
import 'package:haraj/ui/language/setting/language_setting_view.dart';
import 'package:haraj/ui/manufacturer/list/manufacturer_list_view.dart';
import 'package:haraj/ui/offer/list/offer_list_view.dart';
import 'package:haraj/ui/rating/item/rating_list_item.dart';
import 'package:haraj/ui/search/home_item_search_view.dart';
import 'package:haraj/ui/terms_and_conditions/terms_and_conditions_view.dart';
import 'package:haraj/ui/setting/setting_view.dart';
import 'package:haraj/ui/user/blocked_user/blocked_user_list_view.dart';
import 'package:haraj/ui/user/forgot_password/forgot_password_view.dart';
import 'package:haraj/ui/user/phone/sign_in/phone_sign_in_container_view.dart';
import 'package:haraj/ui/user/phone/sign_in/phone_sign_in_view.dart';
import 'package:haraj/ui/user/phone/verify_phone/verify_phone_view.dart';
import 'package:haraj/ui/user/profile/profile_view.dart';
import 'package:haraj/ui/user/register/register_view.dart';
import 'package:haraj/ui/user/verify/verify_email_view.dart';
import 'package:haraj/utils/ps_progress_dialog.dart';
import 'package:haraj/viewobject/api_status.dart';
import 'package:haraj/viewobject/common/ps_value_holder.dart';
import 'package:haraj/viewobject/holder/intent_holder/chat_history_intent_holder.dart';
import 'package:haraj/viewobject/holder/intent_holder/item_list_intent_holder.dart';
import 'package:haraj/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:haraj/viewobject/holder/product_parameter_holder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:haraj/viewobject/holder/user_logout_parameter_holder.dart';
import 'package:haraj/viewobject/holder/user_unread_message_parameter_holder.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:haraj/viewobject/product.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:haraj/config/ps_colors.dart';
import 'package:haraj/utils/utils.dart';

class DashboardView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<DashboardView>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final ScrollController innerScrollController = ScrollController();

  String labelMore = 'حراج الشمال';
  AnimationController animationController;
  AnimationController animationControllerForFab;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  Animation<double> animation;

  String appBarTitle = 'حراج الشمال';
  int _currentIndex = PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT;
  String _userId = '';
  bool isLogout = false;
  bool isFirstTime = true;
  bool isShowMessageDialog = false;
  String phoneUserName = '';
  String phoneNumber = '';
  String phoneId = '';
  UserProvider provider;
  Timer timer;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void _navigateToChat(String sellerId, String buyerId, String senderName,
      String senderProflePhoto, String itemId, String action) {
    if (valueHolder.loginUserId == buyerId) {
      Navigator.pushNamed(context, RoutePaths.chatView,
          arguments: ChatHistoryIntentHolder(
            chatFlag: PsConst.CHAT_FROM_SELLER,
            itemId: itemId,
            buyerUserId: buyerId,
            sellerUserId: sellerId,
          ));
    } else {
      Navigator.pushNamed(context, RoutePaths.chatView,
          arguments: ChatHistoryIntentHolder(
            chatFlag: PsConst.CHAT_FROM_BUYER,
            itemId: itemId,
            buyerUserId: buyerId,
            sellerUserId: sellerId,
          ));
    }
  }

  bool isResumed = false;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //|| state == AppLifecycleState.detached) {
      // timer = Timer(
      //   const Duration(milliseconds: 1000),
      //   () {
      isResumed = true;
      initDynamicLinks(context);
      // },
      // );
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      if (valueHolder.loginUserId != null && valueHolder.loginUserId != '') {
        userUnreadMessageHolder = UserUnreadMessageParameterHolder(
            userId: valueHolder.loginUserId,
            deviceToken: valueHolder.deviceToken);
        userUnreadMessageProvider
            .userUnreadMessageCount(userUnreadMessageHolder);
      }
    } else {
      //
    }
  }

  Future<dynamic> showMessageDialog(BuildContext context) async {
    if (!Utils.isShowNotiFromToolbar() && !isShowMessageDialog) {
      showDialog<dynamic>(
          context: context,
          builder: (_) {
            return ChatNotiDialog(
                description:
                    Utils.getString(context, 'noti_message__new_message'),
                leftButtonText: Utils.getString(context, 'chat_noti__cancel'),
                rightButtonText: Utils.getString(context, 'chat_noti__open'),
                onAgreeTap: () {
                  updateSelectedIndexWithAnimation(
                      Utils.getString(
                          context, 'dashboard__bottom_navigation_message'),
                      PsConst.REQUEST_CODE__DASHBOARD_MESSAGE_FRAGMENT);
                });
          });
      isShowMessageDialog = true;
    }
  }

  Future<void> updateSelectedIndexWithAnimation(String title, int index) async {
    await animationController.reverse().then<dynamic>((void data) {
      if (!mounted) {
        return;
      }
      setState(() {
        appBarTitleName = '';
        appBarTitle = title;
        _currentIndex = index;
      });
    });
  }

  Future<void> updateSelectedIndexWithAnimationUserId(
      String title, int index, String userId) async {
    await animationController.reverse().then<dynamic>((void data) {
      if (!mounted) {
        return;
      }
      if (userId != null) {
        _userId = userId;
      }
      setState(() {
        appBarTitle = title;
        _currentIndex = index;
      });
    });
  }

  @override
  void initState() {
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);

    animationControllerForFab = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this, value: 1);
    super.initState();
    initDynamicLinks(context);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    animationController.dispose();
    animationControllerForFab.dispose();
    WidgetsBinding.instance.removeObserver(this);
    if (timer != null) {
      timer.cancel();
    }
    super.dispose();
  }

  Future<void> initDynamicLinks(BuildContext context) async {
    Future<dynamic>.delayed(const Duration(seconds: 1)); //recomme
    String itemId = '';
    if (!isResumed) {
      final PendingDynamicLinkData data =
          await FirebaseDynamicLinks.instance.getInitialLink();

      if (data != null && data?.link != null) {
        final Uri deepLink = data?.link;
        if (deepLink != null) {
          final String path = deepLink.path;
          final List<String> pathList = path.split('=');
          itemId = pathList[1];
          final ProductDetailIntentHolder holder = ProductDetailIntentHolder(
              productId: itemId,
              heroTagImage: '-1' + pathList[1] + PsConst.HERO_TAG__IMAGE,
              heroTagTitle: '-1' + pathList[1] + PsConst.HERO_TAG__TITLE);
          Navigator.pushNamed(context, RoutePaths.productDetail,
              arguments: holder);
        }
      }
    }

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;
      if (deepLink != null) {
        final String path = deepLink.path;
        final List<String> pathList = path.split('=');
        if (itemId == '') {
          final ProductDetailIntentHolder holder = ProductDetailIntentHolder(
              productId: pathList[1],
              heroTagImage: '-1' + pathList[1] + PsConst.HERO_TAG__IMAGE,
              heroTagTitle: '-1' + pathList[1] + PsConst.HERO_TAG__TITLE);
          Navigator.pushNamed(context, RoutePaths.productDetail,
              arguments: holder);
        }
      }
      debugPrint('DynamicLinks onLink $deepLink');
    }, onError: (OnLinkErrorException e) async {
      debugPrint('DynamicLinks onError $e');
    });
  }

  int getBottonNavigationIndex(int param) {
    int index = 0;
    switch (param) {
      case PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT:
        index = 0;
        break;
      case PsConst.REQUEST_CODE__MENU_ADD_NEW_ITEM:
        index = 1;
        break;
      case PsConst.REQUEST_CODE__DASHBOARD_MESSAGE_FRAGMENT:
        index = 2;
        break;
      case PsConst.REQUEST_CODE__DASHBOARD_MORE_FRAGMENT:
        index = 3;
        break;
      default:
        index = 0;
        break;
    }
    return index;
  }

  dynamic getIndexFromBottonNavigationIndex(int param) {
    int index = PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT;
    String title;
    final PsValueHolder psValueHolder =
        Provider.of<PsValueHolder>(context, listen: false);
    switch (param) {
      case 0:
        index = PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT;
        title = Utils.getString(context, 'app_name');
        break;

      case 1:
        index = PsConst.REQUEST_CODE__MENU_ADD_NEW_ITEM;
        title = Utils.getString(context, 'dashboard__submit_ad');
        break;
      case 2:
        index = PsConst.REQUEST_CODE__DASHBOARD_MESSAGE_FRAGMENT;
        title =
            Utils.getString(context, 'dashboard__bottom_navigation_message');

        break;
      case 3:
        index = PsConst.REQUEST_CODE__DASHBOARD_MORE_FRAGMENT;
        title = Utils.getString(context, 'app_name');
        break;

      default:
        index = 0;
        title = ''; //Utils.getString(context, 'app_name');
        break;
    }
    return <dynamic>[title, index];
  }

  ManufacturerRepository manufacturerRepository;
  UserRepository userRepository;
  ProductRepository productRepository;
  PsValueHolder valueHolder;
  DeleteTaskRepository deleteTaskRepository;
  DeleteTaskProvider deleteTaskProvider;
  UserUnreadMessageProvider userUnreadMessageProvider;
  UserUnreadMessageRepository userUnreadMessageRepository;
  NotificationRepository notificationRepository;
  UserUnreadMessageParameterHolder userUnreadMessageHolder;
  String appBarTitleName = '';
  void changeAppBarTitle(String manufacturerName) {
    appBarTitleName = manufacturerName;
  }

  @override
  Widget build(BuildContext context) {
    manufacturerRepository = Provider.of<ManufacturerRepository>(context);
    userRepository = Provider.of<UserRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);
    productRepository = Provider.of<ProductRepository>(context);
    deleteTaskRepository = Provider.of<DeleteTaskRepository>(context);
    userUnreadMessageRepository =
        Provider.of<UserUnreadMessageRepository>(context);
    notificationRepository = Provider.of<NotificationRepository>(context);
    // final dynamic data = EasyLocalizationProvider.of(context).data;
    provider = UserProvider(repo: userRepository, psValueHolder: valueHolder);
    timeDilation = 1.0;

    if (isFirstTime) {
      appBarTitle = Utils.getString(context, 'app_name');
      Utils.subscribeToTopic(valueHolder.notiSetting ?? true);
      Utils.fcmConfigure(context, _fcm, valueHolder.loginUserId);
      isFirstTime = false;
      // initDynamicLinks(context);
    }

    Future<void> updateSelectedIndex(int index) async {
      if (mounted) {
        setState(() {
          _currentIndex = index;
        });
      }
    }

    dynamic callLogout(UserProvider provider,
        DeleteTaskProvider deleteTaskProvider, int index) async {
      updateSelectedIndex(index);
      provider.replaceLoginUserId('');
      provider.replaceLoginUserName('');
      await deleteTaskProvider.deleteTask();
      await FacebookLogin().logOut();
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
    }

    Future<bool> _onWillPop() {
      return showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return ConfirmDialogView(
                    description: Utils.getString(
                        context, 'home__quit_dialog_description'),
                    leftButtonText: Utils.getString(context, 'dialog__cancel'),
                    rightButtonText: Utils.getString(context, 'dialog__ok'),
                    onAgreeTap: () {
                      SystemNavigator.pop();
                    });
              }) ??
          false;
    }

    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));

    UserUnreadMessageParameterHolder userUnreadMessageHolder;

    // return EasyLocalizationProvider(
    //   data: data,
    //   child:
    return WillPopScope(
        onWillPop: () async => false, //_onWillPop,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: Colors.black,
            ),
            child: Scaffold(
                key: scaffoldKey,
                /*drawer: Drawer(

          child: MultiProvider(
            providers: <SingleChildWidget>[
              ChangeNotifierProvider<UserProvider>(
                  lazy: false,
                  create: (BuildContext context) {
                    return UserProvider(
                        repo: userRepository, psValueHolder: valueHolder);
                  }),
              ChangeNotifierProvider<DeleteTaskProvider>(
                  lazy: false,
                  create: (BuildContext context) {
                    deleteTaskProvider = DeleteTaskProvider(
                        repo: deleteTaskRepository, psValueHolder: valueHolder);
                    return deleteTaskProvider;
                  }),
            ],
            child: Consumer<UserProvider>(
              builder:
                  (BuildContext context, UserProvider provider, Widget child) {
                print(provider.psValueHolder.loginUserId);
                return ListView(padding: EdgeInsets.zero, children: <Widget>[
                  _DrawerHeaderWidget(),
                  ListTile(
                    title: Text(
                        Utils.getString(context, 'home__drawer_menu_home')),
                  ),
                  _DrawerMenuWidget(
                      icon: Icons.store,
                      title: Utils.getString(context, 'home__drawer_menu_home'),
                      index: PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        updateSelectedIndexWithAnimation(title, index);
                      }),
                  _DrawerMenuWidget(
                      icon: Icons.category,
                      title: Utils.getString(
                          context, 'home__drawer_menu_manufacturer'),
                      index: PsConst.REQUEST_CODE__MENU_CATEGORY_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        updateSelectedIndexWithAnimation(title, index);
                      }),
                  _DrawerMenuWidget(
                      icon: Icons.schedule,
                      title: Utils.getString(
                          context, 'home__drawer_menu_latest_product'),
                      index: PsConst.REQUEST_CODE__MENU_LATEST_PRODUCT_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        updateSelectedIndexWithAnimation(title, index);
                      }),
                  _DrawerMenuWidget(
                      icon: Icons.trending_up,
                      title: Utils.getString(
                          context, 'home__drawer_menu_popular_item'),
                      index:
                          PsConst.REQUEST_CODE__MENU_TRENDING_PRODUCT_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        updateSelectedIndexWithAnimation(title, index);
                      }),
                  _DrawerMenuWidget(
                      icon: FontAwesome5.gem,
                      title: Utils.getString(
                          context, 'home__drawer_menu_feature_item'),
                      index:
                          PsConst.REQUEST_CODE__MENU_FEATURED_PRODUCT_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        updateSelectedIndexWithAnimation(title, index);
                      }),
                  const Divider(
                    height: PsDimens.space1,
                  ),
                  ListTile(
                    title: Text(Utils.getString(
                        context, 'home__menu_drawer_user_info')),
                  ),
                  _DrawerMenuWidget(
                      icon: Icons.person,
                      title:
                          Utils.getString(context, 'home__menu_drawer_profile'),
                      index:
                          PsConst.REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        title = (valueHolder == null ||
                                valueHolder.userIdToVerify == null ||
                                valueHolder.userIdToVerify == '')
                            ? Utils.getString(
                                context, 'home__menu_drawer_profile')
                            : Utils.getString(
                                context, 'home__bottom_app_bar_verify_email');
                        updateSelectedIndexWithAnimation(title, index);
                      }),
                  if (provider != null)
                    if (provider.psValueHolder.loginUserId != null &&
                        provider.psValueHolder.loginUserId != '')
                      Visibility(
                        visible: true,
                        child: _DrawerMenuWidget(
                            icon: Icons.favorite_border,
                            title: Utils.getString(
                                context, 'home__menu_drawer_favourite'),
                            index:
                                PsConst.REQUEST_CODE__MENU_FAVOURITE_FRAGMENT,
                            onTap: (String title, int index) {
                              Navigator.pop(context);
                              updateSelectedIndexWithAnimation(title, index);
                            }),
                      ),
                  if (provider != null)
                    if (provider.psValueHolder.loginUserId != null &&
                        provider.psValueHolder.loginUserId != '')
                      Visibility(
                        visible: true,
                        child: _DrawerMenuWidget(
                          icon: Icons.swap_horiz,
                          title: Utils.getString(
                              context, 'home__menu_drawer_paid_ad_transaction'),
                          index:
                              PsConst.REQUEST_CODE__MENU_TRANSACTION_FRAGMENT,
                          onTap: (String title, int index) {
                            Navigator.pop(context);
                            updateSelectedIndexWithAnimation(title, index);
                          },
                        ),
                      ),
                  if (provider != null)
                    if (provider.psValueHolder.loginUserId != null &&
                        provider.psValueHolder.loginUserId != '')
                      Visibility(
                        visible: true,
                        child: _DrawerMenuWidget(
                            icon: Icons.book,
                            title: Utils.getString(
                                context, 'home__menu_drawer_user_history'),
                            index: PsConst
                                .REQUEST_CODE__MENU_USER_HISTORY_FRAGMENT, //14
                            onTap: (String title, int index) {
                              Navigator.pop(context);
                              updateSelectedIndexWithAnimation(title, index);
                            }),
                      ),
                  if (provider != null)
                    if (provider.psValueHolder.loginUserId != null &&
                        provider.psValueHolder.loginUserId != '')
                      Visibility(
                        visible: true,
                        child: _DrawerMenuWidget(
                            icon: Icons.chat_bubble,
                            title: Utils.getString(
                                context, 'home__menu_drawer_user_offers'),
                            index: PsConst.REQUEST_CODE__MENU_OFFER_FRAGMENT,
                            onTap: (String title, int index) {
                              Navigator.pop(context);
                              updateSelectedIndexWithAnimation(title, index);
                            }),
                      ),
                  if (provider != null)
                    if (provider.psValueHolder.loginUserId != null &&
                        provider.psValueHolder.loginUserId != '')
                      Visibility(
                        visible: true,
                        child: _DrawerMenuWidget(
                            icon: SimpleLineIcons.user_unfollow,
                            title: Utils.getString(
                                context, 'home__menu_drawer_user_blocked'),
                            index: PsConst
                                .REQUEST_CODE__MENU_BLOCKED_USER_FRAGMENT,
                            onTap: (String title, int index) {
                              Navigator.pop(context);
                              updateSelectedIndexWithAnimation(title, index);
                            }),
                      ),
                  if (provider != null)
                    if (provider.psValueHolder.loginUserId != null &&
                        provider.psValueHolder.loginUserId != '')
                      Visibility(
                        visible: true,
                        child: _DrawerMenuWidget(
                            icon: MaterialCommunityIcons.playlist_remove,
                            title: Utils.getString(
                                context, 'home__menu_drawer_reported_item'),
                            index: PsConst
                                .REQUEST_CODE__MENU_REPORTED_ITEM_FRAGMENT,
                            onTap: (String title, int index) {
                              Navigator.pop(context);
                              updateSelectedIndexWithAnimation(title, index);
                            }),
                      ),
                  if (provider != null)
                    if (provider.psValueHolder.loginUserId != null &&
                        provider.psValueHolder.loginUserId != '')
                      Visibility(
                        visible: true,
                        child: ListTile(
                          leading: Icon(
                            Icons.power_settings_new,
                            color: PsColors.mainColorWithWhite,
                          ),
                          title: Text(
                            Utils.getString(
                                context, 'home__menu_drawer_logout'),
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          onTap: () async {
                            Navigator.pop(context);
                            showDialog<dynamic>(
                                context: context,
                                builder: (BuildContext context) {
                                  return ConfirmDialogView(
                                      description: Utils.getString(context,
                                          'home__logout_dialog_description'),
                                      leftButtonText: Utils.getString(context,
                                          'home__logout_dialog_cancel_button'),
                                      rightButtonText: Utils.getString(context,
                                          'home__logout_dialog_ok_button'),
                                      onAgreeTap: () async {
                                        Navigator.of(context).pop();

                                        PsProgressDialog.showDialog(context);
                                        // callLogout(
                                        //     provider,
                                        //     deleteTaskProvider,
                                        //     PsConst
                                        //         .REQUEST_CODE__MENU_HOME_FRAGMENT);
                                        final UserLogoutHolder
                                            userlogoutHolder = UserLogoutHolder(
                                                userId: provider
                                                    .psValueHolder.loginUserId);
                                        final PsResource<ApiStatus> apiStatus =
                                            await provider.userLogout(
                                                userlogoutHolder.toMap());
                                        PsProgressDialog.dismissDialog();
                                        if (apiStatus.data != null) {
                                          callLogout(
                                              provider,
                                              deleteTaskProvider,
                                              PsConst
                                                  .REQUEST_CODE__MENU_HOME_FRAGMENT);
                                        }
                                      });
                                });
                          },
                        ),
                      ),
                  const Divider(
                    height: PsDimens.space1,
                  ),
                  ListTile(
                    title:
                        Text(Utils.getString(context, 'home__menu_drawer_app')),
                  ),
                  _DrawerMenuWidget(
                      icon: Icons.g_translate,
                      title: Utils.getString(
                          context, 'home__menu_drawer_language'),
                      index: PsConst.REQUEST_CODE__MENU_LANGUAGE_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        updateSelectedIndexWithAnimation(title, index);
                      }),
                  _DrawerMenuWidget(
                      icon: Icons.contacts,
                      title: Utils.getString(
                          context, 'home__menu_drawer_contact_us'),
                      index: PsConst.REQUEST_CODE__MENU_CONTACT_US_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        updateSelectedIndexWithAnimation(title, index);
                      }),
                  _DrawerMenuWidget(
                      icon: Icons.settings,
                      title:
                          Utils.getString(context, 'home__menu_drawer_setting'),
                      index: PsConst.REQUEST_CODE__MENU_SETTING_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        updateSelectedIndexWithAnimation(title, index);
                      }),
                  _DrawerMenuWidget(
                      icon: Icons.info_outline,
                      title: Utils.getString(
                          context, 'privacy_policy__toolbar_name'),
                      index: PsConst
                          .REQUEST_CODE__MENU_TERMS_AND_CONDITION_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        updateSelectedIndexWithAnimation(title, index);
                      }),
                  ListTile(
                    leading: Icon(
                      Icons.star_border,
                      color: PsColors.mainColorWithWhite,
                    ),
                    title: Text(
                      Utils.getString(
                          context, 'home__menu_drawer_rate_this_app'),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      if (Platform.isIOS) {
                        Utils.launchAppStoreURL(
                            iOSAppId: PsConfig.iOSAppStoreId,
                            writeReview: true);
                      } else {
                        Utils.launchURL();
                      }
                    },
                  )
                ]);
              },
            ),
          ),
        ),*/
                appBar: AppBar(
                  automaticallyImplyLeading: false,

                  backgroundColor: Utils.isLightMode(context)
                      ? PsColors.white
                      : Colors.black12,
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: IconButton(
                          icon: Icon(
                            MaterialCommunityIcons.tune,
                            color: PsColors.black,
                          ),
                          onPressed: () {
                            /*Navigator.pushNamed(
                    context,
                    RoutePaths.notiList,
                  );*/
                            showModalBottomSheet<Widget>(
                                context: context,
                                builder: (BuildContext bc) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: const Radius.circular(10),
                                            topRight:
                                                const Radius.circular(10))),
                                    child: CustomScrollView(
                                        scrollDirection: Axis.vertical,
                                        slivers: <Widget>[
                                          HomeItemSearchView(
                                              animationController:
                                                  animationController,
                                              animation: animation,
                                              productParameterHolder:
                                                  ProductParameterHolder()
                                                      .getLatestParameterHolder())
                                        ]),
                                  );
                                });
                          },
                        ),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Text(
                            appBarTitleName == ''
                                ? appBarTitle
                                : appBarTitleName,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(color: PsColors.black),
                          )),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: IconButton(
                          icon: Icon(
                            Icons.notifications_none,
                            color: PsColors.black,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              RoutePaths.notiList,
                            );
                          },
                        ),
                      )
                    ],
                  ),
                  titleSpacing: 0,
                  elevation: 0,
                  iconTheme: IconThemeData(
                    color: PsColors.black,
                  ),
                  textTheme: Theme.of(context).textTheme,
                  brightness: Utils.getBrightnessForAppBar(context),
                  /*actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.notifications_none,
                color: PsColors.black,
              ),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  RoutePaths.notiList,
                );
              },
            ),
          ],*/
                ),
                bottomNavigationBar: _currentIndex ==
                            PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT ||
                        /*
                        _currentIndex ==
                            PsConst.REQUEST_CODE__DASHBOARD_CATEGORY_FRAGMENT ||*/
                        _currentIndex ==
                            PsConst.REQUEST_CODE__MENU_FAVOURITE_FRAGMENT ||
                        _currentIndex ==
                            PsConst.REQUEST_CODE__MENU_ADD_NEW_ITEM ||
                        _currentIndex ==
                            PsConst
                                .REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT ||
                        _currentIndex ==
                            PsConst
                                .REQUEST_CODE__DASHBOARD_USER_ITEMS_FRAGMENT ||
                        _currentIndex ==
                            PsConst
                                .REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT || //go to profile
                        _currentIndex ==
                            PsConst
                                .REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT || //go to forgot password
                        _currentIndex ==
                            PsConst
                                .REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT || //go to register
                        _currentIndex ==
                            PsConst
                                .REQUEST_CODE__MENU_ADD_NEW_ITEM || //go to register
                        _currentIndex ==
                            PsConst
                                .REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT || //go to email verify
                        _currentIndex ==
                            PsConst.REQUEST_CODE__DASHBOARD_SEARCH_FRAGMENT ||
                        _currentIndex ==
                            PsConst.REQUEST_CODE__DASHBOARD_MESSAGE_FRAGMENT ||
                        _currentIndex ==
                            PsConst.REQUEST_CODE__DASHBOARD_MORE_FRAGMENT ||
                        _currentIndex ==
                            PsConst.REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT ||
                        _currentIndex ==
                            PsConst.REQUEST_CODE__MENU_CONTACT_US_FRAGMENT ||
                        _currentIndex ==
                            PsConst
                                .REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT ||
                        _currentIndex ==
                            PsConst
                                .REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT
                    ? Visibility(
                        visible: true,
                        child: BottomNavigationBar(
                          type: BottomNavigationBarType.fixed,
                          currentIndex: getBottonNavigationIndex(_currentIndex),
                          showUnselectedLabels: true,
                          backgroundColor: PsColors.backgroundColor,
                          selectedItemColor: PsColors.mainColor,
                          elevation: 10,
                          onTap: (int index) {
                            if (index == 3) {
                              final dynamic _returnValue =
                                  getIndexFromBottonNavigationIndex(index);

                              updateSelectedIndexWithAnimation(
                                  _returnValue[0], _returnValue[1]);
                              showModalBottomSheet<Widget>(
                                  context: context,
                                  builder: (BuildContext bc) {
                                    return StatefulBuilder(
                                      builder: (BuildContext contxt,
                                          StateSetter setStte) {
                                        // print("gggg ${valueHolder.loginUserId } ${valueHolder.loginUserId }");
                                        return (valueHolder.loginUserId ==
                                                    null ||
                                                valueHolder.loginUserId == '')
                                            ? Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: const Radius
                                                                .circular(10),
                                                            topRight: const Radius
                                                                .circular(10))),
                                                child: Column(
                                                  children: [
                                                    GestureDetector(
                                                        onTap: () {
                                                          setStte(() {
                                                            labelMore =
                                                                "تسجيل دخول";
                                                            Navigator.pushReplacementNamed(
                                                              context,
                                                              RoutePaths.user_phone_signin_container,//RoutePaths.home,
                                                            );
                                                          });

                                                          print(_currentIndex);
                                                        },
                                                        child: Container(
                                                          color: PsColors
                                                              .backgroundColor,
                                                          padding:
                                                              const EdgeInsets
                                                                      .all(
                                                                  PsDimens
                                                                      .space12),
                                                          child: Ink(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Icon(
                                                                 Icons.login,
                                                                  color: PsColors
                                                                      .mainColor,
                                                                  size: PsDimens
                                                                      .space20,
                                                                ),
                                                                Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            5)),
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: <
                                                                        Widget>[
                                                                      Text(
                                                                        "تسجيل دخول",
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .subtitle1,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Icon(
                                                                  Icons
                                                                      .arrow_forward_ios,
                                                                  color: PsColors
                                                                      .mainColor,
                                                                  size: PsDimens
                                                                      .space12,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setStte(() {
                                                            labelMore =
                                                                Utils.getString(
                                                                    context,
                                                                    'home__menu_drawer_contact_us');
                                                            updateSelectedIndexWithAnimation(
                                                                labelMore,
                                                                PsConst
                                                                    .REQUEST_CODE__MENU_CONTACT_US_FRAGMENT);

                                                            _currentIndex = PsConst
                                                                .REQUEST_CODE__MENU_CONTACT_US_FRAGMENT;
                                                            Navigator.pop(
                                                                context);
                                                          });

                                                          print(_currentIndex);
                                                        },
                                                        child: Container(
                                                          color: PsColors
                                                              .backgroundColor,
                                                          padding:
                                                              const EdgeInsets
                                                                      .all(
                                                                  PsDimens
                                                                      .space12),
                                                          child: Ink(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Icon(
                                                                  PsColors
                                                                      .contactus,
                                                                  color: PsColors
                                                                      .mainColor,
                                                                  size: PsDimens
                                                                      .space20,
                                                                ),
                                                                Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            5)),
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: <
                                                                        Widget>[
                                                                      Text(
                                                                        Utils.getString(
                                                                            context,
                                                                            'home__menu_drawer_contact_us'),
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .subtitle1,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Icon(
                                                                  Icons
                                                                      .arrow_forward_ios,
                                                                  color: PsColors
                                                                      .mainColor,
                                                                  size: PsDimens
                                                                      .space12,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            Navigator.pushNamed(
                                                                context,
                                                                RoutePaths
                                                                    .appinfo,
                                                                arguments: 1);
                                                          });

                                                          print(_currentIndex);
                                                          /*return ProfileView(
                                                        scaffoldKey: widget.scaffoldKey,
                                                        animationController: widget.animationController,
                                                        flag: PsConst
                                                            .REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT,

                                                      );*/
                                                        },
                                                        child: Container(
                                                          color: PsColors
                                                              .backgroundColor,
                                                          padding:
                                                              const EdgeInsets
                                                                      .all(
                                                                  PsDimens
                                                                      .space12),
                                                          child: Ink(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Icon(
                                                                  PsColors
                                                                      .appinfo,
                                                                  color: PsColors
                                                                      .mainColor,
                                                                  size: PsDimens
                                                                      .space20,
                                                                ),
                                                                Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            5)),
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: <
                                                                        Widget>[
                                                                      Text(
                                                                        Utils.getString(
                                                                            context,
                                                                            'setting__app_info'),
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .subtitle1,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Icon(
                                                                  Icons
                                                                      .arrow_forward_ios,
                                                                  color: PsColors
                                                                      .mainColor,
                                                                  size: PsDimens
                                                                      .space12,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            Navigator.pushNamed(
                                                                context,
                                                                RoutePaths
                                                                    .apptax,
                                                                arguments: 1);
                                                          });
                                                          print(_currentIndex);
                                                          /*return ProfileView(
                                                        scaffoldKey: widget.scaffoldKey,
                                                        animationController: widget.animationController,
                                                        flag: PsConst
                                                            .REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT,

                                                      );*/
                                                        },
                                                        child: Container(
                                                          color: PsColors
                                                              .backgroundColor,
                                                          padding:
                                                              const EdgeInsets
                                                                      .all(
                                                                  PsDimens
                                                                      .space12),
                                                          child: Ink(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Icon(
                                                                  PsColors
                                                                      .apptax,
                                                                  color: PsColors
                                                                      .mainColor,
                                                                  size: PsDimens
                                                                      .space20,
                                                                ),
                                                                Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            5)),
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: <
                                                                        Widget>[
                                                                      Text(
                                                                        Utils.getString(
                                                                            context,
                                                                            'setting__app_tax'),
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .subtitle1,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Icon(
                                                                  Icons
                                                                      .arrow_forward_ios,
                                                                  color: PsColors
                                                                      .mainColor,
                                                                  size: PsDimens
                                                                      .space12,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              )
                                            : Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: const Radius
                                                                .circular(10),
                                                            topRight: const Radius
                                                                .circular(10))),
                                                child: Column(
                                                  children: [
                                                    GestureDetector(
                                                        onTap: () {
                                                          setStte(() {
                                                            labelMore =
                                                                Utils.getString(
                                                                    context,
                                                                    'home__bottom_app_bar_login');

                                                            updateSelectedIndexWithAnimation(
                                                                labelMore,
                                                                PsConst
                                                                    .REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT);
                                                            _currentIndex = PsConst
                                                                .REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT;

                                                            Navigator.pop(
                                                                context);
                                                          });

                                                          print(_currentIndex);
                                                        },
                                                        child: Container(
                                                          color: PsColors
                                                              .backgroundColor,
                                                          padding:
                                                              const EdgeInsets
                                                                      .all(
                                                                  PsDimens
                                                                      .space12),
                                                          child: Ink(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Icon(
                                                                  PsColors
                                                                      .userprofile,
                                                                  color: PsColors
                                                                      .mainColor,
                                                                  size: PsDimens
                                                                      .space20,
                                                                ),
                                                                Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            5)),
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: <
                                                                        Widget>[
                                                                      Text(
                                                                        Utils.getString(
                                                                            context,
                                                                            'home__bottom_app_bar_login'),
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .subtitle1,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Icon(
                                                                  Icons
                                                                      .arrow_forward_ios,
                                                                  color: PsColors
                                                                      .mainColor,
                                                                  size: PsDimens
                                                                      .space12,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )),
                                                    (valueHolder.loginUserId !=
                                                                null ||
                                                            valueHolder
                                                                    .loginUserId !=
                                                                '')
                                                        ? GestureDetector(
                                                            onTap: () {
                                                              setStte(() {
                                                                labelMore =
                                                                    "اعلاناتي";
                                                                updateSelectedIndexWithAnimation(
                                                                    labelMore,
                                                                    PsConst
                                                                        .REQUEST_CODE__DASHBOARD_USER_ITEMS_FRAGMENT);

                                                                _currentIndex =
                                                                    PsConst
                                                                        .REQUEST_CODE__DASHBOARD_USER_ITEMS_FRAGMENT;
                                                                Navigator.pop(
                                                                    context);
                                                              });
                                                              /*final AddedItemProvider productProvider = AddedItemProvider(
                                                                  repo: productRepository, psValueHolder: valueHolder);
                                                              if (productProvider.psValueHolder.loginUserId == null ||
                                                                  productProvider.psValueHolder.loginUserId == '') {
                                                                productProvider.addedUserParameterHolder.addedUserId = _userId;
                                                                productProvider.addedUserParameterHolder.status = '1';
                                                                productProvider.loadItemList(
                                                                    _userId, productProvider.addedUserParameterHolder);
                                                              } else {
                                                                productProvider.addedUserParameterHolder.addedUserId =
                                                                    productProvider.psValueHolder.loginUserId;
                                                                productProvider.addedUserParameterHolder.status = '1';
                                                                productProvider.loadItemList(productProvider.psValueHolder.loginUserId,
                                                                    productProvider.addedUserParameterHolder);
                                                              }

                                                              Navigator.pushNamed(
                                                                  context, RoutePaths.userItemListForProfile,
                                                                  arguments: ItemListIntentHolder(
                                                                      userId: productProvider
                                                                          .psValueHolder.loginUserId,
                                                                      status:'1',
                                                                      title: Utils.getString(context, 'more__my_post_title')));                                                            });
*/
                                                            },
                                                            child: Container(
                                                              color: PsColors
                                                                  .backgroundColor,
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      PsDimens
                                                                          .space12),
                                                              child: Ink(
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: <
                                                                      Widget>[
                                                                    Icon(
                                                                      PsColors
                                                                          .myads,
                                                                      color: PsColors
                                                                          .mainColor,
                                                                      size: PsDimens
                                                                          .space20,
                                                                    ),
                                                                    Padding(
                                                                        padding:
                                                                            EdgeInsets.all(5)),
                                                                    Expanded(
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: <
                                                                            Widget>[
                                                                          Text(
                                                                            Utils.getString(context,
                                                                                'more__my_post_title'),
                                                                            style:
                                                                                Theme.of(context).textTheme.subtitle1,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Icon(
                                                                      Icons
                                                                          .arrow_forward_ios,
                                                                      color: PsColors
                                                                          .mainColor,
                                                                      size: PsDimens
                                                                          .space12,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ))
                                                        : Container(),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setStte(() {
                                                            labelMore =
                                                                Utils.getString(
                                                                    context,
                                                                    'more__favourite_title');
                                                            updateSelectedIndexWithAnimation(
                                                                labelMore,
                                                                PsConst
                                                                    .REQUEST_CODE__MENU_FAVOURITE_FRAGMENT);

                                                            _currentIndex = PsConst
                                                                .REQUEST_CODE__MENU_FAVOURITE_FRAGMENT;
                                                            Navigator.pop(
                                                                context);
                                                          });

                                                          print(_currentIndex);
                                                          /*return ProfileView(
                                                        scaffoldKey: widget.scaffoldKey,
                                                        animationController: widget.animationController,
                                                        flag: PsConst
                                                            .REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT,

                                                      );*/
                                                        },
                                                        child: Container(
                                                          color: PsColors
                                                              .backgroundColor,
                                                          padding:
                                                              const EdgeInsets
                                                                      .all(
                                                                  PsDimens
                                                                      .space12),
                                                          child: Ink(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Icon(
                                                                  PsColors
                                                                      .favourit,
                                                                  color: PsColors
                                                                      .mainColor,
                                                                  size: PsDimens
                                                                      .space20,
                                                                ),
                                                                Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            5)),
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: <
                                                                        Widget>[
                                                                      Text(
                                                                        Utils.getString(
                                                                            context,
                                                                            'more__favourite_title'),
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .subtitle1,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Icon(
                                                                  Icons
                                                                      .arrow_forward_ios,
                                                                  color: PsColors
                                                                      .mainColor,
                                                                  size: PsDimens
                                                                      .space12,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setStte(() {
                                                            labelMore =
                                                                Utils.getString(
                                                                    context,
                                                                    'home__menu_drawer_contact_us');
                                                            updateSelectedIndexWithAnimation(
                                                                labelMore,
                                                                PsConst
                                                                    .REQUEST_CODE__MENU_CONTACT_US_FRAGMENT);

                                                            _currentIndex = PsConst
                                                                .REQUEST_CODE__MENU_CONTACT_US_FRAGMENT;
                                                            Navigator.pop(
                                                                context);
                                                          });

                                                          print(_currentIndex);
                                                        },
                                                        child: Container(
                                                          color: PsColors
                                                              .backgroundColor,
                                                          padding:
                                                              const EdgeInsets
                                                                      .all(
                                                                  PsDimens
                                                                      .space12),
                                                          child: Ink(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Icon(
                                                                  PsColors
                                                                      .contactus,
                                                                  color: PsColors
                                                                      .mainColor,
                                                                  size: PsDimens
                                                                      .space20,
                                                                ),
                                                                Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            5)),
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: <
                                                                        Widget>[
                                                                      Text(
                                                                        Utils.getString(
                                                                            context,
                                                                            'home__menu_drawer_contact_us'),
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .subtitle1,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Icon(
                                                                  Icons
                                                                      .arrow_forward_ios,
                                                                  color: PsColors
                                                                      .mainColor,
                                                                  size: PsDimens
                                                                      .space12,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            Navigator.pushNamed(
                                                                context,
                                                                RoutePaths
                                                                    .appinfo,
                                                                arguments: 1);
                                                          });

                                                          print(_currentIndex);
                                                          /*return ProfileView(
                                                        scaffoldKey: widget.scaffoldKey,
                                                        animationController: widget.animationController,
                                                        flag: PsConst
                                                            .REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT,

                                                      );*/
                                                        },
                                                        child: Container(
                                                          color: PsColors
                                                              .backgroundColor,
                                                          padding:
                                                              const EdgeInsets
                                                                      .all(
                                                                  PsDimens
                                                                      .space12),
                                                          child: Ink(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Icon(
                                                                  PsColors
                                                                      .appinfo,
                                                                  color: PsColors
                                                                      .mainColor,
                                                                  size: PsDimens
                                                                      .space20,
                                                                ),
                                                                Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            5)),
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: <
                                                                        Widget>[
                                                                      Text(
                                                                        Utils.getString(
                                                                            context,
                                                                            'setting__app_info'),
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .subtitle1,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Icon(
                                                                  Icons
                                                                      .arrow_forward_ios,
                                                                  color: PsColors
                                                                      .mainColor,
                                                                  size: PsDimens
                                                                      .space12,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            Navigator.pushNamed(
                                                                context,
                                                                RoutePaths
                                                                    .apptax,
                                                                arguments: 1);
                                                          });
                                                          print(_currentIndex);
                                                          /*return ProfileView(
                                                        scaffoldKey: widget.scaffoldKey,
                                                        animationController: widget.animationController,
                                                        flag: PsConst
                                                            .REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT,

                                                      );*/
                                                        },
                                                        child: Container(
                                                          color: PsColors
                                                              .backgroundColor,
                                                          padding:
                                                              const EdgeInsets
                                                                      .all(
                                                                  PsDimens
                                                                      .space12),
                                                          child: Ink(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Icon(
                                                                  PsColors
                                                                      .apptax,
                                                                  color: PsColors
                                                                      .mainColor,
                                                                  size: PsDimens
                                                                      .space20,
                                                                ),
                                                                Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            5)),
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: <
                                                                        Widget>[
                                                                      Text(
                                                                        Utils.getString(
                                                                            context,
                                                                            'setting__app_tax'),
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .subtitle1,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Icon(
                                                                  Icons
                                                                      .arrow_forward_ios,
                                                                  color: PsColors
                                                                      .mainColor,
                                                                  size: PsDimens
                                                                      .space12,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            Navigator.pop(
                                                                context);
                                                            showDialog<dynamic>(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  print(
                                                                      "mmmm${valueHolder.loginUserId}");
                                                                  return ConfirmDialogView(
                                                                      description: Utils.getString(
                                                                          context,
                                                                          'home__logout_dialog_description'),
                                                                      leftButtonText: Utils.getString(
                                                                          context,
                                                                          'home__logout_dialog_cancel_button'),
                                                                      rightButtonText: Utils.getString(
                                                                          context,
                                                                          'home__logout_dialog_ok_button'),
                                                                      onAgreeTap:
                                                                          () async {
                                                                        print(
                                                                            "mm${valueHolder.loginUserId}");
                                                                        Navigator.of(context)
                                                                            .pop();

                                                                        PsProgressDialog.showDialog(
                                                                            context);
                                                                        // callLogout(
                                                                        //     provider,
                                                                        //     deleteTaskProvider,
                                                                        //     PsConst
                                                                        //         .REQUEST_CODE__MENU_HOME_FRAGMENT);

                                                                        final UserLogoutHolder
                                                                            userlogoutHolder =
                                                                            UserLogoutHolder(userId: valueHolder.loginUserId);
                                                                        final PsResource<ApiStatus>
                                                                            apiStatus =
                                                                            await provider.userLogout(userlogoutHolder.toMap());
                                                                        PsProgressDialog
                                                                            .dismissDialog();
                                                                        if (apiStatus.data !=
                                                                            null) {
                                                                          callLogout(
                                                                              provider,
                                                                              deleteTaskProvider,
                                                                              PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT);
                                                                        }

                                                                        /*Navigator.of(context).pop();

                                                                          PsProgressDialog.showDialog(context);
                                                                          // callLogout(
                                                                          //     provider,
                                                                          //     deleteTaskProvider,
                                                                          //     PsConst
                                                                          //         .REQUEST_CODE__MENU_HOME_FRAGMENT);
                                                                          print('logout');
                                                                          print(valueHolder.loginUserId);
                                                                          final UserLogoutHolder
                                                                          userlogoutHolder = UserLogoutHolder(
                                                                              userId: valueHolder.loginUserId);
                                                                          final PsResource<ApiStatus> apiStatus =
                                                                          await provider.userLogout(
                                                                              userlogoutHolder.toMap());
                                                                          PsProgressDialog.dismissDialog();
                                                                          if (apiStatus.data != null) {
                                                                            callLogout(
                                                                                provider,
                                                                                deleteTaskProvider,
                                                                                PsConst
                                                                                    .REQUEST_CODE__MENU_HOME_FRAGMENT);
                                                                          }*/
                                                                      });
                                                                });
                                                          });
                                                        },
                                                        child: Container(
                                                          color: PsColors
                                                              .backgroundColor,
                                                          padding:
                                                              const EdgeInsets
                                                                      .all(
                                                                  PsDimens
                                                                      .space12),
                                                          child: Ink(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Icon(
                                                                  PsColors
                                                                      .signout,
                                                                  color: PsColors
                                                                      .mainColor,
                                                                  size: PsDimens
                                                                      .space20,
                                                                ),
                                                                Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            5)),
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: <
                                                                        Widget>[
                                                                      Text(
                                                                        Utils.getString(
                                                                            context,
                                                                            'home__menu_drawer_logout'),
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .subtitle1,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Icon(
                                                                  Icons
                                                                      .arrow_forward_ios,
                                                                  color: PsColors
                                                                      .mainColor,
                                                                  size: PsDimens
                                                                      .space12,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              );
                                      },
                                    );
                                  });
                            }
                            if (index != 0 && index != 3) {
                              if (valueHolder.loginUserId == null ||
                                  valueHolder.loginUserId == '') {
                                print(" username: ${valueHolder.loginUserId}");
                                Navigator.pushReplacementNamed(
                                  context,
                                  RoutePaths.user_phone_signin_container,
                                );
                              } else {
                                final dynamic _returnValue =
                                    getIndexFromBottonNavigationIndex(index);

                                updateSelectedIndexWithAnimation(
                                    _returnValue[0], _returnValue[1]);
                              }
                            } else {
                              final dynamic _returnValue =
                                  getIndexFromBottonNavigationIndex(index);

                              updateSelectedIndexWithAnimation(
                                  _returnValue[0], _returnValue[1]);
                            }
                          },
                          items: <BottomNavigationBarItem>[
                            BottomNavigationBarItem(
                              icon: const Icon(
                                PsColors.home,
                                size: 20,
                              ),
                              label:
                                  Utils.getString(context, 'dashboard__home'),
                            ),
                            BottomNavigationBarItem(
                                icon: Icon(PsColors.surface1),
                                label: Utils.getString(
                                    context, 'item_entry__listing_entry')),
                            BottomNavigationBarItem(
                              icon: Stack(
                                children: <Widget>[
                                  Container(
                                    width: PsDimens.space40,
                                    margin: const EdgeInsets.only(
                                        left: PsDimens.space8,
                                        right: PsDimens.space8),
                                    child: const Align(
                                      alignment: Alignment.center,
                                      child: Icon(
                                        PsColors.add_ads,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: PsDimens.space4,
                                    top: PsDimens.space1,
                                    child: ChangeNotifierProvider<
                                            UserUnreadMessageProvider>(
                                        create: (BuildContext context) {
                                      userUnreadMessageProvider =
                                          UserUnreadMessageProvider(
                                              repo:
                                                  userUnreadMessageRepository);

                                      if (valueHolder.loginUserId != null &&
                                          valueHolder.loginUserId != '') {
                                        userUnreadMessageHolder =
                                            UserUnreadMessageParameterHolder(
                                                userId: valueHolder.loginUserId,
                                                deviceToken:
                                                    valueHolder.deviceToken);
                                        userUnreadMessageProvider
                                            .userUnreadMessageCount(
                                                userUnreadMessageHolder);
                                      }
                                      return userUnreadMessageProvider;
                                    }, child: Consumer<
                                                UserUnreadMessageProvider>(
                                            builder: (BuildContext
                                                    context,
                                                UserUnreadMessageProvider
                                                    userUnreadMessageProvider,
                                                Widget child) {
                                      if (userUnreadMessageProvider != null &&
                                          userUnreadMessageProvider
                                                  .userUnreadMessage !=
                                              null &&
                                          userUnreadMessageProvider
                                                  .userUnreadMessage.data !=
                                              null) {
                                        // print(userUnreadMessageProvider
                                        //     .userUnreadMessage
                                        //     .data
                                        //     .buyerUnreadCount);
                                        final int sellerCount = int.parse(
                                            userUnreadMessageProvider
                                                .userUnreadMessage
                                                .data
                                                .sellerUnreadCount);
                                        final int buyerCount = int.parse(
                                            userUnreadMessageProvider
                                                .userUnreadMessage
                                                .data
                                                .buyerUnreadCount);
                                        userUnreadMessageProvider
                                                .totalUnreadCount =
                                            sellerCount + buyerCount;
                                        if (userUnreadMessageProvider
                                                .totalUnreadCount ==
                                            0) {
                                          return Container();
                                        } else {
                                          if (userUnreadMessageProvider
                                                  .totalUnreadCount >
                                              0) {
                                            Future<dynamic>.delayed(
                                                Duration.zero,
                                                () =>
                                                    showMessageDialog(context));
                                          }
                                          return Container(
                                            width: PsDimens.space20,
                                            height: PsDimens.space20,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: PsColors.mainColor,
                                            ),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                userUnreadMessageProvider
                                                            .totalUnreadCount >
                                                        9
                                                    ? '9+'
                                                    : userUnreadMessageProvider
                                                        .totalUnreadCount
                                                        .toString(),
                                                textAlign: TextAlign.left,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2
                                                    .copyWith(
                                                        color: PsColors
                                                            .whiteColorWithBlack),
                                                maxLines: 1,
                                              ),
                                            ),
                                          );
                                        }
                                      } else {
                                        return Container();
                                      }
                                    })),
                                  ),
                                ],
                              ),
                              label: Utils.getString(context,
                                  'dashboard__bottom_navigation_message'),
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(PsColors.more),
                              label:
                                  Utils.getString(context, 'item_entry__more'),
                            )
                          ],
                        ),
                      )
                    : null,
                body: ChangeNotifierProvider<NotificationProvider>(
                    lazy: false,
                    create: (BuildContext context) {
                      final NotificationProvider provider =
                          NotificationProvider(
                              repo: notificationRepository,
                              psValueHolder: valueHolder);

                      if (provider.psValueHolder.deviceToken == null ||
                          provider.psValueHolder.deviceToken == '') {
                        final FirebaseMessaging _fcm = FirebaseMessaging();
                        Utils.saveDeviceToken(_fcm, provider);
                      } else {
                        print(
                            'Notification Token is already registered. Notification Setting : true.');
                      }

                      return provider;
                    },
                    child: Builder(
                      builder: (BuildContext context) {
                        if (_currentIndex ==
                            PsConst.REQUEST_CODE__DASHBOARD_CATEGORY_FRAGMENT) {
                          return ManufacturerListView(innerScrollController);
                        } else if (_currentIndex ==
                            PsConst
                                .REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT) {
                          return ChangeNotifierProvider<UserProvider>(
                              lazy: false,
                              create: (BuildContext context) {
                                provider = UserProvider(
                                    repo: userRepository,
                                    psValueHolder: valueHolder);

                                return provider;
                              },
                              child: Consumer<UserProvider>(builder:
                                  (BuildContext context, UserProvider provider,
                                      Widget child) {
                                if (provider == null ||
                                    provider.psValueHolder.userIdToVerify ==
                                        null ||
                                    provider.psValueHolder.userIdToVerify ==
                                        '') {
                                  if (provider == null ||
                                      provider.psValueHolder == null ||
                                      provider.psValueHolder.loginUserId ==
                                          null ||
                                      provider.psValueHolder.loginUserId ==
                                          '') {
                                    return _CallVerifyPhoneWidget(
                                        currentIndex: _currentIndex,
                                        animationController:
                                            animationController,
                                        animation: animation,
                                        updateCurrentIndex:
                                            (String title, int index) {
                                          if (index != null) {
                                            updateSelectedIndexWithAnimation(
                                                title, index);
                                          }
                                        },
                                        updateUserCurrentIndex: (String title,
                                            int index, String userId) {
                                          if (index != null) {
                                            updateSelectedIndexWithAnimation(
                                                title, index);
                                          }
                                          if (userId != null) {
                                            _userId = userId;
                                            provider.psValueHolder.loginUserId =
                                                userId;
                                          }
                                        });
                                  } else {
                                    return ProfileView(
                                      scaffoldKey: scaffoldKey,
                                      animationController: animationController,
                                      flag: _currentIndex,
                                      callLogoutCallBack: (String userId) {
                                        callLogout(
                                            provider,
                                            deleteTaskProvider,
                                            PsConst
                                                .REQUEST_CODE__MENU_HOME_FRAGMENT);
                                      },
                                    );
                                  }
                                } else {
                                  return _CallVerifyEmailWidget(
                                      animationController: animationController,
                                      animation: animation,
                                      currentIndex: _currentIndex,
                                      userId: _userId,
                                      updateCurrentIndex:
                                          (String title, int index) {
                                        updateSelectedIndexWithAnimation(
                                            title, index);
                                      },
                                      updateUserCurrentIndex: (String title,
                                          int index, String userId) async {
                                        if (userId != null) {
                                          _userId = userId;
                                          provider.psValueHolder.loginUserId =
                                              userId;
                                        }
                                        if (mounted) {
                                          setState(() {
                                            appBarTitle = title;
                                            _currentIndex = index;
                                          });
                                        }
                                      });
                                }
                              }));
                        }

                        if (_currentIndex ==
                                PsConst
                                    .REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT ||
                            _currentIndex ==
                                PsConst
                                    .REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT) {
                          return Stack(children: <Widget>[
                            Container(
                              color: PsColors.mainLightColor,
                              width: double.infinity,
                              height: double.maxFinite,
                            ),
                            CustomScrollView(
                                scrollDirection: Axis.vertical,
                                slivers: <Widget>[
                                  PhoneSignInView(
                                      animationController: animationController,
                                      goToLoginSelected: () {
                                        animationController
                                            .reverse()
                                            .then<dynamic>((void data) {
                                          if (!mounted) {
                                            return;
                                          }
                                          if (_currentIndex ==
                                              PsConst
                                                  .REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT) {
                                            updateSelectedIndexWithAnimation(
                                                Utils.getString(
                                                    context, 'home_login'),
                                                PsConst
                                                    .REQUEST_CODE__MENU_LOGIN_FRAGMENT);
                                          }
                                          if (_currentIndex ==
                                              PsConst
                                                  .REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT) {
                                            updateSelectedIndexWithAnimation(
                                                Utils.getString(
                                                    context, 'home_login'),
                                                PsConst
                                                    .REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT);
                                          }
                                        });
                                      },
                                      phoneSignInSelected: (String name,
                                          String phoneNo, String verifyId) {
                                        phoneUserName = name;
                                        phoneNumber = phoneNo;
                                        phoneId = verifyId;
                                        if (_currentIndex ==
                                            PsConst
                                                .REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT) {
                                          updateSelectedIndexWithAnimation(
                                              Utils.getString(
                                                  context, 'home_verify_phone'),
                                              PsConst
                                                  .REQUEST_CODE__MENU_PHONE_VERIFY_FRAGMENT);
                                        }
                                        if (_currentIndex ==
                                            PsConst
                                                .REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT) {
                                          updateSelectedIndexWithAnimation(
                                              Utils.getString(
                                                  context, 'home_verify_phone'),
                                              PsConst
                                                  .REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT);
                                        }
                                      })
                                ])
                          ]);
                        } else if (_currentIndex ==
                                PsConst
                                    .REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT ||
                            _currentIndex ==
                                PsConst
                                    .REQUEST_CODE__MENU_PHONE_VERIFY_FRAGMENT) {
                          return _CallVerifyPhoneWidget(
                              userName: phoneUserName,
                              phoneNumber: phoneNumber,
                              phoneId: phoneId,
                              animationController: animationController,
                              animation: animation,
                              currentIndex: _currentIndex,
                              updateCurrentIndex: (String title, int index) {
                                updateSelectedIndexWithAnimation(title, index);
                              },
                              updateUserCurrentIndex: (String title, int index,
                                  String userId) async {
                                if (userId != null) {
                                  _userId = userId;
                                }
                                if (mounted) {
                                  setState(() {
                                    appBarTitle = title;
                                    _currentIndex = index;
                                  });
                                }
                              });
                        } else if (_currentIndex ==
                                PsConst
                                    .REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT ||
                            _currentIndex ==
                                PsConst
                                    .REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT) {
                          return ProfileView(
                            scaffoldKey: scaffoldKey,
                            animationController: animationController,
                            flag: _currentIndex,
                            userId: _userId,
                            callLogoutCallBack: (String userId) {
                              callLogout(provider, deleteTaskProvider,
                                  PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT);
                            },
                          );
                        } else if (_currentIndex ==
                            PsConst.REQUEST_CODE__MENU_CATEGORY_FRAGMENT) {
                          return ManufacturerListView(innerScrollController);
                        } else if (_currentIndex ==
                            PsConst
                                .REQUEST_CODE__MENU_LATEST_PRODUCT_FRAGMENT) {
                          return ProductListWithFilterView(
                            scrollController: innerScrollController,
                            changeAppBarTitle: changeAppBarTitle,
                            key: const Key('1'),
                            animationController: animationController,
                            productParameterHolder: ProductParameterHolder()
                                .getLatestParameterHolder(),
                          );
                        } else if (_currentIndex ==
                            PsConst
                                .REQUEST_CODE__MENU_DISCOUNT_PRODUCT_FRAGMENT) {
                          return ProductListWithFilterView(
                            key: const Key('2'),
                            changeAppBarTitle: changeAppBarTitle,
                            scrollController: innerScrollController,
                            animationController: animationController,
                            productParameterHolder: ProductParameterHolder()
                                .getRecentParameterHolder(),
                          );
                        } else if (_currentIndex ==
                            PsConst
                                .REQUEST_CODE__MENU_TRENDING_PRODUCT_FRAGMENT) {
                          return ProductListWithFilterView(
                            scrollController: innerScrollController,
                            key: const Key('3'),
                            changeAppBarTitle: changeAppBarTitle,
                            animationController: animationController,
                            productParameterHolder: ProductParameterHolder()
                                .getPopularParameterHolder(),
                          );
                        } else if (_currentIndex ==
                            PsConst
                                .REQUEST_CODE__MENU_FEATURED_PRODUCT_FRAGMENT) {
                          return PaidAdProductListView(
                            key: const Key('4'),
                            animationController: animationController,
                          );
                        } else if (_currentIndex ==
                                PsConst
                                    .REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT ||
                            _currentIndex ==
                                PsConst
                                    .REQUEST_CODE__MENU_FORGOT_PASSWORD_FRAGMENT) {
                          return Stack(children: <Widget>[
                            Container(
                              color: PsColors.mainLightColorWithBlack,
                              width: double.infinity,
                              height: double.maxFinite,
                            ),
                            CustomScrollView(
                                scrollDirection: Axis.vertical,
                                slivers: <Widget>[
                                  ForgotPasswordView(
                                    animationController: animationController,
                                    goToLoginSelected: () {
                                      animationController
                                          .reverse()
                                          .then<dynamic>((void data) {
                                        if (!mounted) {
                                          return;
                                        }
                                        if (_currentIndex ==
                                            PsConst
                                                .REQUEST_CODE__MENU_FORGOT_PASSWORD_FRAGMENT) {
                                          updateSelectedIndexWithAnimation(
                                              Utils.getString(
                                                  context, 'home_login'),
                                              PsConst
                                                  .REQUEST_CODE__MENU_LOGIN_FRAGMENT);
                                        }
                                        if (_currentIndex ==
                                            PsConst
                                                .REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT) {
                                          updateSelectedIndexWithAnimation(
                                              Utils.getString(
                                                  context, 'home_login'),
                                              PsConst
                                                  .REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT);
                                        }
                                      });
                                    },
                                  )
                                ])
                          ]);
                        } else if (_currentIndex ==
                                PsConst
                                    .REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT ||
                            _currentIndex ==
                                PsConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT) {
                          return Stack(children: <Widget>[
                            Container(
                              color: PsColors.mainLightColorWithBlack,
                              width: double.infinity,
                              height: double.maxFinite,
                            ),
                            CustomScrollView(
                                scrollDirection: Axis.vertical,
                                slivers: <Widget>[
                                  RegisterView(
                                      animationController: animationController,
                                      onRegisterSelected: (String userId) {
                                        _userId = userId;
                                        // widget.provider.psValueHolder.loginUserId = userId;
                                        if (_currentIndex ==
                                            PsConst
                                                .REQUEST_CODE__MENU_REGISTER_FRAGMENT) {
                                          updateSelectedIndexWithAnimation(
                                              Utils.getString(context,
                                                  'home__verify_email'),
                                              PsConst
                                                  .REQUEST_CODE__MENU_VERIFY_EMAIL_FRAGMENT);
                                        } else if (_currentIndex ==
                                            PsConst
                                                .REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT) {
                                          updateSelectedIndexWithAnimation(
                                              Utils.getString(context,
                                                  'home__verify_email'),
                                              PsConst
                                                  .REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT);
                                        } else {
                                          updateSelectedIndexWithAnimationUserId(
                                              Utils.getString(context,
                                                  'home__menu_drawer_profile'),
                                              PsConst
                                                  .REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                                              userId);
                                        }
                                      },
                                      goToLoginSelected: () {
                                        animationController
                                            .reverse()
                                            .then<dynamic>((void data) {
                                          if (!mounted) {
                                            return;
                                          }
                                          if (_currentIndex ==
                                              PsConst
                                                  .REQUEST_CODE__MENU_REGISTER_FRAGMENT) {
                                            updateSelectedIndexWithAnimation(
                                                Utils.getString(
                                                    context, 'home_login'),
                                                PsConst
                                                    .REQUEST_CODE__MENU_LOGIN_FRAGMENT);
                                          }
                                          if (_currentIndex ==
                                              PsConst
                                                  .REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT) {
                                            updateSelectedIndexWithAnimation(
                                                Utils.getString(
                                                    context, 'home_login'),
                                                PsConst
                                                    .REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT);
                                          }
                                        });
                                      })
                                ])
                          ]);
                        } else if (_currentIndex ==
                                PsConst
                                    .REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT ||
                            _currentIndex ==
                                PsConst
                                    .REQUEST_CODE__MENU_VERIFY_EMAIL_FRAGMENT) {
                          return _CallVerifyEmailWidget(
                              animationController: animationController,
                              animation: animation,
                              currentIndex: _currentIndex,
                              userId: _userId,
                              updateCurrentIndex: (String title, int index) {
                                updateSelectedIndexWithAnimation(title, index);
                              },
                              updateUserCurrentIndex: (String title, int index,
                                  String userId) async {
                                if (userId != null) {
                                  _userId = userId;
                                }
                                if (mounted) {
                                  setState(() {
                                    appBarTitle = title;
                                    _currentIndex = index;
                                  });
                                }
                              });
                        } else if (_currentIndex ==
                                PsConst
                                    .REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT ||
                            _currentIndex ==
                                PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                          return _CallVerifyPhoneWidget(
                              currentIndex: _currentIndex,
                              animationController: animationController,
                              animation: animation,
                              updateCurrentIndex: (String title, int index) {
                                updateSelectedIndexWithAnimation(title, index);
                              },
                              updateUserCurrentIndex:
                                  (String title, int index, String userId) {
                                if (mounted) {
                                  setState(() {
                                    if (index != null) {
                                      appBarTitle = title;
                                      _currentIndex = index;
                                    }
                                  });
                                }
                                if (userId != null) {
                                  _userId = userId;
                                }
                              });
                        } else if (_currentIndex ==
                            PsConst
                                .REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT) {
                          return ChangeNotifierProvider<UserProvider>(
                              lazy: false,
                              create: (BuildContext context) {
                                final UserProvider provider = UserProvider(
                                    repo: userRepository,
                                    psValueHolder: valueHolder);

                                return provider;
                              },
                              child: Consumer<UserProvider>(builder:
                                  (BuildContext context, UserProvider provider,
                                      Widget child) {
                                if (provider == null ||
                                    provider.psValueHolder.userIdToVerify ==
                                        null ||
                                    provider.psValueHolder.userIdToVerify ==
                                        '') {
                                  if (provider == null ||
                                      provider.psValueHolder == null ||
                                      provider.psValueHolder.loginUserId ==
                                          null ||
                                      provider.psValueHolder.loginUserId ==
                                          '') {
                                    return Stack(
                                      children: <Widget>[
                                        Container(
                                          color:
                                              PsColors.mainLightColorWithBlack,
                                          width: double.infinity,
                                          height: double.maxFinite,
                                        ),
                                        CustomScrollView(
                                            scrollDirection: Axis.vertical,
                                            slivers: <Widget>[
                                              PhoneSignInContainerView(),
                                              /*LoginView(
                                                animationController:
                                                    animationController,
                                                animation: animation,
                                                onGoogleSignInSelected:
                                                    (String userId) {
                                                  if (mounted) {
                                                    setState(() {
                                                      _currentIndex = PsConst
                                                          .REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT;
                                                    });
                                                  }
                                                  _userId = userId;
                                                  provider.psValueHolder
                                                      .loginUserId = userId;
                                                },
                                                onFbSignInSelected:
                                                    (String userId) {
                                                  if (mounted) {
                                                    setState(() {
                                                      _currentIndex = PsConst
                                                          .REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT;
                                                    });
                                                  }
                                                  _userId = userId;
                                                  provider.psValueHolder
                                                      .loginUserId = userId;
                                                },
                                                onPhoneSignInSelected: () {
                                                  if (_currentIndex ==
                                                      PsConst
                                                          .REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT) {
                                                    updateSelectedIndexWithAnimation(
                                                        Utils.getString(context,
                                                            'home_phone_signin'),
                                                        PsConst
                                                            .REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT);
                                                  } else if (_currentIndex ==
                                                      PsConst
                                                          .REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT) {
                                                    updateSelectedIndexWithAnimation(
                                                        Utils.getString(context,
                                                            'home_phone_signin'),
                                                        PsConst
                                                            .REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
                                                  } else if (_currentIndex ==
                                                      PsConst
                                                          .REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT) {
                                                    updateSelectedIndexWithAnimation(
                                                        Utils.getString(context,
                                                            'home_phone_signin'),
                                                        PsConst
                                                            .REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT);
                                                  } else if (_currentIndex ==
                                                      PsConst
                                                          .REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT) {
                                                    updateSelectedIndexWithAnimation(
                                                        Utils.getString(context,
                                                            'home_phone_signin'),
                                                        PsConst
                                                            .REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
                                                  } else {
                                                    updateSelectedIndexWithAnimation(
                                                        Utils.getString(context,
                                                            'home_phone_signin'),
                                                        PsConst
                                                            .REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
                                                  }
                                                },
                                                onProfileSelected:
                                                    (String userId) {
                                                  if (mounted) {
                                                    setState(() {
                                                      _currentIndex = PsConst
                                                          .REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT;
                                                      _userId = userId;
                                                      provider.psValueHolder
                                                          .loginUserId = userId;
                                                    });
                                                  }
                                                },
                                                onForgotPasswordSelected: () {
                                                  if (mounted) {
                                                    setState(() {
                                                      _currentIndex = PsConst
                                                          .REQUEST_CODE__MENU_FORGOT_PASSWORD_FRAGMENT;
                                                      appBarTitle = Utils.getString(
                                                          context,
                                                          'home__forgot_password');
                                                    });
                                                  }
                                                },
                                                onSignInSelected: () {
                                                  updateSelectedIndexWithAnimation(
                                                      Utils.getString(context,
                                                          'home__register'),
                                                      PsConst
                                                          .REQUEST_CODE__MENU_REGISTER_FRAGMENT);
                                                },
                                              ),*/
                                            ])
                                      ],
                                    );
                                  } else {
                                    return ProfileView(
                                      scaffoldKey: scaffoldKey,
                                      animationController: animationController,
                                      flag: _currentIndex,
                                      callLogoutCallBack: (String userId) {
                                        callLogout(
                                            provider,
                                            deleteTaskProvider,
                                            PsConst
                                                .REQUEST_CODE__MENU_HOME_FRAGMENT);
                                      },
                                    );
                                  }
                                } else {
                                  return _CallVerifyEmailWidget(
                                      animationController: animationController,
                                      animation: animation,
                                      currentIndex: _currentIndex,
                                      userId: _userId,
                                      updateCurrentIndex:
                                          (String title, int index) {
                                        updateSelectedIndexWithAnimation(
                                            title, index);
                                      },
                                      updateUserCurrentIndex: (String title,
                                          int index, String userId) async {
                                        if (userId != null) {
                                          _userId = userId;
                                          provider.psValueHolder.loginUserId =
                                              userId;
                                        }
                                        if (mounted) {
                                          setState(() {
                                            appBarTitle = title;
                                            _currentIndex = index;
                                          });
                                        }
                                      });
                                }
                              }));
                        } else if (_currentIndex ==
                            PsConst.REQUEST_CODE__MENU_FAVOURITE_FRAGMENT) {
                          return FavouriteProductListView(
                            scrollController: innerScrollController,
                            animationController: animationController,
                          );
                        } else if (_currentIndex ==
                            PsConst
                                .REQUEST_CODE__DASHBOARD_USER_ITEMS_FRAGMENT) {
                          final AddedItemProvider productProvider =
                              AddedItemProvider(
                                  repo: productRepository,
                                  psValueHolder: valueHolder);
                          if (productProvider.psValueHolder.loginUserId ==
                                  null ||
                              productProvider.psValueHolder.loginUserId == '') {
                            productProvider
                                .addedUserParameterHolder.addedUserId = _userId;
                            productProvider.addedUserParameterHolder.status =
                                '1';
                            productProvider.loadItemList(_userId,
                                productProvider.addedUserParameterHolder);
                          } else {
                            productProvider
                                    .addedUserParameterHolder.addedUserId =
                                productProvider.psValueHolder.loginUserId;
                            productProvider.addedUserParameterHolder.status =
                                '1';
                            productProvider.loadItemList(
                                productProvider.psValueHolder.loginUserId,
                                productProvider.addedUserParameterHolder);
                          }
                          ItemListIntentHolder itemEntryIntentHolder =
                              ItemListIntentHolder(
                                  userId:
                                      productProvider.psValueHolder.loginUserId,
                                  status: '1',
                                  title: Utils.getString(
                                      context, 'more__my_post_title'));
                          return UserItemListForProfileView(
                            addedUserId: itemEntryIntentHolder.userId,
                            status: itemEntryIntentHolder.status,
                            title: itemEntryIntentHolder.title,
                          );
                          /*return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
                            final Object args = settings.arguments;
                            final ItemListIntentHolder itemEntryIntentHolder =
                                args ?? ItemListIntentHolder;

                          });

                          Navigator.pushNamed(
                              context, RoutePaths.userItemListForProfile,
                              arguments: ItemListIntentHolder(
                                  userId: productProvider
                                      .psValueHolder.loginUserId,
                                  status:'1',
                                  title: Utils.getString(context, 'more__my_post_title')));                                                            });


                        return FavouriteProductListView(
                            scrollController: innerScrollController,
                            animationController: animationController,
                          );*/
                        } else if (_currentIndex ==
                            PsConst.REQUEST_CODE__MENU_ADD_NEW_ITEM) {
                          return ItemEntryView(
                            animationController: animationController,
                            item: Product(),
                            flag: PsConst.ADD_NEW_ITEM,
                          );
                        } else if (_currentIndex ==
                            PsConst.REQUEST_CODE__MENU_TRANSACTION_FRAGMENT) {
                          return PaidAdItemListView(
                              scrollController: innerScrollController,
                              animationController: animationController);
                        } else if (_currentIndex ==
                            PsConst.REQUEST_CODE__MENU_OFFER_FRAGMENT) {
                          return OfferListView(
                              animationController: animationController);
                        } else if (_currentIndex ==
                            PsConst.REQUEST_CODE__MENU_BLOCKED_USER_FRAGMENT) {
                          return BlockedUserListView(
                              animationController: animationController);
                        } else if (_currentIndex ==
                            PsConst.REQUEST_CODE__MENU_REPORTED_ITEM_FRAGMENT) {
                          return ReportedItemListView(
                              animationController: animationController);
                        } else if (_currentIndex ==
                            PsConst.REQUEST_CODE__MENU_USER_HISTORY_FRAGMENT) {
                          return HistoryListView(
                              animationController: animationController);
                        }
                        // else if (_currentIndex ==
                        //     PsConst.REQUEST_CODE__MENU_COLLECTION_FRAGMENT) {
                        //   return CollectionHeaderListView(
                        //       animationController: animationController);
                        // }
                        else if (_currentIndex ==
                            PsConst.REQUEST_CODE__MENU_LANGUAGE_FRAGMENT) {
                          return LanguageSettingView(
                              animationController: animationController,
                              languageIsChanged: () {});
                        } /* else if (_currentIndex ==
                            PsConst.REQUEST_CODE__DASHBOARD_MORE_FRAGMENT) {
                          return MoreContainerView();
                        }*/
                        else if (_currentIndex ==
                            PsConst.REQUEST_CODE__MENU_CONTACT_US_FRAGMENT) {
                          return ContactUsView(
                              animationController: animationController);
                        } else if (_currentIndex ==
                            PsConst.REQUEST_CODE__MENU_SETTING_FRAGMENT) {
                          return Container(
                            color: PsColors.coreBackgroundColor,
                            height: double.infinity,
                            child: SettingView(
                              animationController: animationController,
                            ),
                          );
                        } else if (_currentIndex ==
                            PsConst
                                .REQUEST_CODE__MENU_TERMS_AND_CONDITION_FRAGMENT) {
                          return TermsAndConditionsView(
                              animationController: animationController);
                        } else if (_currentIndex ==
                            PsConst.REQUEST_CODE__DASHBOARD_MESSAGE_FRAGMENT) {
                          if (valueHolder.loginUserId != null &&
                              valueHolder.loginUserId != '') {
                            return ChatListView(
                              animationController: animationController,
                            );
                          } else {
                            return _CallVerifyPhoneWidget(
                                currentIndex: _currentIndex,
                                animationController: animationController,
                                animation: animation,
                                updateCurrentIndex: (String title, int index) {
                                  updateSelectedIndexWithAnimation(
                                      title, index);
                                },
                                updateUserCurrentIndex:
                                    (String title, int index, String userId) {
                                  if (mounted) {
                                    setState(() {
                                      if (index != null) {
                                        appBarTitle = title;
                                        _currentIndex = index;
                                      }
                                    });
                                  }
                                  if (userId != null) {
                                    _userId = userId;
                                  }
                                });
                          }
                        } else {
                          animationController.forward();
                          return HomeDashboardViewWidget(
                              innerScrollController,
                              animationController,
                              animationControllerForFab,
                              context, (String payload) {
                            return showDialog<dynamic>(
                              context: context,
                              builder: (_) {
                                return NotiDialog(message: '$payload');
                              },
                            );
                          }, (String payload,
                                  String sellerId,
                                  String buyerId,
                                  String senderName,
                                  String senderProflePhoto,
                                  String itemId,
                                  String action) {
                            return showDialog<dynamic>(
                              context: context,
                              builder: (_) {
                                return ChatNotiDialog(
                                    description: '$payload',
                                    leftButtonText: Utils.getString(
                                        context, 'dialog__cancel'),
                                    rightButtonText: Utils.getString(
                                        context, 'chat_noti__open'),
                                    onAgreeTap: () {
                                      _navigateToChat(
                                          sellerId,
                                          buyerId,
                                          senderName,
                                          senderProflePhoto,
                                          itemId,
                                          action);
                                    });
                              },
                            );
                          });
                        }
                      },
                    )))));
  }
}

/*
class _CallLoginWidget extends StatelessWidget {
  const _CallLoginWidget(
      {@required this.animationController,
      @required this.animation,
      @required this.updateCurrentIndex,
      @required this.updateUserCurrentIndex,
      @required this.currentIndex});
  final Function updateCurrentIndex;
  final Function updateUserCurrentIndex;
  final AnimationController animationController;
  final Animation<double> animation;
  final int currentIndex;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: PsColors.mainLightColorWithBlack,
          width: double.infinity,
          height: double.maxFinite,
        ),
        CustomScrollView(scrollDirection: Axis.vertical, slivers: <Widget>[
          LoginView(
            animationController: animationController,
            animation: animation,
            onGoogleSignInSelected: (String userId) {
              if (currentIndex == PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateUserCurrentIndex(
                    Utils.getString(context, 'home__menu_drawer_profile'),
                    PsConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT,
                    userId);
              } else {
                updateUserCurrentIndex(
                    Utils.getString(context, 'home__menu_drawer_profile'),
                    PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                    userId);
              }
            },
            onFbSignInSelected: (String userId) {
              if (currentIndex == PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateUserCurrentIndex(
                    Utils.getString(context, 'home__menu_drawer_profile'),
                    PsConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT,
                    userId);
              } else {
                updateUserCurrentIndex(
                    Utils.getString(context, 'home__menu_drawer_profile'),
                    PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                    userId);
              }
            },
            onPhoneSignInSelected: () {
              if (currentIndex == PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateCurrentIndex(
                    Utils.getString(context, 'home_phone_signin'),
                    PsConst.REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT);
              } else if (currentIndex ==
                  PsConst.REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT) {
                updateCurrentIndex(
                    Utils.getString(context, 'home_phone_signin'),
                    PsConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
              } else if (currentIndex ==
                  PsConst.REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT) {
                updateCurrentIndex(
                    Utils.getString(context, 'home_phone_signin'),
                    PsConst.REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT);
              } else if (currentIndex ==
                  PsConst.REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT) {
                updateCurrentIndex(
                    Utils.getString(context, 'home_phone_signin'),
                    PsConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
              } else {
                updateCurrentIndex(
                    Utils.getString(context, 'home_phone_signin'),
                    PsConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
              }
            },
            onProfileSelected: (String userId) {
              if (currentIndex == PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateUserCurrentIndex(
                    Utils.getString(context, 'home__menu_drawer_profile'),
                    PsConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT,
                    userId);
              } else {
                updateUserCurrentIndex(
                    Utils.getString(context, 'home__menu_drawer_profile'),
                    PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                    userId);
              }
            },
            onForgotPasswordSelected: () {
              if (currentIndex == PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateCurrentIndex(
                    Utils.getString(context, 'home__forgot_password'),
                    PsConst.REQUEST_CODE__MENU_FORGOT_PASSWORD_FRAGMENT);
              } else {
                updateCurrentIndex(
                    Utils.getString(context, 'home__forgot_password'),
                    PsConst.REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT);
              }
            },
            onSignInSelected: () {
              if (currentIndex == PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateCurrentIndex(Utils.getString(context, 'home__register'),
                    PsConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT);
              } else {
                updateCurrentIndex(Utils.getString(context, 'home__register'),
                    PsConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT);
              }
            },
          ),
        ])
      ],
    );
  }
}
*/

class _CallVerifyPhoneWidget extends StatelessWidget {
  const _CallVerifyPhoneWidget(
      {this.userName,
      this.phoneNumber,
      this.phoneId,
      @required this.updateCurrentIndex,
      @required this.updateUserCurrentIndex,
      @required this.animationController,
      @required this.animation,
      @required this.currentIndex});

  final String userName;
  final String phoneNumber;
  final String phoneId;
  final Function updateCurrentIndex;
  final Function updateUserCurrentIndex;
  final int currentIndex;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: VerifyPhoneView(
          userName: userName,
          phoneNumber: phoneNumber,
          phoneId: phoneId,
          animationController: animationController,
          onProfileSelected: (String userId) {
            if (currentIndex ==
                PsConst.REQUEST_CODE__MENU_PHONE_VERIFY_FRAGMENT) {
              updateUserCurrentIndex(
                  Utils.getString(context, 'home__menu_drawer_profile'),
                  PsConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT,
                  userId);
            } else if (currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT) {
              updateUserCurrentIndex(
                  Utils.getString(context, 'home__menu_drawer_profile'),
                  PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                  userId);
            } else {
              updateUserCurrentIndex(
                  Utils.getString(context, 'home__menu_drawer_profile'),
                  PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                  userId);
            }
          },
          onSignInSelected: () {
            if (currentIndex ==
                PsConst.REQUEST_CODE__MENU_PHONE_VERIFY_FRAGMENT) {
              updateCurrentIndex(Utils.getString(context, 'home__register'),
                  PsConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT);
            } else if (currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT) {
              updateCurrentIndex(Utils.getString(context, 'home__register'),
                  PsConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT);
            }
            // else if (currentIndex ==
            //     PsConst.REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT) {
            //   updateCurrentIndex(Utils.getString(context, 'home__register'),
            //       PsConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT);
            // } else if (currentIndex ==
            //     PsConst.REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT) {
            //   updateCurrentIndex(Utils.getString(context, 'home__register'),
            //       PsConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT);
            // }
          },
        ));
  }
}

class _CallVerifyEmailWidget extends StatelessWidget {
  const _CallVerifyEmailWidget(
      {@required this.updateCurrentIndex,
      @required this.updateUserCurrentIndex,
      @required this.animationController,
      @required this.animation,
      @required this.currentIndex,
      @required this.userId});
  final Function updateCurrentIndex;
  final Function updateUserCurrentIndex;
  final int currentIndex;
  final AnimationController animationController;
  final Animation<double> animation;
  final String userId;

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: VerifyEmailView(
          animationController: animationController,
          userId: userId,
          onProfileSelected: (String userId) {
            if (currentIndex ==
                PsConst.REQUEST_CODE__MENU_VERIFY_EMAIL_FRAGMENT) {
              updateUserCurrentIndex(
                  Utils.getString(context, 'home__menu_drawer_profile'),
                  PsConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT,
                  userId);
            } else if (currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT) {
              updateUserCurrentIndex(
                  Utils.getString(context, 'home__menu_drawer_profile'),
                  PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                  userId);
            } else {
              updateUserCurrentIndex(
                  Utils.getString(context, 'home__menu_drawer_profile'),
                  PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                  userId);
            }
          },
          onSignInSelected: () {
            if (currentIndex ==
                PsConst.REQUEST_CODE__MENU_VERIFY_EMAIL_FRAGMENT) {
              updateCurrentIndex(Utils.getString(context, 'home__register'),
                  PsConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT);
            } else if (currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT) {
              updateCurrentIndex(Utils.getString(context, 'home__register'),
                  PsConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT);
            } else if (currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT) {
              updateCurrentIndex(Utils.getString(context, 'home__register'),
                  PsConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT);
            } else if (currentIndex ==
                PsConst.REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT) {
              updateCurrentIndex(Utils.getString(context, 'home__register'),
                  PsConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT);
            }
          },
        ));
  }
}


/*
class _DrawerMenuWidget extends StatefulWidget {
  const _DrawerMenuWidget({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.onTap,
    @required this.index,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final Function onTap;
  final int index;

  @override
  __DrawerMenuWidgetState createState() => __DrawerMenuWidgetState();
}

class __DrawerMenuWidgetState extends State<_DrawerMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(widget.icon, color: PsColors.mainColorWithWhite),
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        onTap: () {
          widget.onTap(widget.title, widget.index);
        });
  }
}

class _DrawerHeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      child: Column(
        children: <Widget>[
          Image.asset(
            'assets/images/flutter_buy_and_sell_logo.png',
            width: PsDimens.space100,
            height: PsDimens.space72,
          ),
          const SizedBox(
            height: PsDimens.space8,
          ),
          Text(
            Utils.getString(context, 'app_name'),
            style: Theme.of(context)
                .textTheme
                .subtitle1
                .copyWith(color: PsColors.white),
          ),
        ],
      ),
      decoration: BoxDecoration(
          color:
              Utils.isLightMode(context) ? PsColors.mainColor : Colors.black12),
    );
  }
}*/
