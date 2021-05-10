import 'package:haraj/api/common/ps_admob_banner_widget.dart';
import 'package:haraj/config/ps_config.dart';
import 'package:haraj/constant/ps_constants.dart';
import 'package:haraj/constant/ps_dimens.dart';
import 'package:haraj/constant/route_paths.dart';
import 'package:haraj/provider/product/favourite_item_provider.dart';
import 'package:haraj/repository/product_repository.dart';
import 'package:haraj/ui/common/ps_ui_widget.dart';
import 'package:haraj/ui/item/item/product_vertical_list_item.dart';
import 'package:haraj/utils/utils.dart';
import 'package:haraj/viewobject/common/ps_value_holder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haraj/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:haraj/viewobject/product.dart';
import 'package:provider/provider.dart';

class FavouriteProductListView extends StatefulWidget {
  const FavouriteProductListView({
    Key key,
    this.scrollController,
    @required this.animationController,
  }) : super(key: key);
  final AnimationController animationController;
  final ScrollController scrollController;
  @override
  _FavouriteProductListView createState() => _FavouriteProductListView();
}

class _FavouriteProductListView extends State<FavouriteProductListView>
    with TickerProviderStateMixin {
  FavouriteItemProvider _favouriteItemProvider;

  // final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    // if (widget.scrollController != null) {
    widget.scrollController.addListener(() {
      if (widget.scrollController.position.pixels ==
          widget.scrollController.position.maxScrollExtent) {
        _favouriteItemProvider.nextFavouriteItemList();
      }
    });
    // } else {
    //   _scrollController.addListener(() {
    //     if (_scrollController.position.pixels ==
    //         _scrollController.position.maxScrollExtent) {
    //       _favouriteItemProvider.nextFavouriteItemList();
    //     }
    //   });
    // }

    super.initState();
  }

  ProductRepository repo1;
  PsValueHolder psValueHolder;
  dynamic data;
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
    // data = EasyLocalizationProvider.of(context).data;
    repo1 = Provider.of<ProductRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    print(
        '............................Build UI Again ............................');
    // return EasyLocalizationProvider(
    //     data: data,
    //     child:
    return ChangeNotifierProvider<FavouriteItemProvider>(
        lazy: false,
        create: (BuildContext context) {
          final FavouriteItemProvider provider =
          FavouriteItemProvider(repo: repo1, psValueHolder: psValueHolder);
          provider.loadFavouriteItemList();
          _favouriteItemProvider = provider;
          return _favouriteItemProvider;
        },
        child: Scaffold(body:
        Consumer<FavouriteItemProvider>(
            builder: (BuildContext context, FavouriteItemProvider provider,
                Widget child) {
              return   ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            itemCount: provider
                                                .favouriteItemList.data
                                                .length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              final Product product =
                                              provider.favouriteItemList
                                                  .data[index];
                                              return SizedBox(
                                                //height: 200.0,

                                                  child: ProductVeticalListItem(
                                                    productId:
                                                    provider.favouriteItemList
                                                        .data[index]
                                                        .id,
                                                    coreTagKey: provider
                                                        .hashCode
                                                        .toString() +
                                                        provider
                                                            .favouriteItemList
                                                            .data[index].id,
                                                    animationController: widget
                                                        .animationController,
                                                    animation:
                                                    Tween<double>(
                                                        begin: 0.0, end: 1.0)
                                                        .animate(
                                                      CurvedAnimation(
                                                        parent: widget
                                                            .animationController,
                                                        curve: Interval(
                                                            (1 /
                                                                provider
                                                                    .favouriteItemList
                                                                    .data
                                                                    .length) *
                                                                index,
                                                            1.0,
                                                            curve: Curves
                                                                .fastOutSlowIn),
                                                      ),
                                                    ),
                                                    product: provider
                                                        .favouriteItemList
                                                        .data[index],
                                                    onTap: () async {
                                                      final Product product = provider
                                                          .favouriteItemList
                                                          .data.reversed
                                                          .toList()[index];
                                                      final ProductDetailIntentHolder holder =
                                                      ProductDetailIntentHolder(

                                                          productTitle: provider
                                                              .favouriteItemList
                                                              .data[index].title,
                                                          productId: provider
                                                              .favouriteItemList
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

                                                      await provider
                                                          .resetFavouriteItemList();
                                                    },
                                                  ));
                                            }) ;
            }
        )
        ));
  }
}


