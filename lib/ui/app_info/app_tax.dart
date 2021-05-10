import 'package:flutter_icons/flutter_icons.dart';
import 'package:haraj/api/common/ps_admob_banner_widget.dart';
import 'package:haraj/config/ps_colors.dart';
import 'package:haraj/config/ps_config.dart';
import 'package:haraj/constant/ps_dimens.dart';
import 'package:haraj/provider/about_us/about_us_provider.dart';
import 'package:haraj/repository/about_us_repository.dart';
import 'package:haraj/ui/common/base/ps_widget_with_appbar.dart';
import 'package:haraj/ui/common/ps_ui_widget.dart';
import 'package:haraj/utils/utils.dart';
import 'package:haraj/viewobject/about_us.dart';
import 'package:haraj/viewobject/common/ps_value_holder.dart';
import 'package:flutter/material.dart';
import 'package:haraj/viewobject/default_photo.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AppTaxView extends StatefulWidget {
  @override
  _AppTaxViewState createState() {
    return _AppTaxViewState();
  }
}

class _AppTaxViewState extends State<AppTaxView>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  AboutUsProvider _aboutUsProvider;

  AnimationController animationController;
  Animation<double> animation;

  @override
  void dispose() {
    animationController.dispose();
    animation = null;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _aboutUsProvider.nextAboutUsList();
      }
    });

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addListener(() {
        if (mounted) {
          setState(() {});
        }
      });

    animation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(animationController);
  }

  AboutUsRepository repo1;
  PsValueHolder valueHolder;
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
    repo1 = Provider.of<AboutUsRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);
    return PsWidgetWithAppBar<AboutUsProvider>(
        appBarTitle: "عمولة التطبيق",
        initProvider: () {
          return AboutUsProvider(
            repo: repo1,
            psValueHolder: valueHolder,
          );
        },
        onProviderReady: (AboutUsProvider provider) {
          provider.loadAboutUsList();
          _aboutUsProvider = provider;
        },
        builder:
            (BuildContext context, AboutUsProvider provider, Widget child) {
          if (provider.aboutUsList != null &&
              provider.aboutUsList.data != null &&
              provider.aboutUsList.data.isNotEmpty) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(PsDimens.space10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      height: 150,
                      child: Image.asset(
                        'assets/images/LOGO3.png',
                      ),
                    ),


                    Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: PsColors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 5,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ]),
                        width: MediaQuery.of(context).size.width * .9,
                        //  height: MediaQuery.of(context).size.width * .4,
                        child:
                        Row(children: [
                          Icon(PsColors.group__2)
                          ,
                          Padding(padding: EdgeInsets.all(5),),
                          Text("عمولة التطبيق 2% بذمة البائع"
                            ,
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.bodyText2,
                            maxLines: 1,
                          ),

                        ],)
                        ),
                  ],
                ),
              ),
            );
          } else {
            return Container();
          }
        });
  }
}

