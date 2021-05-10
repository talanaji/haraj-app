import 'dart:async';
import 'package:haraj/api/common/ps_admob_banner_widget.dart';
import 'package:haraj/config/ps_colors.dart';
import 'package:haraj/config/ps_config.dart';
import 'package:haraj/constant/ps_dimens.dart';
import 'package:haraj/ui/common/ps_back_button_with_circle_bg_widget.dart';
import 'package:haraj/ui/common/ps_ui_widget.dart';
import 'package:haraj/utils/utils.dart';
import 'package:haraj/viewobject/blog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlogView extends StatefulWidget {
  const BlogView({Key key, @required this.blog, @required this.heroTagImage})
      : super(key: key);

  final Blog blog;
  final String heroTagImage;

  @override
  _BlogViewState createState() => _BlogViewState();
}

class _BlogViewState extends State<BlogView> {
  bool isReadyToShowAppBarIcons = false;

  @override
  Widget build(BuildContext context) {
    if (!isReadyToShowAppBarIcons) {
      Timer(const Duration(milliseconds: 800), () {
        setState(() {
          isReadyToShowAppBarIcons = true;
        });
      });
    }

    return Scaffold(
        body: CustomScrollView(
      shrinkWrap: true,
      slivers: <Widget>[
        SliverAppBar(
          brightness: Utils.getBrightnessForAppBar(context),
          expandedHeight: PsDimens.space300,
          floating: true,
          pinned: true,
          snap: false,
          elevation: 0,
          leading: PsBackButtonWithCircleBgWidget(
              isReadyToShow: isReadyToShowAppBarIcons),
          backgroundColor: PsColors.mainColor,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              height: PsDimens.space300,
              width: double.infinity,
              child: PsNetworkImage(
                photoKey: widget.heroTagImage,
                // height: PsDimens.space300,
                // width: double.infinity,
                defaultPhoto: widget.blog.defaultPhoto,
                boxfit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: TextWidget(
            blog: widget.blog,
          ),
        )
      ],
    ));
  }
}

class TextWidget extends StatefulWidget {
  const TextWidget({
    Key key,
    @required this.blog,
  }) : super(key: key);

  final Blog blog;

  @override
  _TextWidgetState createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && PsConfig.showAdMob) {
        if(mounted){
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
    return Container(
      color: PsColors.backgroundColor,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(PsDimens.space8),
              child: Text(
                widget.blog.item_id,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
           /* Padding(
                padding: const EdgeInsets.only(
                    left: PsDimens.space8,
                    right: PsDimens.space8,
                    bottom: PsDimens.space8),
                child: HtmlWidget(widget.blog.description)*/
                //  Text(
                //   widget.blog.description,
                //   style: Theme.of(context).textTheme.bodyText1.copyWith
              //   (height: 1.5),
                // ),
                //),
            const PsAdMobBannerWidget(),
          ],
        ),
      ),
    );
  }
}
