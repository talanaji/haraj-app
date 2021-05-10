import 'package:haraj/api/common/ps_admob_banner_widget.dart';
import 'package:haraj/config/ps_config.dart';
import 'package:haraj/provider/blog/blog_provider.dart';
import 'package:haraj/repository/blog_repository.dart';
import 'package:haraj/ui/blog/item/blog_list_item.dart';

import 'package:flutter/material.dart';
import 'package:haraj/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:haraj/constant/ps_dimens.dart';
import 'package:haraj/constant/route_paths.dart';
import 'package:haraj/ui/common/ps_ui_widget.dart';

class BlogListView extends StatefulWidget {
  const BlogListView({Key key, @required this.animationController, @required this.itemId})
      : super(key: key);
  final AnimationController animationController;
  final String itemId;
  @override
  _BlogListViewState createState() => _BlogListViewState();
}

class _BlogListViewState extends State<BlogListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  BlogProvider _blogProvider;
  Animation<double> animation;

  @override
  void dispose() {
    animation = null;
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _blogProvider.nextBlogList(widget.itemId);
      }
    });

    super.initState();
  }

  BlogRepository repo1;
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

    repo1 = Provider.of<BlogRepository>(context);


    return ChangeNotifierProvider<BlogProvider>(
      lazy: false,
      create: (BuildContext context) {
        final BlogProvider provider = BlogProvider(repo: repo1);
        provider.loadBlogList(widget.itemId);
        _blogProvider = provider;
        return _blogProvider;
      },
      child: Consumer<BlogProvider>(
        builder: (BuildContext context, BlogProvider provider, Widget child) {
          return Column(
            children: <Widget>[
              (provider.blogList.data.length !=0)?
              Expanded(child:
               RefreshIndicator(
                          child: CustomScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              controller: _scrollController,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              slivers: <Widget>[

                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                      if (provider.blogList.data != null ||
                                          provider.blogList.data.isNotEmpty) {
                                        final int count =
                                            provider.blogList.data.length;

                                        return   BlogListItem(

                                          animationController:
                                              widget.animationController,
                                          animation: Tween<double>(
                                                  begin: 0.0, end: 1.0)
                                              .animate(
                                            CurvedAnimation(
                                              parent:
                                                  widget.animationController,
                                              curve: Interval(
                                                  (1 / count) * index, 1.0,
                                                  curve: Curves.fastOutSlowIn),
                                            ),
                                          ),
                                          blog: provider.blogList.data[index],
                                          itemId: widget.itemId,

                                          onTap: () {
                                           /* print(provider.blogList.data[index]
                                                .defaultPhoto.imgPath);
                                            Navigator.pushNamed(
                                                context, RoutePaths.blogDetail,
                                                arguments: provider
                                                    .blogList.data[index]);*/
                                          },
                                        );
                                      } else {
                                        return null;
                                      }
                                    },
                                    childCount: provider.blogList.data.length,
                                  ),
                                ),
                              ]),
                          onRefresh: () {
                            return provider.resetBlogList(widget.itemId);
                          },
                        )
              ):
              Align(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/baseline_empty_item_grey_24.png',
                        height: 100,
                        width: 150,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(
                        height: PsDimens.space32,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: PsDimens.space20,
                            right: PsDimens.space20),
                        child: Text(
                          "لا يوجد تعليقات",
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(),
                        ),
                      ),
                      const SizedBox(
                        height: PsDimens.space20,
                      ),
                    ],
                  ),
                ),
              )]

              ) ;
        },
      ),
      // ),
    );
  }
}
