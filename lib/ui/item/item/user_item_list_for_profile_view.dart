import 'package:haraj/config/ps_config.dart';
import 'package:haraj/constant/ps_constants.dart';
import 'package:haraj/constant/ps_dimens.dart';
import 'package:haraj/provider/product/added_item_provider.dart';
import 'package:haraj/repository/product_repository.dart';
import 'package:haraj/ui/common/base/ps_widget.dart';
import 'package:haraj/ui/common/base/ps_widget_with_appbar.dart';
import 'package:haraj/ui/item/item/product_vertical_list_item_for_profile.dart';
import 'package:haraj/utils/utils.dart';
import 'package:haraj/viewobject/common/ps_value_holder.dart';
import 'package:flutter/material.dart';
import 'package:haraj/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:haraj/viewobject/product.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:haraj/constant/route_paths.dart';
import 'package:haraj/ui/common/ps_ui_widget.dart';

class UserItemListForProfileView extends StatefulWidget {
  const UserItemListForProfileView({@required this.addedUserId,
  @required this.status,@required this.title});
  final String addedUserId;
  final String status;
  final String title;

  @override
  _UserItemListForProfileViewState createState() {
    return _UserItemListForProfileViewState();
  }
}

class _UserItemListForProfileViewState extends State<UserItemListForProfileView>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  AddedItemProvider _userAddedItemProvider;

  AnimationController animationController;

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        final String loginUserId = Utils.checkUserLoginId(psValueHolder);
        _userAddedItemProvider.nextItemList(
            loginUserId, _userAddedItemProvider.addedUserParameterHolder);
      }
    });
  }

  ProductRepository repo1;
  PsValueHolder psValueHolder;
  @override
  Widget build(BuildContext context) {
    Future<bool> _requestPop() {
      animationController.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context, true);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    timeDilation = 1.0;
    repo1 = Provider.of<ProductRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    return


      WillPopScope(
        onWillPop: () async => false, //_onWillPop,

        child: PsWidget<AddedItemProvider>(
          initProvider: () {
            return AddedItemProvider(repo: repo1, psValueHolder: psValueHolder);
          },
          onProviderReady: (AddedItemProvider provider) {
            final String loginUserId = Utils.checkUserLoginId(psValueHolder);

            provider.addedUserParameterHolder.addedUserId = widget.addedUserId;
            provider.addedUserParameterHolder.status = widget.status;

            provider.loadItemList(
                loginUserId, provider.addedUserParameterHolder);

            _userAddedItemProvider = provider;
          },
          builder:
              (BuildContext context, AddedItemProvider provider, Widget child) {
            return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: provider
                            .itemList.data
                            .length,
                        itemBuilder: (BuildContext context,
                            int index) {
                          final Product product =
                          provider.itemList
                              .data[index];
                          return SizedBox(
                            //height: 200.0,

                              child: ProductVeticalListItemForProfile(
                                productId: provider
                                    .itemList
                                    .data[index].id,
                                provider: provider,
                                coreTagKey: provider
                                    .hashCode
                                    .toString() +
                                    provider
                                        .itemList
                                        .data[index].id,
                                animationController:  animationController,
                                animation:
                                Tween<double>(
                                    begin: 0.0, end: 1.0)
                                    .animate(
                                  CurvedAnimation(
                                    parent:  animationController,
                                    curve: Interval(
                                        (1 /
                                            provider
                                                .itemList
                                                .data
                                                .length) *
                                            index,
                                        1.0,
                                        curve: Curves
                                            .fastOutSlowIn),
                                  ),
                                ),
                                product: provider
                                    .itemList
                                    .data[index],
                                onTap: () async {
                                  final Product product = provider
                                      .itemList
                                      .data.reversed
                                      .toList()[index];
                                  final ProductDetailIntentHolder holder =
                                  ProductDetailIntentHolder(
                                      productTitle: provider
                                          .itemList
                                          .data[index].title,
                                      productId: provider
                                          .itemList
                                          .data[index].id,
                                      heroTagImage:
                                      provider.hashCode
                                          .toString() +
                                          product.id +
                                          PsConst
                                              .HERO_TAG__IMAGE,
                                      heroTagTitle:
                                      provider.hashCode
                                          .toString() +
                                          product.id +
                                          PsConst
                                              .HERO_TAG__TITLE);
                                  await Navigator.pushNamed(
                                      context,
                                      RoutePaths
                                          .productDetail,
                                      arguments: holder);

                                },
                              ));
                        }) ;

/*
              Stack(children: <Widget>[
              Container(
                  margin: const EdgeInsets.only(
                      left: PsDimens.space8,
                      right: PsDimens.space8,
                      top: PsDimens.space8,
                      bottom: PsDimens.space8),
                  child: RefreshIndicator(
                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                        controller: _scrollController,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        slivers: <Widget>[
                          SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 280.0,
                                    childAspectRatio: 0.55),
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                if (provider.itemList.data != null ||
                                    provider.itemList.data.isNotEmpty) {
                                  final int count =
                                      provider.itemList.data.length;
                                  return ProductVeticalListItemForProfile(
                                    coreTagKey: provider.hashCode.toString() +
                                        provider.itemList.data[index].id,
                                    animationController: animationController,
                                    animation:
                                        Tween<double>(begin: 0.0, end: 1.0)
                                            .animate(
                                      CurvedAnimation(
                                        parent: animationController,
                                        curve: Interval(
                                            (1 / count) * index, 1.0,
                                            curve: Curves.fastOutSlowIn),
                                      ),
                                    ),
                                    product: provider.itemList.data[index],
                                    onTap: () {
                                      print(provider.itemList.data[index]
                                          .defaultPhoto.imgPath);
                                      final Product product = provider
                                          .itemList.data.reversed
                                          .toList()[index];
                                      final ProductDetailIntentHolder holder =
                                          ProductDetailIntentHolder(
                                              productId:
                                                  provider.itemList.data[index].id,
                                              heroTagImage:
                                                  provider.hashCode.toString() +
                                                      product.id +
                                                      PsConst.HERO_TAG__IMAGE,
                                              heroTagTitle:
                                                  provider.hashCode.toString() +
                                                      product.id +
                                                      PsConst.HERO_TAG__TITLE);
                                      Navigator.pushNamed(
                                          context, RoutePaths.productDetail,
                                          arguments: holder);
                                    },
                                  );
                                } else {
                                  return null;
                                }
                              },
                              childCount: provider.itemList.data.length,
                            ),
                          ),
                        ]),
                    onRefresh: () async {
                      _userAddedItemProvider.addedUserParameterHolder
                          .addedUserId = widget.addedUserId;

                      return _userAddedItemProvider.resetItemList(
                          provider.psValueHolder.loginUserId,
                          provider.addedUserParameterHolder);
                    },
                  )),
              PSProgressIndicator(provider.itemList.status)
            ]);*/
          }),
    );
  }
}
