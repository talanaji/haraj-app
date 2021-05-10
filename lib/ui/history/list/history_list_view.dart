import 'package:haraj/api/common/ps_admob_banner_widget.dart';
import 'package:haraj/constant/ps_constants.dart';
import 'package:haraj/constant/ps_dimens.dart';
import 'package:haraj/constant/route_paths.dart';
import 'package:haraj/provider/history/history_provider.dart';
import 'package:haraj/repository/history_repsitory.dart';
import 'package:haraj/ui/history/item/history_list_item.dart';
import 'package:flutter/material.dart';
import 'package:haraj/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:haraj/viewobject/product.dart';
import 'package:provider/provider.dart';

class HistoryListView extends StatefulWidget {
  const HistoryListView({Key key, @required this.animationController})
      : super(key: key);
  final AnimationController animationController;
  @override
  _HistoryListViewState createState() => _HistoryListViewState();
}

class _HistoryListViewState extends State<HistoryListView>
    with SingleTickerProviderStateMixin {
  HistoryRepository historyRepo;
  dynamic data;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  @override
  Widget build(BuildContext context) {
    // if (!isConnectedToInternet && PsConfig.showAdMob) {
    //   print('loading ads....');
    //   checkConnection();
    // }
    // data = EasyLocalizationProvider.of(context).data;
    historyRepo = Provider.of<HistoryRepository>(context);
    // return EasyLocalizationProvider(
    //     data: data,
    //     child:
    return ChangeNotifierProvider<HistoryProvider>(
        lazy: false,
        create: (BuildContext context) {
          final HistoryProvider provider = HistoryProvider(
            repo: historyRepo,
          );
          provider.loadHistoryList();
          return provider;
        },
        child: Consumer<HistoryProvider>(
          builder:
              (BuildContext context, HistoryProvider provider, Widget child) {
            if (provider.historyList != null &&
                provider.historyList.data != null) {
              return Column(
                children: <Widget>[
                  const PsAdMobBannerWidget(),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: PsDimens.space10),
                      child: RefreshIndicator(
                        child: CustomScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            slivers: <Widget>[
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    final int count =
                                        provider.historyList.data.length;
                                    return HistoryListItem(
                                      animationController:
                                          widget.animationController,
                                      animation:
                                          Tween<double>(begin: 0.0, end: 1.0)
                                              .animate(
                                        CurvedAnimation(
                                          parent: widget.animationController,
                                          curve: Interval(
                                              (1 / count) * index, 1.0,
                                              curve: Curves.fastOutSlowIn),
                                        ),
                                      ),
                                      history: provider
                                          .historyList.data.reversed
                                          .toList()[index],
                                      onTap: () {
                                        final Product product = provider
                                            .historyList.data.reversed
                                            .toList()[index];
                                        final ProductDetailIntentHolder holder =
                                            ProductDetailIntentHolder(

                                                productTitle: product.title,
                                                productId: product.id,
                                                heroTagImage: provider.hashCode
                                                        .toString() +
                                                    product.id +
                                                    PsConst.HERO_TAG__IMAGE,
                                                heroTagTitle: provider.hashCode
                                                        .toString() +
                                                    product.id +
                                                    PsConst.HERO_TAG__TITLE);
                                        Navigator.pushNamed(
                                            context, RoutePaths.productDetail,
                                            arguments: holder);
                                      },
                                    );
                                  },
                                  childCount: provider.historyList.data.length,
                                ),
                              )
                            ]),
                        onRefresh: () {
                          return provider.resetHistoryList();
                        },
                      ),
                    ),
                  )
                ],
              );
            } else {
              return Container();
            }
          },
        )
        // )
        );
  }
}