class _LinkAndTitle extends StatelessWidget {
  const _LinkAndTitle({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.link,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final String link;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: PsDimens.space16,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: <Widget>[
              Container(
                  width: PsDimens.space20,
                  height: PsDimens.space20,
                  child: Icon(
                    icon,
                  )),
              const SizedBox(
                width: PsDimens.space8,
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: PsDimens.space8,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: <Widget>[
              const SizedBox(
                width: PsDimens.space32,
              ),
              InkWell(
                child: Text(
                    link == ''
                        ? Utils.getString(context, 'shop_info__dash')
                        : link,
                    style: Theme.of(context).textTheme.bodyText1),
                onTap: () async {
                  if (await canLaunch(link)) {
                    await launch(link);
                  } else {
                    throw 'Could not launch $link';
                  }
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _HeaderImageWidget extends StatelessWidget {
  const _HeaderImageWidget({
    Key key,
    @required this.photo,
  }) : super(key: key);

  final DefaultPhoto photo;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        PsNetworkImage(
          photoKey: '',
          defaultPhoto: photo ?? '',
          width: MediaQuery.of(context).size.width,
          height: 300,
          boxfit: BoxFit.cover,
          onTap: () {},
        ),
      ],
    );
  }
}

class ImageAndTextWidget extends StatelessWidget {
  const ImageAndTextWidget({
    Key key,
    @required this.data,
  }) : super(key: key);

  final AboutUs data;
  @override
  Widget build(BuildContext context) {
    const Widget _spacingWidget = SizedBox(
      height: PsDimens.space4,
    );

    final Widget _imageWidget = PsNetworkImage(
      photoKey: '',
      defaultPhoto: data.defaultPhoto,
      // width: 50,
      // height: 50,
      boxfit: BoxFit.cover,
      onTap: () {},
    );

    return Row(
      children: <Widget>[
        Container(
          width: 50,
          height: 50,
          child: _imageWidget),
        const SizedBox(
          width: PsDimens.space8,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                data.aboutTitle,
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      color: PsColors.mainColor,
                    ),
              ),
              _spacingWidget,
              InkWell(
                child: Text(
                  data.aboutPhone,
                  style: Theme.of(context).textTheme.bodyText1.copyWith(),
                ),
                onTap: () async {
                  if (await canLaunch('tel://${data.aboutPhone}')) {
                    await launch('tel://${data.aboutPhone}');
                  } else {
                    throw 'Could not Call Phone Number 1';
                  }
                },
              ),
              _spacingWidget,
              Row(
                children: <Widget>[
                  Container(
                      child: const Icon(
                    Icons.email,
                  )),
                  const SizedBox(
                    width: PsDimens.space8,
                  ),
                  InkWell(
                    child: Text(data.aboutEmail,
                        style: Theme.of(context).textTheme.bodyText1),
                    onTap: () async {
                      if (await canLaunch('mailto:teamps.is.cool@gmail.com')) {
                        await launch('mailto:teamps.is.cool@gmail.com');
                      } else {
                        throw 'Could not launch teamps.is.cool@gmail.com';
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _PhoneAndContactWidget extends StatelessWidget {
  const _PhoneAndContactWidget({
    Key key,
    @required this.phone,
  }) : super(key: key);

  final AboutUs phone;
  @override
  Widget build(BuildContext context) {
    const Widget _spacingWidget = SizedBox(
      height: PsDimens.space8,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // const SizedBox(
        //   height: PsDimens.space32,
        // ),
        // Text(Utils.getString(context, 'shop_info__contact'),
        //     style: Theme.of(context).textTheme.subtitle1),
        // _spacingWidget,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                width: PsDimens.space20,
                height: PsDimens.space20,
                child: const Icon(
                  Icons.phone_in_talk,
                )),
            const SizedBox(
              width: PsDimens.space8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  Utils.getString(context, 'shop_info__phone'),
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                _spacingWidget,
                InkWell(
                  child: Text(
                    phone.aboutPhone,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(),
                  ),
                  onTap: () async {
                    if (await canLaunch('tel://${phone.aboutPhone}')) {
                      await launch('tel://${phone.aboutPhone}');
                    } else {
                      throw 'Could not Call Phone Number 1';
                    }
                  },
                ),
                // _spacingWidget,
                // InkWell(
                //   child: Text(
                //     phone.aboutPhone2,
                //     style: Theme.of(context).textTheme.bodyText1.copyWith(),
                //   ),
                //   onTap: () async {
                //     if (await canLaunch('tel://${phone.aboutPhone2}')) {
                //       await launch('tel://${phone.aboutPhone2}');
                //     } else {
                //       throw 'Could not Call Phone Number 2';
                //     }
                //   },
                // ),
                // _spacingWidget,
                // InkWell(
                //   child: Text(
                //     phone.aboutPhone3,
                //     style: Theme.of(context).textTheme.bodyText1.copyWith(),
                //   ),
                //   onTap: () async {
                //     if (await canLaunch('tel://${phone.aboutPhone3}')) {
                //       await launch('tel://${phone.aboutPhone3}');
                //     } else {
                //       throw 'Could not Call Phone Number 3';
                //     }
                //   },
                // ),
              ],
            ),
          ],
        ),
        // _spacingWidget,
      ],
    );
  }
}

class _TitleAndDescriptionWidget extends StatelessWidget {
  const _TitleAndDescriptionWidget({Key key, this.data}) : super(key: key);

  final AboutUs data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Text(
          data.aboutTitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subtitle1.copyWith(
                color: PsColors.mainColor,
              ),
        ),
        const SizedBox(
          height: PsDimens.space16,
        ),
        Text(
          data.aboutDescription,
          style: Theme.of(context).textTheme.bodyText1.copyWith(height: 1.3),
        ),
        const SizedBox(
          height: PsDimens.space32,
        ),
      ],
    );
  }
}
